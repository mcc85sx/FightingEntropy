Class BootImage
    {
        [Object] $Path
        [Object] $Name
        [Object] $Type
        [Object] $ISO
        [Object] $WIM
        [Object] $XML

        BootImage([String]$Path,[String]$Name)
        {
            $This.Path = $Path
            $This.Name = $Name
            $This.Type = Switch ([UInt32]($This.Name -match "\(x64\)")) { 0 { "x86" } 1 { "x64" } }
            $Regex     = "($($This.Name -Replace "\(","\(" -Replace "\)","\)"))"

            ForEach ( $Item in ( Get-ChildItem $Path | ? Name -match $Regex ) )
            { 
                Switch($Item.Extension)
                {
                    .iso { $This.ISO = $Item }
                    .wim { $This.WIM = $Item }
                    .xml { $This.XML = $Item }
                }
            }
        }
    }
