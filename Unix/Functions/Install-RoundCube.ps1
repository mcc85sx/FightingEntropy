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
