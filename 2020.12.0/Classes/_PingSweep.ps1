Class _PingSweep
{
    [String[]] $IPAddress
    Hidden [Hashtable] $Process
    [Object] $Buffer            = @( 97..119 + 97..105 | % { "0x{0:x}" -f $_ } )
    [Object] $Options
    [Object] $Output

    _PingSweep([String[]]$IPAddress)
    {
        $This.IPAddress         = $IPAddress
        $This._Refresh()
    }

    _Refresh()
    {
        $This.Process           = @{ }
        $X                      = 0

        ForEach ( $IP in $This.IPAddress )
        {
            $This.Options       = [System.Net.NetworkInformation.PingOptions]::new()
            $This.Process.Add( $X ++ , [System.Net.NetworkInformation.Ping]::new().SendPingAsync($IP,100,$This.Buffer,$This.Options))
        }

        $This.Output            = $This.Process | % GetEnumerator | Sort-Object Name | % Value
    }

    [Object[]] _Filter()
    {
        Return @( $This.Output | % Result | ? Status -ne TimedOut | Sort-Object Address )
    }
}
