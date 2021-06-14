Function Install-Roundcube
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Version)
    
    Class RCInstall
    {
        [String] $Version
        [String]    $Name
        [String]    $File 
        [String]    $Path = "/var/www/roundcube"
        [String]     $URL = 
        [String[]] $Items = ("install https://rpms.remirepo.net/enterprise/remi-release-8.rpm",
                            "module reset php",
                            "module enable php:remi-7.4",
                            "$("ldap imagick common gd imap json curl zip xml mbstring bz2 intl gmp".Split(" ") | % { "php-$_" })")
        
        RCInstall([String]$Version)
        {
            If ($Version -notmatch "(\d+\.\d+.\d+)")
            {
                Throw "Invalid version"
            }

            $This.Version = $Version
            $This.Name    = "roundcubemail-$Version"
            $This.File    = "$($This.Name)-complete.tar.gz"
            $This.URL     = "https://github.com/roundcube/roundcubemail/releases/download/$Version/$($This.File)"

            wget $This.URL
            sudo tar xvzf $This.File
            
            If ( ! ( Test-Path $This.Path ) ) 
            { 
                New-Item -Path $This.Path -ItemType Directory -Verbose 
            }

            sudo mv "$($This.Name)/*" $This.Path

            ForEach ( $Item in $This.Items )
            {
                Invoke-Expression "sudo dnf $Item -y"
            }
        }
    }
    
    [RCInstall]::New($Version)
}
