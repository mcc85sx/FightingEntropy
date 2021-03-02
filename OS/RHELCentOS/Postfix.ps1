Class PostFix
{
    [String]  $Hostname
    [String]    $Domain
    [String]   $Network
    [String]      $Path = "/etc/postfix/main.cf"
    [String[]] $Content
    [String[]]  $Output

    PostFix([String]$Network)
    {
        $This.Hostname = (hostname)
        $This.Domain   = (realm discover | ? { $_ -match "domain" } | % Substring 15)
        $This.Network  = $Network

        If (!(Test-Path $This.Path))
        {
            Write-Host "Checking/Installing [:] Postfix"
            sudo yum install postfix -y
        }

        $This.Content    = Get-Content -Path $This.Path
    }

    Configure()
    {
        $This.Output = $This.Content
        $This.Output = $This.Output -Replace '#myhostname = host.domain.tld',
        ('myhostname = {0}' -f $This.Hostname)
        
        $This.Output = $This.Output -Replace '#mydomain = domain.tld',
        ('mydomain = {0}' -f $This.Domain)

        $This.Output = $This.Output -Replace "#myorigin = ",
        "myorigin = "
        
        $This.Output = $This.Output -Replace '#inet_interfaces = all', 
        'inet_interfaces = all' 
        
        $This.Output = $This.Output -Replace "#mydestination = ",
        "mydestination = "

        $This.Output = $This.Output -Replace "(\#\s*mail\.)",
        "mail."

        $This.Output = $This.Output -Replace '#local_recipient_maps',
        'local_recipient_maps'

        $This.Output = $This.Output -Replace "#mynetworks_style = subnet",
        "mynetworks_style = subnet"

        $This.Output = $This.Output -Replace "#mynetworks = 168.100.189.0/28, 127.0.0.0/8",
        ('mynetworks = {0}, 127.0.0.0/8' -f $This.Network)
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose -Force
    }
}
