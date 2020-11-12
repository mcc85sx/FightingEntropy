# _______________________________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ PowerShell - Obtains pwsh to process script \\
    su -                                                                  
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    yum install powershell -y
    sudo pwsh
#\________________________________________________________________________/
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

Class Content  # 2020_1111 @ MCC 
{
    [String]      $Path
    [Object]   $Content
    [String[]]  $Search
    [String[]]  $Target

    Content([String]$Path,[String[]]$Search,[String[]]$Target)
    {
        If ( $Search.Count -ne $Target.Count -or $Search.Count -eq 0 -or $Target.Count -eq 0 )
        {
            Throw "Invalid input" 
        }

        $This.Path    = $Path
        $This.Content = Get-Content $This.Path
        $This.Search  = $Search
        $This.Target  = $Target

        Switch($This.Search.Count)
        {
            Default 
            {
                ForEach ( $I in 0..( $This.Search.Count - 1 ) )
                { 
                    $This.Content = $This.Content -Replace $This.Search[$I], $This.Target[$I] 
                }
            }

            1 
            {
                $This.Content = $This.Content -Replace $This.Search, $This.Target
            }
        }

        Set-Content $This.Path $This.Content
    }
}

Class Service # 2020_1111 @ MCC 
{
    [String]             $Name
    [Object]           $Object
    [String[]]         $Status = ("start enable reload restart status" -Split " ")

    [ValidateSet("Launch","Status","Restart")]
    [String]             $Mode

    [String]            $Title
    [String[]]           $Slot

    Service([String]$Mode,[String]$Name)
    {
        $This.Name             = $Name
        $This.Object           = (systemctl status $Name)
        $This.Mode             = $Mode
        $This.Title            = @{ 
            
            Launch             = "Launching"
            Status             = "Launch w/ Status"
            Restart            = "Restarting" 
        
        }[$Mode]
        
        $This.Slot             = @{ 
            
            Launch             = 0,1,2
            Status             = 0,1,4
            Restart            = 3 
        
        }[$Mode]
        
        $This.Slot             = [Int32[]]$This.Slot | % { $This.Status[$_] }

        ForEach ( $Item in $This.Slot )
        {
            systemctl $Item $This.Name
        }
    }
}

