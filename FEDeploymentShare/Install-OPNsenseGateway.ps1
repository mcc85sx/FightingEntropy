# [Gateway Section II] $OPEN_A_NEW_CONSOLE
# FEDeploymentShare -> OPNsense gateway [July 23rd, 2021] @ [1:20PM] 
#                                     | [July 24th, 2021] @ [5:10PM]
#                                     | [July 25th, 2021] @ [7:00AM]

# Assemblies
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Window 
{
    [DllImport("user32.dll")][return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out WindowPosition lpRect);

    [DllImport("user32.dll")][return: MarshalAs(UnmanagedType.Bool)]
    public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);

    [DllImport("user32.dll")] [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr handle, int state);
}
public struct WindowPosition
{
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

$KeyEntry = @'
Class KeyEntry
{
    Static [Char[]] $Capital  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    Static [Char[]]   $Lower  = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
    Static [Char[]] $Special  = ")!@#$%^&*(:+<_>?~{|}`"".ToCharArray()
    Static [Object]    $Keys  = @{

        " " =  32; [Char]706 =  37; [char]708 =  38; [char]707 =  39; [char]709 =  40; "0" =  48; 
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

    If ( $Object.Length -gt 1 )
    {
        $Object = $Object.ToCharArray()
    }
    ForEach ( $Key in $Object )
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
'@

$WindowObject = @"
using System;
using System.Runtime.InteropServices;
public class WindowObject
{
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

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
    [Object] $VMC
    VMSilo([String]$Name,[Object[]]$Gateway)
    {
        $This.Name     = $Name
        $This.VMHost   = Get-VMHost
        $This.Switch   = Get-VMSwitch
        $This.Internal = $This.Switch | ? SwitchType -eq Private
        $This.External = $This.Switch | ? SwitchType -eq External
        $This.Gateway  = ForEach ( $X in 0..($Gateway.Count - 1))
        {        
            $Item            = [VMGateway]::New($Gateway[$X],1024MB,20GB,1,$This.External.Name)
            $Item.Path       = $Item.Path       -f $This.VMHost.VirtualMachinePath
            $Item.NewVhdPath = $Item.NewVhdPath -f $This.VMHost.VirtualHardDiskPath
            $Item
        }
        $This.VMC = @( )
    }
    Clear()
    {
        $VMList        = Get-VM | % Name

        ForEach ( $Item in $This.Gateway)
        {
            If ($Item.Name -in $VMList)
            {
                Stop-VM -Name $Item.Name -Force -Verbose
                Remove-VM -Name $Item.Name -Force -Verbose
            }
        }

        ForEach ( $Item in $This.Gateway)
        {
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
    Create([Object]$ISOPath)
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
            Switch -Regex ($IsoPath.GetType().Name)
            {
                "\[\]"
                {
                    Set-VMDVDDrive -VMName $Item.Name -Path $IsoPath[($X % $IsoPath.Count)] -Verbose
                }
                Default
                {
                    Set-VMDVDDrive -VMName $Item.Name -Path $ISOPath -Verbose
                }
            }
            $Mac = $Null
            $ID  = $Item.Name 
            Start-VM -Name $ID
            Do
            {
                Start-Sleep 1
                $Item = Get-VM -Name $ID
                $Mac  = $Item.NetworkAdapters | ? Switchname -eq $This.External.Name | % MacAddress
            }
            Until($Mac -ne 000000000000)
            Stop-VM -Name $ID -Confirm:$False -Force
            $This.VMC += $Mac
        }
    }
}

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ Launch [~] Installer                                                                           ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

$VMHost     = Get-VMHost
$VMDisk     = $VMHost | % VirtualHardDiskPath
$Credential = Get-Credential root
$Scratch    = "$Env:ProgramData\Secure Digits Plus LLC"
$Date       = Get-Date -UFormat %Y%m%d
$Path       = "$Scratch\Lab($Date)"
$GWList     = Get-ChildItem $Path | ? Name -match "\(\d+\).+(\.txt)"
$Gateway    = $GWList | % { Get-Content $_.FullName | ConvertFrom-Json }
$IsoPath    = "C:\Images\OPNsense-21.1-OpenSSL-dvd-amd64.iso"

# [Temp settings]######
$Silo       = [VMSilo]::New("New VMSilo [$Date][$(Get-Date -UFormat %H%M%S)]",$Gateway)
$Silo.Clear()
$Silo.Create($IsoPath)

# [DHCP/MacAddress Stuff]
$Scope   = Get-DHCPServerV4Scope
$Reserve = Get-DhcpServerv4Reservation -ScopeID $Scope.ScopeID
$Slot    = $Reserve[-1].IPAddress.ToString().Split(".")

If ( $Gateway.Count -gt 1 )
{
    $Spot    = [UInt32]$Slot[3]

    ForEach ( $X in 0..($Gateway.Count - 1))
    {
        $Reserve = Get-DhcpServerv4Reservation -ScopeID $Scope.ScopeID
        $Item    = $Gateway[$X]
        $Mac     = $Silo.VMC[$X]

        If ($Item.Name -in $Reserve.Name)
        {     
            Write-Host "Modifying [+] DHCP Reservation [$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"

            Get-DHCPServerV4Reservation -ScopeID $Scope.ScopeID | ? Description -match $Item.Network | Set-DHCPServerV4Reservation -ClientID $Mac -Hostname $Item.Sitelink -Verbose
        }

        Else
        {
            Write-Host "Adding [+] DHCP Reservation [$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"
            $Spot ++
            $Obj             = @{
    
                ScopeID      = $Scope.ScopeID
                IPAddress    = @($Slot[0,1,2];$Spot) -join '.'
                ClientID     = $Mac
                Name         = $Item.SiteLink
                Description  = "[$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"
            }
            Add-DhcpServerV4Reservation @Obj -Verbose
        }
    }
}

######
0..($GWList.Count-1) | Start-RSJob -Name {$GWList[$_].Name} -Throttle 4 -ScriptBlock {

    $Credential = $Using:Credential
    $Path       = $Using:Path
    $VMDisk     = $Using:VMDisk
    $KeyEntry   = $Using:KeyEntry
    Invoke-Expression $KeyEntry

    $X          = $_
    $File       = Get-ChildItem $Path | ? Name -match "\($X\).+(\.txt)" | % FullName
    $VM         = Get-Content $File | ConvertFrom-Json 

    $ID         = $VM.Name

    $Time       = [System.Diagnostics.Stopwatch]::StartNew()
    $Log        = @{ }

    Start-VM $ID -Verbose
    $Log.Add($Log.Count,"[$($Time.Elapsed)] Starting [~] [$ID]")

    $Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $ID
    $KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1
        $Item     = Get-VM -Name $ID
        Switch($Item.CPUUsage)
        {
            Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]
    }
    Until ($Sum -ge 250) # Initial config script import... (250)
    
    $C         = @( )
    Do
    {
        Start-Sleep -Seconds 1

        $Item     = Get-VM -Name $ID
        Switch($Item.CPUUsage)
        {
            Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]
    }
    Until($Sum -ge 35) # Manual assignment capture (35)

    # Manual Interface
    $KB.TypeKey(13)
    Start-Sleep 1

    # Configure VLans Now?
    
    KeyEntry $KB "n"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter WAN interface name
    KeyEntry $KB "hn0"
    Start-Sleep -M 100
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter LAN Interface name
    KeyEntry $KB "hn1"
    Start-Sleep -M 100
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter Optional interface name
    $KB.TypeKey(13)
    Start-Sleep 2

    # Proceed...?
    KeyEntry $KB "y"
    $KB.TypeKey(13)

    $C         = @( )
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

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]

        Start-Sleep -Seconds 1
    }
    Until($Sum -gt 250) # Initial login, must account for machine delay

