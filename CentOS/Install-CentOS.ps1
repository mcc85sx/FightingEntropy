# CentOS mail server [July 6th, 2020] @ [7:55 AM - 10:21PM]
# -----------------------------------------------

# https://serverok.in/install-centos-8-from-net-boot-iso
# Software network boot image use this link
# http://mirror.centos.org/centos/8/BaseOS/x86_64/os/

[Char[]] $Capital  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
[Char[]]   $Lower  = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
[Char[]] $Special  = ")!@#$%^&*(:+<_>?~{|}`"".ToCharArray()
[Object]    $Keys  = @{

    " " =  32; "˂" =  37; "˄" =  38; "˃" =  39; "˅" =  40; "0" =  48; 
    "1" =  49; "2" =  50; "3" =  51; "4" =  52; "5" =  53; "6" =  54; 
    "7" =  55; "8" =  56; "9" =  57; "a" =  65; "b" =  66; "c" =  67; 
    "d" =  68; "e" =  69; "f" =  70; "g" =  71; "h" =  72; "i" =  73; 
    "j" =  74; "k" =  75; "l" =  76; "m" =  77; "n" =  78; "o" =  79; 
    "p" =  80; "q" =  81; "r" =  82; "s" =  83; "t" =  84; "u" =  85; 
    "v" =  86; "w" =  87; "x" =  88; "y" =  89; "z" =  90; ";" = 186; 
    "=" = 187; "," = 188; "-" = 189; "." = 190; "/" = 191; '`' = 192; 
    "[" = 219; "\" = 220; "]" = 221; "'" = 222;
}

[Object]     $SKey = @{ 

    "A" =  65; "B" =  66; "C" =  67; "D" =  68; "E" =  69; "F" =  70; 
    "G" =  71; "H" =  72; "I" =  73; "J" =  74; "K" =  75; "L" =  76; 
    "M" =  77; "N" =  78; "O" =  79; "P" =  80; "Q" =  81; "R" =  82; 
    "S" =  83; "T" =  84; "U" =  85; "V" =  86; "W" =  87; "X" =  88;
    "Y" =  89; "Z" =  90; ")" =  48; "!" =  49; "@" =  50; "#" =  51; 
    "$" =  52; "%" =  53; "^" =  54; "&" =  55; "*" =  56; "(" =  57; 
    ":" = 186; "+" = 187; "<" = 188; "_" = 189; ">" = 190; "?" = 191; 
    "~" = 192; "{" = 219; "|" = 220; "}" = 221; '"' = 222;
}

$Zone     = "securedigitsplus.com"
$ScopeID  = Get-DhcpServerv4Scope | % ScopeID
$ID       = "mail"
$Root     = Get-Credential "certsrv"

# Time ~ 13:20 / VMDK 2.5GB [Reboot system]

$VMSwitch = Get-VMSwitch | ? SwitchType -eq External | % Name
$ISOPath  = "C:\Images\CentOS-8.4.2105-x86_64-boot.iso"
$VMC      = Get-VMHost

$Name       = "mail"
$Time       = [System.Diagnostics.Stopwatch]::StartNew()

$VM                    = @{  

Name               = $Name
MemoryStartupBytes = 2048MB
Path               = "{0}\{1}.vmx"  -f $VMC.VirtualMachinePath,  $Name
NewVHDPath         = "{0}\{1}.vhdx" -f $VMC.VirtualHardDiskPath, $Name
NewVHDSizeBytes    = 100GB
Generation         = 1
SwitchName         = $VMSwitch
}

$Clear                 = Get-VM -Name $Name -EA 0

If ($Clear -ne $Null)
{
If ( $Clear.Status -ne "Stopped" )
{
    Stop-VM $Clear -Force -Verbose
}

$Clear | Remove-VM -Force -Verbose  
}

If (Test-Path $VM.Path) 
{
Remove-Item $VM.Path -Recurse -Force -Verbose
}

If (Test-Path $VM.NewVHDPath)
{
Remove-Item $VM.NewVHDPath -Force -Verbose
}

New-VM @VM -Verbose
Set-VMDvdDrive -VMName $Name -Path $ISOPath -Verbose
Set-VM $Name -ProcessorCount 2 -Verbose
$VMNet = Get-VMNetworkAdapter -VMName $Name 