Class UnixHost # 2020_1111 @ MCC
{
    Hidden [Object]         $Obj = (hostnamectl)
    Hidden [String[]]     $Order = ("Hostname Chassis MachineID BootID VMProvider OS CPE Kernel Architecture" -Split " ") 
    [String]           $Hostname
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

    UnixHost()
    {
        $This.Hostname      = $This.Item("Static hostname")
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

Class NetInterface  # 2020_1111 @ MCC
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

    NetInterface([String]$IF)
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

Class Network  # 2020_1111 @ MCC
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

Function Set-Selinux
{
    [Content]::New("/etc/sysconfig/selinux","SELINUX=enforcing","SELINUX=disabled")
}

Function Set-VideoResolution
{
    grubby --update-kernel=ALL --args ="video=hyperv_fb:1920x1080"
    # There's a way to do this without rebooting...
    reboot
}

Function Set-PowerShellLink
{
    [String] $User  = (who).Split("  :")[0]
    [String] $Path  = "/home/$User/Desktop/PowerShell.desktop"
    [Object] $Value = ("[Desktop Entry];Version=1.0;Type=Application;Terminal=true;Exec=/opt/microsoft/powershell/7/pwsh;Name=PowerShell 7;Comment=;Icon=".Split(";"))
    
    Set-Content -Path $Path -Value $Value
    sudo chmod 755 $Path
}

Function Install-Network
{
    sudo yum install wget tar net-tools -y
}

Function Configure-Network
{
    $Network = [Network]::New()

    $Network.Host
    $Network.Interface
    $Network.Network

    #If ( $Network.Host.Hostname -ne $Target )
    #{
    #    hostnamectl set-hostname $Target
    #}
            
    $IPAddress = $Network.Interface | ? Flags -match 4163 | % IPV4Address
    $Content   = Get-Content -Path "/etc/hosts"
    
    Switch ($IPAddress.Count)
    {
        0
        { 
            Throw "Invalid entry" 
        }

        1
        {
            $Content += ( "{0} {1} {2}" -f $IPAddress,$Network.Host.HostID, $Network.Host.HostName )
        }

        Default 
        { 
            ForEach ( $IP in $IPAddress )
            {
                $Item = ( "{0} {1} {2}" -f $IP, $Network.Host.HostID, $Network.Host.HostName )
                If ( $Item -notin $Content )
                {
                    $Content += $Item
                }
            }
        }
    }

    Set-Content -Path "/etc/hosts" -Value @($Content)
}

Function Install-VSCode
{
    "https://packages.microsoft.com" | % { 
    
    	[Object]    $Keys = "$_/keys/microsoft.asc"
    	[Object]    $Repo = "$_/yumrepos/vscode"
    }
                
    sudo rpm --import $Keys
    Set-Content -Path "/etc/yum.repos.d/vscode.repo" -Value @("[code];name=Visual Studio Code;baseurl=$Repo;enabled=1;gpgcheck=1;gpgkey=$Keys".Split(';')) -Verbose

    sudo yum install code -y
    code --install-extension ms-vscode.powershell
}

Function Install-MicrosoftEdge
{
    "https://packages.microsoft.com" | % {

	sudo rpm --import $_/keys/microsoft.asc
	sudo dnf config-manager --add-repo $_/yumrepos/edge
    	sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-dev.repo
        sudo dnf install microsoft-edge-dev -y
    }
}



Function Install-ADDS
{
    yum install realmd sssd oddjob oddjob-mkhomedir adcli samba samba-common samba-common-tools krb5-workstation -y
}

Function Install-CIFS
{
    yum install cifs-utils -y
}

Function Get-ADLogin ([String]$Username)
{
    realm join -v -U $Username.ToUpper()
}

Function Get-CIFSShare ([String]$Server,[String]$Share,[String]$Mount="/mnt",[String]$Username)
{
    sudo mount.cifs //$Server/$Share $Mount -o user=$UserName
}

Function Install-Apache
{
    sudo yum install epel-release httpd httpd-tools -y
    chown apache:apache /var/www/html -R
}

Function Configure-Apache
{
    [String]            $Root = "/etc/httpd/conf/httpd.conf"
    [String]      $ServerName = (hostname)
    [String[]]       $Content = (Get-Content $Root)

    0..( $Content.Count - 1 ) | % { 
        
        If ( $Content[$_] -match "(<Directory />)" )
        {
            $Content[$_+1]    = $Content[$_+1] -Replace "none","all" 
        }
        
        If ( $Content[$_] -match "(#ServerName)" ) 
        { 
            $Content[$_]      = $Content[$_] -Replace "www.example.com", $ServerName -Replace "#Ser","Ser" 
        }
    }

    Set-Content -Path $Root -Value $Content -Verbose

    "http","https" | % { firewall-cmd --zone=public --permanent --add-service=$_ }

    [Service]::New("Launch","httpd")
}

Function Install-MariaDB
{
    sudo yum install mariadb mariadb-server -y
    [Service]::New("Launch","mariadb")
}

Function Install-PostFix
{
    sudo yum install postfix -y
}

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
    
    <#[Content]::New("/etc/postfix/main.cf")
    
    #   30 | compatibility_level = 2
    #   41 | #soft_bounce = no
    #   50 | queue_directory = /var/spool/postfix
    #   55 | command_directory = /usr/sbin
    #   61 | daemon_directory = /usr/libexec/postfix
    #   67 | data_directory = /var/lib/postfix
    #   78 | mail_owner = postfix
    #   85 | #default_privs = nobody
        94 | myhostname = mail.securedigitsplus.com #
    #   95 | #myhostname = More than likely for a virtual host or fallback #
       102 | mydomain = securedigitsplus.com        #
    #  118 | #myorigin = $myhostname
       119 | myorigin = $mydomain
       132 | inet_interfaces = all
    #  133 | #inet_interfaces = $myhostname
    #  134 | #inet_interfaces = $myhostname , localhost
       135 | inet_interfaces = localhost
       138 | inet_protocols = all
    #  149 | #proxy_interfaces = 
    #  150 | #proxy_interfaces = 1.2.3.4
       183 | mydestination = $myhostname, localhost.$mydomain, localhost
    #  184 | #mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
       185 | mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,
    #  186 | #  mail.$mydomain, www.$mydomain, ftp.$mydomain
       227 | local_recipient_maps = unix:passwd.byname $alias_maps
       228 | local_recipient_maps = proxy:unix:passwd.byname $alias_maps
       229 | local_recipient_maps = 
       240 | unknown_local_recipient_reject_code = 550
    #  268 | #mynetworks_style = class
       269 | mynetworks_style  = subnet
    #  270 | #mynetworks_style = host
       283 | mynetworks = 192.168.1.0/24, 127.0.0.0/8
    #  284 | #mynetworks = $config_directory/mynetworks
    #  285 | #mynetworks = hash:/etc/postfix/network_table
    #  315 | #relay_domains = $mydestination [ Scope ]
    #  332 | #relayhost = $mydomain
    #  333 | #relayhost = [gateway.my.domain]
    #  334 | #relayhost = [mailserver.isp.tld]
       335 | #relayhost = uucphost
       336 | #relayhost = [an.ip.add.ress]
       350 | #relay_recipient_maps = hash:/etc/postfix/relay_recipients
       367 | in_flow_delay = 1s
       404 | #alias_maps = dbm:/etc/aliases
       405 | alias_maps = hash:/etc/aliases
       406 | #alias_maps = hash:/etc/aliases, nis:mail.aliases
       407 | #alias_maps = netinfo:/aliases
       414 | #alias_database = dbm:/etc/aliases
       415 | #alias_database = dbm:/etc/mail/aliases
       416 | alias_database = hash:/etc/aliases
       417 | #alias_database = hash:/etc/aliases, hash:/opt/majordomo/aliases
       428 | #recipient_delimiter = +
       437 | #home_mailbox = Mailbox
       438 | home_mailbox = Maildir/
       444 | #mail_spool_directory = /var/mail
       445 | #mail_spool_directory = /var/spool/mail
       466 | #mailbox_command = /some/where/procmail
       467 | #mailbox_command = /some/where/procmail -a "$EXTENSION"
       486 | #mailbox_transport = lmtp:unix:/var/lib/imap/socket/lmtp
       498 | # local_destination_recipient_limit = 300
       499 | # local_destination_concurrency_limit = 5
       510 | #mailbox_transport = cyrus
       526 | #fallback_transport = lmtp:unix:/var/lib/imap/socket/lmtp
       527 | #fallback_transport = 
       548 | #luser_relay = $user@other.host
       549 | #luser_relay = $local@other.host
       550 | #luser_relay = admin+$local
       567 | #header_checks = regexp:/etc/postfix/header_checks
       580 | #fast_flush_domains = $relay_domains
       591 | #smtpd_banner = $myhostname ESMTP $mail_name
       592 | #smtpd_banner = $myhostname ESMTP $mail_name ($mail_version)
       608 | #local_destination_concurrency_limit = 2
       609 | #default_destination_concurrency_limit = 20
       617 | debug_peer_level = 2
       625 | #debug_peer_list = 127.0.0.1
       626 | #debug_peer_list = some.domain
       635 | debugger_command = 
       636 |      PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
       637 | 	   ddd $daemon_directory/$process_name $Process_id & sleep 5
       665 | sendmail_path = /usr/sbin/sendmail.postfix
       670 | newaliases_path = /usr/bin/newaliases.postfix
       675 | mailq_path = /usr/bin/mailq.postfix
       681 | setgid_group = postdrop
       685 | html_directory = no
       689 | manpage_directory = /user/share/man
       694 | sample_directory = /usr/share/doc/postfix/samples
       698 | readme_directory = /usr/share/doc/postfix/README_FILES
       709 | smtpd_tls_cert_file = /etc/pki/tls/certs/postfix.pem
       715 | smtpd_tls_key_file = /etc/pki/tls/private/postfix.key
       720 | smtpd_tls_security_level = may
       725 | smtpd_tls_CApath = /etc/pki/tls/certs
       731 | smtpd_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
       736 | smtp_tls_security_level = may
       737 | meta_directory = /etc/postfix
       738 | shlib_directory = /usr/lib64/postfix #>

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

Function Install-RoundCube
{
    [String] $Name = "roundcubemail-1.4.9"
    [String] $File = "$Name-complete.tar.gz"
    [String] $Path = "/var/www/roundcube"

    wget "https://github.com/roundcube/roundcubemail/releases/download/1.4.9/$File"
    sudo tar xvzf $File
    
    If ( ! ( Test-Path $Path ) ) 
    { 
        New-Item -Path $Path -ItemType Directory -Verbose 
    }

    sudo mv $Name $Path

    sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
    sudo dnf module reset php -y
    sudo dnf module enable php:remi-7.4 -y

    sudo dnf install php-ldap php-imagick php-common php-gd php-imap php-json php-curl php-zip php-xml php-mbstring php-bz2 php-intl php-gmp -y 
    #(("ldap imagick common gd imap json curl zip xml mbstring bz2 intl gmp" -Split " ") | % { "php-$_" }) -join " "
}

Function Configure-RoundCube 
(    
    [String]$Path="/var/www/roundcube"
    [String]$Name=[Network]::New().Host.Hostname,
    [Int32]$Port=80,
    [String]$Root="/var/www/html/",
    [String]$Logs="/var/log/httpd"
)
{   
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
sudo firewall-cmd --zone=public --permanent --add-service={http,https,smtp-submission,smtps,imap,imaps}

systemctl reload firewalld
sudo dnf install wget
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot
sudo chown root /usr/local/bin/certbot
sudo chmod 0755 /usr/local/bin/certbot

sudo nano /etc/httpd/conf.d/mail.securedigitsplus.com.conf