    # Login
    KeyEntry $KB "installer"
    $KB.PressKey(13)
    Start-Sleep 1

    # Password
    KeyEntry $KB "opnsense"
    $KB.PressKey(13)
    Start-Sleep 6

    # Welcome
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Installer")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 2

    # Continue with default keymap
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Accept defaults")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 2

    # Guided installation
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Guided installation")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 2

    # Select a disk
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Disk select")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 3

    # Install mode
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Install mode")
    Write-Host $Log[$Log.Count-1]

    While((Get-Item "$VMDisk\$ID.vhdx").Length -lt 3.65GB)
    {
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Installing")
        Write-Host $Log[$Log.Count-1]

        $Item     = Get-VM -Name $ID
        Start-Sleep -Seconds 10
    }

    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense wrapping up installation")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 1

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID
        Switch($Item.CPUUsage)
        {
            Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Installing [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]
        
        Start-Sleep 1
    }
    Until ($Sum -gt 300)

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
    $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] Installed")
    Write-Host $Log[$Log.Count-1]
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
            Default { $C  = @( ) } 0 { $C += 1 } 1 { $C += 1 }
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNsense [~] First boot... [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]

        Start-Sleep 1
    }
    Until($Sum -gt 200)

    KeyEntry $KB "root"
    $KB.TypeKey(13)
    Start-Sleep 1

    KeyEntry $KB $Credential.GetNetworkCredential().Password
    $KB.TypeKey(13)
    Start-Sleep 3

    KeyEntry $KB "2"
    $KB.TypeKey(13)
    Start-Sleep 1

    KeyEntry $KB "1"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Configure LAN via DHCP? (No)
    KeyEntry $KB "n"
    $KB.TypeKey(13)
    Start-Sleep 1

    # IPV4 Gateway (Subnet start address)
    KeyEntry $KB $VM.Start
    $KB.TypeKey(13)
    Start-Sleep 1

    # Subnet bit count/prefix (Subnet prefix)
    KeyEntry $KB $VM.Prefix
    $KB.TypeKey(13)
    Start-Sleep 1

    # Upstream gateway? (for WAN)
    $KB.TypeKey(13)
    Start-Sleep 1

    # IPV6 WAN Tracking? (Can't hurt)
    KeyEntry $KB "y"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enable DHCP? (No, save DHCP for Windows Server)
    KeyEntry $KB "n"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Revert to HTTP as the web GUI protocol? (No)
    $KB.TypeText("n")
    $KB.TypeKey(13)
    Start-Sleep 1

    # Generate a new self-signed web GUI certificate? (Yes)
    KeyEntry $KB "y"
    $KB.TypeKey(13)
    Start-Sleep 1

    # Restore web GUI defaults? (Yes)
    KeyEntry $KB "y"
    $KB.TypeKey(13)
    Start-Sleep 1

    Set-Content -Path $File.Replace(".txt",".log") -Value $Log[0..($Log.Count-1)]
}