$Time      = [System.Diagnostics.Stopwatch]::StartNew()
$Log       = @{ }

Start-VM $Name -Verbose

$Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

$Log.Add($Log.Count,"[$($Time.Elapsed)] Started [~] [$Name]")

$C         = @( )
Do
{
Start-Sleep -Seconds 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Starting")
$Item     = Get-VM -Name $Name
    
Switch($Item.CPUUsage)
{
    0       { $C +=   1  }
    Default { $C  = @( ) }
}
}
Until($C.Count -ge 3)

# Install CentOS 8
$KB.TypeKey($Keys["i"])
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)

$C         = @( )
Do
{
Start-Sleep -Seconds 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Initializing")
$Item     = Get-VM -Name $Name
    
Switch($Item.CPUUsage)
{
    0       { $C +=   1  }
    Default { $C  = @( ) }
}
}
Until($C.Count -ge 5)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Welcome to CentOS Linux 8")
$KB.TypeKey(13)
Start-Sleep -Seconds 1

# Enter the GUI menu
$KB.TypeKey(9)
$KB.TypeKey(9)
$KB.TypeKey(13)
Start-Sleep 6

# Main menu -> Network
# Left Left Down Down Enter
# Or $KB.TypeKey(9) * 6
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Network configuration...")
0..5 | % { $KB.TypeKey(9); Start-Sleep -Milliseconds 10 }
$KB.TypeKey(13)
Start-Sleep 3

# Network menu
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Setting VM Adapter Mac [$($VMNet.MacAddress)]")
Get-DhcpServerv4Reservation -ScopeId $ScopeID | Set-DhcpServerv4Reservation -ClientId $VMNet.MacAddress

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(32)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] IP Address / Network Engaged")
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

"$ID.$Zone".ToCharArray() | % { $KB.TypeKey($Keys["$_"]);Start-Sleep -Milliseconds 10 }
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Hostname/Network configured")
Start-Sleep 3

# Go to Installation destination
0..1 | % { $KB.TypeKey($Keys["˄"]); Start-Sleep -Milliseconds 10 }
$KB.TypeKey(13)
Start-Sleep 3
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Auto-partitioning selected")
$KB.TypeKey(13)
Start-Sleep 15

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Destination")
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Source")
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

"http://mirror.centos.org/centos/8/BaseOS/x86_64/os/".ToCharArray() | % {

If ($_ -cin @($Special + $Capital))
{
    $KB.PressKey(16)
    $KB.TypeKey($SKey["$_"])
    $KB.ReleaseKey(16)
}

Else
{
    $KB.TypeKey($Keys["$_"])
}
Start-Sleep -Milliseconds 10
}

$KB.PressKey(16)
Start-Sleep -Milliseconds 10

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10

$KB.ReleaseKey(16)
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Source Selected")
Start-Sleep 2

$KB.TypeKey($Keys["˅"])
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep 2

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey($Keys["˅"])
Start-Sleep -Milliseconds 10
$KB.TypeKey($Keys["˅"])
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10
$KB.PressKey(16)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.ReleaseKey(16)
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Software Selected")
Start-Sleep 2

# Root password
$KB.TypeKey($Keys["˂"])
Start-Sleep -Milliseconds 10
$KB.TypeKey($Keys["˅"])
Start-Sleep -Milliseconds 10
$KB.TypeKey($Keys["˅"])
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep 1

# Enter root password
$Root.GetNetworkCredential().Password.ToCharArray() | % { 

If ($_ -cin @($Special + $Capital))
{
    $KB.PressKey(16)
    $KB.TypeKey($SKey["$_"])
    $KB.ReleaseKey(16)
}

Else
{
    $KB.TypeKey($Keys["$_"])
}

Start-Sleep -Milliseconds 10
}

$KB.TypeKey(9)

# Enter root confirm
$Root.GetNetworkCredential().Password.ToCharArray() | % { 

If ($_ -cin @($Special + $Capital))
{
    $KB.PressKey(16)
    $KB.TypeKey($SKey["$_"])
    $KB.ReleaseKey(16)
}

Else
{
    $KB.TypeKey($Keys["$_"])
}

Start-Sleep -Milliseconds 10
}

