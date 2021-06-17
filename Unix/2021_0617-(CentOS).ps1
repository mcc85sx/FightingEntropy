# _______________________________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ PowerShell - Obtains pwsh to process script \\
    su -                                                                  
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    yum install powershell -y
    sudo pwsh
#\________________________________________________________________________/
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
# _______________________________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ Refresh Certificates \\

# ____________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ Visual Studio Code \\
Function Install-VSCode
{
    $Link = "https://packages.microsoft.com"
    $Keys = "$Link/keys/microsoft.asc"
    $Repo = "$Link/yumrepos/vscode"
            
    sudo rpm --import $Keys
    Set-Content "/etc/yum.repos.d/vscode.repo" "[code]|name=Visual Studio Code|baseurl=$Repo|enabled=1|gpgcheck=1|gpgkey=$Keys".Split('|') -VB

    sudo yum install code
    code --install-extension ms-vscode.powershell
}
#\___________________________________________________________________________________________________//
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Function _NetworkObject
{
    Class _Host
    {
        Hidden [Object]         $Obj = (hostnamectl)
        Hidden [String[]]     $Order = ("Hostname HostID Chassis MachineID BootID VMProvider OS CPE Kernel Architecture" -Split " ") 
        [String]             $HostID
        [String]           $Hostname
        [String]         $DomainName
        [String]            $Chassis
        [String]          $MachineID
        [String]             $BootID
        [String]         $VMProvider
        [String]                 $OS
        [String]                $CPE
        [String]             $Kernel
        [String]       $Architecture

        [String]                Item([String]$I)
        {
            $Item = ( $This.Obj | ? { $_ -cmatch $I } )

            Return @( If (!!$Item) {$Item.Substring(20)} Else {"-"} )
        }

        _Host()
        {
            $This.Hostname      = $This.Item("Static hostname")
            $This.HostID        = $This.Hostname.Split(".")[0]
            $This.DomainName    = (realm discover)[0]
            $This.Chassis       = $This.Item("Chassis")
            $This.MachineID     = $This.Item("Machine ID")
            $This.BootID        = $This.Item("Boot ID")
            $This.VMProvider    = $This.Item("Virtualization")
            $This.OS            = $This.Item("Operating System")
            $This.CPE           = $This.Item("CPE OS Name")
            $This.Kernel        = $This.Item("Kernel")
            $This.Architecture  = $This.Item("Architecture")
        }
    }

    class _Interface
    {
        [String] $Name
        [String] $Type
        [String] $Flags
        [Int32]  $Active
        [Int32]  $MTU
        [String] $IPV4Address
        [String] $Netmask
        [String] $Broadcast
        [String] $IPV4PrefixLength
        [String] $IPV4Network
        [String] $IPV6Address
        [String] $PrefixLength
        [String] $ScopeID
        [String] $MacAddress
        [Int32]  $TXQueueLength
        [String[]] $Interface

        [String] Item([String]$I)
        {
            $Item = $This.Interface | ? { $_ -cmatch $I }
            
            Return @( If (!!$Item) {$Item.Split(" ")[1]} Else {"-"} )
        }

        [String] Slot()
        {
            $Item = $This.Interface | ? { $_ -match "(\(\w+\))" }

            Return @( If (!!$Item) {$Item} Else {"-"} )
        }

        [String] IPV4Prefix ([String]$NetMask)
        {
            Return @( ( $NetMask.Split(".") | % { [Convert]::ToString($_,2) | % ToCharArray } ) | ? { $_ -match 1 } ).Count
        }

        [String] IPV4Net([String]$IPV4Address)
        {
            Return @( ip route | ? { $_ -match $IPV4Address } | % Split " " )[0]
        }

        _Interface([String]$IF)
        {
            $This.Interface        = $IF -Split "\s{2}" | ? Length -gt 0
            $This.Type             = $This.Slot()
            $This.Name             = ($This.Interface[0] -Split ":")[0]
            $This.Flags            = ($This.Interface[0] -Split "=")[1]
            $This.MTU              = $This.Item("mtu")
            $This.IPV4Address      = $This.Item("inet ")
            $This.Netmask          = $This.Item("netmask")
            $This.IPV4PrefixLength = $This.IPV4Prefix($This.NetMask)
            $This.IPV4Network      = $This.IPV4Net($This.IPV4Address)
            $This.Broadcast        = $This.Item("broadcast")
            $This.IPV6Address      = $This.Item("inet6")
            $This.PrefixLength     = $This.Item("prefixlen")
            $This.ScopeID          = $This.Item("scopeid")
            $This.MacAddress       = $This.Item("ether")
            $This.TXQueueLength    = $This.Item("txqueuelen")
        }
    }

    Class _Network
    {
        [Object]            $Host
        [Object]       $Interface
        [Object]         $Network

        _Network()
        {
            $This.Host               = [_Host]::New()
            $This.Interface          = @( )

            $Config                  = (ifconfig) -Split "`n"
            $Array                   = ""

            ForEach ( $I in 0..($Config.Count - 1 ))
            {
                $Array              += $Config[$I]

                If ( $Config[$I].Length -eq 0 )
                {
                    $This.Interface += [_Interface]::New($Array)
                    $Array           = ""
                }
            }

            $This.Network            = @( )
            $This.Interface          | ? Flags -match "4163" | % { $This.Network += $_.IPV4Network }
        }
    }

    [_Network]::New()
}

