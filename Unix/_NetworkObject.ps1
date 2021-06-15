Function _NetworkObject
{
    Class _Host
    {
        Hidden [Object]         $Obj = (hostnamectl)
        Hidden [String[]]     $Order = ("Hostname HostID Chassis MachineID BootID VMProvider OS CPE Kernel Architecture" -Split " ") 
        [String]             $HostID
        [String]           $Hostname
        [String]         $DomainName
        [String]            $Chassis
        [String]          $MachineID
        [String]             $BootID
        [String]         $VMProvider
        [String]                 $OS
        [String]                $CPE
        [String]             $Kernel
        [String]       $Architecture

        [String]                Item([String]$I)
        {
            $Item = ( $This.Obj | ? { $_ -cmatch $I } )

            Return @( If (!!$Item) {$Item.Substring(20)} Else {"-"} )
        }

        _Host()
        {
            $This.Hostname      = $This.Item("Static hostname")
            $This.HostID        = $This.Hostname.Split(".")[0]
            $This.DomainName    = (realm discover)[0]
            $This.Chassis       = $This.Item("Chassis")
            $This.MachineID     = $This.Item("Machine ID")
            $This.BootID        = $This.Item("Boot ID")
            $This.VMProvider    = $This.Item("Virtualization")
            $This.OS            = $This.Item("Operating System")
            $This.CPE           = $This.Item("CPE OS Name")
            $This.Kernel        = $This.Item("Kernel")
            $This.Architecture  = $This.Item("Architecture")
        }
    }

    class _Interface
    {
        [String] $Name
        [String] $Type
        [String] $Flags
        [Int32]  $Active
        [Int32]  $MTU
        [String] $IPV4Address
        [String] $Netmask
        [String] $Broadcast
        [String] $IPV4PrefixLength
        [String] $IPV4Network
        [String] $IPV6Address
        [String] $PrefixLength
        [String] $ScopeID
        [String] $MacAddress
        [Int32]  $TXQueueLength
        [String[]] $Interface

        [String] Item([String]$I)
        {
            $Item = $This.Interface | ? { $_ -cmatch $I }
            
            Return @( If (!!$Item) {$Item.Split(" ")[1]} Else {"-"} )
        }

        [String] Slot()
        {
            $Item = $This.Interface | ? { $_ -match "(\(\w+\))" }

            Return @( If (!!$Item) {$Item} Else {"-"} )
        }

        [String] IPV4Prefix ([String]$NetMask)
        {
            Return @( ( $NetMask.Split(".") | % { [Convert]::ToString($_,2) | % ToCharArray } ) | ? { $_ -match 1 } ).Count
        }

        [String] IPV4Net([String]$IPV4Address)
        {
            Return @( ip route | ? { $_ -match $IPV4Address } | % Split " " )[0]
        }

        _Interface([String]$IF)
        {
            $This.Interface        = $IF -Split "\s{2}" | ? Length -gt 0
            $This.Type             = $This.Slot()
            $This.Name             = ($This.Interface[0] -Split ":")[0]
            $This.Flags            = ($This.Interface[0] -Split "=")[1]
            $This.MTU              = $This.Item("mtu")
            $This.IPV4Address      = $This.Item("inet ")
            $This.Netmask          = $This.Item("netmask")
            $This.IPV4PrefixLength = $This.IPV4Prefix($This.NetMask)
            $This.IPV4Network      = $This.IPV4Net($This.IPV4Address)
            $This.Broadcast        = $This.Item("broadcast")
            $This.IPV6Address      = $This.Item("inet6")
            $This.PrefixLength     = $This.Item("prefixlen")
            $This.ScopeID          = $This.Item("scopeid")
            $This.MacAddress       = $This.Item("ether")
            $This.TXQueueLength    = $This.Item("txqueuelen")
        }
    }

    Class _Network
    {
        [Object]            $Host
        [Object]       $Interface
        [Object]         $Network

        _Network()
        {
            $This.Host               = [_Host]::New()
            $This.Interface          = @( )

            $Config                  = (ifconfig) -Split "`n"
            $Array                   = ""

            ForEach ( $I in 0..($Config.Count - 1 ))
            {
                $Array              += $Config[$I]

                If ( $Config[$I].Length -eq 0 )
                {
                    $This.Interface += [_Interface]::New($Array)
                    $Array           = ""
                }
            }

            $This.Network            = @( )
            $This.Interface          | ? Flags -match "4163" | % { $This.Network += $_.IPV4Network }
        }
    }

    [_Network]::New()
}
