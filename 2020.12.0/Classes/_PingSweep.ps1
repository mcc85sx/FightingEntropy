Class _PingSweep
{
    [String[]] $IPAddress
    Hidden [Hashtable] $Process
    [Object] $Buffer         = @( 97..119 + 97..105 | % { "0x{0:x}" -f $_ } )
    [Object] $Options
    [Object] $Output
    [Object] $Result

    _PingSweep([String[]]$IPAddress)
    {
        $This.IPAddress      = $IPAddress
        $This._Refresh()
    }

    _Refresh()
    {
        $This.Process        = @{ }

        ForEach ( $X in 0..( $This.IPAddress.Count - 1 ) )
        {
            $IP              = $This.IPAddress[$X]

            $This.Options    = [System.Net.NetworkInformation.PingOptions]::new()
            $This.Process.Add($X,[System.Net.NetworkInformation.Ping]::new().SendPingAsync($IP,100,$This.Buffer,$This.Options))
        }

        $This.Output         = @( )
        
        ForEach ( $X in 0..( $This.IPAddress.Count - 1 ) ) 
        {
            $IP              = $This.IPAddress[$X] 
            $This.Output    += [_PingObject]::New($X,$IP,$This.Process[$X])
        }
    }
    
    [Object[]] _Filter()
    {
        $This.Output | ? Status -eq +
    }
}
