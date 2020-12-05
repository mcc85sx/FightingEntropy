Class _VendorList
{
    Hidden [Object]    $File
    [String[]]          $Hex
    [String[]]        $Names
    [String[]]         $Tags
    [Hashtable]          $ID
    [Hashtable]       $VenID

    _VendorList([String]$Path)
    {
        Switch ([Int32]($Path -Match "(http|https)"))
        {
            0
            {
                If ( ! ( Test-Path -Path $Path ) )
                {
                    Throw "Invalid Path"
                }
        
                $This.File = (Get-Content -Path $Path) -join "`n"
            }

            1
            { 
                [Net.ServicePointManager]::SecurityProtocol = 3072

                $This.File = Invoke-RestMethod -URI $Path
                
                If ( ! $This.File  )
                {
                    Throw "Invalid URL"
                }
            }
        }

        $This.Hex            = $This.File -Replace "(\t){1}.*","" -Split "`n"
        $This.Names          = $This.File -Replace "([A-F0-9]){6}\t","" -Split "`n"
        $This.Tags           = $This.Names | Sort-Object
        $This.ID             = @{ }

        ForEach ( $I in 0..( $This.Tags.Count - 1 ) )
        {
            If ( ! $This.ID[$This.Tags[$I]] )
            {
                $This.ID.Add($This.Tags[$I],$I)
            }
        }

        $This.VenID          = @{ }
        ForEach ( $I in 0..( $This.Hex.Count - 1 ) )
        {
            $This.VenID.Add($This.Hex[$I],$This.Names[$I])
        }
    }
}
