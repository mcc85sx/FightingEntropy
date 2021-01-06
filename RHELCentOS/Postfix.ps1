lass PostFix
{
    [String] $Hostname
    [String]   $Domain
    [String]  $Network
    [String[]]   $List = @( )
    [String]     $Path = "/etc/postfix/main.cf"
    [String[]]  $Value

    PostFix([String]$Network)
    {
        $This.Hostname = (hostname)
        $This.Domain   = (realm discover | ? { $_ -match "domain" } | % Substring 15)
        $This.Network  = $Network
    }

    Install()
    {
        sudo yum install postfix -y
        $This.Value    = Get-Content -Path $This.Path
    }

    Swap()
    {
        $This.Value = $This.Value -Replace '#myhostname = host.domain.tld',
        ('myhostname = {0}' -f $This.Hostname)
        
        $This.Value = $This.Value -Replace '#mydomain = domain.tld',
        ('mydomain = {0}' -f $This.Domain)

        $This.Value = $This.Value -Replace "#myorigin = ",
        "myorigin = "
        
        $This.Value = $This.Value -Replace '#inet_interfaces = all', 
        'inet_interfaces = all' 
        
        $This.Value = $This.Value -Replace "#mydestination = ","mydestination = "

        $This.Value = $This.Value -Replace "(\#\s*mail\.)","mail."

        $This.Value = $This.Value -Replace '#local_recipient_maps',
        'local_recipient_maps'

        $This.Value = $This.Value -Replace "#mynetworks_style = subnet",
        "mynetworks_style = subnet"

        $This.Value = $This.Value -Replace "#mynetworks = 168.100.189.0/28, 127.0.0.0/8",
        ('mynetworks = {0}, 127.0.0.0/8' -f $This.Network)
    }

    WriteCFG()
    {
        Set-Content -Path $This.Path -Value $This.Value -Verbose -Force
    }
}
