Class SELinux
{
    [String]      $Path = "/etc/sysconfig/selinux"
    [String[]] $Content
    [String[]]  $Output

    SELinux()
    {
        Write-Host "Get-Content [:] $($This.Path)"
        $This.Content = Get-Content -Path $This.Path
        $This.Output  = ($This.Content -join "`n").Replace("SELINUX=enforcing","SELINUX=disabled")
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose -Force
    }
}

Class Apache
{
    [String]      $Path = "/etc/httpd/conf/httpd.conf"
    [String[]] $Content
    [String[]]  $Output

    Apache()
    {
        
    }

    Install()
    {
        If (!(Test-Path $This.Path))
        {
            Write-Host "Checking/Installing [:] EPEL, Apache"
            sudo yum install epel-release httpd httpd-tools -y
    
            Write-Host "File System [:] /var/www/html"
            sudo chown apache:apache /var/www/html -R
        }
        
        $This.Content = Get-Content -Path $This.Path
    }
    
    Configure()
    {
        Write-Host "Configuring [:] Apache"
        $This.Output = $This.Content
        
        0..( $This.Output.Length - 1 ) | % {

            If ( $This.Output[$_] -match "(<Directory />)")
            {
                $This.Output[$_+1] = "    AllowOverride All"
            }
        }
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose -Force
    }

    Firewall()
    {
        Write-Host "Firewall [:] HTTP"
        sudo firewall-cmd --zone=public --permanent --add-service=http
        
        Write-Host "Firewall [:] HTTPS"
        sudo firewall-cmd --zone=public --permanent --add-service=https
    }

    Service()
    {
        Write-Host "System Control [:] Apache/httpd [Start]"
        sudo systemctl start httpd

        Write-Host "System Control [:] Apache/httpd [Enable]"
        sudo systemctl enable httpd 

        Write-Host "System Control [:] Apache/httpd [Reload]"
        sudo systemctl reload httpd
    }
}

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
    }

    Install()
    {
        If (!(Test-Path $This.Path))
        {
            Write-Host "Checking/Installing [:] Postfix"
            sudo yum install postfix -y
        }

        $This.Content    = Get-Content -Path $This.Path
        Write-Host "Installed [:] Postfix"
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

Class RoundCube
{
    [String]      $ServerName = (hostname)
    [UInt32]            $Port = 80
    [String] $VirtualHostName
    [String]         $Version 
    [String]             $Url
    [String]            $Path = "/var/www/roundcube"
    [String]            $Logs = "/etc/httpd/logs"
    [String[]]       $Content
    [String[]]        $Output

    RoundCube()
    {
        $This.Version         = "roundcubemail-1.4.10"
        $This.Url             = "https://github.com/roundcube/roundcubemail/releases/download/1.4.10/$($This.Version)-complete.tar.gz"
    }

    Install()
    {
        Write-Host "Checking/Installing [:] MariaDB"
        sudo yum install mariadb mariadb-server -y

        Write-Host "Downloading [:] $($This.Version)"
        sudo wget $This.URL
        
        "{0}/{1}" -f (pwd).Path, $This.Version | % { 

            Write-Host "Extracting [:] $_"
            sudo tar xvzf "$($_)-complete.tar.gz"

            Write-Host "Moving [:] $_"
            sudo mv $_ /var/www/roundcube/
        }

        Write-Host "Checking/Installing [:] PHP/Remi"
        sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

        Write-Host "Resetting [:] PHP/Service"
        sudo dnf module reset php -y

        Write-Host "Enabling [:] PHP/Remi"
        sudo dnf module enable php:remi-7.4 -y

        Write-Host "Checking/Installing [:] PHP Dependencies"
        sudo dnf install php-ldap php-imagick php-common php-gd php-imap php-json php-curl php-zip php-xml php-mbstring php-bz2 php-intl php-gmp -y
    }
    
    VirtualHost([String]$VHost)
    {
        $This.VirtualHostName = $VHost
        $This.Path   = "/etc/httpd/conf.d/{0}.conf" -f $This.VirtualHostname
        $This.Output = (("<VirtualHost *:{0}>;  ServerName {1};  DocumentRoot {2};;  ErrorLog {3}/_error.log;" +
                        "CustomLog {3}/_access.log combined;;  <Directory />;    Options FollowSymLinks;    " +
                        "AllowOverride All;  </Directory>;;  <Directory {2}>;    Options FollowSymLinks Mult" + 
                        "iViews;    AllowOverride All;    Order allow,deny;    allow from all;  </Directory>" + 
                        ";;</VirtualHost>") -f $This.Port,$This.ServerName,$This.Path,$This.Logs) -Split ";"
    }
    
    Service()
    {
        Write-Host "Service [:] mariadb"
        systemctl start mariadb
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose
    }
}

Class RHELCentOS
{
    [Object] $Hostname
    [Object] $SELinux
    [Object] $Apache
    [Object] $PostFix
    [Object] $MySQL
    [Object] $RoundCube

    RHELCentOS([String]$Hostname)
    {
        $This.Hostname  = $Hostname
        $This.SELinux   = [SELinux]::New()
        
        Write-Host "Installing [:] epel, nano, realmd, tar, wget"
        sudo yum install epel-release nano realmd tar wget -y
        
        $This.Apache    = [Apache]::New()
        $This.PostFix   = [PostFix]::New("192.168.1.0/24")
        $This.RoundCube = [RoundCube]::New()
    }
}
