# _______________________________________________________________________________________________________________________
#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ PowerShell - Obtains pwsh to process script \\
    su -                                                                  
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    yum install powershell -y
    sudo pwsh
#\________________________________________________________________________/
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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
Function NetworkObject
{
    Class _UnixHost
    {
        Hidden [Object]         $Obj = (hostnamectl)
        Hidden [String[]]     $Order = ("Hostname HostID Chassis MachineID BootID VMProvider OS CPE Kernel Architecture" -Split " ") 
        [String]             $HostID
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

        _UnixHost()
        {
            $This.Hostname      = $This.Item("Static hostname")
            $This.HostID        = $This.Hostname.Split(".")[0]
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

    Class _InternetConnections
    {
        Hidden [String] $Line
                [String] $Proto
                [UInt32] $RecvQ
                [UInt32] $SendQ
                [String] $Local
                [String] $Foreign
                [String] $State

                [String] X ([Int32]$Start,[Int32]$Length)
                {
                    Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
                }

                _InternetConnections([String]$In)
                {
                    $This.Line    = $In
                    $This.Proto   = $This.X(0,6)
                    $This.RecvQ   = $This.X(6,6)
                    $This.SendQ   = $This.X(13,7)
                    $This.Local   = $This.X(20,24)
                    $This.Foreign = $This.X(44,24)
                    $This.State   = $In.Substring(68)
                }
            }

            Class _UnixDomainSockets
            {
                Hidden [String] $Line 
                [String] $Proto
                [UInt32] $RefCnt
                [String] $Flags
                [String] $Type
                [String] $State
                [UInt32] $INode
                [String] $Path

                [String] X ([Int32]$Start,[Int32]$Length)
                {
                    Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
                }

                _UnixDomainSockets([String]$In)
                {
                    # $In = "Proto RefCnt Flags       Type       State         I-Node   Path"
                    $This.Line     = $In
                    $This.Proto    = $This.X(0,6)
                    $This.RefCnt   = $This.X(6,7)
                    $This.Flags    = $This.X(13,12)
                    $This.Type     = $This.X(25,11)
                    $This.State    = $This.X(36,14)
                    $This.INode    = $This.X(50,9)
                    $This.Path     = $In.Substring(60)
                }
            }

            Class _BluetoothConnections
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

                [String] X ([Int32]$Start,[Int32]$Length)
                {
                    Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
                }

                _BluetoothConnections([String]$In)
                {
                    # $In = "Proto  Destination       Source            State         PSM DCID   SCID      IMTU    OMTU Security"
                    $This.Line             = $In
                    $This.Proto            = $This.X(0,7)
                    $This.Destination      = $This.X(7,18)
                    $This.Source           = $This.X(25,18)
                    $This.State            = $This.X(43,14)
                    $This.PSM              = $This.X(57,4)
                    $This.DCID             = $This.X(61,7)
                    $This.SCID             = $This.X(68,10)
                    $This.IMTU             = $This.X(78,8)
                    $This.OMTU             = $This.X(86,5)
                    $This.Security         = $In.Substring(91)
                }
            }

    Class _Netstat
    {
        [String[]]   $Section = ("Internet {0};UNIX domain sockets;Bluetooth {0}" -f "connections" -Split ";")
        [Object] $InputObject
        [Object]        $Swap
        [Object]      $Output

        _Netstat()
        {
            $This.InputObject = (netstat)
            $Mode             = -1
            $This.Output      = @( )

            ForEach ( $I in 0..( $This.InputObject.Count - 1 ) )
            {
                $Line = $This.InputObject[$I]

                If ( $Line -match $This.Section[0] ) { $Mode = 0 }
                If ( $Line -match $This.Section[1] ) { $Mode = 1 }
                If ( $Line -match $This.Section[2] ) { $Mode = 2 }
    
                If ( $Line.Substring(0,5) -notmatch "Proto" )
                {
                    Switch ($Mode)
                    {
                        0 { $This.Output += [_InternetConnections]::New($Line)  }
                        1 { $This.Output += [_UnixDomainSockets]::New($Line)   }
                        2 { $This.Output += [_BluetoothConnections]::New($Line) }
                    }
                }
            }
        }
    }

    class _NetInterface
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

        _NetInterface([String]$IF)
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
        #[Object]         $Netstat

        _Network()
        {
            $This.Host               = [_UnixHost]::New()
            $This.Interface          = @( )

            $Config                  = (ifconfig) -Split "`n"
            $Array                   = ""

            ForEach ( $I in 0..($Config.Count - 1 ))
            {
                $Array              += $Config[$I]

                If ( $Config[$I].Length -eq 0 )
                {
                    $This.Interface += [_NetInterface]::New($Array)
                    $Array           = ""
                }
            }

            $This.Network            = @( )
            $This.Interface          | ? Flags -match "4163" | % { $This.Network += $_.IPV4Network }
            #$This.Netstat            = [_Netstat]::New()
        }
    }

    [_Network]::New()
}

Function _Network
{
    [CmdLetBinding()]Param([Parameter(Mandatory,Position=0)][String]$Hostname)

    If ( hostname -ne $Hostname )
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

# SELINUX Security
_Content "/etc/sysconfig/selinux" "SELINUX=enforcing" "SELINUX=disabled"

# Update
yum update -y

# [Install Phase]

# Network
_Network "centos-lab2.securedigitsplus.com"

# Network Tools
_Install "wget tar net-tools"

# CIFS
_Install "cifs-utils"

# ADDS
_Install "realmd sssd oddjob oddjob-mkhomedir adcli samba samba-common samba-common-tools krb5-workstation"

# Apache
_Install "epel-release httpd httpd-tools"

# MariaDB
_Install "mariadb mariadb-server"

# Postfix
_Install "postfix"

# Dovecot
_Install "dovecot"



# Join ADDS/CIFS/SMB
$Username = Read-Host "Enter username"
$Server   = Read-Host "Enter server"
$Share    = Read-Host "Enter share name"

realm join -v -U $Username
sudo mount.cifs "//$Server/$Share" /mnt -o user=$Username


# Configure
Function Configure-Apache
{
    chown apache:apache /var/www/html -R

    $Path    = "/etc/httpd/conf/httpd.conf" 
    $Content = Get-Content $Path
    
    ForEach ( $I in 0..( $Content.Length - 1 ) )
    {
        If ( $Content[$I] -match "(<Directory />)" )
        { 
            $Content[$I+1] = "    AllowOverride All" 
        }
    }

    Set-Content $Path $Content

    "http","https" | % { sudo firewall-cmd --zone=public --permanent --add-service=$_ }

    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl reload httpd 
}
