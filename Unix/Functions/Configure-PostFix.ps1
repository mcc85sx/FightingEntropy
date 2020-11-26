Function Configure-PostFix
{
    [Object] $Network   = [Network]::New().Network
    [String] $Hostname  = (hostname)
    [String] $Domain    = $Hostname -Replace "$($Hostname.Split(".")[0]).",""
    [String[]] $Content = Get-Content "/etc/postfix/main.cf"

    If ( $Network.Count -gt 1 )
    {
        $Network        = $Network -join ', '
    }
    
    #[Content]::New("/etc/postfix/main.cf")
    $Replace            = @{ }

    $Replace            | % Add 0 ("#myhostname = host.domain.tld","myhostname = $hostname")
    $Replace            | % Add 1 ("#mydomain =","mydomain = $Domain")
    $Replace            | % Add 2 ('myorigin = $mydomain'  | % { "#$_", $_ })
    $Replace            | % Add 3 ('inet_interfaces = all' | % { "#$_", $_ })
    $Replace            | % Add 4 ('mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,' | % { "#$_", $_ })
    $Replace            | % Add 5 ('  mail.$mydomain, www.$mydomain, ftp.$mydomain' | % { "#$_", $_ })
    $Replace            | % Add 6 ("local_recipient_maps" | % { "#$_", $_ })
    $Replace            | % Add 7 ("mynetworks_style = subnet" | % { "#$_", $_ })
    $Replace            | % Add 8 ("mynetworks = 168.100.189.0/28, 127.0.0.0/8" | % {"#$_",$_.Replace("168.100.189.0/28",$Network)})

    ForEach ( $I in 0..($Replace.Count - 1 ) )
    {
        $Content        = $Content.Replace($Replace[$I][0],$Replace[$I][1])
    }
    
    # DEBUG | 0..( $Content.Count - 1 ) | % { "[{0:d3}] {1}" -f $_,$Content[$_] }
}
