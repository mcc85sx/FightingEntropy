Class _PingObject
{
    Hidden [Object]   $Reply
    [UInt32]          $Index
    [String]         $Status
    [String]        $Address
    [String]       $Hostname
    [Object]        $NetBIOS

    _PingObject([UInt32]$Index,[String]$Address,[Object]$Reply)
    {
        $This.Index          = $Index
        $This.Address        = $Address
        $This.Reply          = $Reply.Result
        $This.Status         = @("-","+")[[Int32]($Reply.Result.Status -match "Success")]
        $This.HostName       = Switch ( $This.Status )
        {
            "+"
            {
                Resolve-DNSName $This.Address | % NameHost
            }

            Default
            {
                "-"
            }
        }
    }
}