$KB.TypeKey(9)
Start-Sleep -Milliseconds 10
$KB.TypeKey(13)
Start-Sleep 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Root password entered")

$KB.Typekey(9)
Start-Sleep -Milliseconds 10
$KB.Typekey(9)
Start-Sleep -Milliseconds 10
$KB.Typekey(9)
Start-Sleep -Milliseconds 10
$KB.Typekey(13)

$C         = @( )
Do
{
Start-Sleep -Seconds 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing...")
$Item     = Get-VM -Name $Name
    
Switch($Item.CPUUsage)
{
    0       { $C +=   1  }
    Default { $C  = @( ) }
}
}
Until($C.Count -ge 15)

$KB.TypeKey(9)
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installed, Rebooting...")

Do
{
$Item = Get-VM -Name $Name
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Rebooting...")
}
Until ($Item.Uptime.TotalSeconds -lt 5)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Releasing DVD")
Set-VMDvdDrive -VMName $Name -Path $Null -Verbose

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Booting...")
Start-VM -VMName $Name

$C = @( )
Do
{
$Item = Get-VM -Name $Name
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Booting...")
Switch($Item.CPUUsage)
{
    0 { $C += 1 } 
    Default { $C = @( ) }
}
Start-Sleep 1
}
Until ($C.Count -gt 10)

# First login
"root".ToCharArray() | % { $KB.TypeKey($Keys["$_"]) }
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10

Function KeyEntry
{
[CmdLetBinding()]
Param(
[Parameter(Mandatory)][Object]$KB,
[Parameter(Mandatory)][Object]$Object)

ForEach ( $Key in $Object.ToCharArray() )
{
    If ($Key -cin @($Special + $Capital))
    {
        $KB.PressKey(16)
        $KB.TypeKey($SKey["$Key"])
        $KB.ReleaseKey(16)
    }
    Else
    {
        $KB.TypeKey($Keys["$Key"])
    }
}
}

$Root.GetNetworkCredential().Password.ToCharArray() | % { 

If ($_ -cin @($Special + $Capital))
{
    $KB.PressKey(16)
    $KB.TypeKey($SKey["$_"])
    $KB.ReleaseKey(16)
}

Else
{
    $KB.TypeKey($Keys["$_"])
}

Start-Sleep -Milliseconds 10
}
$KB.TypeKey(13)
Start-Sleep -Milliseconds 10

KeyEntry $KB "curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
$KB.TypeKey(13)

KeyEntry $KB @("yum install powershell wget tar net-tools realmd cifs-utils sssd oddjob oddjob-mkhomedir",
           "adcli samba samba-common samba-common-tools krb5-workstation epel-release httpd httpd-tools",
           "mariadb mariadb-server postfix dovecot mod_ssl -y" -join ' ')
$KB.TypeKey(13)

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
    [CmdLetBinding()]Param([Parameter(Position=0)][String]$Path = "/var/www/html")

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
}

