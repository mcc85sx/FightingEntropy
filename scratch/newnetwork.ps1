Function Get-FENetwork
{
    # Gather classes for controller

    Class _VendorList # Obtains hardware vendor list to convert MacAddress to correct vendor name
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
                
                    If ( ! $This.File )
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

    Class _NbtReferenceObject # Object to populate the NBT Reference Table
    {
        [String]      $ID
        [String]    $Type
        [String] $Service

        _NbtReferenceObject([String]$In)
        {
            $This.ID, $This.Type, $This.Service = $In -Split "/"
            $This.ID = "<$($This.ID)>"
        }
    }

    Class _NbtReference # Reference object to map NetBIOS ID's to service names
    {
        [String[]] $String = (("00/{0}/Workstation {4};01/{0}/Messenger {6};01/{1}/Master Browser;03/{0}/Messenger {6};" + 
        "06/{0}/RAS Server {6};1F/{0}/NetDDE {6};20/{0}/File Server {6};21/{0}/RAS Client {6};22/{0}/{2} Interchange(MSMail C" + 
        "onnector);23/{0}/{2} Exchange Store;24/{0}/{2} Directory;30/{0}/{4} Server;31/{0}/{4} Client;43/{0}/{3} Control;44/{" + 
        "0}/SMS Administrators Remote Control Tool {6};45/{0}/{3} Chat;46/{0}/{3} Transfer;4C/{0}/DEC TCPIP SVC on Windows NT" +
        ";42/{0}/mccaffee anti-virus;52/{0}/DEC TCPIP SVC on Windows NT;87/{0}/{2} MTA;6A/{0}/{2} IMC;BE/{0}/{5} Agent;BF/{0}" + 
        "/{5} Application;03/{0}/Messenger {6};00/{1}/{7} Name;1B/{0}/{7} Master Browser;1C/{1}/{7} Controller;1D/{0}/Master " + 
        "Browser;1E/{1}/Browser {6} Elections;2B/{0}/Lotus Notes Server;2F/{1}/Lotus Notes ;33/{1}/Lotus Notes ;20/{1}/DCA Ir" + 
        "maLan Gateway Server;01/{1}/MS NetBIOS Browse Service") -f "UNIQUE","GROUP","Microsoft Exchange","SMS Clients Remote",
        "Modem Sharing","Network Monitor","Service","Domain").Split(";")
        [Object[]] $Output

        _NbtReference()
        {
            $This.Output = @( )
            $This.String | % { 

                $This.Output += [_NbtReferenceObject]::New($_)
            }
        }
    }

    Class _NbtHostObject # Used to identify NBT network hosts
    {
        Hidden [String[]]  $Line
        [String]           $Name
        [String]             $ID
        [String]           $Type
        [String]        $Service

        _NbtHostObject([String]$Line)
        {
            $This.Line    = $Line.Split(" ") | ? Length -gt 0
            $This.Name    = $This.Line[0]
            $This.ID      = $This.Line[1]
            $This.Type    = $This.Line[2]
        }
    }

    Class _NbtTable # Parses/Formats the NBT table 
    {
        [String]      $Name
        [String] $IpAddress
        [Object]     $Hosts

        _NbtTable([String]$Name)
        {
            $This.Name = $Name
            $This.Hosts = @( )
        }

        NodeIp([String]$Node)
        {
            $This.IpAddress = [Regex]::Matches($Node,"(\d+\.){3}(\d+)").Value
        }

        AddHost([String]$Line)
        {
            $This.Hosts += [_NbtHostObject]::New($Line)
        }
    }

    Class _NbtStat # Parses/Formats nbtstat -N
    {
        Hidden [Object] $Alias
        Hidden [Object] $Table
        Hidden [Object] $Section
        [Object] $Output

        _NbtStat([Object[]]$Interface)
        {
            $This.Alias   = $Interface.Alias | % { "{0}:" -f $_ }
            $This.Table   = nbtstat -N
            $This.Section = @{ }
            $X            = -1

            ForEach ( $Line in $This.Table )
            {
                If ( $Line -in $This.Alias )
                {
                    $X ++
                    $This.Section.Add($X,[_NbtTable]::New($Line))
                }

                ElseIf ( $Line -match "Node IpAddress" )
                {
                    $This.Section[$X].NodeIp($Line)
                }
    
                ElseIf ( $Line -match "Registered" )
                {
                    $This.Section[$X].AddHost($Line)
                }
            }

            $This.Output = $This.Section | % GetEnumerator | Sort-Object Name | % Value
        }
    }

    Class _V4PingObject
    {
        Hidden [Object]   $Reply
        [UInt32]          $Index
        [String]         $Status
        [String]      $IPAddress
        [String]       $Hostname

        _V4PingObject([UInt32]$Index,[String]$Address,[Object]$Reply)
        {
            $This.Reply          = $Reply.Result
            $This.Index          = $Index
            $This.Status         = @("-","+")[[Int32]($Reply.Result.Status -match "Success")]
            $This.IPAddress      = $Address
            $This.Hostname       = Switch ($This.Status)
            {
                "+"
                {
                    Resolve-DNSName $This.IPAddress | % NameHost
                }

                Default
                {
                    "-"
                }
            }
        }
    }

    Class _V4PingSweep
    {
        [String]         $HostRange
        [String[]]       $IPAddress
        Hidden [Hashtable] $Process
        [Object] $Buffer         = @( 97..119 + 97..105 | % { "0x{0:X}" -f $_ } )
        [Object] $Options
        [Object] $Output
        [Object] $Result

        _V4PingSweep([String]$HostRange)
        {
            $This.HostRange = $HostRange
            $Item           = $HostRange -Split "/"
            
            $Table          = @{ }
            $This.Process   = @{ }

            ForEach ( $X in 0..3 )
            {
                $Table.Add( $X, (Invoke-Expression $Item[$X]) )
            }
            
            $X = 0

            ForEach ( $0 in $Table[0] )
            {
                ForEach ( $1 in $Table[1] )
                {
                    ForEach ( $2 in $Table[2] ) 
                    {
                        ForEach ( $3 in $Table[3] )
                        {
                            $This.Process.Add($X++,"$0.$1.$2.$3")
                        }
                    }
                }
            }

            $This.IPAddress      = $This.Process | % GetEnumerator | Sort-Object Name | % Value
            $This._Refresh()
        }

        _Refresh()
        {
            $This.Process        = @{ }

            ForEach ( $X in 0..( $This.IPAddress.Count - 1 ) )
            {
                $IP              = $This.IPAddress[$X]

                $This.Options    = [System.Net.NetworkInformation.PingOptions]::new()
                $This.Process.Add($X,[System.Net.NetworkInformation.Ping]::new().SendPingAsync($IP,100,$This.Buffer,$This.Options))
            }

            $This.Output         = @( )
        
            ForEach ( $X in 0..( $This.IPAddress.Count - 1 ) ) 
            {
                $IP              = $This.IPAddress[$X] 
                $This.Output    += [_V4PingObject]::New($X,$IP,$This.Process[$X])
            }
        }
    }

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
                            $IRange = ( $X * $Slot ) | % { $_..( $_ + $Slot - 1 ) }

                            If ( $Item[$I] -in $IRange )
                            {
                                "{0}..{1}" -f $IRange[0,-1]
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
        }

        [Object[]] ScanV4()
        {
            Return @( [_V4PingSweep]::New($This.HostRange).Output | ? Status -eq + )
        }
    }

    Class _V6Network
    {
        [String] $IPAddress
        [Int32]  $Prefix
        [String] $Link

        _V6Network([Object]$Address)
        {
            $This.IPAddress = $Address.IPAddress
            $This.Prefix    = $Address.PrefixLength
        }
    }

    Class _NetInterface
    {
        Hidden [Object] $Interface
        [String] $Hostname
        [String] $Alias
        [Int32]  $Index
        [String] $Description
        [String] $Status
        [String] $MacAddress
        [String] $Vendor
        [Object] $IPv4
        [Object] $IPv6
        [Object] $Nbt
        [Object] $Arp

        _NetInterface([Object]$Interface)
        {
            $This.Interface   = $Interface
            $This.HostName    = $Interface.ComputerName
            $This.Alias       = $Interface.InterfaceAlias
            $This.Index       = $Interface.InterfaceIndex
            $This.Description = $Interface.InterfaceDescription
            $This.Status      = $Interface.NetAdapter.Status
            $This.MacAddress  = $Interface.NetAdapter.LinkLayerAddress
            
            $This.IPV4        = @( )

            ForEach ( $Address in $Interface.IPV4Address ) 
            { 
                $This.IPV4   += [_V4Network]::New($Address)
            }

            $This.IPV4        = $This.IPV4 | Select-Object -Unique
            
            $This.IPV6        = @( )

            ForEach ( $Address in $Interface.IPV6Address)
            {
                $This.IPV6   += [_V6Network]::New($Address)
            }

            ForEach ( $Address in $Interface.IPV6LinkLocalAddress )
            {
                $This.IPV6   += [_V6Network]::New($Address)
            }

            ForEach ( $Address in $Interface.IPV6TemporaryAddress )
            {
                $This.IPV6   += [_V6Network]::New($Address)
            }

            $This.IPV6        = $This.IPV6 | Select-Object -Unique
        }

        GetVendor([Object]$Vendor)
        {
            $This.Vendor = $Vendor.VenID[ ( $This.MacAddress -Replace "(-|:)","" | % Substring 0 6 ) ]
        }

        Load([Object]$Nbt,[Object]$Arp)
        {
            $This.Nbt = $Nbt
            $This.Arp = $Arp
        }
    }

    Class _ArpHostObject # Used to identify ARP network hosts
    {
        [String]       $Hostname
        [String]      $IpAddress
        [String]     $MacAddress
        [String]         $Vendor
        [String]           $Type

        _ArpHostObject([String]$Line)
        {
            $This.IpAddress  = $Line | % Substring  2 22 | % Replace " ",""
            $This.MacAddress = $Line | % Substring 24 17
            $This.Type       = $Line | % Substring 46
        }

        GetVendor([Object]$Vendor)
        {
            $This.Vendor     = $Vendor.VenID[ ( $This.MacAddress -Replace "(-|:)","" | % Substring 0 6 ) ]
        }
    }

    Class _ArpTable
    {
        [String]      $Name
        [String] $IpAddress
        [Object]     $Hosts

        _ArpTable([String]$Line)
        {
            $This.Name      = $Line.Split(" ")[-1]
            $This.IPAddress = $Line.Replace("Interface: ","").Split(" ")[0]
            $This.Hosts     = @( )
        }
    }

    Class _ArpStat
    {
        [Object] $Alias
        [Object] $Table
        [Object] $Section
        [Object] $Output

        _ArpStat([Object[]]$Interface)
        {
            $This.Alias = ForEach ( $I in $Interface ) 
            {
                "Interface: {0} --- 0x{1:x}" -f $I.IPV4.IPAddress, $I.Index 
            }

            $This.Table   = arp -a
            $This.Section = @{ }
            $X            = -1

            ForEach ( $Line in $This.Table )
            {
                If ( $Line -in $This.Alias )
                {
                    $X ++
                    $This.Section.Add( $X,[_ArpTable]::New($Line))
                }

                ElseIf ( $Line -match "(static|dynamic)" )
                {
                    $This.Section[$X].Hosts += [_ArpHostObject]::New($Line)
                }
            }

            $This.Output = $This.Section | % GetEnumerator | Sort-Object Name | % Value
        }
    }

    Class _Controller
    {
        Hidden [Object]      $VendorList
        Hidden [Object]    $NbtReference
        Hidden [Object]             $Nbt
        Hidden [Object]             $Arp
        [Object]              $Interface
        [Object]                $Network

        _Controller()
        {
            Write-Host "Collecting Network Adapter Information"

            $This.VendorList     = [_VendorList]::New("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/scratch/VendorList.txt")
            $This.NBTReference   = [_NBTReference]::New().Output
            $This.Interface      = @( )
            
            ForEach ( $Interface in Get-NetIPConfiguration )
            {
                $Adapter         = [_NetInterface]::New($Interface)
                Write-Host ( "[+] {0}" -f $Adapter.Alias )
                $Adapter.GetVendor($This.VendorList)
                $This.Interface += $Adapter
            }
            
            $This.NBT            = [_NbtStat]::New($This.Interface).Output
            $This.ARP            = [_ArpStat]::New($This.Interface).Output

            ForEach ( $Interface in $This.NBT )
            {
                ForEach ( $xHost in $Interface.Hosts )
                {
                    $xHost.Service = $This.NBTReference | ? ID -match $xHost.ID | ? Type -eq $xHost.Type | % Service
                }
            }

            ForEach ( $I in 0..( $This.Interface.Count - 1 ) )
            {
                $IPAddress  = $This.Interface[$I].IPV4.IPAddress

                $xNbt       = $This.Nbt | ? IpAddress -match $IpAddress | % Hosts
                $xArp       = $This.Arp | ? IpAddress -match $IpAddress | % Hosts

                ForEach ( $Item in $xArp )
                {
                    If ( $Item.Type -match "static" )
                    {
                        $Item.Hostname = "-"
                        $Item.Vendor   = "-"
                    }

                    If ( $Item.Type -match "dynamic" )
                    {
                        $Item.GetVendor($This.VendorList)

                        If ( !$Item.Vendor )
                        {
                            $Item.Vendor = "<unknown>"
                        }
                    }
                }

                $This.Interface[$I].Load($xNbt,$xArp)
            }

            $This.Network = $This.Interface | ? { $_.IPV4.Gateway }
        }

        Report()
        {
            ForEach ( $Interface in $This.Interface )
            {
                $Interface | % { 
                    
                    Write-Theme @(
                    "Interface [$($_.Alias)]",
                    " ",
                    "---- Host Information ---------------------------";
                    @{
                        Hostname    = $_.Hostname
                        Alias       = $_.Alias
                        Index       = $_.Index
                        Description = $_.Description
                        Status      = $_.Status
                        MacAddress  = $_.MacAddress
                        Vendor      = $_.Vendor
                    };
                    " ",
                    "---- IPv4 Information ---------------------------";
                    ForEach ( $IPV4 in $_.IPV4 )
                    {
                        @{ 
                            IPAddress   = $IPV4.IPAddress
                            Class       = $IPV4.Class
                            Prefix      = $IPV4.Prefix
                            Netmask     = $IPV4.Netmask
                            Network     = $IPV4.Network
                            Gateway     = $IPV4.Gateway
                            Subnet      = $IPV4.Subnet
                            Broadcast   = $IPV4.Broadcast
                            HostRange   = $IPV4.HostRange
                        }
                    };
                    " ",
                    "---- IPv6 Information ---------------------------";
                    ForEach ( $IPV6 in $_.IPV6 )
                    {
                        @{
                            IPAddress = $IPV6.IPAddress
                            Prefix    = $IPV6.Prefix
                        }  
                    })

                    Start-Sleep -Seconds 2
                }
            }
        }
    }
