Class _ADConnection
{
    [Object] $Primary
    [Object] $Secondary
    [Object] $Swap
    [Object] $Target
    [Object] $Credential
    [Object] $Output
    [Object] $Return

    _ADConnection([Object]$Hostmap)
    {
        $This.Primary                        = $HostMap | ? { $_.NBT.ID -match "1b" }
        $This.Secondary                      = $HostMap | ? { $_.NBT.ID -match "1c" }
        $This.Swap                           = @( )
        
        $This.Target                         = $Null
        $This.Credential                     = $Null

        If ( $This.Primary   ) { $This.Swap += $This.Primary   }
        If ( $This.Secondary ) { $This.Swap += $This.Secondary }

        $This.Output                         = $This.Swap  | Select-Object -Unique IPAddress, Hostname, NetBIOS
    }
}
