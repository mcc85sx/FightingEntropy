Class ImageStore
{
    [String]   $Source
    [String]   $Target
    [Object[]]  $Store
    [Object[]]   $Swap
    [Object[]] $Output
    ImageStore([String]$Source,[String]$Target)
    {
        If ( ! ( Test-Path $Source ) )
        {
            Throw "Invalid image base path"
        }

        If ( !(Test-Path $Target) )
        {
            New-Item -Path $Target -ItemType Directory -Verbose
        }

        $This.Source = $Source
        $This.Target = $Target
        $This.Store  = @( )
    }
    AddImage([String]$Type,[String]$Name)
    {
        $This.Store += [ImageFile]::New($Type,"$($This.Source)\$Name")
    }
    GetSwap()
    {
        $This.Swap = @( )
        $Ct        = 0

        ForEach ( $Image in $This.Store )
        {
            ForEach ( $Index in $Image.Index )
            {
                $Iso                     = @{ 

                    SourceIndex          = $Index
                    SourceImagePath      = $Image.Path
                    DestinationImagePath = ("{0}\({1}){2}({3}).wim" -f $This.Target, $Ct, $Image.DisplayName, $Index)
                    DestinationName      = "{0}({1})" -f $Image.DisplayName,$Index
                }

                $Item                    = [ImageIndex]::New($Iso)
                $Item.Rank               = $Ct
                $This.Swap              += $Item
                $Ct                     ++
            }
        }
    }
    GetOutput()
    {
        $Last = $Null

        ForEach ( $X in 0..( $This.Swap.Count - 1 ) )
        {
            $Image       = $This.Swap[$X]

            If ( $Last -ne $Null -and $Last -ne $Image.SourceImagePath )
            {
                Write-Theme "Dismounting... $Last" 12,4,15,0
                Dismount-DiskImage -ImagePath $Last -Verbose
            }

            If (!(Get-DiskImage -ImagePath $Image.SourceImagePath).Attached)
            {
                Write-Theme ("Mounting [+] {0}" -f $Image.SourceImagePath) 14,6,15,0
                Mount-DiskImage -ImagePath $Image.SourceImagePath
            }
            
            $Image.Path = "{0}:\sources\install.wim" -f (Get-DiskImage -ImagePath $Image.SourceImagePath | Get-Volume | % DriveLetter)
            
            $Image.Load($This.Target)

            $ISO                        = @{
    
                SourceIndex             = $Image.SourceIndex
                SourceImagePath         = $Image.Path
                DestinationImagePath    = $Image.DestinationImagePath
                DestinationName         = $Image.DestinationName
            }
            
            Write-Theme "Extracting [~] $($Iso.DestinationImagePath)" 11,7,15,0
            Export-WindowsImage @ISO
            Write-Theme "Extracted [+] $($Iso.DestinationName)" 10,10,15,0

            $Last                       = $Image.SourceImagePath
            $This.Output               += $Image
        }

        Dismount-DiskImage -ImagePath $Last
    }
}