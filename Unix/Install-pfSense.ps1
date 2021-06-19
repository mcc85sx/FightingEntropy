# Installs pfSense in Hyper-V
# [Parameter(Mandatory)][String]$ISOPath

Class _VMObject
{
    [Object] $Object
    [String] $Name
    [String] $State
    [String] $VMPath
    [String] $VHDPath
    [String] $VMSwitch

    _VMObject([Object]$VM,[String]$VMPath,[String]$VHDPath,[String]$VMSwitch)
    {
        $This.Object    = $VM 
        $This.Name      = $VM.Name
        $This.State     = $VM.State
        $This.VMPath    = $VMPath
        $This.VHDPath   = $VHDPath
        $This.VMSwitch  = $VMSwitch
    }
}

Class _VMMeasure
{
    [Object]$VM
    [String]$Uptime
    [String]$CPU
    #[String]$HardDisk

    _VMMeasure([String]$Name)
    {
        $This.VM       = Get-VM -Name $Name
        $This.Uptime   = $This.VM.Uptime
        $This.CPU      = $This.VM.CPUUsage
        #$This.HardDisk = Measure-VM -Name $Name | % HardDiskMetrics
    }
}

# VM Host Control
$_VMC   = Get-VMHost
$_VMS   = Get-VMSwitch | % Name
$_VHDX  = $_VMC.VirtualHardDiskPath
$_VMX   = $_VMC.VirtualMachinePath

$Name   = "pfSense-lab1"
# Create a pfsense VM
$VM                    = @{  

    Name               = $Name
    MemoryStartupBytes = 4GB
    Path               = "{0}\{1}.vmx"  -f $_VMX  , $Name
    NewVHDPath         = "{0}\{1}.vhdx" -f $_VHDX , $Name
    NewVHDSizeBytes    = 20GB
    Generation         = 1
    SwitchName         = $_VMS

}

$Clear                 = Get-VM -Name $Name -EA 0

If ( $Clear -ne $Null )
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

$Time      = [System.Diagnostics.Stopwatch]::StartNew()
$Measure   = @( )

Write-Host "[$($Time.Elapsed)] Starting [~] ($Name)"
Start-VM $Name -Verbose

$Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"
Write-Host "[$($Time.Elapsed)] Controls [+] ($Name)"

$C = @( )
Do
{
    Start-Sleep -Seconds 1
    clear-host
    Write-Host "[$($Time.Elapsed)]"
    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

ForEach ( $I in 0..3 )
{
    Start-Sleep -Seconds 1
    Write-Host ("[$($Time.Elapsed)] {0}" -f @(Switch($I)
    {
        0 { "Copyright and distribution"   }
        1 { "Install pfSense"              }
        2 { "Continue with default keymap" }
        3 { "Auto (UFS) BIOS Partition"    }
    }))

    $KB.PressKey(13)
}

$C = @( )
Do
{
    Start-Sleep -Seconds 1
    clear-host
    Write-Host "[$($Time.Elapsed)]"
    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

# Initializing file system...

# Manual Configuration (may make changes to script here)
$KB.PressKey(13)
Write-Host "[$($Time.Elapsed)] Manual Configuration"

$C = @( )
Do
{
    Start-Sleep -Seconds 1
    clear-host
    Write-Host "[$($Time.Elapsed)]"
    $Item     = [_VMMeasure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 10)

# Installation finished | Reboot now?
$KB.PressKey(13)
Write-Host "[$($Time.Elapsed)] Reboot..?"
Set-VMDvdDrive -VMName $Name -Path $Null -Verbose

$C = @( )
Do
{
    Start-Sleep -Seconds 1
    clear-host
    Write-Host "[$($Time.Elapsed)]"
    $Item     = [_Measure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

# Enter WAN Interface name
78,13,72,78,48,13,13,89,13 | % { $KB.PressKey($_) }

Do
{
    Start-Sleep -Seconds 1
    clear-host
    Write-Host "[$($Time.Elapsed)]"
    $Item     = [_Measure]$Name
    $Measure += $Item
    
    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

$IP = Get-VMNetworkAdapter -VMName $VM.Name | % Ipaddresses | ? { $_ -match "(\d+\.\d+\.\d+\.\d+)" }
