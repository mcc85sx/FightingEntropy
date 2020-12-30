Class _PingObject
{
    Static Hidden [Object] $Ref = [_NBTRef]::New().Output
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

        If ( $This.Status -eq "+" )
        {
            Write-Host ( "[+] {0}/{1}" -f $This.IPAddress, $This.Hostname )

            $This.NBT          = nbtstat -a $This.IPAddress | ? { $_ -match "Registered" } | % { [_NBTHost]::New($This.Ref,$_) }
            $This.NetBIOS      = $This.NBT | ? { $_.ID -match "1B" -or $_.ID -eq "1C" } | Select -Unique | % Name 
        }
    }
}
