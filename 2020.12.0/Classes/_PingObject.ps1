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
        $This.Reply            = $Reply.Result
        $This.Index            = $Index
        $This.Status           = @("-","+")[[Int32]($Reply.Result.Status -match "Success")]
        $This.IPAddress        = $Address
        $This.Hostname         = Switch ($This.Status)
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

        $This.NBT              = nbtstat -a $This.IPAddress | ? { $_ -match "Registered" } | % { [_NBTHost]::New([_NBTRef]::New().Output,$_) }
        $This.NetBIOS          = $This.NBT | ? { $_.ID -eq "1b" -or $_.ID -eq "1c" } | Select -Unique
    }
}
