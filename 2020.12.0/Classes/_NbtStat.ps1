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
        $This.Hosts      = $Object | ? { $_ -match "Registered" } | % { [_NBTHost]::New($_) }
    }
}
