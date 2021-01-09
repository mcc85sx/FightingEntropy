Class RoundCube
{
    [String]      $ServerName = (hostname)
    [UInt32]            $Port = 80
    [String] $VirtualHostName
    [String]            $Root = "/var/www/roundcube"
    [String]         $Version 
    [String]             $Url
    [String]            $Path
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
                        ";;</VirtualHost>") -f $This.Port,$This.ServerName,$This.Root,$This.Logs) -Split ";"
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose
    }
}
