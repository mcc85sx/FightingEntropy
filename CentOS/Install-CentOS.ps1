# CentOS mail server [July 6th, 2020] @ [7:55 AM]
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
           "mariadb mariadb-server postfix dovecot -y" -join ' ')
$KB.TypeKey(13)
