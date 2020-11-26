Class Network
{
    [Object]            $Host
    [Object]       $Interface
    [Object]         $Network

    Network()
    {
        $This.Host               = [UnixHost]::New()
        $This.Interface          = @( )

        $Config                  = (ifconfig) -Split "`n"
        $Array                   = ""

        ForEach ( $I in 0..($Config.Count - 1 ))
        {
            $Array              += $Config[$I]

            If ( $Config[$I].Length -eq 0 )
            {
                $This.Interface += [NetInterface]::New($Array)
                $Array           = ""
            }
        }

        $This.Network            = @( )
        $This.Interface          | ? Flags -match "4163" | % { $This.Network += $_.IPV4Network }
    }
}
