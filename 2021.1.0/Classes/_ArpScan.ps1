Class _ArpScan
    {
        [Object]               $ARP = (arp -a)
        Hidden [Object[]]  $Adapter = (Get-NetAdapter)
        Hidden [Hashtable] $Process
        [Object[]]          $Output

        _ArpScan()
        {
            $This.Process = @{ }
            $This.Output  = @( )
            $X            = -1
            
            ForEach ( $I in 0..( $This.Arp.Count - 1 ) )
            {
                If ( $This.Arp[$I].Length -gt 0 )
                {   
                    If ( $This.Arp[$I] -match "Interface" )
                    {
                        $X ++
                        $This.Process.Add($X,@( ))
                    }
                    
                    If ( $This.Arp[$I] -notmatch "Internet Address" )
                    {
                        $This.Process[$X] += $This.Arp[$I]
                    }
                }
            }
            
            Switch ($This.Process.Count)
            {
                1 
                {
                    $This.Output = [_ArpStat]::New($This.Process[0])
                }

                Default 
                {
                    ForEach ( $I in 0..( $This.Process.Count - 1 ) )
                    {
                        $This.Output += [_ArpStat]::New($This.Process[$I])
                    }
                }
            }

            $This.Output = $This.Output | Sort-Object IPAddress
        }
    }
