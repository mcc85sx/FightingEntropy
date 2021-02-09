Function Get-FEImage
{
    [CmdLetBinding()]Param(
    [Parameter(Mandatory)][String]$Source,
    [Parameter(Mandatory)][String]$Target)

    Class _ImageIndex
    {
        [String]          $SourceIndex
        [String]      $SourceImagePath
        [String] $DestinationImagePath
        [String]      $DestinationName

        _ImageIndex(
        [String]          $SourceIndex ,
        [String]      $SourceImagePath ,
        [String] $DestinationImagePath ,
        [String]      $DestinationName )
        {
            $This.SourceIndex          = $SourceIndex
            $This.SourceImagePath      = $SourceImagePath
            $This.DestinationImagePath = $DestinationImagePath
            $This.DestinationName      = $DestinationName
        }
    }

    Class _ImageFile
    {
        [ValidateSet("Client","Server")]
        [String]        $Type
        [String]        $Name
        [String] $DisplayName
        [String]        $Path
        [UInt32[]]     $Index

        _ImageFile([String]$Type,[String]$Path)
        {
            $This.Type  = $Type
        
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            $This.Name        = ($Path -Split "\\")[-1]
            $This.DisplayName = "[$Type]-[$($This.Name)]"
            $This.Path        = $Path
            $This.Index       = @( )
        }

        AddMap([UInt32[]]$Index)
        {
            ForEach ( $I in $Index )
            {
                $This.Index  += $I
            }
        }
    }

    Class _ImageStore
    {
        [String]   $Source
        [String]   $Target
        [String]    $Drive
        [Object[]]  $Store
        [Object[]] $Output

        _ImageStore([String]$Source,[String]$Target)
        {
            If ( ! ( Test-Path $Source ) )
            {
                Throw "Invalid image base path"
            }

            If ( Test-Path $Target )
            {
                Throw "Path exists !"
            }

            If ( !(Test-Path $Target) )
            {
                New-Item -Path $Target -ItemType Directory -Verbose
            }

            $This.Source = $Source
            $This.Target = $Target
            $This.Drive  = [Char]( [Int32]( Get-Volume | ? DriveLetter | % DriveLetter )[-1] + 1 )
            $This.Store  = @( )
        }

        AddImage([String]$Type,[String]$Name)
        {
            $This.Store += [_ImageFile]::New($Type,"$($This.Source)\$Name")
        }

        GetOutput()
        {
            $This.Output = @( )

            ForEach ( $Image in $This.Store )
            {
                ForEach ( $Index in $Image.Index )
                {
                    $This.Output += [_ImageIndex]::new($Index,$Image.Path,"$($This.Target)\$($Image.DisplayName)[$Index].wim","$($Image.DisplayName)[$Index]")
                }
            }
        }

        ExtractImages()
        {
            $Item = $Null
            $Last = $Null
            $Swap = $Null
            $Path = $Null
            $Info = $Null

            If ( ! $This.Output )
            {
                Throw "No images detected"
            }

            ForEach ( $Image in 0..($This.Output.Count - 1) )
            {
                $Item = $This.Output[$Image]
                $Swap = Get-DiskImage -ImagePath $Item.SourceImagePath

                If (!$Swap.Attached)
                {
                    If ( $Last -ne $Null )
                    {
                        If ( Get-DiskImage -ImagePath $Last | % Attached )
                        {
                            Write-Theme "Dismounting... $Last"
                            Dismount-DiskImage -ImagePath $Last -Verbose
                            Start-Sleep -Seconds 10
                        }
                    }

                    Write-Theme "Mounting... $($Item.SourceImagePath)"
                    Mount-DiskImage -ImagePath $Item.SourceImagePath -Verbose

                    $Info = Get-WindowsImage -ImagePath "$(Get-DiskImage -ImagePath $Item.SourceImagePath | Get-Volume | % DriveLetter ):\sources\install.wim" -Verbose
                }

                $ISO                     = @{ 

                    SourceIndex          = $Item.SourceIndex
                    SourceImagePath      = $Item.SourceImagePath
                    DestinationImagePath = $Item.DestinationImagePath
                    DestinationName      = $Info | ? ImageIndex -eq $Item.SourceIndex | % ImageName
                }

                If ( $Iso.DestinationName -match "Server" )
                {
                    $Iso.DestinationName = "{0} (x64)" -f [Regex]::Matches($Iso.DestinationName,"(Windows Server )+(\d){4}( Datacenter| Standard)").Value
                }

                Else
                {
                    $Arch                = Switch -Regex ($Item.DestinationImagePath) { x64 {"64"} x32 {"86"} x86 {"86"} }
                    $Iso.DestinationName = "{0} (x$Arch)" -f [Regex]::Matches($Iso.DestinationName,"(Windows 10 )+(Pro*|Education|Home)").Value
                }
                
                Write-Theme "Extracting [~] $($ISO.DestinationImagePath)"

                Export-WindowsImage @ISO

                $Last = $Item.SourceImagePath
            }

            Dismount-DiskImage -ImagePath $Item.SourceImagePath
        }
    }

    $Images = [_ImageStore]::New($Source,$Target)

    $Index  = 0
    $Images.AddImage("Server","Windows Server 2016.iso")
    $Images.Store[$Index].AddMap(4)
    $Index ++

    $Images.AddImage("Client","Win10_20H2_English_x64.iso")
    $Images.Store[$Index].AddMap((4,1,6))
    $Index ++

    $Images.AddImage("Client","Win10_20H2_English_x32.iso")
    $Images.Store[$Index].AddMap((4,1,6))
    $Index ++

    $Images.GetOutput()

    $Item = $Null
    $Last = $Null
    $Swap = $Null
    $Path = $Null
    $Info = $Null

    If ( ! $Images.Output )
    {
        Throw "No images detected"
    }
    
    ForEach ( $Image in 0..($Images.Output.Count - 1 ) )
    {
        $Item = $Images.Output[$Image]
        $Swap = Get-DiskImage -ImagePath $Item.SourceImagePath

        If (!$Swap.Attached)
        {
            If ( $Last -ne $Null )
            {
                If ( Get-DiskImage -ImagePath $Last | % Attached )
                {
                    Write-Theme "Dismounting... $Last"
                    Dismount-DiskImage -ImagePath $Last -Verbose
                    Start-Sleep -Seconds 10
                }
            }

            Write-Theme "Mounting... $($Item.SourceImagePath)"
            Mount-DiskImage -ImagePath $Item.SourceImagePath -Verbose

            $Letter = Get-DiskImage -ImagePath $Item.SourceImagePath | Get-Volume | % DriveLetter
            $Path   = "$Letter`:\sources\install.wim"
            $Info   = Get-WindowsImage -ImagePath $Path -Verbose
        }

        $ISO                     = @{ 

            SourceIndex          = $Item.SourceIndex
            SourceImagePath      = $Path
            DestinationImagePath = $Item.DestinationImagePath
            DestinationName      = $Info | ? ImageIndex -eq $Item.SourceIndex | % ImageName
        }
        
        If ( $Iso.DestinationName -match "Server" )
        {
            $Iso.DestinationName = "{0} (x64)" -f [Regex]::Matches($Iso.DestinationName,"(Windows Server )+(\d){4}( Datacenter| Standard)").Value
        }
        
        Else
        {
            $Arch                = Switch -Regex ($Swap.ImagePath) { x64 {"64"} x32 {"86"} x86 {"86"} }
            $Iso.DestinationName = "Windows 10 {0} (x{1})" -f [Regex]::Matches($Iso.DestinationName,"(Pro|Education|Home)").Value, $Arch
        }
                
        Write-Theme "Extracting [~] $($ISO.DestinationImagePath)"

        Export-WindowsImage @ISO

        $Last = $Item.SourceImagePath
    }

    Dismount-DiskImage -ImagePath $Item.SourceImagePath
}