Function _Network
{
    [CmdLetBinding()]Param([Parameter(Mandatory,Position=0)][String]$Hostname)

    If ( (hostname) -ne $Hostname )
    {
        hostnamectl set-hostname $Hostname
    }
    
    [Int32]            $X = -1
    [Hashtable]  $Collect = @{ }

    ifconfig              | % { 

        If ( $_.Length -gt 1 -and $_ -match "^\w+\:" )
        {
            $X++
            $Collect.Add($X,@( ))
        }

        $Collect[$X]     += $_
    }

    [String]      $Domain = (realm discover)[0]
    [Object[]]        $IP = @( ) 
    
    ForEach ( $Item in $Collect[0..($Collect.Count-1)] )
    { 
        $IP += ($Item | ? { $_ -match "inet " -and $_ -notmatch "127.0.0.1" } | % { [Regex]::Matches($_,"(?:inet )\d+\.\d+\.\d+\.\d+").Value.Split(" ")[-1] })
    }

    [Object[]]     $Hosts = @( )

    If (!$Domain)
    {
        $IP | % { $Hosts += ("{0} {1}" -f $_, $Hostname) }
    }

    If ($Domain)
    {
        If ( $Hostname -match $Domain )
        {
            $Hostname = ($Hostname -Split "\.")[0]
        }

        $IP | % { $Hosts += ("{0} {1} {1}.{2}" -f $_, $Hostname, $Domain)}
    }

    [String]    $Path = "/etc/hosts"
    [Object] $Content = Get-Content $Path
    
    $Hosts | % { 

        If ( $_ -notin $Content )
        {
            $Content += $_
        }
    }

    Set-Content $Path $Content -Force -Verbose
}

Function _Content
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$Path,
        [Parameter(Mandatory,Position=1)][String]$Search,
        [Parameter(Mandatory,Position=2)][String]$Replace)

    If (!(Test-Path $Path))
    {
        Throw "Invalid path"
    }

    $Content = ( Get-Content $Path ) -Replace $Search,$Replace
    
    Set-Content -Path $Path -Value $Content -Verbose
}

Function _Install
{
    [CmdLetBinding()]Param(   
    [Parameter(Mandatory,Position=0)]
    [ValidateNotNullOrEmpty()][String]$List)

    Invoke-Expression "sudo yum install $($List -Split " ") -y" 
}

Function _JoinRealm
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Username)

    realm join -v -U $Username
}

