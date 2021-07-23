# FEDeploymentShare -> OPNsense gateway [July 23rd, 2021] @ [1:20PM]
# Classes
Class KeyEntry
{
    Static [Char[]] $Capital  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    Static [Char[]]   $Lower  = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
    Static [Char[]] $Special  = ")!@#$%^&*(:+<_>?~{|}`"".ToCharArray()
    Static [Object]    $Keys  = @{

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
    Static [Object]     $SKey = @{ 

        "A" =  65; "B" =  66; "C" =  67; "D" =  68; "E" =  69; "F" =  70; 
        "G" =  71; "H" =  72; "I" =  73; "J" =  74; "K" =  75; "L" =  76; 
        "M" =  77; "N" =  78; "O" =  79; "P" =  80; "Q" =  81; "R" =  82; 
        "S" =  83; "T" =  84; "U" =  85; "V" =  86; "W" =  87; "X" =  88;
        "Y" =  89; "Z" =  90; ")" =  48; "!" =  49; "@" =  50; "#" =  51; 
        "$" =  52; "%" =  53; "^" =  54; "&" =  55; "*" =  56; "(" =  57; 
        ":" = 186; "+" = 187; "<" = 188; "_" = 189; ">" = 190; "?" = 191; 
        "~" = 192; "{" = 219; "|" = 220; "}" = 221; '"' = 222;
    }
}

Function KeyEntry
{
    [CmdLetBinding()]
    Param(
    [Parameter(Mandatory)][Object]$KB,
    [Parameter(Mandatory)][Object]$Object)

    ForEach ( $Key in $Object.ToCharArray() )
    {
        If ($Key -cin @([KeyEntry]::Special + [KeyEntry]::Capital))
        {
            $KB.PressKey(16) | Out-Null
            $KB.TypeKey([KeyEntry]::SKey["$Key"]) | Out-Null
            $KB.ReleaseKey(16) | Out-Null
        }
        Else
        {
            $KB.TypeKey([KeyEntry]::Keys["$Key"]) | Out-Null
        }

        Start-Sleep -Milliseconds 50
    }
}

Class VMGateway
{
    Hidden [Object]$Item
    [Object]$Name
    [Object]$MemoryStartupBytes
    [Object]$Path
    [Object]$NewVHDPath
    [Object]$NewVHDSizeBytes
    [Object]$Generation
    [Object]$SwitchName
    VMGateway([Object]$Item,[Object]$Mem,[Object]$HD,[UInt32]$Gen,[String]$Switch)
    {
        $This.Item               = $Item
        $This.Name               = $Item.Name
        $This.MemoryStartupBytes = $Mem
        $This.Path               = "{0}\$($Item.Name).vmx"
        $This.NewVhdPath         = "{0}\$($Item.Name).vhdx"
        $This.NewVhdSizeBytes    = $HD
        $This.Generation         = $Gen
        $This.SwitchName         = $Switch
    }
}

Class VMSilo
{
    [Object] $Name
    [Object] $VMHost
    [Object] $Switch
    [Object] $Internal
    [Object] $External
    [Object] $Gateway
    [Object] $VM
    VMSilo([String]$Name,[Object[]]$Gateway)
    {
        $This.Name     = $Name
        $This.VMHost   = Get-VMHost
        $This.Switch   = Get-VMSwitch
        $This.Internal = $This.Switch | ? SwitchType -eq Private
        $This.External = $This.Switch | ? SwitchType -eq External
        $This.Gateway  = @( )
        ForEach ( $X in 0..($Gateway.Count - 1))
        {        
            $Item            = [VMGateway]::New($Gateway[$X],1024MB,20GB,1,$This.External.Name)
            $Item.Path       = $Item.Path       -f $This.VMHost.VirtualMachinePath
            $Item.NewVhdPath = $Item.NewVhdPath -f $This.VMHost.VirtualHardDiskPath
            $This.Gateway   += $Item
        }
    }
    Clear()
    {
        $VMList        = Get-VM

        ForEach ( $Item in $This.Gateway)
        {
            If ($Item.Name -in $VMList)
            {
                Stop-VM -Name $Item.Name -Force -Verbose
                Remove-VM -Name $Item.Name -Recurse -Force -Verbose
            }

            If (Test-Path $Item.Path)
            {
                Remove-Item $Item.Path -Recurse -Force -Verbose
            }

            If (Test-Path $Item.NewVhdPath)
            {
                Remove-Item $Item.NewVhdPath -Recurse -Force -Verbose
            }
        }
    }
    Create()
    {
        ForEach ($X in 0..($This.Gateway.Count - 1))
        {
            $Item                      = $This.Gateway[$X] | % { 
                
                @{
                    Name               = $_.Name
                    MemoryStartupBytes = $_.MemoryStartupBytes
                    Path               = $_.Path
                    NewVhdPath         = $_.NewVhdPath
                    NewVhdSizeBytes    = $_.NewVhdSizeBytes
                    Generation         = $_.Generation
                    SwitchName         = $_.SwitchName
                }
            }
            
            New-VM @Item -Verbose
            Add-VMNetworkAdapter -VMName $Item.Name -SwitchName $This.Internal.Name -Verbose
        }
    }
    Image([String]$Path)
    {
        ForEach ( $Item in $This.Gateway )
        {
            Set-VMDVDDrive -VMName $Item.Name -Path $Path -Verbose
        }
    }
}

# [Temp settings]
$Credential = Get-Credential root
$Gateway    = Get-Content C:\Test-Recover.txt | ConvertFrom-Json
$Silo      = [VMSilo]::New("VMSilo Name",$Gateway)
$OPNSense  = "C:\Images\OPNsense-21.1-OpenSSL-dvd-amd64.iso"
$Silo.Clear()
$Silo.Create()
$Silo.Image($Opnsense)

# Set-Content -Path C:\test-recover.txt -Value ($Silo.Gateway | ConvertTo-JSon) -Verbose

0..($Gateway.Count-1) | Start-RSJob -Name {$Gateway.Name[$_]} -Throttle 7 -ScriptBlock { 

    $Credential = $Using:Credential
    $GW         = Get-Content C:\Test-Recover.txt | ConvertFrom-Json
                  ( Get-Content C:\KeyEntry.ps1 -Encoding UTF8 ) -join "`n" | Invoke-Expression
    $VM         = $GW[$_]
    $ID         = $VM.Name

    $Time       = [System.Diagnostics.Stopwatch]::StartNew()
    $Log        = @{ }

    Start-VM $ID -Verbose
    $Log.Add($Log.Count,"[$($Time.Elapsed)] Starting [~] [$ID]")

    $Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $ID
    $KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing")
        Write-Host $Log[$Log.Count-1]

        $Item     = Get-VM -Name $ID
            
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }
    }
    Until (Get-VM -Name $ID | ? { $_.Uptime.TotalSeconds -gt 85})

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing")
        Write-Host $Log[$Log.Count-1]

        $Item     = Get-VM -Name $ID
            
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }
    }
    Until($C.Count -ge 5)

    # Manual Interface
    $KB.TypeKey(13)
    Start-Sleep 1

    # Configure VLans Now?
    KeyEntry $KB "n"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter WAN interface name
    KeyEntry $KB "hn0"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter LAN Interface name
    KeyEntry $KB "hn1"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter Optional interface name
    $KB.TypeKey(13)
    Start-Sleep 1

    # Proceed...?
    KeyEntry $KB "y"
    $KB.TypeKey(13)
    Start-Sleep 1

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing")
        Write-Host $Log[$Log.Count-1]

        $Item     = Get-VM -Name $ID
            
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }
    }
    Until($C.Count -ge 5)

    # Login
    KeyEntry $KB "installer"
    $KB.PressKey(13)
    Start-Sleep 1

    # Password
    KeyEntry $KB "opnsense"
    $KB.PressKey(13)
    Start-Sleep 5

    # Welcome
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Installer")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    # Continue with default keymap
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Accept defaults")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    # Guided installation
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Guided installation")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    # Select a disk
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Disk select")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    # Install mode
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Install mode")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Installing")
        Write-Host $Log[$Log.Count-1]

        $Item     = Get-VM -Name $ID
        
        Get-Item $VM.NewVHDPath | ? Length -ge 4030726144 | % {
            
            Switch($Item.CPUUsage)
            {
                0       { $C +=   1  }
                1       { $C +=   1  }
            }
        }   
    }
    Until($C.Count -ge 5)

    # Enter root password
    KeyEntry $KB $Credential.GetNetworkCredential().Password
    $KB.TypeKey(13)
    Start-Sleep 1

    # Confirm root password
    KeyEntry $KB $Credential.GetNetworkCredential().Password
    $KB.TypeKey(13)
    Start-Sleep 1

    # Complete
    $KB.TypeKey(13)
    Start-Sleep 5

    # Reboot
    $KB.TypeKey(13)
    Start-Sleep 5

    Do
    {
        $Item = Get-VM -Name $ID
        $Log.Add($Log.Count,"[$($Time.Elapsed)] [$ID] [~] Rebooting...")
        Write-Host $Log[$Log.Count-1]

        Start-Sleep 1

    }
    Until ($Item.Uptime.TotalSeconds -le 2)

    Stop-VM -Name $ID -Verbose -Force

    # Disconnect DVD/ISO
    $Log.Add($Log.Count,"[$($Time.Elapsed)] [~] Releasing DVD-ISO")
    Set-VMDvdDrive -VMName $ID -Path $Null -Verbose

    Start-VM -Name $ID 

    $C         = @( )
    Do
    {
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] First boot...")
        Write-Host $Log[$Log.Count-1]
        $Item     = Get-VM -Name $ID
            
        Switch($Item.CPUUsage)
        {
            0       { $C +=   1  }
            Default { $C  = @( ) }
        }

        Start-Sleep 1
    }
    Until($C.Count -ge 5)

    KeyEntry $KB "root"
    $KB.TypeKey(13)
    Sleep 1

    KeyEntry $KB $Credential.GetNetworkCredential().Password
    $KB.TypeKey(13)
    Sleep 1

    KeyEntry $KB "2"
    $KB.TypeKey(13)
    Sleep -m 100

    KeyEntry $KB "1"
    $KB.TypeKey(13)
    Sleep -m 100

    # Configure LAN via DHCP? (No)
    KeyEntry $KB n
    $KB.TypeKey(13)
    Sleep -m 100

    # IPV4 Gateway (Subnet start address)
    KeyEntry $KB $VM.Item.Start
    $KB.TypeKey(13)
    Sleep -m 100

    # Subnet bit count/prefix (Subnet prefix)
    KeyEntry $KB $VM.Item.Prefix
    $KB.TypeKey(13)
    Sleep -m 100

    # Upstream gateway? (for WAN)
    $KB.TypeKey(13)
    Sleep -m 100

    # IPV6 WAN Tracking? (Can't hurt)
    KeyEntry $KB y
    $KB.TypeKey(13)
    Sleep -m 100

    # Enable DHCP? (No, save DHCP for Windows Server)
    KeyEntry $KB n
    $KB.TypeKey(13)
    Sleep -m 100

    # Revert to HTTP as the web GUI protocol? (No)
    KeyEntry $KB N
    $KB.TypeKey(13)
    Sleep -m 100

    # Generate a new self-signed web GUI certificate? (Yes)
    KeyEntry $KB y
    $KB.TypeKey(13)
    Sleep -m 100

    # Restore web GUI defaults? (Yes)
    KeyEntry $KB y
    $KB.TypeKey(13)
    Sleep -m 100

    [PSCustomObject]@{ Log = $Log }
}

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Host Configuration ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

<# Log in
KeyEntry $KB "8"
$KB.TypeKey(13)

KeyEntry $KB "vi /etc/hosts"
$KB.TypeKey(13)

$KB.TypeKey(40)
$KB.TypeKey(35)
0..27 | % { $KB.TypeKey(46) }

KeyEntry $KB "s$($VM.Item.Sitename) $($VM.Item.Name.ToLower())"
$KB.TypeKey(27)

KeyEntry $KB ":wq!"
$KB.TypeKey(13)

KeyEntry $KB "hostname $($VM.Item.Sitename)"
$KB.TypeKey(13)
Sleep -m 100

KeyEntry $KB "exit"
$KB.TypeKey(13)

KeyEntry $KB "reboot"
$KB.TypeKey(13)
#>
