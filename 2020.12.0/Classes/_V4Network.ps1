Class _V4Network
    {
        [String]            $IPAddress
        [String]                $Class
        [Int32]                $Prefix
        [String]              $Netmask
        Hidden [Object]         $Route
        [String]              $Network
        [String]              $Gateway
        [String[]]             $Subnet
        [String]            $Broadcast
        [String]            $HostRange
        [String]                $Range

        [String] GetNetmask([Int32]$CIDR)
        {
            $Switch         = 0

            Return @( ForEach ( $I in 0..3 )
            {
                If ( $CIDR -in @{ 0 = 1..7; 1 = 8..15; 2 = 16..23; 3 = 24..30 }[$I] )
                {
                    $Switch = 1
                    @(0,128,192,224,240,248,252,254,255)[$CIDR % 8]
                }

                Else
                {
                    @(255,0)[$Switch]
                }

            }) -join "."
        }

        GetRange()
        {
            $Item = ( $This.Network.Interface.IPV4 | ? Gateway | % HostRange ).Split("/")

            If ( $Item )
            {
                $Table      = @{ }
                $Process    = @{ }

                0..3        | % { $Table.Add( $_, ( Invoke-Expression $Range.Split("/")[$_] ) ) }

                $Total      = Invoke-Expression ( ( 0..3 | % { $Table[$_].Count } ) -join "*" )
                $Ct         = 0 
                ForEach ( $0 in $Table[0] )
                {
                    ForEach ( $1 in $Table[1] )
                    {
                        ForEach ( $2 in $Table[2] ) 
                        {
                            ForEach ( $3 in $Table[3] )
                            {
                                $Process.Add($Ct++,"$0.$1.$2.$3")
                            }
                        }
                    }
                }

                $This.Range = ( $Process | % GetEnumerator | Sort-Object Name | % Value ) -join "`n"
            }

            Else
            {
                $This.Range = ""
            }
        }

        IPCheck()
        {
            $Item = [IPAddress]$This.IPAddress | % GetAddressBytes
            
            If ( $Item[0] -in @(0,127;224..255) )
            {
                Throw "Invalid Address Detected"
            }

            If ( ( $Item[0..1] -join '.' ) -eq "169.254" )
            {
                Throw "Automatic Private IP Address Detected"
            }
        }

        GetHostRange()
        {
            $Item           = [IPAddress]$This.IPAddress | % GetAddressBytes 
            $Mask           = [IPAddress]$This.Netmask   | % GetAddressBytes 
            $This.HostRange = @( ForEach ( $I in 0..3 )
            {
                $Step = 256 - $Mask[$I]
                
                Switch ( $Step )
                {
                    1 
                    { 
                        $Item[$I] 
                    } 
                    
                    256 
                    { 
                        "0..255" 
                    } 
                    
                    Default 
                    {
                        $Slot = 256 / $Step

                        ForEach ( $X in 0..( ( 256 / $Slot ) - 1 ) )
                        {
                            $Range = ( $X * $Slot ) | % { $_..( $_ + $Slot - 1 ) }

                            If ( $Item[$I] -in $Range )
                            {
                                "{0}..{1}" -f $Range[0,-1]
                            }
                        }
                    }
                }
            }) -join '/'
        }

        _V4Network([Object]$Address)
        {
            If ( ! $Address )
            {
                Throw "Address Empty"
            }

            $This.IPAddress = $Address.IPAddress
            $This.IPCheck()

            $This.Class     = @('N/A';@('A')*126;'Local';@('B')*64;@('C')*32;@('MC')*16;@('R')*15;'BC')[[Int32]$This.IPAddress.Split(".")[0]]
            $This.Prefix    = $Address.PrefixLength
            $This.Netmask   = $This.GetNetMask($This.Prefix)
            $This.Route     = Get-NetRoute -AddressFamily IPV4 | ? InterfaceIndex -eq $Address.InterfaceIndex
            $This.Network   = $This.Route | ? { ($_.DestinationPrefix -Split "/")[1] -match $This.Prefix } | % { ($_.DestinationPrefix -Split "/")[0] }
            $This.Gateway   = $This.Route | ? NextHop -ne 0.0.0.0 | % NextHop
            $This.Subnet    = $This.Route | ? DestinationPrefix -notin 255.255.255.255/32,224.0.0.0/4,0.0.0.0/0 | % DestinationPrefix | Sort-Object
            $This.Broadcast = ( $This.Subnet | % { ( $_ -Split "/" )[0] } )[-1]
            $This.GetHostRange()
            $This.GetRange()
        }
    }
