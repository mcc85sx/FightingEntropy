Function Get-FENetwork
{
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

    Class _NbtObj
    {
        [String]      $ID
        [String]    $Type
        [String] $Service

        _NbtObj([String]$In)
        {
            $This.ID, $This.Type, $This.Service = $In -Split "/"
        }
    }

    Class _NbtHost
    {
        Hidden [String[]]  $Line
        [String]           $Name
        [String]             $ID
        [String]           $Type
        [String]        $Service

        _NbtHost([Object]$NBT,[String]$Line)
        {
            $This.Line    = $Line.Split(" ") | ? Length -gt 0
            $This.Name    = $This.Line[0]
            $This.ID      = $This.Line[1]
            $This.Type    = $This.Line[2]
            $This.Service = $NBT | ? ID -match $This.ID | ? Type -Match $This.Type | % Service
        }
    }

    Class _NbtRef
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

        _NbtRef()
        {
            $This.Output = @( )
            $This.String | % { 

                $This.Output += [_NbtObj]::New($_)   
            }
        }
    }

    Class _NbtScan
    {
        Hidden [Object]    $NBTStat = (nbtstat -N)
        Hidden [Object[]]  $Adapter = (Get-NetAdapter)
        Hidden [Object[]]  $Service = ([_NBTRef]::New().Output)
        Hidden [Hashtable] $Process 
        [Object[]]          $Output

        [String] GetService ([Object]$Hosts)
        {
            Return @( $This.Service | ? ID -match $Hosts.ID | ? Type -eq $Hosts.Type | % Service )
        }

        _NbtScan()
        {
            $This.Process          = @{ }
            $X                     = -1

            ForEach ( $I in 1..( $This.NBTStat.Count - 1 ) )
            {
                $Item              = $This.NBTStat[$I].Split(":")[0]
        
                If ( $Item -in $This.Adapter.Name )
                {
                    $X ++
                    $This.Process.Add($X,@( ))
                }

                If ( $Item.Length -gt 0 ) 
                { 
                    $This.Process[$X] += $This.NBTStat[$I]
                }
            }

            Switch ($This.Process.Count)
            {
                1 
                {
                    $Item = [_NBTStat]::New($This.Process[0])

                    ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                    {
                        $Item.Hosts[$I].Service = $This.GetService($Item.Hosts[$I])
                    }

                    $This.Output += $Item
                }

                Default 
                { 
                    ForEach ( $X in 0..( $This.Process.Count - 1 ) )
                    {
                        $Item = [_NBTStat]::New($This.Process[$X])

                        ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                        {
                            $Item.Hosts[$I].Service = $This.GetService($Item.Hosts[$I])
                        }

                        $This.Output += $Item
                    }
                }
            }

            $This.Output = $This.Output | Sort-Object Name
        }
    }

    Class _NbtStat
    {
        Hidden [Object]   $Object
        [String]            $Name
        [String]       $IPAddress
        [Object[]]         $Hosts
        
        _NbtStat([Object[]]$Object)
        {
            $This.Object     = $Object
            $This.Name       = $Object[0].Split(":")[0]
            $This.IPAddress  = $Object[1].Split("[")[1].Split("]")[0]
            $This.Hosts      = $Object | ? { $_ -match "Registered" } | % { [_NBTHost]::New([_NBTRef]::New().Output,$_) }
        }
    }

    Class _ArpHost
    {
        Hidden [String] $Line
        [String] $Name
        [String] $IPAddress
        [String] $MacAddress
        [String] $Type

        [String] X ([Int32]$Start,[Int32]$End)
        {
            Return @( $This.Line.Substring($Start,$End).Trim(" ") )
        }

        _ArpHost([String]$Line)
        {
            $This.Line       = $Line
            $This.IPAddress  = $This.X(0,24)
            $This.MacAddress = $This.X(24,17)
            $This.Type       = $This.Line.Substring(41).Trim(" ")
            $This.Name       = Try { Resolve-DnsName $This.IPAddress -QuickTimeout -EA 0 | % NameHost } Catch { "-" }
        }
    }

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

    Class _ArpStat
    {
        Hidden [String] $Object
        [String] $Name
        [String] $IPAddress
        [String] $IFIndex
        [Object[]] $Hosts

        _ArpStat([Object]$Object)
        {
            $This.Object    = $Object
            $This.IPAddress = $Object[0].Replace("Interface: ","").Split(" ")[0]
            $This.IFIndex   = Invoke-Expression $Object[0].Split(" ")[-1]
            $This.Name      = (Get-NetIPInterface | ? IFIndex -eq $This.IFIndex | % IFAlias)[0]
            $This.Hosts     = $Object | ? { $_ -notmatch "(Interface|static)" } | % { [_ArpHost]::New($_) }
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
        Hidden [String]         $Range
        Hidden [String[]]        $Span

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
            If ( $This.Gateway )
            {
                $Item       = $This.HostRange -Split "/"

                $Table      = @{ }
                $Process    = @{ }

                0..3        | % { $Table.Add( $_, ( Invoke-Expression $This.HostRange.Split("/")[$_] ) ) }

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

                $This.Span  = $Process | % GetEnumerator | Sort-Object Name | % Value
                $This.Range = $This.Span -join "`n"
            }

            Else
            {
                $This.Span  = @( )
                $This.Range = "-"
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
            $This.GetRange()
        }
    }

    Class _V6Network
    {
        [String] $IPAddress
        [Int32]  $Prefix
        [String] $Link

        _V6Network([Object]$Address)
        {
            $This.IPAddress = $Address
        }
    }

    Class _NetInterface
    {
        [String] $Name
        [String] $Alias
        [Int32]  $Index
        [String] $Description
        [String] $MacAddress
        [String] $Vendor
        [Object] $IPV4
        [Object] $IPV6
        [Object] $DNS
        [Object] $ARP
        [Object] $NBT

        _NetInterface([Object]$Interface)
        {
            $This.Name        = $Interface.ComputerName
            $This.Alias       = $Interface.InterfaceAlias
            $This.Index       = $Interface.InterfaceIndex
            $This.Description = $Interface.InterfaceDescription
            $This.MacAddress  = $Interface.NetAdapter.LinkLayerAddress
            $This.IPV4        = [_V4Network]::New($Interface.IPV4Address)
            $This.IPV6        = [_V6Network]::New($Interface.IPV6LinkLocalAddress)
            $This.DNS         = $Interface.DNSServer
        }
    }

    Class _PingSweep
    {
        [String[]] $IPAddress
        Hidden [Hashtable] $Process
        [Object] $Buffer         = @( 97..119 + 97..105 | % { "0x{0:x}" -f $_ } )
        [Object] $Options
        [Object] $Output
        [Object] $Result

        _PingSweep([String[]]$IPAddress)
        {
            $This.IPAddress      = $IPAddress
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
                $This.Output    += [_PingObject]::New($X,$IP,$This.Process[$X])
            }
        }
    
        [Object[]] _Filter()
        {
            Return @( $This.Output | ? Status -eq + )
        }
    }

    Class _PingObject
    {
        Hidden [Object]     $Ref = [_NBTRef]::New().Output
        Hidden [Object]   $Reply
        [UInt32]          $Index
        [String]         $Status
        [String]      $IPAddress
        [String]       $Hostname
        [Object]            $NBT
        [String]        $NetBIOS

        _PingObject([UInt32]$Index,[String]$Address,[Object]$Reply)
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

            If ( $This.Status -eq "+" )
            {
                Write-Host ( "[+] {0}/{1}" -f $This.IPAddress, $This.Hostname )

                $This.NBT        = nbtstat -a $This.IPAddress | ? { $_ -match "Registered" } | % { [_NBTHost]::New($This.Ref,$_) }
                $This.NetBIOS    = $This.NBT | ? { $_.ID -match "1B" -or $_.ID -eq "1C" } | Select -Unique | % Name 
            }
        }
    }

    Class _Network
    {
        [Object[]]   $Adapter
        [Object]      $Vendor
        [Object[]]       $NBT
        [Object]     $NBTScan
        [Object]     $ARPScan
        [Object[]] $Interface
        [Object]     $Network
        [Object]      $Output

        _Network()
        {
            Write-Host "Collecting Network Adapters"
            $This.Adapter        = (Get-NetAdapter)

            Write-Host "Collecting Vendor List"
            $This.Vendor         = [_VendorList]::New("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/scratch/VendorList.txt")
            
            Write-Host "Scanning NBT Table"
            $This.NBT            = [_NBTRef]::New().Output
            $This.NBTScan        = [_NBTScan]::New().Output
            
            Write-Host "Scanning ARP Table"
            $This.ARPScan        = [_ARPScan]::New().Output
            $This.Interface      = @( )

            ForEach ( $Interface in Get-NetIPConfiguration -Detailed )
            {
                $Item            = [_NetInterface]::New($Interface)
                $Item.Vendor     = $This.GetVendor($Item.MacAddress)
                $Item.Arp        = $This.ARPScan | ? IFIndex -eq $Item.Index
                $Item.NBT        = $This.NBTScan | ? Name -eq $Item.Alias
                $This.Interface += $Item
                Write-Host ("[+] {0}" -f $Item.Alias)
            }

            $This.Interface      = $This.Interface | Sort-Object Alias
            $This.Network        = $This.Interface | ? { $_.IPV4.Gateway }
        }

        [String] GetVendor([String]$MacAddress)
        {
            If ( $MacAddress -notmatch "([A-Fa-f0-9]{2}(-|:)*){5}[A-Fa-f0-9]{2}" )
            {
                Throw "Invalid MacAddress"
            }
            
            Return $This.Vendor.VenID[( $MacAddress -Replace "(:|-)" , "" ).SubString(0,6)]
        }
    }

    [_Network]::New()
}