Function _JoinShare
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$Username,
        [Parameter(Mandatory,Position=1)][String]$Server,
        [Parameter(Mandatory,Position=2)][String]$Share
    )

    sudo mount.cifs "//$Server/$Share" /mnt -o user=$Username
}

Function _Apache
{
    [CmdLetBinding()]Param([Parameter(Mandatory,Position=0)][String]$Path = "/var/www/html")

    chown apache:apache $Path -R

    $Conf    = "/etc/httpd/conf/httpd.conf" 
    $Content = Get-Content $Conf
    
    ForEach ( $X in 0..($Content.Count - 1))
    {
        If ( $Content[$X] -match "(<Directory />)" )
        { 
            $Content[$X+1] = "    AllowOverride All" 
        }
    }

    Set-Content $Conf $Content

    "http","https" | % { sudo firewall-cmd --zone=public --permanent --add-service=$_ }

    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl reload httpd 
}

Function _MariaDB
{
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
    sudo systemctl reload mariadb
}

IRM https://github.com/mcc85s/FightingEntropy/blob/main/Functions/Write-Theme.ps1?raw=true | IEX

Write-Theme "Write-Theme [+] Loaded" 10,2,15,0

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ Initialization Stage ]________________________________________________________________________//¯¯¯        
#     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

    _Content "/etc/sysconfig/selinux" "SELINUX=enforcing" "SELINUX=disabled"
  
    yum update -y

    _Install ("wget tar net-tools realmd cifs-utils sssd oddjob oddjob-mkhomedir",
              "adcli samba samba-common samba-common-tools krb5-workstation", 
              "epel-release httpd httpd-tools mariadb mariadb-server postfix", 
              "dovecot" -join ' ')

    _Network "centos-lab2.securedigitsplus.com"

  _JoinRealm mcook85

  _JoinShare certsrv dsc0.securedigitsplus.com cert

  # Server
  # $Chain = _Certificate cp.securedigitsplus.com $home\.ssh\putty_key /var/etc/acme-client/certs

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ Configuration Stage    ]______________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

_Apache
_MariaDB

# ca-bundle.crt        dh.pem         postfix.pem  securedigitsplus.com.crt  securedigitsplus.com.p12
# ca-bundle.trust.crt  localhost.crt  R3.crt       securedigitsplus.com.key  securedigitsplus.com.pem


