$Kerb   = Get-Credential # Kerberos Administrator
$Unix   = Get-Credential root # Unix Administrator
$P12    = Get-Credential p12
$Server = "dsc0.securedigitsplus.com"
$Share  = "cert"

Import-Module FightingEntropy

Write-Theme "Preliminary [+] Info & VM Declaratives" 10,2,15

$Zone                  = "securedigitsplus.com"
$Scope                 = Get-DhcpServerv4Scope
$ID                    = "mail"

$VMSwitch              = Get-VMSwitch | ? SwitchType -eq External | % Name
$ISOPath               = "C:\Images\CentOS-8.4.2105-x86_64-boot.iso"
$VMC                   = Get-VMHost
$Name                  = "mail"
$VM                    = @{  

    Name               = $Name
    MemoryStartupBytes = 2048MB
    Path               = "{0}\{1}.vmx"  -f $VMC.VirtualMachinePath,  $Name
    NewVHDPath         = "{0}\{1}.vhdx" -f $VMC.VirtualHardDiskPath, $Name
    NewVHDSizeBytes    = 100GB
    Generation         = 1
    SwitchName         = $VMSwitch
}

Write-Theme "Purging/Building VM" 9,12,10

$Clear                 = Get-VM -Name $Name -EA 0

If ($Clear)
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

Start-VM -Name $Name -Verbose
Start-Sleep 1
Stop-VM -Name $Name -Confirm:$False -Force -Verbose

$VMNet = Get-VMNetworkAdapter -VMName $Name
$DHCP  = Get-DhcpServerv4Reservation $Scope.ScopeID

If ( "172.16.0.21" -notin $DHCP.IPAddress.IPAddressToString )
{
    $Obj             = @{
    
        ScopeID      = $Scope.ScopeID
        IPAddress    = "172.16.0.21"
        ClientID     = $VMNet.MacAddress
        Name         = "MAIL"
        Description  = "Mail Server"
    }
    Add-DhcpServerV4Reservation @Obj -Verbose
}
If ("172.16.0.21" -in $DHCP.IPAddress.IPAddressToString )
{
    Set-DhcpServerv4Reservation -IPAddress "172.16.0.21" -ClientID $VMNet.MacAddress -Verbose
}

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ Starting VM    ]______________________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Starting VM [$Name]" 10, 2, 15

$Time                  = [System.Diagnostics.Stopwatch]::StartNew()
$Log                   = @{ } 

Start-VM $Name -Verbose

$Ctrl      = Get-WmiObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

$Log.Add($Log.Count,"[$($Time.Elapsed)] Started [~] [$Name]")
Write-Host $Log[$Log.Count-1]

Do 
{
    $Item = Get-VM -Name $Name
    Start-Sleep 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)] Menu [~] [$Name]")
    Write-Host $Log[$Log.Count-1]
} 
Until ($Item.Uptime.TotalSeconds -ge 10)

Write-Theme "Install [?] CentOS 8" 10, 2, 15

Invoke-KeyEntry $KB "i"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Initializing")
    Write-Host $Log[$Log.Count-1]

    $Item     = Get-VM -Name $Name
        
    Switch($Item.CPUUsage)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -ge 5)

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ CentOS [+] Welcome to CentOS Linux 8                                                           ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Write-Theme "CentOS [+] Welcome to CentOS Linux 8" 10, 2, 15

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Welcome to CentOS Linux 8")
$KB.TypeKey(13)
Start-Sleep 1

# Enter the GUI menu
9,9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Start-Sleep 6

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Network Menu   ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Network Menu" 14,12,10

# Navigate to Network tab
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Network configuration...")
$KB.PressKey(18)
Invoke-KeyEntry $KB "n"
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 3

# Tabby McTabagain
9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
$KB.TypeKey(32)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] IP Address / Network Engaged")
Write-Host $Log[$Log.Count-1]

9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Invoke-KeyEntry $KB "$ID.$Zone"
9,32 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Start-Sleep 2
$KB.TypeKey(32)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Hostname/Network configured")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1

9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Start-Sleep 8

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installation Destination   ]__________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Installation Destination" 14,12,10

$KB.PressKey(18)
Invoke-KeyEntry $KB "d"
$KB.ReleaseKey(18)
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Destination")
Write-Host $Log[$Log.Count-1]
Start-Sleep 8

$KB.TypeKey(13)
Start-Sleep 8

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Auto-partitioning selected")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)

Start-Sleep 10
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Installation Destination")
Write-Host $Log[$Log.Count-1]

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installation Source    ]______________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Installation Source" 14,12,10