$Server   = Get-VMHost | % ComputerName
$VMC      = @( 0..($Gateway.Count-1) | % { 
    
    Start-Process -FilePath C:\Windows\System32\vmconnect.exe -ArgumentList @($Server,$Gateway.Name[$_]) -Passthru
    Start-Sleep -Milliseconds 100
})

$Time = [System.Diagnostics.Stopwatch]::StartNew()
Do
{
    "[$($Time.Elapsed)]"
    $RS = Get-RSJob
    $RS
    $Complete = $RS | ? State -eq Completed
    Start-Sleep -Seconds 10
    Clear-Host
}
Until ($Complete.Count -ge $Gateway.Count)

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Host Configuration ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

# $Credential = Get-Credential root
$ID        = "dsc1"
$Switch    = Get-VMSwitch
$Internal  = $Switch | ? SwitchType -eq Private | % Name
$External  = $Switch | ? SwitchType -eq External | % Name
$VM        = Get-VM -Name $ID
$DHCP      = Get-DHCPServerV4OptionValue 
$DNS       = $DHCP | ? OptionID -eq 6 | % Value
$Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $ID
$KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"
Invoke-Expression $KeyEntry
Add-Type $WindowObject

$VMC       = Start-Process vmconnect -ArgumentList @($Server,$ID) -PassThru

$KB.TypeCtrlAltDel()
Start-Sleep 3
KeyEntry $KB $Credential.GetNetworkCredential().Password
$KB.TypeKey(13)
Start-Sleep 12

$KB.PressKey(91)
$KB.TypeKey(82)
$KB.ReleaseKey(91)
$KB.TypeText("msedge")
$KB.TypeKey(13)
Start-Sleep 1

$KB.PressKey(91)
$KB.TypeKey(82)
$KB.ReleaseKey(91)
$KB.TypeText("taskmgr")
$KB.TypeKey(13)
Start-Sleep 1

$KB.PressKey(18)
$KB.TypeKey(70)
$KB.TypeKey(78)
$KB.ReleaseKey(18)
Start-Sleep 1
$KB.TypeText("powershell")
$KB.TypeKey(9)
$KB.TypeKey(32)
$KB.TypeKey(9)
$KB.TypeKey(13)
Start-Sleep 12

