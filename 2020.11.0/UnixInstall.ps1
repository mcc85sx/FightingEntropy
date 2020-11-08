# hostnamectl set-hostname centos-lab.securedigitsplus.com

Class UnixHost
{
    Hidden [Object] $Obj = (hostnamectl)
    [String] $Hostname
    [String] $Chassis
    [String] $MachineID
    [String] $BootID
    [String] $VMProvider
    [String] $OS
    [String] $CPE
    [String] $Kernel
    [String] $Architecture

    [String] Item([String]$I)
    {
        $Item = ( $This.Obj | ? { $_ -cmatch $I } )

        Return @( If (!!$Item) {$Item.Substring(20)} Else {"-"} )
    }

    UnixHost()
    {
        $This.Hostname      = $This.Item("Static hostname")
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

class NetInterface
{
    [String] $Name
    [String] $Type
    [String] $Flags
    [Int32]  $Active
    [Int32]  $MTU
    [String] $IPV4Address
    [String] $Netmask
    [String] $Broadcast
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

    NetInterface([String]$IF)
    {
        $This.Interface     = $IF -Split "\s{2}" | ? Length -gt 0
        $This.Type          = $This.Slot()
        $This.Name          = ($This.Interface[0] -Split ":")[0]
        $This.Flags         = ($This.Interface[0] -Split "=")[1]
        $This.MTU           = $This.Item("mtu")
        $This.IPV4Address   = $This.Item("inet ")
        $This.Netmask       = $This.Item("netmask")
        $This.Broadcast     = $This.Item("broadcast")
        $This.IPV6Address   = $This.Item("inet6")
        $This.PrefixLength  = $This.Item("prefixlen")
        $This.ScopeID       = $This.Item("scopeid")
        $This.MacAddress    = $This.Item("ether")
        $This.TXQueueLength = $This.Item("txqueuelen")
    }
}

Class Network
{
    [Object]            $Host
    [Object]       $Interface

    Network()
    {
        $This.Host               = [UnixHost]::New()
        $This.Interface          = @( )

        $Config                  = (ifconfig) -Split "`n"
        $Array                   = ""

        ForEach ( $I in 0..($Config.Count - 1 ))
        {
            $Array              += $Config[$I]

            If ( $Config[$I].Length -eq 0 )
            {
                $This.Interface += [NetInterface]::New($Array)
                $Array           = ""
            }
        } 
    }
}

$Net = [Network]::New()