Function _PostFix
{
    [CmdLetBinding()]Param(
        [Parameter(Position=0)][String]$CertPath="/etc/ssl/certs"
    )
    $Path     = "/etc/postfix/main.cf"
    $Content  = Get-Content $Path
    $Network  = _NetworkObject

    $Main     = @{ 

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
    mailbox_transport = "lmtp:unix:private/dovecot-lmtp"

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
    smtpd_tls_cert_file = "$CertPath/securedigitsplus.com.cer"

    # [714] smtpd_tls_key_file = /etc/pki/tls/private/postfix.key
    smtpd_tls_key_file = "$CertPath/securedigitsplus.com.key"

    # [719] smtpd_tls_security_level = may
    smtpd_tls_security_level = "may"

    # [724] smtp_tls_CApath = /etc/pki/tls/certs
    smtp_tls_CApath = $CertPath

    # [730] smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
    smtp_tls_CAfile = "$CertPath/ca.cer"

    # [735] smtp_tls_security_level = may
    smtp_tls_security_level = "may"

    # [736] meta_directory = /etc/postfix
    # [737] shlib_directory = /usr/lib64/postfix

    #Force TLSv1.3 or TLSv1.2
    smtpd_tls_mandatory_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1"
    smtpd_tls_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1"
    smtp_tls_mandatory_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1"
    smtp_tls_protocols = "!SSLv2, !SSLv3, !TLSv1, !TLSv1.1"
    smtputf8_enable = "no"

    }

    $Main.GetEnumerator() | % { postconf -e "$($_.Name)=$($_.Value)" }

    $MasterPath = "/etc/postfix/master.cf"
    $Master     = Get-Content $MasterPath
    $Content    = @( )

    $Start      = 0..($Master.Count-1) | ? { $Master[$_] -match "#submission" }
    $End        = 0..($Master.Count-1) | ? { $Master[$_] -match "#628"}

    0..($Start-1) | % { $Content += $Master[$_] }
    
    # Submission...
    $Submission  = @(
    "#submission inet n       -       y       -       -       smtpd",
    $master[$Start+1],
    $master[$Start+2],
    "#  -o smtpd_tls_wrappermode=no",
    $master[$Start+3],
    "#  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject",
    "#  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject",
    "#  -o smtpd_sasl_type=dovecot",
    "#  -o smtpd_sasl_path=private/auth")
    
    # Smtps
    $Smtps = @(
    "#smtps     inet  n       -       y       -       -       smtpd",
    $Master[$Start+13],
    $Master[$Start+14],
    $Master[$Start+15],
    "#  -o syslog_name=postfix/smtps",
    "#  -o smtpd_tls_wrappermode=yes",
    "#  -o smtpd_sasl_auth_enable=yes",
    "#  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject",
    "#  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject",
    "#  -o smtpd_sasl_type=dovecot",
    "#  -o smtpd_sasl_path=private/auth")
    ($Submission,$Smtps).Replace("#","") | % { $Content += $_ }
    $End..($Master.Count-1) | % { $Content += $master[$_] }

    Set-Content -Path $MasterPath -Value $Content -Verbose

    systemctl restart postfix
}

