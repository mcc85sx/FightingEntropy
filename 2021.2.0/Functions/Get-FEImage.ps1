
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
            $This.Output = $This.GetOutput()
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
                    $This.Output += [_ImageIndex]::new($Index,$Image.Path,"$($This.Target)\$($Image.DisplayName)[$Index]","$($Image.DisplayName)[$Index]")
                }
            }
        }

        ExtractImages()
        {
            $Item = $Null
            $Last = $Null
            $Swap = $Null

            If ( ! $This.Output )
            {
                Throw "No images detected"
            }

            ForEach ( $Image in $This.Output )
            {
                $Item = $Image.SourceImagePath
                $Swap = Get-DiskImage $Item

                If (!$Swap.Attached)
                {
                    If ( $Last )
                    {
                        If ( Get-DiskImage -ImagePath $Last | % Attached )
                        {
                            Dismount-DiskImage -ImagePath $Last
                            Start-Sleep -Seconds 2
                        }
                    }

                    Write-Theme "Mounting... $Last"
                    Mount-DiskImage -ImagePath $Item
                }

                @{ 
                    SourceIndex          = $Image.SourceIndex
                    SourceImagePath      = "$($This.Drive):\sources\install.wim"
                    DestinationImagePath = $Image.DestinationImagePath
                    DestinationName      = $Image.DestinationName
            
                } | % { Export-WindowsImage @_ -Verbose }

                $Last = $Item
            }

            Dismount-DiskImage -ImagePath $Item
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
}
