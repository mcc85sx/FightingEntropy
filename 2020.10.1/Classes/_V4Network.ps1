Class _V4Network
{
    [String]            $IPAddress
    [String]                $Class
    [Int32]                $Prefix
    Hidden [Object]         $Route
    [String]              $Network
    [String]              $Gateway
    Hidden [String[]]      $Subnet
    [String]            $Broadcast

    _V4Network([Object]$Address)
    {
        If ( ! $Address )
        {
            Throw "Address Empty"
        }

        $This.IPAddress = $Address.IPAddress
        $This.Class     = @('N/A';@('A')*126;'Local';@('B')*64;@('C')*32;@('MC')*16;@('R')*15;'BC')[[Int32]$This.IPAddress.Split(".")[0]]
        $This.Prefix    = $Address.PrefixLength

        $This.Route     = Get-NetRoute -AddressFamily IPV4 | ? InterfaceIndex -eq $Address.InterfaceIndex
        $This.Network   = $This.Route | ? { ($_.DestinationPrefix -Split "/")[1] -match $This.Prefix } | % { ($_.DestinationPrefix -Split "/")[0] }
        $This.Gateway   = $This.Route | ? NextHop -ne 0.0.0.0 | % NextHop
        $This.Subnet    = $This.Route | ? DestinationPrefix -notin 255.255.255.255/32,224.0.0.0/4,0.0.0.0/0 | % DestinationPrefix | Sort-Object
        $This.Broadcast = ( $This.Subnet | % { ( $_ -Split "/" )[0] } )[-1]
    }
}