$KB.PressKey(18)
Invoke-KeyEntry $KB "i"
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Source")
Write-Host $Log[$Log.Count-1]

9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

Invoke-KeyEntry $KB "http://mirror.centos.org/centos/8/BaseOS/x86_64/os/"
Start-Sleep 1

$KB.PressKey(16)
Start-Sleep -Milliseconds 100

9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$KB.ReleaseKey(16)
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Installation Source")
Write-Host $Log[$Log.Count-1]
Start-Sleep 3

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Software Selection ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Software Selection" 14,12,10

$KB.PressKey(18)
Invoke-KeyEntry $KB "ss"
$KB.ReleaseKey(18)
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Software Selection")
Write-Host $Log[$Log.Count-1]
Start-Sleep 3

9,9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100
$KB.PressKey(16)
Start-Sleep -Milliseconds 100
9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$KB.ReleaseKey(16)
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Software Selection")
Write-Host $Log[$Log.Count-1]
Start-Sleep 4

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Root password  ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Root password" 14,12,10

$KB.PressKey(18)
Invoke-KeyEntry $KB "r"
$KB.ReleaseKey(18)
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Root password")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1

Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
$KB.TypeKey(9)

Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
$KB.TypeKey(9)
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Root password")
Write-Host $Log[$Log.Count-1]

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installing...  ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Installing..." 10,2,15

9,9,9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing...")
    Write-Host $Log[$Log.Count-1]
}
Until((Get-Item $VM.NewVHDPath).Length -ge 2500000000)

Write-Theme "CentOS [+] Files sourced, now validating"

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Files sourced, now validating")
Write-Host $Log[$Log.Count-1]

Do
{
    $Item     = Get-VM -Name $ID
    Switch($Item.CPUUsage)
    {
        Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
    }

    $Sum = @( Switch($C.Count)
    {
        0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
    } ) | Invoke-Expression

    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)][CentOS [~] Finalizing][Inactivity:$Sum/100")
    Write-Host $Log[$Log.Count-1]
}
Until($Sum -ge 100)

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installed/Reboot   ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Installed/Rebooting"

$KB.TypeKey(9)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installed, Rebooting...")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)

Do
{
    Start-Sleep -Seconds 1
    $Item = Get-VM -Name $Name
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Rebooting...")
    Write-Host $Log[$Log.Count-1]
}
Until ($Item.Uptime.TotalSeconds -lt 5)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Releasing DVD")
Write-Host $Log[$Log.Count-1]
Set-VMDvdDrive -VMName $Name -Path $Null -Verbose


$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Booting...")
Write-Host $Log[$Log.Count-1]
Start-VM -VMName $Name

$C = @( )
Do
{
    $Item     = Get-VM -Name $ID
    Switch($Item.CPUUsage)
    {
        Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
    }

    $Sum = @( Switch($C.Count)
    {
        0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
    } ) | Invoke-Expression

    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)][CentOS [~] Booting][Inactivity:$Sum/100")
    Write-Host $Log[$Log.Count-1]
}
Until($Sum -ge 100)

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ First Login    ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "First Login"

Invoke-KeyEntry $KB "root"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] First login")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] First login")
Write-Host $Log[$Log.Count-1]

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installing additional packages ]______________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Installing additional packages"

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Provisioning additional packages...")
Write-Host $Log[$Log.Count-1]

Invoke-KeyEntry $KB "curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

$Utils = ("yum install powershell wget tar net-tools realmd cifs-utils sssd oddjob oddjob-mkhomedir openldap",
"adcli samba samba-common samba-common-tools krb5-workstation epel-release httpd httpd-tools",
"mariadb mariadb-server postfix dovecot dovecot-mysql mod_ssl nano firewalld -y" -join ' ')
Invoke-KeyEntry $KB $Utils
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing packages...")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)

$C = @( )
Do
{
    $Item     = Get-VM -Name $ID
    Switch($Item.CPUUsage)
    {
        Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
    }

    $Sum = @( Switch($C.Count)
    {
        0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
    } ) | Invoke-Expression

    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)][CentOS [~] Installing Packages][Inactivity:$Sum/100")
    Write-Host $Log[$Log.Count-1]
}
Until($Sum -ge 100)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Packages installed")
Write-Host $Log[$Log.Count-1]

# Join Kerberos realm
Invoke-KeyEntry $KB "realm join -v -U $($Kerb.Username.ToUpper()) $Zone"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 2
$Pass = $Kerb.GetNetworkCredential().Password
Invoke-KeyEntry $KB "$Pass"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Joining Kerberos")
Write-Host $Log[$Log.Count-1]
Start-Sleep 10

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ Enter [+] PowerShell                                                                           ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Write-Theme "Enter [+] PowerShell"

