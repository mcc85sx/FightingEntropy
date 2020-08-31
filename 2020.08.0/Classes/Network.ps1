
    Class Host
    {
        [String]          $HostName
        [String]         $IPAddress
        [String]             $Class
        [String]        $MacAddress
        [String]            $Vendor

        Host([String]$IPAddress,[String]$MacAddress)
        {
            If ( $IPAddress -notmatch "(\d+).(\d+).(\d+).(\d+)" )
            {
                Throw "Invalid IPAddress"
            }

            If ( $MacAddress -notmatch "([A-Fa-f0-9]{2}(-|:)*){5}[A-Fa-f0-9]{2}" )
            {
                Throw "Invalid MacAddress"
            }

            $This.IPAddress         = $IPAddress
            $This.MacAddress        = $MacAddress
            $This.Class             = @('N/A';@('A')*126;'Local';@('B')*64;@('C')*32;@('MC')*16;@('R')*15;'BC')[$IPAddress.Split(".")[0]]

            If ( $This.Class -in "A","B","C" -and $This.MacAddress -notmatch "ff-ff-ff-ff-ff-ff" ) 
            {
                $This.Hostname      = Try { ( Resolve-DNSName $IPAddress -EA 0 ).NameHost } Catch { "*UnKnown*" }
                Write-Host "Resolved [+] $IPAddress..."
            }

            Else
            {
                $This.Hostname      = "-"
                Write-Host "Reserved [-] $IPAddress..."
            }
        }
    }

    Class NetInterface
    {
        [String]              $Type
        [String]           $ifAlias
        [Int32]            $ifIndex
        [String]         $IPAddress
        [Int32]             $Prefix
        [String]           $NetMask
        [Object]           $Gateway

        [String] GetNetMask([Int32]$Prefix)
        {
            If ( $Prefix -notin 1..30 )
            {
                Throw "CIDR out of range"
            }
            
            $Switch                 = 0
            $Mask                   = 0..3
            $Slot                   = @{ 0 = 1..7 ; 1 = 8..15 ; 2 = 16..23 ; 3 = 24..30 }

            ForEach ( $I in 0..3 )
            {
                If ( $Switch -eq 1 ) 
                { 
                    $Mask[$I] = 0 
                }

                If ( $Switch -eq 0 )
                {
                    If ( $Prefix -in $Slot[$I] ) 
                    { 
                        $Mask[$I]   = @(0,128,192,224,240,248,252,254,255)[$Prefix % 8]
                        $Switch     = 1
                    } 
                
                    Else
                    { 
                        $Mask[$I]    = 255 
                    }
                }
            }
        
            Return $Mask[0..3] -join '.'
        }

        [

        NetInterface([CimInstance]$IPAddress)
        {
            $This.Type              = "IPV{0}" -f @{ 0 = 4 ; 1 = 6 }[[Int32]($IPAddress.IPAddress -notmatch "(\d+).(\d+).(\d+).(\d+)" )]
            $This.ifAlias           = $IPAddress.InterfaceAlias
            $This.ifIndex           = $IPAddress.InterfaceIndex
            $This.IPAddress         = $IPAddress.IPAddress
            $This.Prefix            = $IPAddress.PrefixLength
            $This.Netmask           = $This.GetNetMask($This.Prefix)
            $This.Gateway           = ( Get-NetRoute -InterfaceIndex $This.ifIndex | ? DestinationPrefix -match "/$($This.Prefix)" ).DestinationPrefix.Split("/")[0]
        }
    }

    Class Adapter
    {
        [String]             $Alias
        [String]             $Index
        [String]       $Description
        [String]          $HostName
        [String]            $Domain
        [Object]              $IPV4
        [Object]              $IPV6
        [String]        $MacAddress
        [String]            $Vendor
        [Object]             $Table

        [Object] Form([String]$Line)
        {
            $Item                   = $Line -Split " " | ? { $_.Length -gt 0 }

            Return ( [Host]::New( $Item[0], $Item[1] ) )
        }

        Adapter([String[]]$Table)
        {

            $This.Index             = Invoke-Expression ( $Table[0] -Split " " )[3]

            $This.IPV4              = Get-NetIPAddress -AddressFamily IPv4 | ? ifIndex -eq $This.Index
            $This.IPV6              = Get-NetIPAddress -AddressFamily IPv6 | ? ifIndex -eq $This.Index

            $This.Table             = @( )
            
            If ( $Table.Count -gt 2 ) 
            {
                $Table[2..($Table.Count-1)] | % { 
                    
                    $This.Table    += $This.Form($_) 
                }
            }

            Else
            {
                $This.Table         = $This.Form($Table[2])
            }
        }
    }

    Class Vendor
    {
        [String]               $Hex
        [Int32]              $Index
        [String]              $Name

        Vendor([String]$MacAddress)
        {
            $This.Hex               = ( $MacAddress -Replace "(:|-)" , "" ).SubString(0,6)
            $This.Index             = [Convert]::ToInt64($This.Hex,16)
        }
    }

    Class VendorList
    {
        Hidden [String]       $Path
        [String[]]            $List
        [Int32[]]            $Index
        [String[]]            $Name

        VendorList([String]$Path)
        {
            $This.Path              = "$Path\Archives\Network"

            If ( ! ( Test-Path "$($This.Path)\Vendor.zip" ) )
            {
                Throw "Invalid Path"
            }

            Write-Host "Retrieving Vendor List"

            Expand-Archive -Path "$($This.Path)\Vendor.zip" -DestinationPath $This.Path -Force

            ForEach ( $Item in "Index","Name","List" )
            {
                $This.$Item         = "$($This.Path)\$Item.txt" | % { Get-Content $_ ; Remove-Item $_ }
                Write-Host "  Loaded [+] $Item"
            }
        }
    }

    Class Network
    {
        Hidden [Hashtable]    $Hash = @{

            Class                   = @('N/A';@('A')*126;'Local';@('B')*64;@('C')*32;@('MC')*16;@('R')*15;'BC')

            NBTScan                 = @{

                ID                  = ("00,01,01,03,06,1F,20,21,22,23,24,30,31,43,44,45,46,4C,42,52,87,6A,BE,BF,03,00,1B,1C,1D,1E,2B,2F,33,20,01" -Split ",") | % { "<$_>" }
                Type                = ("UNIQUE,GROUP" -Split ',')[@(0,0,1;@(0)*22;@(1,0)*3;@(1)*4)]
                Service             = (("Workstation {0},{2} {0},{7} {8},{2} {0},RAS {10} {0},NetDDE {0},File {10} {0},RAS Client {0},{1} {9} Interchange" +
                                      "[MSMail Connector],{1} {9} Store,{1} {9} Directory,{4} {10},{4} Client,{5} Control,SMS Administrators Remote Cont" +
                                      "rol Tool {0},{5} Chat,{5} Transfer,DEC TCPIP {0} on Windows NT,McAfee Anti-Virus,DEC TCPIP {0} on Windows NT,{1} " +
                                      "{9} MTA,{1} {9} IMC,Network Monitor Agent,Network Monitor Application,{2} {0},{6} Name,{6} {7} {8},{6} Controller" + 
                                      ",{7} {8},{8} {0} Elections,{3} {10},{3},{3},DCA IrmaLan Gateway {10},MS NetBIOS Browse {0}") -f "Service","Microsoft",
                                      "Messenger","Lotus Notes","Modem Sharing","SMS Clients Remote","Domain","Master","Browser","Exchange","Server").Split(",")
            }

            NetMask                 = @{ 

                Slot                = @{ 0 = 1..7 ; 1 = 8..15 ; 2 = 16..23 ; 3 = 24..30 }
                Mask                = 0..3
                Switch              = 0
                Remain              = $Null
            }
        }

        [String]                       $Path
        [String]               $ComputerName
        [String]                     $Domain

        [Object]                     $Vendor
        [Object]                  $Interface
        [Object]                  $HostRange

        [String] GetVendor([String]$MacAddress)
        {
            $IVendor                           = [Vendor]::New($MacAddress)
            $Rank                              = 0

            ForEach ( $I in 1..( $This.Vendor.Index.Count ) )
            {
                If ( $Rank -eq $IVendor.Index )
                {
                    $IVendor.Name              = $This.Vendor.Name[$This.Vendor.Index[$I]]
                }

                $Rank                          = $Rank + $This.Vendor.List[$I]
            }

            Return $IVendor.Name
        }

        Network ()
        {
            Get-ItemProperty "HKLM:\System\CurrentControlSet\Services\TCPIP\Parameters" | % { 

                $This.Path          = [FEModule]::New().Path
                $This.ComputerName  = $_.HostName
                $This.Domain        = $_.Domain
                $This.Vendor        = [VendorList]::New($This.Path)
            }

            $Cache                  = arp -a
            $ID                     = -1
            $List                   = @{ }
            $Adapter                = Get-NetAdapter
            $This.Interface         = @( )
            
            ForEach ( $I in 0..( $Cache.Count - 1 ) )
            {
                If ( $Cache[$I] -match "Interface:" )
                {
                    Write-Host "Detected [+] Interface"
                    $ID             ++
                    $List.Add( $ID , @( ) )
                }

                If ( $Cache[$I].Length -gt 0 )
                {
                    $List[$ID]      += $Cache[$I]
                }
            }
            
            If ( $List.Count -eq 1 )
            {
                $This.Interface                         = [Adapter]::New( $List )
                
                $Adapter                                | ? IFIndex -eq $This.Interface.Index | % {

                    $This.Interface.Hostname            = $This.ComputerName
                    $This.Interface.Domain              = $This.Domain
                    $This.Interface.Alias               = $_.Name
                    $This.Interface.Description         = $_.InterfaceDescription
                    $This.Interface.MacAddress          = $_.MacAddress
                    $This.Interface.Vendor              = $This.GetVendor($_.MacAddress)
                }
            }

            If ( $List.Count -gt 1 )
            {
                ForEach ( $I in 0..( $List.Count - 1 ) )
                {
                    $This.Interface                    += [Adapter]::New( $List[$I] )

                    $Adapter                            | ? IFIndex -eq $This.Interface[$I].Index | % { 

                        $This.Interface[$I].Hostname    = $This.ComputerName
                        $This.Interface[$I].Domain      = $This.Domain
                        $This.Interface[$I].Alias       = $_.Name
                        $This.Interface[$I].Description = $_.InterfaceDescription
                        $This.Interface[$I].MacAddress  = $_.MacAddress
                        $This.Interface[$I].Vendor      = $This.GetVendor($_.MacAddress)
                    }
                }
            }

            $This.HostRange     = @( )

            If ( $This.Interface.Count -eq 1 ) 
            {
                ForEach ( $X in 0..( $This.Interface.Table.Count - 1 ) )
                {
                    $Item = $This.Interface.Table[$X]

                    If ( $Item.MacAddress -notin $This.Hostrange.MacAddress )
                    {
                        If ( $Item.Hostname -ne "-" )
                        {
                            $This.HostRange += $Item
                        }
                    }
                }
            }

            Else
            {
                ForEach ( $I in 0..( $This.Interface.Count - 1 ) )
                {
                    ForEach ( $X in 0..( $This.Interface[$I].Table.Count - 1 ) )
                    {
                        $Item = $This.Interface[$I].Table[$X]

                        If ( $Item.MacAddress -notin $This.Hostrange.MacAddress )
                        {
                            If ( $Item.HostName -ne "-" )
                            {
                                $This.HostRange += $Item
                            }
                        }
                    }
                }
            }

            ForEach ( $I in 0..( $This.HostRange.Count - 1 ) )
            {
                $This.HostRange[$I].Vendor = $This.GetVendor($This.HostRange[$I].MacAddress)
            }

            
        }

        [String] GetNetMask([Int32]$CIDR)
        {
            If ( $CIDR -notin 1..30 )
            {
                Throw "CIDR out of range"
            }
            
            $Switch                 = 0
            $Mask                   = 0..3
            $Slot                   = @{ 0 = 1..7 ; 1 = 8..15 ; 2 = 16..23 ; 3 = 24..30 }

            ForEach ( $I in 0..3 )
            {
                If ( $Switch -eq 1 ) 
                { 
                    $Mask[$I] = 0 
                }

                If ( $Switch -eq 0 )
                {
                    If ( $CIDR -in $Slot[$I] ) 
                    { 
                        $Mask[$I]   = @(0,128,192,224,240,248,252,254,255)[$CIDR % 8]
                        $Switch     = 1
                    } 
                
                    Else
                    { 
                        $Mask[$I]    = 255 
                    }
                }
            }
        
            Return $Mask[0..3] -join '.'
        }
    }

    $Net               = [Network]::New()

    $Net.Interface 
    $Net.HostRange | FT
