# Import-Module ("{0}Bin\MicrosoftDeploymentToolkit.psd1" -f (gp "HKLM:\Software\Microsoft\Deployment 4" | % Install_Dir))
# Restore-MDTPersistentDrive
# Remove-MDTPersistentDrive -Name FE001
# Remove-PSDrive -Name FE001
# Remove-SMBShare -Name FlightTest$ -Force -Verbose
# Remove-Item C:\FlightTest -Recurse -Verbose

$Zone     = "securedigitsplus.com"
$ScopeID  = Get-DhcpServerv4Scope | % ScopeID
$ID       = "win10-lab"
$Template = @(Get-ADComputer -Filter * | ? Name -match template)
$VMSwitch = Get-VMSwitch | ? SwitchType -eq External | % Name
$VMC      = Get-VMHost
$DHCP     = Get-DhcpServerv4Lease -ScopeId $ScopeID | ? Hostname -match $ID
$DNS4     = Get-DNSServerResourceRecord -RRType A -ZoneName $Zone | ? HostName -match $ID
$DNS6     = Get-DNSServerResourceRecord -RRType AAAA -ZoneName $Zone | ? HostName -match $ID
$ADDS     = Get-ADObject -Filter * | ? Name -match $ID
$VM       = Get-VM | ? Name -match $ID

If ($DHCP.Count -gt 0)
{
    $DHCP | Remove-DHCPServerV4Lease -Verbose
}

If ($DNS4.Count -gt 0)
{
    $DNS4 | Remove-DnsServerResourceRecord -ZoneName $Zone -Force
}

If ($DNS6.Count -gt 0)
{
    $DNS6 | Remove-DnsServerResourceRecord -ZoneName $Zone -Force -Verbose
}

If ($ADDS.Count -gt 0)
{
    $ADDS | Remove-ADObject -Recursive -Confirm
}

If ($VM.Count -gt 0)
{
    ForEach ( $VMX in $VM )
    {
        If ( $VMX.State -eq "Running" )
        {
            Stop-VM -Name $VMX.Name -Force
        }
        $VMX.HardDrives.Path | Remove-Item -Force -Verbose
        $VMX | Remove-VM -Force -Verbose
    }
}

Get-RSJob | Remove-RSJob


FEDeploymentShare

$Template = @(Get-ADComputer -Filter * | ? Name -match template)
$VMSwitch = Get-VMSwitch | ? SwitchType -eq External | % Name
$VMC     = Get-VMHost
$Keys    = @{

    "0" =  48; "1" =  49; "2" =  50; "3" =  51; "4" =  52; "5" =  53; 
    "6" =  54; "7" =  55; "8" =  56; "9" =  57; "." = 190;
    A   =  65; B   =  66; C   =  67; D   =  68; E   =  69; F   =  70; 
    G   =  71; H   =  72; I   =  73; J   =  74; K   =  75; L   =  76; 
    M   =  77; N   =  78; O   =  79; P   =  80; Q   =  81; R   =  82; 
    S   =  83; T   =  84; U   =  85; V   =  86; W   =  87; X   =  88;
    Y   =  89; Z   =  90; "/" = 191; "\" = 220; " " =  32; "-" = 189;
}

1..3 | Start-RSJob -Name {$_} -ScriptBlock {

    $Name       = "win10-lab$_"
    New-ADComputer -Instance $Using:Template -Name $Name -Verbose
    $VMC        = $Using:VMC
    $Keys       = $Using:Keys
    $VMSwitch   = $Using:VMSwitch

    $Time       = [System.Diagnostics.Stopwatch]::StartNew()

    $VM                    = @{  

        Name               = $Name
        MemoryStartupBytes = 2048MB
        Path               = "{0}\{1}.vmx"  -f $VMC.VirtualMachinePath,  $Name
        NewVHDPath         = "{0}\{1}.vhdx" -f $VMC.VirtualHardDiskPath, $Name
        NewVHDSizeBytes    = 25GB
        Generation         = 2
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
    Set-VMProcessor -VMName $Name -Count 2

    $Time      = [System.Diagnostics.Stopwatch]::StartNew()
    $Log       = @{ }

    $Log.Add($Log.Count,"[$($Time.Elapsed)] Starting [~] [$Name]")

    Start-VM $Name -Verbose

    $Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
    $KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"
    $Mouse     = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_SyntheticMouse" -Namespace "root\virtualization\v2"

    $Log.Add($Log.Count,"[$($Time.Elapsed)] Started [~] [$Name]")

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] [~]")
        $Item     = Get-VM -Name $Name
        
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }
    }
    Until($C.Count -ge 5)

    $Log.Add($Log.Count,"[$($Time.Elapsed)] Windows 10 Client Installation [~] Task Sequence Selection Pane")

    0..3 | % { $KB.PressKey(9) }
    $KB.TypeKey(32)
    $KB.PressKey(9)
    $KB.PressKey(40)
    $KB.PressKey(40)
    $KB.PressKey(9)
    $KB.PressKey(13)
    Start-Sleep -S 3

    $Name.ToCharArray() | % { $KB.PressKey($Keys["$_"]) }
    $KB.PressKey(9)
    $KB.PressKey(9)
    $KB.PressKey(13)
    Start-Sleep -S 3

    0..2 | % { 

        $KB.PressKey(18)
        $KB.PressKey($Keys["n"])
        Start-Sleep -S 1
    }

    $KB.PressKey(18)
    $KB.PressKey($Keys["g"])

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] [~]")
        $Item     = Get-VM -Name $Name
        
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }
    }
    Until($C.Count -ge 15)

    [PSCustomObject]@{

        Log = $Log
    }
}
