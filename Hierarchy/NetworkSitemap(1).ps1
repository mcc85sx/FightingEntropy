
$Time      = [System.Diagnostics.Stopwatch]::StartNew()
$Measure   = @( )
$Log       = @{ }

$Log.Add($Log.Count,"[$($Time.Elapsed)] Starting [~] [$Name]")
Write-Host $Log[$Log.Count-1]

Start-VM $Name -Verbose
$Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $Name
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace root\virtualization\v2

$Log.Add($Log.Count,"[$($Time.Elapsed)] Started [~] [$Name]")
Write-Host $Log[$Log.Count-1]

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ OPNsense first boot    ]______________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Do
{
    Start-Sleep -Seconds 1
    clear-host
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Initializing")
    Write-Host $Log[$Log.Count-1]
    $Item = [_VMMeasure]$Name
    $Measure += $Item
}
Until ($Time.Elapsed.TotalSeconds -gt 150)
$Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [+] Initialized")
Write-Host $Log[$Log.Count-1]

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ OPNsense installer ]__________________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯             

$Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Login Screen")
Write-Host $Log[$Log.Count-1]
73,78,83,84,65,76,76,69,82,13 | % { $KB.PressKey($_) }
Start-Sleep -Seconds 1
 
$Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Default Password")
Write-Host $Log[$Log.Count-1]
79,80,78,83,69,78,83,69,13 | % { $KB.PressKey($_) }
Start-Sleep -Seconds 6

# Auto-Installation
$Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Launching...")
Write-Host $Log[$Log.Count-1]

0..4 | % { 

    $Item = Switch($_)
    {
        0 {"Ok, let's go."}
        1 {"Accept these Settings"}
        2 {"Guided installation"}
        3 {"Disk selected"}
        4 {"GPT/UEFI mode"}
    }
    $Log.Add($Log.Count,"[$($Time.Elapsed)] [-] $Item")
    Write-Host $Log[$Log.Count-1]
    $KB.PressKey(13)
    Start-Sleep -Seconds 1
}

# Commence Installation
$C = @( )
Do
{
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Installing...")
    Write-Host $Log[$Log.Count-1]

    $Item = [_VMMeasure]$Name
    $Measure += $Item

    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }

    Start-Sleep -Seconds 1
    Clear-Host
}
Until ($C.Count -ge 8)

# Installation complete
0..4 | % { 

    $Item = Switch($_) {
        0 {"[Password]"}
        1 {"[Confirm]"}
        2 {"Accept"}
        3 {"Warning"}
        4 {"Complete"}
    }

    $Log.Add($Log.Count,"[$($Time.Elapsed)] [-] $Item")

    Write-Host $Log[$Log.Count-1]
    $KB.PressKey(13)

    Start-Sleep -Seconds 1
}

# Reboot phase
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

# Initialize first run
$C = @( )
Do
{
    $Item = [_VMMeasure]$Name
    $Measure += $Item

    $Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Init first run")
    Write-Host $Log[$Log.Count-1]

    Switch($Item.CPU)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }

    Start-Sleep -Seconds 1
    Clear-Host
}
Until ($C.Count -ge 4)

$Log.Add($Log.Count,"[$($Time.Elapsed)] [+] Installed and booted, ready for ops.")
Write-Host $Log[$Log.Count-1]

# Launched, now configure

# Login
$Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Logging in first use")
Write-Host $Log[$Log.Count-1]
82,79,79,84,13,79,80,78,83,69,78,83,69,13 | % { $KB.PressKey($_) }
Start-Sleep -Seconds 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Entering shell")
Write-Host $Log[$Log.Count-1]
56,13 | % { $KB.PressKey($_) }
Start-Sleep -Seconds 1

$Time.Stop()
$Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Begin init.cfg")
Write-Host $Log[$Log.Count-1]