Function _Dovecot
{
    [String] $Name     = "securedigitsplus.com"
    [String] $CertPath = "/etc/ssl/certs"

    # ------------ #
    # Dovecot.conf #
    # ------------ #
    [String] $Path    = "/etc/dovecot/dovecot.conf"
    [Object] $Content = Get-Content $Path

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "#protocols" }
    $Content[$X] = "protocols = imap lmtp"

    Set-Content -Path $Path -Value $Content -Verbose

    # ------------ #
    # 10-mail.conf #
    # ------------ #
    [String] $Path = "/etc/dovecot/conf.d/10-mail.conf"
    [Object] $Content = Get-Content $Path

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "#mail_location"}
    $Content[$X] = "mail_location = maildir:~/Maildir"

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "mail_privileged_group"}
    $Content[$X] = "mail_privileged_group = mail"

    Set-Content -Path $Path -Value $Content -Verbose

    gpasswd -a dovecot mail

    # -------------- #
    # 10-master.conf #
    # -------------- #

    # LMTP
    [String] $Path    = "/etc/dovecot/conf.d/10-master.conf"
    [Object] $Content = Get-Content $Path
    [Object] $Value   = @( )

    $X = 0..($Content.count-1) | ? { $Content[$_] -match "service lmtp"}
    $Y = $X + 12
    0..($X-1) | % { $Value += $Content[$_] }
    $LMTP = @("service lmtp {"," unix_listener /var/spool/postfix/private/dovecot-lmtp {",
    "  mode = 0600","  user = postfix","  group = postfix"," }","}")
    $Value += $LMTP
    
    $Y..($Content.Count-1) | % { $Value += $Content[$_] }

    Set-Content -Path $Path -Value $Value -Verbose

    # AUTH
    [String] $Path    = "/etc/dovecot/conf.d/10-master.conf"
    [Object] $Content = Get-Content $Path
    [Object] $Value   = @( )

    $X = 0..($Content.count-1) | ? { $Content[$_] -match "^service auth {"}
    0..($X) | % { $Value += $Content[$_] }
    $Value += @("  unix_listener /var/spool/postfix/private/auth {","    mode = 0600","    user = postfix","    group = postfix","    }")
    ($X+18)..($Content.Count-1) | % { $Value += $Content[$_] }

    Set-Content -Path $Path -Value $Value -Verbose

    # ------------ #
    # 10-auth.conf #
    # ------------ #

    [String] $Path    = "/etc/dovecot/conf.d/10-auth.conf"
    [Object] $Content = Get-Content $Path

    $X = 0..($Content.count-1) | ? { $Content[$_] -match "#disable_plain" }
    $Content[$X] = $Content[$X].Replace("#","")

    $X = 0..($Content.count-1) | ? { $Content[$_] -match "#auth_username_format" }
    $Content[$X] = $Content[$X].Replace("#","").Replace("%Lu","%n")

    $X = 0..($Content.count-1) | ? { $Content[$_] -match "auth_mechanisms" }
    $Content[$X] = $Content[$X] += " login"

    Set-Content -Path $Path -Value $Content -Verbose

    # ----------- #
    # 10-ssl.conf #
    # ----------- #

    [String] $Path    = "/etc/dovecot/conf.d/10-ssl.conf"
    [Object] $Content = Get-Content $Path

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "^ssl_cert" }
    $Content[$X+0] = "ssl_cert = <$CertPath/$Name.cer"
    $Content[$X+1] = "ssl_key = <$CertPath/$Name.key"

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "^#ssl_dh"}
    $Content[$X] = "ssl_dh = <$CertPath/dh.pem"

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "^#ssl_min_protocol"}
    $content[$X] = "ssl_min_protocol = TLSv1.2"

    $X = 0..($Content.Count-1) | ? { $Content[$_] -match "^#ssl_prefer"}
    $Content[$X] = "ssl_prefer_server_ciphers = yes"

    Set-Content -Path $Path -Value $Content -Verbose
    
    # ----------------- #
    # 15-mailboxes.conf #
    # ----------------- #

    [String] $Path    = "/etc/dovecot/conf.d/15-mailboxes.conf"
    [Object] $Content = Get-Content $Path
    [Object] $Value   = @( )

    0..($Content.Count-1) | % { 
        
        $Value += $Content[$_]

        If ( $Content[$_] -match "^  mailbox \w+ \{$" )
        {
            $Value += "    auto = create"
        }
    }

    Set-Content -Path $Path -Value $Value -Verbose 

    # --------------- #
    # Generate dh.pem #
    # --------------- #

    sudo openssl dhparam -out $CertPath/dh.pem 4096

    # ------- #
    # Restart #
    # ------- #

    systemctl restart postfix dovecot
}

Function _PHP
{
    sudo dnf install php php-cli php-common php-fpm php-gd php-mysqlnd -y 
    #php-auth php-intl php-mail-mime php-mail-mimedecode php-mcrypt php-net-smtp php-net-socket php-pear php-xml php7.0-intl php7.0-mcrypt php7.0-xml php7.0-gd php7.0-gd php-imagick 
    sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
}

Function _Roundcube
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Version)
    
    If ($Version -notmatch "(\d+\.\d+.\d+)")
    {
        Throw "Invalid version"
    }

    [String] $Name = "roundcubemail-$Version"
    [String] $Path = "/var/www/roundcube"
    [String] $File = "$Name-complete.tar.gz"
    [String]  $URL = "https://github.com/roundcube/roundcubemail/releases/download/$Version/$File"
    [String[]] $Items = "install https://rpms.remirepo.net/enterprise/remi-release-8.rpm",
    "module reset php","module enable php:remi-7.4",
    "install $("ldap imagick common gd imap json curl zip xml mbstring bz2 intl gmp" -Split" " | % { "php-$_" })"

    wget $URL
    sudo tar xvzf $File

    If (!(Test-Path $Path)) 
    { 
        New-Item -Path $Path -ItemType Directory -Verbose 
    }

    sudo mv "$((pwd))/$Name" "$(pwd)/roundcube"
    sudo mv "$(pwd)/roundcube" "/var/www"

    ForEach ( $Item in $Items )
    {
        Invoke-Expression "sudo dnf $Item -y"
    }

    $Hostname = (hostname)
    $Root     = "/var/www/roundcube/"
    $Logs     = "/var/log/httpd"

    set-content -path "/etc/httpd/conf.d/$Hostname.conf" -Value (("|<{0} *:80>|  ServerName $Hostname|  DocumentRoot $Root||",
    "  ErrorLog $Logs`_error.log|  CustomLog $Logs`_access.log combined||  <{1} />|    {2}|    {3}|  </{1}>||  <{1} $Root>|",
    "    {2} MultiViews|    {3}|    Order allow,deny|    allow from all|  </{1}>||</{0}>" ) -f "VirtualHost","Directory",
    "Options FollowSymLinks","AllowOverride All").Split('|') -Verbose
}