Invoke-KeyEntry $KB "pwsh"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] PowerShell Configuration...")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 2

# Source the installation functions
Invoke-KeyEntry $KB "IRM github.com/mcc85sx/FightingEntropy/blob/master/CentOS/CentOSMailServer.ps1?raw=true | IEX"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Set Name/Domain/Servername Variables
Invoke-KeyEntry $KB "`$Name='$Name';`$Domain='$Zone';`$ServerName=`"`$Name.`$Domain`""
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# SELinux
Invoke-KeyEntry $KB '_Content "/etc/sysconfig/selinux" "SELINUX=enforcing" "SELINUX=disabled"'
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] selinux/disabled")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

# Update
Invoke-KeyEntry $KB "yum update -y"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] yum update")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

$C = @( )
Do
{
    $Item = Get-VM -Name $Name
    Switch($Item.CPUUsage)
    {
        0 { $C += 1 }
        Default { $C = @( ) }
    }
}
Until ($C.Count -gt 5)

# Join certificate share
Invoke-KeyEntry $KB "sudo mount.cifs //$Server/$Share /mnt -o user=$($Kerb.UserName)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 2

# Enter password
Invoke-KeyEntry $KB "$($Kerb.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 2

# Copy Certicates
ForEach ( $Cert in "ca.crt","securedigitsplus.com.p12" )
{
    Invoke-KeyEntry $KB "cp /mnt/securedigitsplus.com/$Cert /etc/ssl/certs/$Cert"
    Start-Sleep -Milliseconds 100
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Copying Certificate: [$Cert]")
    Write-Host $Log[$Log.Count-1]
    $KB.TypeKey(13)
    Start-Sleep 1
}

# Extract Certificate from p12
Invoke-KeyEntry $KB "openssl pkcs12 -in /etc/ssl/certs/$zone.p12 -out /etc/ssl/certs/$zone.crt.pem -clcerts -nokeys"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)

Invoke-KeyEntry $KB "$($P12.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 2

# Extract Key from p12
Invoke-KeyEntry $KB "openssl pkcs12 -in /etc/ssl/certs/$zone.p12 -out /etc/ssl/certs/$zone.key.pem -nocerts -nodes"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)

Invoke-KeyEntry $KB "$($P12.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 2

# Configure & Start Apache
Invoke-KeyEntry $KB "_Apache"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Configuring & Starting Apache")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 5

Invoke-KeyEntry $KB "_Content `"/etc/httpd/conf/httpd.conf`" `"#ServerName www.example.com`" `"ServerName `$ServerName`""
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Start MariaDB
Invoke-KeyEntry $KB "_MariaDB"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Starting MariaDB/MySQL")
Write-Host $Log[$Log.Count-1]
Start-Sleep 10

# Configure & Start Postfix
Invoke-KeyEntry $KB "_PostFix securedigitsplus.com /etc/ssl/certs"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Configuring & Starting PostFix")
Write-Host $Log[$Log.Count-1]
Start-Sleep 10

# Configure & Start Dovecot
Invoke-KeyEntry $KB "_Dovecot securedigitsplus.com /etc/ssl/certs"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Configuring & Starting Dovecot")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1 

# Creating Diffie-Hellman dh.pem
$T2 = [System.Diagnostics.Stopwatch]::StartNew()
$C = @( )
Do
{
    $Item = Get-VM -Name $Name
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Generating Diffie-Hellman [dh.pem][$($T2.Elapsed)]")
    Write-Host $Log[$Log.Count-1]

    Switch($Item.CPUUsage)
    {
        0 { $C += 1 }
        Default { $C = @( ) }
    }
    Start-Sleep 1
}
Until ($C.Count -gt 15)
$T2.Stop()

# Install & Configure PHP
Invoke-KeyEntry $KB "_PHP"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing & Configuring [php7.4]")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1

# Installing PHP
$C = @( )
Do
{
    $Item = Get-VM -Name $Name
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing [php-fpm suite]")
    Write-Host $Log[$Log.Count-1]

    Switch($Item.CPUUsage)
    {
        0 { $C += 1 }
        Default { $C = @( ) }
    }
    Start-Sleep 1
}
Until ($C.Count -gt 5)

# Install & Configure Roundcube Webmail
Invoke-KeyEntry $KB "_Roundcube 1.4.11"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing & Configuring Roundcube Webmail")
Write-Host $Log[$Log.Count-1]
Start-Sleep 1