Function _PostFix
{
    $Path     = "/etc/postfix/main.cf"
    $Content  = Get-Content $Path
    $Network  = _NetworkObject
    $CertPath = "/etc/ssl/certs"

    $Hash    = @{ 

    # [029] compatibility_level = 2
    compatibility_level = 2
    
    # [040] #soft_bounce = no
    #soft_bounce         = "no"

    # [049] queue_directory = /var/spool/postfix
    queue_directory     = "/var/spool/postfix"

    # [054] command_directory = /usr/sbin
    command_directory   = "/usr/sbin"

    # [060] daemon_directory = /usr/libexec/postfix
    daemon_directory    = "/usr/libexec/postfix"

    # [066] data_directory = /var/lib/postfix
    data_directory      = "/var/lib/postfix"

    # [077] mail_owner = postfix
    mail_owner          = "postfix"

    # [084] #default_privs = nobody
    #default_privs       = "nobody"

    # [093] #myhostname = host.domain.tld
    # [094] #myhostname = virtual.domain.tld
    myhostname          = $Network.Host.Hostname

    # [101] #mydomain = domain.tld
    mydomain            = $Network.Host.DomainName

    # [116] #myorigin = $myhostname
    # [117] #myorigin = $mydomain
    myorigin            = $Network.Host.DomainName

    # [131] #inet_interfaces = all
    # [132] #inet_interfaces = $myhostname
    # [133] #inet_interfaces = $myhostname, localhost
    # [134] inet_interfaces = localhost
    inet_interfaces     = "all"

    # [137] inet_protocols = all
    inet_protocols = "all"

    # [148] #proxy_interfaces =
    # [149] #proxy_interfaces = 1.2.3.4
    #proxy_interfaces =

    # [182] mydestination = $myhostname, localhost.$mydomain, localhost
    # [183] #mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
    # [184] #mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,
    # [185] #       mail.$mydomain, www.$mydomain, ftp.$mydomain
    mydestination = $Network.Host.Hostname

    # [197] # local_recipient_maps = (i.e. empty).
    # [226] #local_recipient_maps = unix:passwd.byname $alias_maps
    # [227] #local_recipient_maps = proxy:unix:passwd.byname $alias_maps
    # [228] #local_recipient_maps =
    #local_recipient_maps =

    # [239] unknown_local_recipient_reject_code = 550
    unknown_local_recipient_reject_code = 550

    # [253] # By default (mynetworks_style = subnet), Postfix "trusts" SMTP
    # [258] # Specify "mynetworks_style = class" when Postfix should "trust" SMTP
    # [264] # Specify "mynetworks_style = host" when Postfix should "trust"
    # [267] #mynetworks_style = class
    # [268] #mynetworks_style = subnet
    # [269] #mynetworks_style = host
    mynetworks_style = "subnet"

    # [282] #mynetworks = 168.100.189.0/28, 127.0.0.0/8
    # [283] #mynetworks = $config_directory/mynetworks
    # [284] #mynetworks = hash:/etc/postfix/network_table
    mynetworks = "$($Network.Network), 127.0.0.0/8"

    # [314] #relay_domains = $mydestination
    #relay_domains = $mydestination

    # [331] #relayhost = $mydomain
    # [332] #relayhost = [gateway.my.domain]
    # [333] #relayhost = [mailserver.isp.tld]
    # [334] #relayhost = uucphost
    # [335] #relayhost = [an.ip.add.ress]
    #relayhost =

    # [349] #relay_recipient_maps = hash:/etc/postfix/relay_recipients
    #relay_recipient_maps = hash:/etc/postfix/relay_recipients

    # [366] #in_flow_delay = 1s
    in_flow_delay = "1s"

    # [403] #alias_maps = dbm:/etc/aliases
    # [404] alias_maps = hash:/etc/aliases
    # [405] #alias_maps = hash:/etc/aliases, nis:mail.aliases
    # [406] #alias_maps = netinfo:/aliases
    alias_maps = "hash:/etc/aliases"
    
    # [413] #alias_database = dbm:/etc/aliases
    # [414] #alias_database = dbm:/etc/mail/aliases
    # [415] alias_database = hash:/etc/aliases
    # [416] #alias_database = hash:/etc/aliases, hash:/opt/majordomo/aliases
    alias_database = "hash:/etc/aliases"

    # [427] #recipient_delimiter = +
    recipient_delimiter = "+"

    # [436] #home_mailbox = Mailbox
    # [437] #home_mailbox = Maildir/
    home_mailbox = "Maildir/"

    # [443] #mail_spool_directory = /var/mail
    # [444] #mail_spool_directory = /var/spool/mail
    # [465] #mailbox_command = /some/where/procmail
    # [466] #mailbox_command = /some/where/procmail -a "$EXTENSION"
    # [483] # Cyrus IMAP over LMTP. Specify ``lmtpunix      cmd="lmtpd"
    # [484] # listen="/var/imap/socket/lmtp" prefork=0'' in cyrus.conf.
    # [485] #mailbox_transport = lmtp:unix:/var/lib/imap/socket/lmtp
    # [492] # mailbox_transport = lmtp:unix:/var/lib/imap/socket/lmtp
    # [497] # local_destination_recipient_limit = 300
    # [498] # local_destination_concurrency_limit = 5
    # [509] #mailbox_transport = cyrus
    # [525] #fallback_transport = lmtp:unix:/var/lib/imap/socket/lmtp
    # [526] #fallback_transport =
    # [543] # file, then you must specify "local_recipient_maps =" (i.e. empty) in
    # [547] #luser_relay = $user@other.host
    # [548] #luser_relay = $local@other.host
    # [549] #luser_relay = admin+$local
    # [566] #header_checks = regexp:/etc/postfix/header_checks
    # [579] #fast_flush_domains = $relay_domains
    # [590] #smtpd_banner = $myhostname ESMTP $mail_name
    # [591] #smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)
    # [607] #local_destination_concurrency_limit = 2
    # [608] #default_destination_concurrency_limit = 20
    # [616] debug_peer_level = 2
    debug_peer_level = 2

    # [624] #debug_peer_list = 127.0.0.1
    # [625] #debug_peer_list = some.domain
    # [634] debugger_command =
    # [635]          PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
    # [642] # debugger_command =
    # [643] #       PATH=/bin:/usr/bin:/usr/local/bin; export PATH; (echo cont;
    # [652] # debugger_command =
    # [653] #       PATH=/bin:/usr/bin:/sbin:/usr/sbin; export PATH; screen
    # [664] sendmail_path = /usr/sbin/sendmail.postfix
    # [669] newaliases_path = /usr/bin/newaliases.postfix
    # [674] mailq_path = /usr/bin/mailq.postfix
    # [680] setgid_group = postdrop
    # [684] html_directory = no
    # [688] manpage_directory = /usr/share/man
    # [693] sample_directory = /usr/share/doc/postfix/samples
    # [697] readme_directory = /usr/share/doc/postfix/README_FILES
    # [708] smtpd_tls_cert_file = /etc/pki/tls/certs/postfix.pem
    # [714] smtpd_tls_key_file = /etc/pki/tls/private/postfix.key
    # [719] smtpd_tls_security_level = may
    # [724] smtp_tls_CApath = /etc/pki/tls/certs
    # [730] smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
    # [735] smtp_tls_security_level = may
    # [736] meta_directory = /etc/postfix
    # [737] shlib_directory = /usr/lib64/postfix

    }

    ForEach ($X in 0..($Content.Count - 1))
    {
        Switch -regex ($Content[$X])
        {

        }
    }
    [Content]::New("/etc/postfix/main.cf" | % { 

        @{
            Path    = $_
            Content = GC $_ 
        }
    }
}

Function Install-RoundCube
{
    [ CmdLetBinding () ] Param ( 
    
        [ Parameter ( Position = 0, Mandatory, HelpMessage =    "File Path" ) ] [ String ] $Path ,
        [ Parameter ( Position = 1, Mandatory, HelpMessage =   "ServerName" ) ] [ String ] $Name ,
        [ Parameter ( Position = 2,            HelpMessage =         "Port" ) ] [ Int32  ] $Port = 80 ,
        [ Parameter ( Position = 3,            HelpMessage = "DocumentRoot" ) ] [ String ] $Root = "/var/www/html/" , 
        [ Parameter ( Position = 4,            HelpMessage =    "Log Paths" ) ] [ String ] $Logs = "/var/log/httpd" )

    roundcubemail-1.4.2 | % {

        wget https://github.com/roundcube/roundcubemail/releases/download/1.4.2/$_-complete.tar.gz
        sudo tar xvzf $_-complete.tar.gz
        sudo mv $_ /var/www/roundcube/
    }

    sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
    sudo dnf module reset php
    sudo dnf module enable php:remi-7.4 -y

    sudo dnf install -y " ldap imagick common gd imap json curl zip xml mbstring bz2 intl gmp" -Replace " "," php-"
    
    Set-Content -Path $Path -Value (("|<{0} *:$Port>|  ServerName $Name|  DocumentRoot $Root||  ErrorLog $Logs`_error.log|"+
    "  CustomLog $Logs`_access.log combined||  <{1} />|    {2}|    {3}|  </{1}>||  <{1} $Root>|    {2} MultiViews|    {3}|"+
    "    Order allow,deny|    allow from all|  </{1}>||</{0}>" ) -f  "VirtualHost" , "Directory" , "Options FollowSymLinks",
    "AllowOverride All").Split('|')

}
    
Function Install-SQLDatabase
{
    [ CmdLetBinding () ] Param ( 
    
        [ Parameter ( Position = 0, Mandatory, HelpMessage =    "Database Name" ) ] [       String ] $Name ,
        [ Parameter ( Position = 1, Mandatory, HelpMessage =    "Character Set" ) ] [       String ] $Encoding = "default character set utf8 collate utf8_general_ci",
        [ Parameter ( Position = 2,            HelpMessage =   "Master Account" ) ] [       String ] $Account ,
        [ Parameter ( Position = 3,            HelpMessage =         "Password" ) ] [ SecureString ] $Password = ( Read-Host "Enter Password" -AsSecureString ) ,
        [ Parameter ( Position = 5,            HelpMessage =        "Log Paths" ) ] [       String ] $Logs     = "/var/log/httpd" )

    Do
    {
        $Confirm = Read-Host "Enter Confirmation Password" -AsSecureString
        
        If ( $Password -notmatch $Confirm )
        {
            Read-Host "Password does not match confirmation"
        }
    }
    Until  ( $Password    -match $Confirm )

    mysql_secure_installation
    mysql -u root -p
    create database $Name $Encoding;
    create user $Account@localhost identified by "$Password";
    grant all privileges on $Name.* to $Account@localhost;
    flush privileges;
    exit;

    & { "mysql -u root -p roundcube < /var/www/roundcube/SQL/mysql.initial.sql" }

    Initialize-Service php-fpm Relaunch
    Initialize-Service httpd   Restart

    setsebool -P httpd_execmem 1

    systemctl reload firewalld

    [Content]::New("/etc/php.ini",";date.timezone =","date.timezone = America/New_York")
}

#/_________________________________________

yum install dovecot -y

$Conf           = "/etc/dovecot/conf.d" | % {
    
    @{
        Dovecot = "$_/dovecot.conf" 
        Mail    = "$_/10-mail.conf" 
        Auth    = "$_/10-auth.conf" 
        Master  = "$_/10-master.conf" 
        IMAP    = "$_/20-imap.conf" 
        POP3    = "$_/20-pop3.conf" 
    }
}


gedit /etc/dovecot/dovecot.conf

$Dovecot = "/etc/dovecot/dovecot.conf"

ForEach ( $I in $Dovecot )
     24 | protocols = imap pop3 lmtp
     
gedit /etc/dovecot/conf.d/10-mail.conf
	 24 | mail_location = maildir:~/Maildir

gedit /etc/dovecot/conf.d/10-auth.conf
	 10 | disable_plaintext_auth = yes
	100 | auth mechanisms = plain login

gedit /etc/dovecot/conf.d/10-master.conf
	 91 | user = postfix
	 92 | group = postfix

gedit /etc/dovecot/conf.d/20-imap.conf
     67 | imap_client_workarounds = delay-newmail tb-extra-mailbox-sep

gedit /etc/dovedot/conf.d/20-pop3.conf
	 50 | pop3_uidl_format = %08Xu%08Xv
	 90 | pop3_client_workarounds = outlook-no-nuls oe-ns-eoh
         
openssl req -new -x509 -days 365 -nodes -out /etc/pki/dovecot/certs/mycert.pem -keyout /etc/pki/dovecot/private/mykey.pem
#

# does not work in pwsh 
IEX "sudo firewall-cmd --zone=public --permanent --add-service={http,https,smtp-submission,smtps,imap,imaps}"

systemctl reload firewalld
sudo dnf install wget
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot
sudo chown root /usr/local/bin/certbot
sudo chmod 0755 /usr/local/bin/certbot

sudo nano /etc/httpd/conf.d/mail.securedigitsplus.com.conf



openssl x509 -in /etc/ssl/certs/securedigitsplus.com.pem
securedigitsplus.com.pem