$KB.TypeText('"ServerManager","TaskMgr" | % { Stop-Process -Name $_ -EA 0 }')
$KB.TypeKey(13)

$KB.TypeText("Add-Type @'")
$KB.TypeKey(13)

$KB.TypeText($WindowObject)
$KB.TypeKey(13)

$KB.TypeText("'@")
$KB.TypeKey(13)

$KB.TypeText('$Date = Get-Date -UFormat %Y%m%d')
$KB.TypeKey(13)

$KB.TypeText('$Path = "$Home\Desktop\IP-($Date).ps1"')
$KB.TypeKey(13)

$KB.TypeText('$Start = Get-NetIPAddress -AddressFamily IPV4 | ? PrefixOrigin -eq Manual')
$KB.TypeKey(13)

$KB.TypeText('$ifIndex = $Start.InterfaceIndex')
$KB.TypeKey(13)

$KB.TypeText('$Ip = $Start.IPAddress')
$KB.TypeKey(13)

$KB.TypeText('$pfLength = $Start.PrefixLength')
$KB.TypeKey(13)

$KB.TypeText('$Gw = Get-NetRoute -InterfaceIndex $ifIndex | ? DestinationPrefix -eq 0.0.0.0/0 | % NextHop')
$KB.TypeKey(13)

$KB.TypeText('$Dns = Get-DNSClientServerAddress -AddressFamily IPV4 -interfaceIndex $ifIndex | % ServerAddresses')
$KB.TypeKey(13)

$KB.TypeText('If ($Dns.Count -gt 1) { $Dns = "`"$($Dns -join "``",``"")`"" } Else { $Dns = "`"$Dns`"" }')
$KB.TypeKey(13)

$KB.TypeText('$Content = "`$ifIndex=`"$ifIndex`";`$IP=`"$IP`";`$pfLength=`"$pfLength`";`$Dns=$Dns;`$Gw=`"$Gw`""')
$KB.TypeKey(13)

$KB.TypeText('Set-Content -Path $Path -Value $Content -Verbose')
$KB.TypeKey(13)

$VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $Internal

