
    $Keys        = @{

        "0" =  48; "1" =  49; "2" =  50; "3" =  51; "4" =  52; "5" =  53; 
        "6" =  54; "7" =  55; "8" =  56; "9" =  57; "." = 190;
        A   =  65; B   =  66; C   =  67; D   =  68; E   =  69; F   =  70; 
        G   =  71; H   =  72; I   =  73; J   =  74; K   =  75; L   =  76; 
        M   =  77; N   =  78; O   =  79; P   =  80; Q   =  81; R   =  82; 
        S   =  83; T   =  84; U   =  85; V   =  86; W   =  87; X   =  88;
        Y   =  89; Z   =  90; "/" = 191; "\" = 220; " " =  32; "-" = 189;
    }

    Class _VMMeasure
    {
        [Object]$VM
        [String]$Uptime
        [String]$CPU
        _VMMeasure([String]$Name)
        {
            $This.VM       = Get-VM -Name $Name
            $This.Uptime   = $This.VM.Uptime
            $This.CPU      = $This.VM.CPUUsage
        }
    }

$Name = "bsd-lab1"
$ISOPath = GCI C:\Images *bsd* | % fullname

# VM Host Control
$_VMC   = Get-VMHost
$_VMS   = Get-VMSwitch | % Name 
$_VHDX  = $_VMC.VirtualHardDiskPath
$_VMX   = $_VMC.VirtualMachinePath

# Create an opnsense VM
$VM                    = @{  

    Name               = $Name
    MemoryStartupBytes = 4GB
    Path               = "{0}\{1}.vmx"  -f $_VMX  , $Name
    NewVHDPath         = "{0}\{1}.vhdx" -f $_VHDX , $Name
    NewVHDSizeBytes    = 20GB
    Generation         = 1
    #SwitchName         = 
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
Set-VM $Name -ProcessorCount 2 -Verbose
Set-VMDvdDrive -VMName $Name -Path $ISOPath
# Get-VM $Name | Add-VMNetworkAdapter


$Time      = [System.Diagnostics.Stopwatch]::StartNew()
$Measure   = @( )
$Log       = @{ }

$Log.Add($Log.Count,"[$($Time.Elapsed)] Starting [~] [$Name]")
Write-Host $Log[$Log.Count-1]

Start-VM $Name -Verbose
$Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

$Log.Add($Log.Count,"[$($Time.Elapsed)] Started [~] [$Name]")
Write-Host $Log[$Log.Count-1]

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    Clear-Host
    $Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Initializing")
    Write-Host $Log[$Log.Count-1]

    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

# Initialized
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Initialized")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)
Start-Sleep 1

# Keymap selection
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Keymap Selection")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)
Start-Sleep 1

# Set hostname
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Set hostname")
Write-Host $Log[$Log.Count-1]
$Name.ToCharArray() | % { 

    $KB.PressKey($Keys["$_"])
    Start-Sleep -M 100
}
$KB.PressKey(13)
Start-Sleep 1

# Distribution select
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Distribution select")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)
Start-Sleep 1

# Connect WAN for network installation
Get-VM -Name $Name | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName Hyper-VNIC
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] VMNetwork Adapter")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1

ForEach ($I in 0..6)
{
    $Item = Switch ($I)
    {
        0 { "Network Installation" }
        1 { "Network Configuration" }
        2 { "IPv4 Configuration" } 
        3 { "DHCP4 Configuration" }
        4 { "IPv6 Configuration" }
        5 { "SLAAC Configuration" }
        6 { "Resolver Configuration"}
    }

    $Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] [$Item]")
    Write-Host $Log[$Log.Count-1]

    $KB.PressKey(13)
    Start-Sleep @(1,4)[$I -eq 3 -or $I -eq 6]
}

$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Resolver Configuration")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Mirror Selection")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Auto (ZFS) Partitioning")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    Clear-Host
    $Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Querying disks...")
    Write-Host $Log[$Log.Count-1]

    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 3)

# ZFS Configuration (Proceed)
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Install -> Proceed with installation")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)

# Stripe
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Stripe -> ZFS Configuration")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(13)

# ZFS Config
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] da0 -> Msft Virtual Disk")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(32) # Space
$KB.PressKey(13) # Enter

# Last chance
$Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Last chance!")
Write-Host $Log[$Log.Count-1]
$KB.PressKey(37) # Left
$KB.PressKey(13) # Enter

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    Clear-host
    $Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] Installing...")
    Write-Host $Log[$Log.Count-1]
    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 15)

# Default Password Entry
0..1 | % { 

    "password".ToCharArray() | % { $KB.PressKey($Keys["$_"]) }
    $KB.PressKey(13)
    Start-Sleep 1
}

# Time Zone Selector
$KB.PressKey($Keys["0"])
$KB.PressKey(13)

# Confirmation
$KB.PressKey(13)

# Time and date [1/2]
$KB.PressKey($Keys["s"])

# Time and date [2/2]
$KB.PressKey($Keys["s"])

# System Configuration
$KB.PressKey(13)

# System Hardening
$KB.PressKey(13)

# Add User Accounts
$KB.PressKey($Keys["n"])

# Final Configuration
$KB.PressKey(13)
Start-Sleep 2

# Manual Configuration
$KB.PressKey($Keys["y"])

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ Configure [:] Root User                                                                        ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯   

"vi /etc/ssh/sshd_config".ToCharArray() | % { 

    If ( $_ -eq "_" )
    {
        $KB.PressKey(16)
        $KB.PressKey(189)
        $KB.ReleaseKey(16)
    }

    Else
    {
        $KB.PressKey($Keys["$_"] )
    }
}
$KB.PressKey(13)

# Line[35]
ForEach ( $I in 0..34 )
{
    $KB.PressKey(40)
}

$KB.PressKey(46)
$KB.PressKey(35)
$KB.PressKey(46)
"syes".ToCharArray() | % { $KB.PressKey($Keys["$_"]) }
$KB.PressKey(27)
$KB.PressKey(16)
$KB.PressKey(186)
$KB.ReleaseKey(16)
$KB.PressKey($Keys["w"])
$KB.PressKey($Keys["q"])
$KB.PressKey(16)
$KB.PressKey($Keys["1"])
$KB.PressKey(13)

"reboot".ToCharArray() | % { $KB.PressKey($Keys["$_"]) }
$KB.PressKey(13)

Do
{
    $Item = [_VMMeasure]$Name
    $Measure += $Item
    $Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Rebooting...")
    Write-Host $Log[$Log.Count-1]

    Start-Sleep -Seconds 1
    Clear-Host
}
Until ($Item.VM.Uptime.TotalSeconds -le 1)
$Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Releasing DVD-ISO")
Write-Host $Log[$Log.Count-1]
Set-VMDvdDrive -VMName $Name -Path $Null -Verbose

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    Clear-host
    $Log.Add($Log.Count,"[$($Time.Elapsed)] FreeBSD [~] First boot...")
    Write-Host $Log[$Log.Count-1]
    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 15)
