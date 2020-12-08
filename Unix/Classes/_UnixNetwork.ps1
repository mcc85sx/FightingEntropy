Class _UnixNetwork
{
    [Object]       $Interface
    [Object]         $Network

    _UnixNetwork()
    {
        $This.Interface          = @( )

        $Config                  = (ifconfig) -Split "`n"
        $Array                   = ""

        ForEach ( $I in 0..($Config.Count - 1 ))
        {
            $Array              += $Config[$I]

            If ( $Config[$I].Length -eq 0 )
            {
                $This.Interface += [_UnixNetInterface]::New($Array)
                $Array           = ""
            }
        }

        $This.Network            = @( )
        $This.Interface          | ? Flags -match "4163" | % { $This.Network += $_.IPV4Network }
    }
}
