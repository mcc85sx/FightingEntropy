yum update
nano /etc/sysconfig/selinux
yum install epel-release -y

# Network
sudo yum install wget tar net-tools -y

# Apache
sudo yum install epel-release httpd httpd-tools -y
sudo chown apache:apache /var/www/html -R

Class Apache
{
    [String]   $Path = "/etc/httpd/conf/httpd.conf"
    [String[]] $Value

    Apache()
    {
        If (!(Test-Path $This.Path))
        {
            sudo yum install epel-release httpd httpd-tools -y
            sudo chown apache:apache /var/www/html -R
        }
        
        $This.Value = Get-Content -Path $This.Path
    }

    [Void] Config()
    {
        ForEach ($I in 0..( $This.Value.Length - 1 ))
        {
            If ( $This.Value[$I] -match "(<Directory />)")
            {
                $This.Value[$I+1] = "    AllowOverride All"
            }
        }
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Value -Verbose -force
    }

    Firewall()
    {
        sudo firewall-cmd --zone=public --permanent --add-service=http
        sudo firewall-cmd --zone=public --permanent --add-service=https
    }

    Service()
    {
        sudo systemctl start httpd
        sudo systemctl enable httpd 
        sudo systemctl reload httpd
    }
}

$Apache = [Apache]::New()
sudo yum install mariadb mariadb-server -y
sudo yum install postfix -y

Class PostFix
{
    [String] $Path = "/etc/postfix/main.cf"
    [String[]] $Value

    [Object] $Hash

    PostFix()
    {
        $This.Value = Get-Content -Path $This.Path
        $This.Hash  = @{ }

        ForEach ( $I in 0..($This.Value.Count - 1))
        {
            $Item = @( If ( $This.Hash[$This.Value[$I] )
            { 
                $This.Value[$I]
                $This.Hash.Add($This.Value[$I],$I)
            }
        }
    }
}

$PostFix = [PostFix]::New()

Class RoundCube
{
    [UInt32]       $Port = 80
    [String] $ServerName = (hostname)
    [String]       $Root 
    [String]        $Url
    [String]    $Version
    [String]       $Path = "/var/www/roundcube"
    [String]       $Logs = "/etc/httpd/logs"
    [String[]]    $Value
    [String[]]   $Config

    RoundCube()
    {
        $This.ServerName = (hostname)
        $This.Version    = "roundcubemail-1.4.10"
        $This.Url        = "https://github.com/roundcube/roundcubemail/releases/download/1.4.10/$($This.Version)-complete.tar.gz"
    }

    Install()
    {
        sudo wget $This.URL
        
        "{0}/{1}" -f (pwd).Path, $This.Version | % { 

            sudo tar xvzf "$($_)-complete.tar.gz"
            sudo mv $_ /var/www/roundcube/
        }

        sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
        sudo dnf module reset php -y
        sudo dnf module enable php:remi-7.4 -y
        sudo dnf install php-ldap php-imagick php-common php-gd php-imap php-json php-curl php-zip php-xml php-mbstring php-bz2 php-intl php-gmp -y
    }

    MySql()
    {
        sudo mysql -u root -p
        CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
        CREATE USER roundcubeuser@localhost IDENTIFIED BY 'password';
        GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;
        flush privileges;
    }

    VirtualHost([String]$VirtualHostname)
    {
        $This.Path   = "/etc/httpd/conf.d/{0}" -f $VirtualHostname
        $This.Config = ("<VirtualHost *:{0}>;  ServerName {1};  DocumentRoot {2};;  ErrorLog {3}/_error.log;" +
                        "CustomLog {3}/_access.log combined;;  <Directory />;    Options FollowSymLinks;    " +
                        "AllowOverride All;  </Directory>;;  <Directory {2}>;    Options FollowSymLinks Mult" + 
                        "iViews;    AllowOverride All;    Order allow,deny;    allow from all;  </Directory>" + 
                        ";;</VirtualHost>") -f $This.Port,$This.ServerName,$This.DocumentRoot,$This.Logs -Split ";"
    }

    WriteVirtualHost()
    {
        Set-Content -Path $This.Path -Value $This.Config -Verbose
    }
}

$RoundCube = [RoundCube]::New()

Function Initialize-Service
{
    [CmdLetBinding()]Param( 
        [Parameter(Mandatory,Position=0)][String]$Name,
        [ValidateSet("Launch","Status","Restart")]
        [Parameter(Mandatory,Position=1)][String]$Mode)

    ForEach ( $Item in @( Switch($Mode) { Launch {0,1,2} Status {0,1,4} Restart {3} }))
    {
        systemctl ("start,enable,reload,restart,status" -Split ",")[$Item] $Name
    }
}
