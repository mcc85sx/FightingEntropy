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
    [Object]          $Object
    [String[]]        $Config

    Network()
    {
        $This.Host            = hostnamectl
        $This.Config          = (ifconfig) -Split "`n"
        $This.Object          = @( )
        $Array                = ""

        ForEach ( $I in 0..($This.Config.Count - 1 ) )
        {
            $Array           += $This.Config[$I]

            If ( $This.Config[$I].Length -eq 0 )
            {
                $This.Object += [NetInterface]::New($Array)
                $Array        = ""
            }
        } 
    }
}
