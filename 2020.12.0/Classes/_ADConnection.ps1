Class _ADConnection
{
    [Object] $Primary
    [Object] $Secondary
    [Object] $Swap
    [Object] $Return
    [Object] $Target
    [Object] $Credential
    [Object] $Output

    _ADConnection([Object]$Hostmap)
    {
        $This.Primary               = $HostMap | ? { $_.NBT.ID -match "1b" }
        $This.Secondary             = $HostMap | ? { $_.NBT.ID -match "1c" }
        $This.Output                = @( )
        $This.Target                = @( )
        $This.Credential            = $Null

        If ( $This.Primary )
        {
            $This.Swap              = $This.Primary.NBT   | ? ID -eq 1b
        }

        If ( $This.Secondary )
        {
            $This.Swap              = $This.Secondary.NBT | ? ID -eq 1c
        }

        $This.Return                = $This.Primary, $This.Secondary | Select -Unique
        $This.Output                = $This.Return | Select-Object IPAddress, Hostname, NetBIOS
    }
}