ForEach ( $X in 0 )#..($Gateway.Count-1))
{
    $Item  = $Gateway[$X]
    $Names = "Hash Name Location Region Country Postal Timezone SiteLink SiteName Network Prefix Netmask Start End Range Broadcast"

    $KB.TypeText('$Item = @{}')
    $KB.TypeKey(13)

    ForEach ($Name in $Names -Split " ") 
    { 
        $KB.TypeText("`$Item.Add('$Name','$($Item.$Name)')")
        $KB.TypeKey(13)
    }

    $KB.TypeText('$Temp     = $Item.Start -Split "\."')
    $KB.TypeKey(13)

    $KB.TypeText('$Temp[-1] = [UInt32]($Temp[-1]) + 1')
    $KB.TypeKey(13)

    $KB.TypeText('$Hash = @{ InterfaceIndex = $ifIndex; AddressFamily="IPV4"; IPAddress=$Temp -join "."; PrefixLength=$pfLength; DefaultGateway=$Item.Start}')
    $KB.TypeKey(13)

    $KB.TypeText('Get-NetRoute -DestinationPrefix 0.0.0.0/0 -InterfaceIndex $ifIndex | ? NextHop -notmatch $Item.Start | Remove-NetRoute -Confirm:$False -Verbose')
    $KB.TypeKey(13)

    $KB.TypeText('Get-NetIPAddress -AddressFamily IPV4 -InterfaceIndex $ifIndex | ? PrefixOrigin -eq Manual | ? IPAddress -ne $Hash.IPAddress | Remove-NetIPAddress -Confirm:$False -Verbose')
    $KB.TypeKey(13)

    $KB.TypeText('New-NetIPAddress @Hash -Verbose -EA 0')
    $KB.TypeKey(13)

    $KB.TypeText('Set-DNSclientServerAddress -InterfaceIndex $ifIndex -ServerAddresses $Item.Start -Verbose;Start-Sleep 1')
    $KB.TypeKey(13)

    # Alt-Tab
    Start-Sleep 25
    $KB.PressKey(18)
    $KB.TypeKey(9)
    $KB.ReleaseKey(18)
    Start-Sleep 1

    $KB.PressKey(17)
    $KB.TypeKey(76)
    $KB.ReleaseKey(17)
    $KB.TypeText("https://$($Item.Start)")
    $KB.TypeKey(13)
    Start-Sleep 5

    # [Edge]-Browser Accept
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    $KB.TypeKey(9)
    $KB.TypeKey(13)
    Start-Sleep 3

    # [Edge]-Login
    $KB.TypeText('root')
    $KB.TypeKey(9)
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(9)
    $KB.TypeKey(13)
    Start-Sleep 10

    # [Edge]-General Setup
    $KB.PressKey(16)
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 2

    # [Edge]-General Information
    $KB.PressKey(16)
    0..11 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeText($Item.SiteLink)
    $KB.TypeKey(9)
    $KB.TypeText($Item.Sitename.Replace($Item.Sitelink.ToLower()+'.',""))
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeText($DNS[0])
    $KB.TypeKey(9)
    If ($DNS[1])
    {
        $KB.TypeText($DNS[1])
        $KB.TypeKey(9)
    }
    $KB.TypeKey(32)
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    Start-Sleep 2

    # [Edge]-Time server information
    $KB.PressKey(16)
    0..2 | % { $KB.TypeKey(9)}
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 2

    # [Edge]-WAN Interface (Keep set to DHCP, has a reservation tied to MAC address)
    $KB.PressKey(16)
    0..4 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    0..1 | % { $KB.TypeKey(9) }
    $KB.TypeKey(32)
    Start-Sleep 2

    # LAN Interface (Should be fine as is)
    $KB.PressKey(16)
    0..2 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 2

    # Set root password
    $KB.PressKey(16)
    0..2 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 2

    # Reload Configuration
    $KB.PressKey(16)
    0..2 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 10

    # Finished Initial configuration | NOT UPDATE SCREEN
    $KB.PressKey(16)
    0..2 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(13)
    Start-Sleep 15
    $KB.TypeKey(13)
    Start-Sleep 25

    # Firmware - Check for updates
    $KB.PressKey(16)
    $KB.TypeKey(9)
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 35

    # Updates
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    Start-Sleep 1

    # Confirm
    $KB.PressKey(16)
    0..8 | % { $KB.TypeKey(9) }
    $KB.ReleaseKey(16)
    $KB.TypeKey(32)
    Start-Sleep 1
    $KB.TypeKey(9)
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    Start-Sleep 3

    # Alt-Tab
    $KB.PressKey(18)
    $KB.TypeKey(9)
    $KB.ReleaseKey(18)
    Start-Sleep 1
}

$VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $External

$KB.TypeText('$Content = Get-Content "$Home\Desktop\IP*";Invoke-Expression ($Content -join "`n")')
$KB.TypeKey(13)

$KB.TypeText('$Hash = @{ InterfaceIndex = $ifIndex; AddressFamily="IPV4"; IPAddress=$IP; PrefixLength=$pfLength; DefaultGateway=$Gw}')
$KB.TypeKey(13)

$KB.TypeText('$EndGw = Get-Netroute | ? DestinationPrefix -eq 0.0.0.0/0 | % NextHop')
$KB.TypeKey(13)

$KB.TypeText('$EndIp = Get-NetIPAddress -AddressFamily IPV4 | ? IPAddress -ne 127.0.0.1')
$KB.TypeKey(13)

$KB.TypeText('$EndDns = Get-DNSClientServerAddress -AddressFamily IPV4 -InterfaceIndex $ifIndex')
$KB.TypeKey(13)

$KB.TypeText('If ($EndGw -ne $Gw) { Get-NetRoute | ? NextHop -eq $EndGw | Remove-NetRoute -Confirm:$False -Verbose; $Hash.DefaultGateway = $Gw }')
$KB.TypeKey(13)

$KB.TypeText('If ($EndIp.IPAddress -ne $Ip) { Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ifIndex | ? PrefixOrigin -eq Manual | ? IPAddress -ne $IP | Remove-NetIPAddress -Confirm:$False -Verbose; $Hash.IPAddress = $IP }')
$KB.TypeKey(13)

$KB.TypeText('New-NetIPAddress @Hash -Verbose')
$KB.TypeKey(13)

$KB.TypeText('Set-DNSClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses @($Dns) -Verbose')
$KB.TypeKey(13)

# [Restart] #----------# 
91,9,40,40,40,32,40,13,40,9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
