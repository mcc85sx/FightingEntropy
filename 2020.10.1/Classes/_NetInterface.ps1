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