# Installing Roundcube
$C = @( )
Do
{
    $Item = Get-VM -Name $Name
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing Roundcube Webmail")
    Write-Host $Log[$Log.Count-1]

    Switch($Item.CPUUsage)
    {
        0 { $C += 1 }
        Default { $C = @( ) }
    }
    Start-Sleep 1
}
Until ($C.Count -gt 5)

Invoke-KeyEntry $KB "exit"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] PowerShell configuration")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ (MariaDB/MySQL) [~] Initial configuration                                                      ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Write-Theme "(MariaDB/MySQL) [~] Initial configuration"

Invoke-KeyEntry $KB "mysql_secure_installation"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] (MariaDB/MySQL) Initial DB configuration")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1 

# Enter current password for root
$KB.TypeKey(13)
Start-Sleep 1

# Set Root Password?
Invoke-KeyEntry $KB "y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# New password
Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Re-enter password
Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Remove anonymous users?
Invoke-KeyEntry $KB "y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Disallow root login remotely?
Invoke-KeyEntry $KB "y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Remove test database and access to it?
Invoke-KeyEntry $KB "y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Reload privilege tables now?
Invoke-KeyEntry $KB "y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] (MariaDB/MySQL) Initialized")
Write-Host $Log[$Log.Count-1]

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ MariaDB/MySQL [~] Create Database                                                              ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

Write-Theme "MariaDB/MySQL [~] Create Database"

Invoke-KeyEntry $KB "mysql -u root -p"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Roundcube Database")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

# Enter Password
Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 4

# Create Roundcube database
KeyEntry $KB "create database roundcube default character set utf8 collate utf8_general_ci;"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Create Roundcube database admin
Invoke-KeyEntry $KB "create user 'rcadmin'@'localhost' identified by 'password';"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Create roundcube database remote
Invoke-KeyEntry $KB "create user 'rcremote'@'%' identified by 'password';"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Grant rights to admin
Invoke-KeyEntry $KB "grant all on roundcube.* to 'rcadmin'@'localhost';"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Grant rights to remote
Invoke-KeyEntry $KB "grant all on roundcube.* to 'rcremote'@'%';"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Flush privileges
Invoke-KeyEntry $KB "flush privileges;"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1

# Restart
Invoke-KeyEntry $KB "exit;"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Roundcube Database")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Straggler configuration    ]__________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Write-Theme "Straggler configuration"

# Apache/Roundcube files/folders path
Invoke-KeyEntry $KB "chown apache:apache /var/www/roundcube -R"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] (Apache/Roundcube) files/folders path")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

# Apache/Roundcube log path
Invoke-KeyEntry $KB "chown apache:apache /var/log/httpd -R"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] (Apache/Roundcube) log path")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

# Apache/Roundcube temp path
Invoke-KeyEntry $KB "chown apache:apache /var/www/roundcube/temp -R"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] (Apache/Roundcube) temp path")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

# Setting database
Invoke-KeyEntry $KB "mysql -u root -p roundcube < /var/www/roundcube/SQL/mysql.initial.sql"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] (Roundcube/MariaDB) Database")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 2

# Enter Password
Invoke-KeyEntry $KB "$($Unix.GetNetworkCredential().Password)"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 5

# Restart PHP-FPM & Apache
ForEach ( $Item in "php-fpm","httpd" )
{
    "start","enable","reload" | % { 

        Invoke-KeyEntry $KB "systemctl $_ $Item"
        Start-Sleep -Milliseconds 100
        $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] $_ $Item")
        Write-Host $Log[$Log.Count-1]
        $KB.TypeKey(13)
        Start-Sleep 1
    }
}

# Start Apache for real
Invoke-KeyEntry $KB "setsebool -P httpd_execmem 1"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Fully start Apache")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

$C = @( )
Do
{
    $Item = Get-VM -Name $Name
    Switch($Item.CPUUsage)
    {
        0 { $C += 1 }
        Default { $C = @( ) }
    }
    Start-Sleep 1
}
Until ($C.Count -gt 5)

# Restart the firewall
Invoke-KeyEntry $KB "systemctl reload firewalld"
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Reloading Firewall")
Write-Host $Log[$Log.Count-1]
$KB.TypeKey(13)
Start-Sleep 1

$Time.Stop()
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Fully start Apache")
Write-Host $Log[$Log.Count-1]

$Name = Get-Date -UFormat %Y_%d%m_%H%M%S
Set-Content -Path "$home\Desktop\$Name.log" -Value ( 0..($Log.Count-1) | % { $Log[$_] } ) -Verbose
