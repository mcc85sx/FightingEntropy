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
            DestinationImagePath = $Item.DestinationImagePath.Replace("$Target\","$Target\[$Image]")
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
    
    $Step = 0

    ForEach ( $Item in Get-ChildItem -Path $Target )
    {
        $Info = Get-WindowsImage -ImagePath $Item.FullName
        
        Switch -Regex ($Item.Name)
        {
            Server
            {
                $Edition   = Switch -Regex ($Info.ImageName) { Standard { "SD" } Datacenter { "DC" } }
                $Year      = [Regex]::Matches($Info.ImageName,"(\d{4})").Value
                $Label     = "{0}{1}" -f $Edition,$Year
            }

            Client
            {
                $Edition   = Switch -Regex ($Info.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }
                $Arch      = Switch -Regex ($Item.Name) { x64 {"64"} x32 {"86"} x86 {"86"} }
                $Label     = "10{0}{1}" -f $Edition,$Arch
            }
        }

        $Path = "{0}\[$Step]$Label" -f ($Item.Fullname | Split-Path -Parent)

        If ( ! ( Test-Path -LiteralPath $Path ) )
        {
           New-Item -Path $Path -ItemType Directory
        }

        Move-Item -LiteralPath $Item.FullName -Destination $Path -Verbose
        Get-ChildItem -LiteralPath $Path -Filter *.wim | Rename-Item -NewName "$Label.wim"
        $Step ++
    }
}
