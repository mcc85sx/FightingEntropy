# [Gateway Section II]
# FEDeploymentShare -> OPNsense gateway [July 23rd, 2021] @ [1:20PM] 
#                                     | [July 24th, 2021] @ [5:10PM]
#                                     | [July 25th, 2021] @ [7:00AM]

# Assembly

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
$Spot    = [UInt32]$Slot[3]

If ( $Gateway.Count -gt 1 )
{
    ForEach ( $X in 0..($Gateway.Count - 1))
    {
        $Reserve = Get-DhcpServerv4Reservation -ScopeID $Scope.ScopeID
        $Item    = $Gateway[$X]
        $Mac     = $Silo.VMC[$X]

        If ( $Item.Name -notin $Reserve.Name )
        {
            Write-Host "Adding [+] DHCP Reservation [$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"
            $Spot ++
            $Obj             = @{
    
                ScopeID      = $Scope.ScopeID
                IPAddress    = @($Slot[0,1,2];$Spot) -join '.'
                ClientID     = $Mac
                Name         = $Item.Sitelink
                Description  = "[$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"
            }
            Add-DhcpServerV4Reservation @Obj -Verbose
        }

        If ($Item.Name -in $Reserve.Name)
        {     
            Write-Host "Adding [+] DHCP Reservation [$($Item.Network)/$($Item.Prefix)]@[$($Item.Sitename)]"

            Get-DHCPServerV4Reservation -ScopeID $Scope.ScopeID | ? Name -match $Item.Name | Set-DHCPServerV4Reservation -ClientID $Mac -Verbose
        }
    }
}

######

0..($GWList.Count-1) | Start-RSJob -Name {$GWList[$_].Name} -Throttle 4 -ScriptBlock {

    $Credential = $Using:Credential
    $Path       = $Using:Path
    $VMDisk     = $Using:VMDisk
    $Key        = Get-ChildItem $Path | ? Name -match KeyEntry | % FullName
    #$X          = $_
    $File       = Get-ChildItem $Path | ? Name -match "\($_\)" | % FullName
    $VM         = Get-Content $File | ConvertFrom-Json 

                  ( Get-Content $Key -Encoding UTF8 ) -join "`n" | Invoke-Expression

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
        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing")
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

        $Log.Add($Log.Count,"[$($Time.Elapsed)] OPNSense [~] Initializing [Inactivity:($($Sum))]")
        Write-Host $Log[$Log.Count-1]
    }
    Until($Sum -ge 35) # Manual assignment capture (35)

    # Manual Interface
    $KB.TypeKey(13)
    Start-Sleep 1

    # Configure VLans Now?
    KeyEntry $KB n
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter WAN interface name
    KeyEntry $KB hn0
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter LAN Interface name
    KeyEntry $KB hn1
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enter Optional interface name
    $KB.TypeKey(13)
    Start-Sleep 2

    # Proceed...?
    KeyEntry $KB y
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
    KeyEntry $KB installer
    $KB.PressKey(13)
    Start-Sleep 1

    # Password
    KeyEntry $KB opnsense
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
    Until ($Sum -gt 200)

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
    Until($Sum -gt 100)

    KeyEntry $KB root
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
    KeyEntry $KB y
    $KB.TypeKey(13)
    Start-Sleep 1

    # Enable DHCP? (No, save DHCP for Windows Server)
    KeyEntry $KB n
    $KB.TypeKey(13)
    Start-Sleep 1

    # Revert to HTTP as the web GUI protocol? (No)
    KeyEntry $KB n
    $KB.TypeKey(13)
    Start-Sleep 1

    # Generate a new self-signed web GUI certificate? (Yes)
    KeyEntry $KB y
    $KB.TypeKey(13)
    Start-Sleep 1

    # Restore web GUI defaults? (Yes)
    KeyEntry $KB y
    $KB.TypeKey(13)
    Start-Sleep 1

    Set-Content -Path $File.Replace(".txt",".log") -Value $Log[0..($Log.Count-1)]
}

#$Server   = Get-VMHost | % ComputerName
#$Silo.VMC = @( 0..7 | % { 
#    
#    Start-Process -FilePath C:\Windows\System32\vmconnect.exe -ArgumentList @($Server,$Gateway.Name[$_]) -Passthru
#    Start-Sleep -Milliseconds 100
#})

#$Time = [System.Diagnostics.Stopwatch]::StartNew()
#Do
#{
#    "[$($Time.Elapsed)]"
#    $RS = Get-RSJob
#    $RS
#    $Complete = $RS | ? State -eq Completed
#    Start-Sleep -Seconds 10
#    Clear-Host
#}
#Until ($Complete.Count -ge $Gateway.Count)

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
$KB.TypeKey(13) #>
