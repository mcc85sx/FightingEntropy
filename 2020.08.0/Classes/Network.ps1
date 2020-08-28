
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
                Throw "Invalid entry"
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
                $This.Vendor        = [Vendor]::New($MacAddress)
                Write-Host "Resolved [+] $IPAddress..."
            }

            Else
            {
                $This.Hostname      = "-"
                $This.Vendor        = "-"
                Write-Host "Reserved [-] $IPAddress..."
            }
        }
    }

    Class Adapter
    {
        [String]             $Alias
        [String]             $Index
        [String]       $Description
        [String]          $HostName
        [String]            $Domain
        [String]       $IPV4Address
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
            $This.IPV4Address       = ( $Table[0] -Replace "Interface: ", "" -Split " " )[0]
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
        [String]              $Name
        [String]        $MacAddress
        [Int32]              $Index

        Vendor([String]$MacAddress)
        {
            If ( $MacAddress -notmatch "([A-Fa-f0-9]{2}(-|:)*){5}[A-Fa-f0-9]{2}" )
            {
                Throw "Invalid MacAddress"
            }

            $This.MacAddress = $MacAddress
            $This.Index      = Invoke-Expression ( "0x{0}" -f ( ( $MacAddress -Replace "(:|-)" , "" )[0..5] -join '' ) )
        }
    }

    Class VendorList
    {
        Hidden [String]       $Path
        [Int32[]]            $Index
        [String[]]            $Name
        [String[]]            $List

        VendorList([String]$Path)
        {
            $This.Path              = "$Path\Archives\Network" 

            If ( ! ( Test-Path "$($This.Path)\Vendor.zip" ) )
            {
                Throw "Invalid Path"
            }

            Expand-Archive -Path "$($This.Path)\Vendor.zip" -DestinationPath $This.Path -Force

            ForEach ( $Item in "Index","Name","List" )
            {
                Write-Host " Loading [+] $Item"

                $This.$Item         = "$($This.Path)\$Item.txt" | % { Get-Content $_ ; Remove-Item $_ }
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

        [String]              $Path
        [String]      $ComputerName
        [String]            $Domain

        Hidden [Object]     $Vendor
        [Object]         $Interface
        [Object]         $HostRange

        Network ()
        {
            Get-ItemProperty "HKLM:\System\CurrentControlSet\Services\TCPIP\Parameters" | % { 

                $This.Path          = [FEModule]::New().Path
                $This.ComputerName  = $_.HostName
                $This.Domain        = $_.Domain
                $This.Vendor        = [VendorList]::New($This.Path)
            }
        }

        GetInterface()
        {
            $Cache                  = arp -a
            $ID                     = -1
            $List                   = @{ }
            $Adapter                = Get-NetAdapter
            $This.Interface         = @( )
            
            ForEach ( $I in 0..( $Cache.Count - 1 ) )
            {
                If ( $Cache[$I] -match "Interface:" )
                {
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
                    $This.Interface.Vendor              = $_.MacAddress -Replace "(-|:)" , ""
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
                        $This.Interface[$I].Vendor      = $_.MacAddress -Replace "(-|:)" , ""
                    }
                }
            }
        }

        [String] GetVendor([Object]$Vendor,[String]$MacAddress)
        {
            $Item                   = [Vendor]::New($MacAddress)
            $Rank                   = 0

            ForEach ( $I in 1..( $Vendor.List.Count - 1 ) )
            {
                $Rank               = $Rank + $Vendor.List[$I]
                
                If ( $Rank -eq $Item.Index )
                {
                    $Item.Name      = $This.Vendor.Name[$This.Vendor.Index[$I]]
                }
            }

            If ( !$Item.Name )
            {
                $Item.Name          = "Exceeded"
            }

            Return $Item.Name
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

    $Net = [Network]::New()
    
    $Net.GetInterface()

    If ( $Net.Interface.Count -eq 1 ) 
    {
        $Net.Interface.Table
    }

    Else
    {
        ForEach ( $I in 0..( $Net.Interface.Table.Count - 1 ) )
        {
            $Net.Interface[$I].Table
        }
    }

    #$Net.Interface.Table | ? Vendor -eq "" | % { ( $_.MacAddress -Replace "(-|:)" , "" )[0..5] -join '' }