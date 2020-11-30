Class _ArpStat
{
    Hidden [String] $Object
    [String] $IPAddress
    [String] $IFIndex
    [Object[]] $Hosts

    _ArpStat([Object]$Object)
    {
        $This.Object    = $Object
        $This.IPAddress = $Object[0].Replace("Interface: ","").Split(" ")[0]
        $This.IFIndex   = $Object[0].Split(" ")[-1]
        $This.Hosts     = $Object | ? { $_ -notmatch "Interface" } | % { [_ArpHost]::New($_) }
    }
}
