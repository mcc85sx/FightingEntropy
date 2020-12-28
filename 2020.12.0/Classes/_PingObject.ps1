Class _PingObject
{
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
        $This.HostName       = Switch ( $This.Status )
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