_Content "/etc/sysconfig/selinux" "SELINUX=enforcing" "SELinux=disabled"
yum update -y
_Network "mail.securedigitsplus.com"
_JoinRealm mcook85
_JoinShare certsrv dsc0.securedigitsplus.com cert

# Copy Certicates 
ForEach ( $Cert in "securedigitsplus.com" | % { "ca.cer","fullchain.cer","$_.cer","$_.key","$_.pfx" } )
{
    Copy-Item "/mnt/securedigitsplus.com/$Cert" "/etc/ssl/certs/$Cert" -Verbose
}

_Apache
_MariaDB
_Postfix
_Dovecot
_PHP
_Roundcube "1.4.11"

# MySQL
mysql_secure_installation
mysql -u root -p
create database roundcube default character set utf8 collate utf8_general_ci;
create user @localhost identified by "$Password";

$Value = @'
<?php

/* Local configuration for Roundcube Webmail */

// ----------------------------------
// SQL DATABASE
// ----------------------------------
// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// Note: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
//       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
// Note: Various drivers support various additional arguments for connection,
//       for Mysql: key, cipher, cert, capath, ca, verify_server_cert,
//       for Postgres: application_name, sslmode, sslcert, sslkey, sslrootcert, sslcrl, sslcompression, service.
//       e.g. 'mysql://roundcube:@localhost/roundcubemail?verify_server_cert=false'
$config['db_dsnw'] = 'mysql://mailadmin:password@localhost/roundcube';

// ----------------------------------
// IMAP
// ----------------------------------
// The IMAP host chosen to perform the log-in.
// Leave blank to show a textbox at login, give a list of hosts
// to display a pulldown menu or set one host as string.
// Enter hostname with prefix ssl:// to use Implicit TLS, or use
// prefix tls:// to use STARTTLS.
// Supported replacement variables:
// %n - hostname ($_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
// %s - domain name after the '@' from e-mail address provided at login screen
// For example %n = mail.domain.tld, %t = domain.tld
// WARNING: After hostname change update of mail_host column in users table is
//          required to match old user data records with the new host.
$config['default_host'] = 'localhost';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
$config['support_url'] = 'https://www.securedigitsplus.com';

// This key is used for encrypting purposes, like storing of imap password
// in the session. For historical reasons it's called DES_key, but it's used
// with any configured cipher_method (see below).
// For the default cipher_method a required key length is 24 characters.
$config['des_key'] = 'i05RgPEXrdnQGZEskzU2j6JH';

// Automatically add this domain to user names for login
// Only for IMAP servers that require full e-mail addresses for login
// Specify an array with 'host' => 'domain' values to support multiple hosts
// Supported replacement variables:
// %h - user's IMAP hostname
// %n - hostname ($_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname $_SERVER['HTTP_HOST'] without the first part)
// %z - IMAP domain (IMAP hostname without the first part)
// For example %n = mail.domain.tld, %t = domain.tld
$config['username_domain'] = 'securedigitsplus.com';

// Name your service. This is displayed on the login screen and in the window title
$config['product_name'] = 'Secure Digits Plus (π) Webmail';

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
$config['plugins'] = array();
'@

Set-Content -Path "/var/www/roundcube/config/config.inc.php" -value $Value -Verbose

Remove-Item /var/www/roundcube/installer -Recurse -Force -Verbose

_Content "/etc/php.ini" ";date.timezone =","date.timezone = America/New_York"
