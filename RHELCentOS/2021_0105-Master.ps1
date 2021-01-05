# hostnamectl set-hostname centos-lab.securedigitsplus.com
Class _Netstat_InternetConnections
{
    Hidden [String] $Line
    [String] $Proto
    [String] $RecvQ
    [String] $SendQ
    [String] $Local
    [String] $Foreign
    [String] $State

    _Netstat_InternetConnections([String]$In)
    {
        $This.Line    = $In
        $This.Proto   = $In.SubString(0,6)
        $This.RecvQ   = $In.SubString(6,6)
        $This.SendQ   = $In.SubString(13,7)
        $This.Local   = $In.SubString(20,24)
        $This.Foreign = $In.SubString(44,24)
        $This.State   = $In.Substring(68)
    }
}

Class _Netstat_UnixDomainSockets
{
    Hidden [String] $Line 
    [String] $Proto
    [String] $RefCnt
    [String] $Flags
    [String] $Type
    [String] $State
    [String] $INode
    [String] $Path

    _Netstat_UnixDomainSockets([String]$In)
    {
        $This.Line     = $In
        $This.Proto    = $In.Substring(0,6)
        $This.RefCnt   = $In.Substring(6,7)
        $This.Flags    = $In.Substring(13,12)
        $This.Type     = $In.Substring(25,11)
        $This.State    = $In.Substring(36,14)
        $This.INode    = $In.Substring(50,9)
        $This.Path     = $In.Substring(60)
    }
}

Class _Netstat_BluetoothConnections
{
    Hidden [String] $Line
    [String] $Proto
    [String] $Destination
    [String] $Source
    [String] $State
    [String] $PSM
    [String] $DCID
    [String] $SCID
    [String] $IMTU
    [String] $Security

    _Netstat_BluetoothConnections([String]$In)
    {
        $This.Line             = $In
        $This.Proto            = $In.Substring(0,7)
        $This.Destination      = $In.Substring(7,18)
        $This.Source           = $In.Substring(25,18)
        $This.State            = $In.Substring(43,14)
        $This.PSM              = $In.Substring(57,4)
        $This.DCID             = $In.Substring(61,7)
        $This.SCID             = $In.Substring(68,10)
        $This.IMTU             = $In.Substring(78,8)
        $This.OMTU             = $In.Substring(86,5)
        $This.Security         = $In.Substring(91)   
    }
}

Class _Netstat
{
    [String[]]   $Section = ("Internet {0};UNIX domain sockets;Bluetooth {0}" -f "connections" -Split ";")
    [Object] $InputObject = (netstat)
    [Object]        $Swap
    [Object]      $Output

    _Netstat()
    {
        $Mode             = -1
        $This.Output      = @( )

        ForEach ( $Line in $This.InputObject )
        {
            If ( $Line.Length -gt 1 ) 
            {
                If ( $Line -notmatch "Proto" )
                {
                    If ( $Line -match $This.Section[0] ) { $Mode = 0 } 
                    If ( $Line -match $This.Section[1] ) { $Mode = 1 } 
                    If ( $Line -match $This.Section[2] ) { $Mode = 2 }

                    Switch ($Mode)
                    {
                        0 { $This.Output += [_Netstat_InternetConnections]::New($Line)  }
                        1 { $This.Output += [_Netstat_UnixDomainSockets]::New($Line)   }
                        2 { $This.Output += [_Netstat_BluetoothConnections]::New($Line) }
                    }
                }
            }
        }
    }
}

Class Content # Gets content, makes replacements, and sets the updated content back to source
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

Class Service
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

Function Install-Network ([String]$Hostname)
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

Function Install-DConf
{
    sudo yum install dconf-editor -y
}

Function Set-PowerShellLink
{
    [String] $User  = (who).Split("  :")[0]
    [String] $Path  = "/home/$User/Desktop/pwsh.desktop"
    [Object] $Value = @("[Desktop Entry]",
                        "Version=1.0",
                        "Type=Application",
                        "Terminal=true",
                        "Exec=/opt/microsoft/powershell/7/pwsh",
                        "Name=pwsh",
                        "Comment=",
                        "Icon=")  
     
    New-Item -Path $Path -ItemType File -Verbose
    Set-Content -Path $Path -Value @($Value)
    chmod 755 $Path
}

Function Install-ADDS
{
    sudo yum install realmd sssd oddjob oddjob-mkhomedir adcli samba samba-common samba-common-tools krb5-workstation -y
}

Function Install-CIFS
{
    sudo yum install cifs-utils -y
}

Function Get-ADLogin ([String]$Username)
{
    realm join -v -U $Username.ToUpper()
}

Function Get-CIFSShare ([String]$Server,[String]$Share,[String]$Mount="/mnt",[String]$Username)
{
    sudo mount.cifs //$Server/$Share $Mount $UserName
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
{
    [String]   $Path = (Get-ChildItem -Path "/var/www/roundcube" | ? Name -match "roundcube" | % FullName)
    [String]   $Name = [Network]::New().Host.Hostname
    [Int32]    $Port = 80
    [String]   $Root = "/var/www/html/"
    [String]   $Logs = "/var/log/httpd"

    If ( !$Path )
    {
        Throw "Roundcube not installed/found"
    }

    Set-Content -Path $Path -Value ((";<{0} *:$Port>;  ServerName $Name;  DocumentRoot $Root;;  ErrorLog $Logs`_error.log;"+
    "  CustomLog $Logs`_access.log combined;;  <{1} />;    {2};    {3};  </{1}>;;  <{1} $Root>;    {2} MultiViews;    {3};"+
    "    Order allow,deny;    allow from all;  </{1}>;;</{0}>" ) -f  "VirtualHost" , "Directory" , "Options FollowSymLinks",
    "AllowOverride All").Split(';') -Verbose
}
