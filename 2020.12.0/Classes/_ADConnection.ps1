Class _ADConnection
{
    [Object] $Primary
    [Object] $Secondary
    [Object] $Target
    [Object] $Credential
    [Object] $Output
    [Object] $Return

    _ADConnection([Object]$Hostmap)
    {
        $This.Primary               = $HostMap | ? { $_.NBT.ID -match "1b" }
        $This.Secondary             = $HostMap | ? { $_.NBT.ID -match "1c" }
        $This.Output                = @( )
        $This.Target                = @( )
        $This.Credential            = $Null

        If ( $This.Primary )
        {
            $This.Primary.NetBIOS   = $This.Primary.NBT   | ? ID -eq 1b | % Name
        }

        If ( $This.Secondary )
        {
            $This.Secondary.NetBIOS = $This.Secondary.NBT | ? ID -eq 1c | % Name 
        }

        $This.Output                = $This.Primary, $This.Secondary | Select -Unique
        $This.Output                = $This.Output | Select-Object IPAddress, Hostname, NetBIOS
    }
}
