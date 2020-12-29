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
        $This.Primary      = $HostMap | ? { $_.NBT.ID -match "1b" }
        $This.Secondary    = $HostMap | ? { $_.NBT.ID -match "1c" }
        $This.Output       = @( )
        $This.Target       = @( )
        $This.Credential   = $Null

        $This.Primary      | % { 
        
            $_.NetBIOS     = $_.NBT | ? ID -eq 1b | % Name
        }

        $This.Secondary    | % { 
                
            $_.NetBIOS     = $_.NBT | ? ID -eq 1c | % Name 
        }

        $This.Output       = $This.Primary, $This.Secondary | Select -Unique
        $This.Output       = $This.Output | Select-Object IPAddress, Hostname, NetBIOS
    }
}
