Class Scope
    {
        [String]$Network
        [String]$Netmask
        Hidden [String[]]$Wildcard
        [String]$Start
        [String]$End
        [String]$Range
        [String]$Broadcast
        Scope([String]$Network,[String]$Netmask,[String]$Wildcard)
        {
            $This.Network  = $Network
            $This.Netmask  = $Netmask
            $This.Wildcard = $Wildcard -Split ","

            $NetworkSplit  = $Network  -Split "\."
            $NetmaskSplit  = $Netmask  -Split "\."
            $xStart         = @{ }
            $xEnd           = @{ }
            $xRange         = @{ }
            $xBroadcast     = @{ }

            ForEach ( $I in 0..3 )
            {
                $WC = $This.Wildcard[$I]
                $NS = [Int32]$NetworkSplit[$I]

                Switch($WC)
                {
                    1
                    {
                        $xStart.Add($I,$NS)
                        $xEnd.Add($I,$NS)
                        $xRange.Add($I,"$NS")
                        $xBroadcast.Add($I,$NS)
                    }

                    256
                    {
                        $xStart.Add($I,0)
                        $xEnd.Add($I,255)
                        $xRange.Add($I,"0..255")
                        $xBroadcast.Add($I,255)
                    }

                    Default
                    {
                        $xStart.Add($I,$NS)
                        $xEnd.Add($I,$NS+($WC-1))
                        $xRange.Add($I,"$($NS)..$($NS+($WC-1))")
                        $xBroadcast.Add($I,$NS+($WC-1))
                    }
                }
            }

            $This.Start = $xStart[0..3] -join '.'
            $This.End   = $xEnd[0..3] -join '.'
            $This.Range = $xRange[0..3] -join '/'
            $This.Broadcast = $xBroadcast[0..3] -join '.'
        }
    }