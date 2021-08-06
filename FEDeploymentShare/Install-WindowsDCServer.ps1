#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Server configuration   ]______________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

Class VMServer
{
    Hidden [Object]$Item
    [Object]$Name
    [Object]$MemoryStartupBytes
    [Object]$Path
    [Object]$NewVHDPath
    [Object]$NewVHDSizeBytes
    [Object]$Generation
    [Object]$SwitchName
    VMServer([Object]$Item,[Object]$Mem,[Object]$HD,[UInt32]$Gen,[String]$Switch)
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
    New([Object]$Path)
    {
        If (!(Test-Path $Path))
        {
            Throw "Invalid path"
        }

        ElseIf (Get-VM -Name $This.Name -EA 0)
        {
            Write-Host "VM exists..."
            If (Get-VM -Name $This.Name | ? Status -ne Off)
            {
                $This.Stop()
            }

            $This.Remove()
        }

        $This.Path             = $This.Path -f $Path
        $This.NewVhdPath       = $This.NewVhdPath -f $Path

        If (Test-Path $This.Path)
        {
            Remove-Item $This.Path -Recurse -Confirm:$False -Verbose
        }

        If (Test-Path $This.NewVhdPath)
        {
            Remove-Item $This.NewVhdPath -Recurse -Confirm:$False -Verbose
        }

        $Object                = @{

            Name               = $This.Name
            MemoryStartupBytes = $This.MemoryStartupBytes
            Path               = $This.Path
            NewVhdPath         = $This.NewVhdPath
            NewVhdSizeBytes    = $This.NewVhdSizebytes
            Generation         = $This.Generation
            SwitchName         = $This.SwitchName
        }

        New-VM @Object -Verbose | Add-VMDVDDrive -Verbose
        Set-VMProcessor -VMName $This.Name -Count 2 -Verbose
    }
    Start()
    {
        Get-VM -Name $This.Name | ? State -eq Off | Start-VM -Verbose
    }
    Remove()
    {
        Get-VM -Name $This.Name | Remove-VM -Force -Confirm:$False -Verbose
    }
    Stop()
    {
        Get-VM -Name $This.Name | ? State -ne Off | Stop-VM -Verbose -Force
    }
    LoadISO([String]$Path)
    {
        If (!(Test-Path $Path))
        {
            Throw "Invalid ISO path"
        }

        Else
        {
            Get-VM -Name $This.Name | % { Set-VMDVDDrive -VMName $_.Name -Path $Path -Verbose }
        }
    }
}

Function KeyEntry
{
    [CmdLetBinding()]
    Param(
    [Parameter(Mandatory)][Object]$KB,
    [Parameter(Mandatory)][Object]$Object)

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

$VMHost     = Get-VMHost
$VMDisk     = $VMHost | % VirtualHardDiskPath
$Credential = Get-Credential root
$Switch     = Get-VMSwitch
$Internal   = $Switch | ? SwitchType -eq Internal | ? Name -eq Internal | % Name
$External   = $Switch | ? SwitchType -eq External | % Name
$Scratch    = "$Env:ProgramData\Secure Digits Plus LLC"
$Date       = Get-Date -UFormat %Y%m%d
$Path       = "$Scratch\Lab(20210803)"#$Date)"
$GWList     = Get-ChildItem $Path | ? Name -match "\(\d+\).+(\.txt)"
$Gateway    = $GWList | % { Get-Content $_.FullName | ConvertFrom-Json }
$Servers    = $GWList | % { Get-Content $_.FullName | ConvertFrom-Json }  
$Servers    | % { $_.Name = "dc1-$($_.Postal)" }
$ISOPath    = Get-ChildItem "C:\Images" | ? Name -match SERVER_EVAL | % FullName
$Domain     = $Env:UserDNSDomain.ToLower()
$Base       = ( $Domain.Split(".") | % { "DC=$_"} ) -join ','
$Cfg        = "CN=Configuration,$Base"
$DhcpOpt    = Get-DhcpServerv4OptionValue | Sort-Object OptionID

$X = 0
Do
{
    # Time and logging
    $T1        = [System.Diagnostics.Stopwatch]::StartNew()
    $T2        = [System.Diagnostics.Stopwatch]::New()
    $Log       = @{ }

    # Grab server manifest
    $Item      = $Servers[$X]
    $Log.Add($Log.Count,"[$($T1.Elapsed)][Beginning [~] Installation]")
    Write-Host $Log[$Log.Count-1]

    # Get switch, ID
    $Switch    = $Item.Sitelink
    $ID        = $Item.Name

    Get-ADObject -LDAPFilter "(objectClass=server)" -SearchBase "CN=Configuration,$Base" | ? Name -match $ID | Remove-ADObject -Recursive -Confirm:$False -Verbose

    # Instantiate actionable VM object
    $Server    = [VMServer]::New($Item,4096MB,100GB,2,$Switch)
    $Server.New($VMDisk)
    $Server.LoadISO($IsoPath)

    # Get Virtual network interface DNS local address
    $DNS       = Get-NetAdapter | ? Name -match "($External)" | Get-NetIPAddress | % IPAddress

    # Set boot settings
    $VM        = Get-VM -Name $ID
    $BootOrder = $VM | Get-VMFirmware | % { $_.BootOrder[2,0,1] }
    $VM        | Set-VMFirmware -BootOrder $BootOrder -Verbose

    # Start
    $Server.Start()

    # Set Msvm keyboard controls
    $Ctrl      = Get-WMIObject MSVM_ComputerSystem -NS Root\Virtualization\V2 | ? ElementName -eq $ID
    $KB        = Get-WmiObject -Query "ASSOCIATORS OF {$($Ctrl.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

    # Connect to the VM
    Start-Process -FilePath vmconnect -ArgumentList @("dsc0",$ID) -Verbose -Passthru
    $KB.TypeKey(13)

    # Timer to initialize setup
    $T2.Start()
    $C         = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][Initializing [~] Setup ($($T2.Elapsed))][(Inactivity:$Sum/35)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 35)
    $T2.Reset()
    
    0..2 | % { $KB.TypeKey(9); Start-Sleep -M 100 }
    $KB.TypeKey(13)
    Start-Sleep 1

    $KB.TypeKey(13)

    $T2.Start()
    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][Starting [~] Setup ($($T2.Elapsed))][(Inactivity:$Sum/35)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 35)
    $T2.Reset()

    40, 40, 40, 40,  9, 13 | % { $KB.TypeKey($_); Start-Sleep -M 100 }; Start-Sleep 5
    32,  9, 13,  9, 13     | % { $KB.TypeKey($_); Start-Sleep -M 100 }; Start-Sleep 3
     9,  9,  9,  9, 13     | % { $KB.TypeKey($_); Start-Sleep -M 100 }; Start-Sleep 1

    # Commence main installation
    $T2.Start()
    $C = @( )
    Do
    {
        $Disk = Get-Item $VMDisk\$ID.vhdx | % { $_.Length }

        $Log.Add($Log.Count,("[$($T1.Elapsed)][Installing [~] Windows Server 2019 ($($T2.Elapsed))][({0:n3}/8.500 GB)]" -f [Float]($Disk/1GB)))
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Disk -ge 8.5GB)
    $T2.Reset()

    # Set idle timer for first login
    $T2.Start()
    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][Finalizing [~] Setup ($($T2.Elapsed))][(Inactivity:$Sum/250)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Item.Uptime.TotalSeconds -le 2)
    $T2.Reset()

    $T2.Start()
    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][Preparing [~] System ($($T2.Elapsed))][(Inactivity:$Sum/250)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -ge 250)
    $T2.Reset()

    # Log and begin interacting with VM
    $Log.Add($Log.count,"[$($T1.Elapsed)][Ready [+] System (First login)]")
    Write-Host $Log[$Log.Count-1]

    # First PW Screen
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    Start-Sleep 1
    $KB.TypeKey(9)
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    Start-Sleep 1
    $KB.TypeKey(13)
    Start-Sleep 15

    # First Login screen
    $KB.TypeCtrlAltDel()
    Start-Sleep 5
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(13)

    $Log.Add($Log.Count,"[$($T1.Elapsed)][First Login [@] ($(Get-Date))]")
    Write-Host $Log[$Log.Count-1]
    Start-Sleep 60

    # For the 'join network' 
    $KB.TypeKey(27)
    Start-Sleep 1

    # Run PowerShell
    $T2.Start()
    $Log.Add($Log.Count,"[$($T1.Elapsed)][PowerShell [~] Setup ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.PressKey(91)
    $KB.TypeKey(82)
    $KB.ReleaseKey(91)
    Start-Sleep 1
    $KB.TypeText("powershell")
    $KB.TypeKey(13)
    Start-Sleep 30

    # Stop ServerManager, get manifest, set static IP
    $KB.TypeText("Stop-Process -Name ServerManager")
    $KB.TypeKey(13)
    Start-Sleep 15

    $KB.TypeText("Set-DisplayResolution -Width 1280 -Height 720")
    $KB.TypeKey(13)
    Start-Sleep 12

    $KB.TypeText("y")
    $KB.TypeKey(13)
    Start-Sleep 1

    $Log.Add($Log.count,"[$($T1.Elapsed)][PowerShell [~] Setup (IP/Gateway/DNS) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.TypeText("`$ifIndex = Get-NetIPAddress -AddressFamily IPV4 | ? IPAddress -ne 127.0.0.1 | % InterfaceIndex;`$pfLength='$($Server.Item.Prefix)'")
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText("`$Start = `"$($Server.Item.Start)`";`$Temp = `$Start.Split('.'); `$Temp[-1] = [UInt32]`$Temp[-1] + 1;")
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText("`$Hash = @{ InterfaceIndex = `$ifIndex; AddressFamily='IPV4'; IPAddress=`$Temp -join '.'; PrefixLength=`$pfLength; DefaultGateway='$($Server.Item.Start)'}")
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText("New-NetIPAddress @Hash -Verbose -EA 0")
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText("Set-DNSclientServerAddress -InterfaceIndex `$ifIndex -ServerAddresses $DNS -Verbose;Start-Sleep 1")
    $KB.TypeKey(13)
    Start-Sleep 5

    # Deposit the manifest to a text file
    $Log.Add($Log.count,"[$($T1.Elapsed)][PowerShell [~] Setup (Transfer Server Manifest) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $CSV     = $Servers[$X] | ConvertTo-CSV
    $Names   = $CSV[1].Split(",")
    $Values  = $CSV[2].Split(",")
    $Content = @("@(`"```$Hash = @{`""; 0..($Names.Count-1) | % { "'{0} = {1}'" -f $Names[$_], $Values[$_] }; "`"};`")") -join "`n"
    $KB.TypeText("`$Content = $Content")
    $KB.TypeKey(13)
    Start-Sleep 10

    $KB.TypeText("Set-Content -Path `$Home\Desktop\server.txt -Value `$Content -Verbose")
    $KB.TypeKey(13)
    Start-Sleep 3
    $T2.Reset()

    $KB.TypeText("Invoke-Expression (`$Content -join `"``n`")")
    $KB.TypeKey(13)

    $T2.Start()
    $Log.Add($Log.count,"[$($T1.Elapsed)][PowerShell [~] Setup (FightingEntropy) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.TypeText("IRM github.com/mcc85s/FightingEntropy/blob/main/Install.ps1?raw=true | IEX")
    $KB.TypeKey(13)

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][PowerShell [~] Setup (FightingEntropy) ($($T2.Elapsed))][(Inactivity:$Sum/100)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 100)
    $T2.Reset()

    $Log.Add($Log.count,"[$($T1.Elapsed)][System [~] (Hostname/Network/Domain) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $KB.PressKey(91)
    $KB.TypeKey(82)
    $KB.ReleaseKey(91)
    Start-Sleep 1
    $KB.TypeText("control panel")
    $KB.TypeKey(13)
    Start-Sleep 3
    $KB.PressKey(17)
    $KB.TypeKey(76)
    $KB.ReleaseKey(17)
    Start-Sleep 1
    $KB.TypeText("Control Panel\System and Security\System")
    $KB.TypeKey(13)
    Start-Sleep 1
    $KB.TypeKey(32)
    Start-Sleep 1
    $KB.TypeText("[$ID]://($($Server.Item.SiteLink))")
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    Start-Sleep 1
    $KB.TypeText($Server.Name)
    Start-Sleep 1
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    Start-Sleep 1
    $KB.TypeText($Domain)
    13,13,27,9,38,9 | % { $KB.TypeKey($_); Start-Sleep -M 100 }
    $KB.TypeText($Domain)
    $KB.TypeKey(9)
    $KB.TypeKey(13)
    Start-Sleep 10
    $KB.TypeText("$($Credential.Username)@$Domain")
    $KB.TypeKey(9)
    Start-Sleep 1
    $KB.TypeText("$($Credential.GetNetworkCredential().Password)")
    $KB.TypeKey(9)
    Start-Sleep 1

    $Log.Add($Log.count,"[$($T1.Elapsed)][System [~] (Joining domain...) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $KB.TypeKey(13)
    Start-Sleep 25

    $KB.TypeKey(13)
    Start-Sleep 10

    $KB.TypeKey(13)
    Start-Sleep 1

    $KB.PressKey(18)
    $KB.TypeKey(65)
    $KB.ReleaseKey(18)
    Start-Sleep 1

    $KB.TypeKey(13)
    $Log.Add($Log.count,"[$($T1.Elapsed)][System [+] (Hostname/Network/Domain) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $T2.Reset()

    # Wait for login
    Do
    {
        $Item = Get-VM -Name $ID
        Start-Sleep 1
    }
    Until ($Item.Uptime.TotalSeconds -lt 2)

    $T2.Start()
    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.count,"[$($T1.Elapsed)][Domain [~] Restarting ($($T2.Elapsed))]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 100)

    $Log.Add($Log.count,"[$($T1.Elapsed)][Domain [+] (Joined to domain) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $T2.Reset()

    $KB.TypeCtrlAltDel()
    Start-Sleep 5
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(13)
    Start-Sleep 15

    $T2.Start()
    $Log.Add($Log.count,"[$($T1.Elapsed)][Services [~] (Deploy Dhcp) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.PressKey(91)
    $KB.TypeKey(82)
    $KB.ReleaseKey(91)
    Start-Sleep 1
    $KB.TypeText("powershell")
    $KB.TypeKey(13)
    Start-Sleep 15

    $KB.TypeText("Stop-Process -Name ServerManager")
    $KB.TypeKey(13)
    Start-Sleep 15

    # Install Dhcp
    $KB.TypeText("Get-WindowsFeature | ? Name -match DHCP | Install-WindowsFeature")
    $KB.TypeKey(13)

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.count,"[$($T1.Elapsed)][Services [~] (Deploy Dhcp) ($($T2.Elapsed))][(Inactivity:$Sum/100)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 100)

    $Log.Add($Log.count,"[$($T1.Elapsed)][Services [+] (Deploy Dhcp) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $T2.Reset()

    # Reload the gateway/server variables
    $KB.TypeText("(Get-Content `$Home\Desktop\server.txt) -join `"``n`" | Invoke-Expression")
    $KB.TypeKey(13)
    Start-Sleep 2

    # Get Dhcp splat 
    $KB.TypeText('$Content="`$Dhcp=@{StartRange=`"$($Hash.Start)`";EndRange=`"$($Hash.End)`";Name=`"$($Hash.Network)/$($Hash.Prefix)`";Description=`"$($Hash.Sitelink)`";SubnetMask=`"$($Hash.Netmask)`"}"')
    $KB.TypeKey(13)
    Start-Sleep 3

    # Set content
    $KB.TypeText("Set-Content `$Home\Desktop\dhcp.txt -Value `$Content -Verbose")
    $KB.TypeKey(13)
    Start-Sleep 2

    # Add the Dhcp scope
    $KB.TypeText('$Content | Invoke-Expression; Add-DhcpServerV4Scope @Dhcp -Verbose')
    $KB.TypeKey(13)
    Start-Sleep 2

    # Get NetIPConfig
    $KB.TypeText('$Config = Get-NetIPConfiguration -Detailed')
    $KB.TypeKey(13)
    Start-Sleep 10

    $KB.TypeText('$Arp = arp -a | ? { $_ -match "dynamic" -and $_ -match "$($Hash.Start) "};$ClientID=[Regex]::Matches($Arp,"([a-f0-9]{2}\-){5}([a-f0-9]){2}").Value -Replace "-|:",""')
    $KB.TypeKey(13)
    Start-Sleep 6

    # Set Initial DHCP Reservations
    $KB.TypeText('Add-DhcpServerv4Reservation -ScopeID $Hash.Network -IPAddress $Hash.Start -ClientID $ClientID -Name Router -Verbose')
    $KB.TypeKey(13)
    Start-Sleep 4

    $KB.TypeText('Add-DhcpServerv4Reservation -ScopeID $Hash.Network -IPAddress $Config.IPv4Address.IPAddress -ClientID $Config.NetAdapter.LinkLayerAddress.Replace("-","").ToLower() -Name Server -Verbose')
    $KB.TypeKey(13)
    Start-Sleep 6

    # Set Dhcp Scope Options
    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 3 -Value `$Config.IPV4DefaultGateway.NextHop -Verbose") # (Router)
    $KB.TypeKey(13)
    Start-Sleep 2

    $Value = ( $DhcpOpt | ? OptionID -eq 4 | % Value ) -join ','
    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 4 -Value $Value -Verbose") # (Time Servers)
    $KB.TypeKey(13)
    Start-Sleep 2

    $Value = ( $DhcpOpt | ? OptionID -eq 5 | % Value ) -join ','
    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 5 -Value $Value -Verbose") # (Name Servers)
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("`$Value = ( `$Config.DNSServer | ? AddressFamily -eq 2 | % ServerAddresses )")
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 6 -Value `$Value -Verbose") # (Dns Servers)
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 15 -Value $Domain -Verbose") # (Dns Domain Name)
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("Set-DhcpServerv4OptionValue -OptionID 28 -Value `$Hash.Broadcast -Verbose") # (Broadcast Address)
    $KB.TypeKey(13)
    Start-Sleep 2

    $Log.Add($Log.count,"[$($T1.Elapsed)][Services [+] (Dhcp Configured) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $T2.Reset()

    $T2.Start()
    $Log.Add($Log.count,"[$($T1.Elapsed)][Services [~] (Adds/Rsat/Dhcp/Dns) Suite ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.TypeText('$Module = Get-FEModule')
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText('($Module.Classes | ? Name -match ServerFeature | Get-Content ) -join "`n" | Invoke-Expression')
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText('$Features = [_ServerFeatures]::New().Output')
    $KB.TypeKey(13)
    Start-Sleep 5

    $KB.TypeText('$Features | ? { !($_.Installed) } | % { $_.Name.Replace("_","-") } | Install-WindowsFeature -Verbose')
    $KB.TypeKey(13)

    $C = 0
    Do
    {
        $Item = Get-VM -Name $ID
        Start-Sleep 1
        $Log.Add($Log.Count,"[$($T1.Elapsed)][Installing [~] (Adds/Rsat/Dhcp/Dns) Suite ($($T2.Elapsed))][(Timer:$C/120)]")
        Write-Host $Log[$Log.Count-1]

        $C ++
    }
    Until ($C -gt 120)

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)]Installing [~] (Adds/Rsat/Dhcp/Dns) Suite ($($T2.Elapsed))][(Inactivity:$Sum/100)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 100)

    $Log.Add($Log.Count,"[$($T1.Elapsed)][Installed [+] (Adds/Rsat/Dhcp/Dns) Suite ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    $T2.Reset()

    $T2.Start()
    $Log.Add($Log.Count,"[$($T1.Elapsed)][Deploying [~] (Domain Controller) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $KB.TypeText('Import-Module ADDSDeployment')
    $KB.TypeKey(13)
    Start-Sleep 10

    $KB.TypeText("`$Pw = Read-Host 'Enter password' -AsSecureString")
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("`$Credential=[System.Management.Automation.PSCredential]::New(`"$($Credential.Username)@$Domain`",`$Pw)")
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("`$ADDS=@{NoGlobalCatalog=0;CreateDnsDelegation=0;Credential=`$Credential;CriticalReplicationOnly=0;DatabasePath='C:\Windows\NTDS';DomainName='$($Domain)';InstallDns=1;LogPath='C:\Windows\NTDS';NoRebootOnCompletion=0;SiteName='$($Server.Item.SiteLink)';SysVolPath='C:\Windows\SYSVOL';Force=1;SafeModeAdministratorPassword=`$Pw}")
    $KB.TypeKey(13)
    Start-Sleep 8


    $KB.TypeText("Install-ADDSDomainController @ADDS -Verbose")
    $KB.TypeKey(13)
    $Log.Add($Log.Count,"[$($T1.Elapsed)][Deploying [~] (Domain Controller) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]

    $T2.Start()
    Do
    {
        $Item = Get-VM -Name $ID
        $Log.Add($Log.Count,"[$($T1.Elapsed)][Deploying [~] (Domain Controller) ($($T2.Elapsed))]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until($Item.Uptime.TotalSeconds -le 2)

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID

        Switch($Item.CPUUsage)
        {
            Default { $C = @( ) } 0 { $C += 1 } 1 { $C += 1 } 
        }

        $Sum = @( Switch($C.Count)
        {
            0 { 0 } 1 { $C } Default { (0..($C.Count-1) | % {$C[$_]*$_}) -join "+" }
        } ) | Invoke-Expression

        $Log.Add($Log.Count,"[$($T1.Elapsed)][Booting [~] Domain Controller ($($T2.Elapsed))][(Inactivity:$Sum/100)]")
        Write-Host $Log[$Log.Count-1]
        Start-Sleep 1
    }
    Until ($Sum -gt 100)

    $T2.Stop()
    $Log.Add($Log.Count,"[$($T1.Elapsed)][Deployed [+] (Domain Controller) ($($T2.Elapsed))]")
    Write-Host $Log[$Log.Count-1]
    
    Set-Content -Path "$Home\Desktop\($ID)($Date).txt" -value $Log[0..($Log.Count-1)] -Verbose

    # !!!!!! Set up (Sitelink/Bridge/Replication)
    <# Recycling
    $KB.TypeCtrlAltDel()
    Start-Sleep 3
    9,9,9,13|%{$KB.TypeKey($_); Start-Sleep -M 100 }
    Start-Sleep 1
    $KB.TypeText($Credential.Username+"@$Domain")
    $KB.TypeKey(9)
    Start-Sleep 1
    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(13)
    Start-Sleep 40

    $KB.TypeKey(27)
    $KB.PressKey(91)
    $KB.TypeKey(82)
    $KB.ReleaseKey(91)
    Start-Sleep 1
    $KB.TypeText("taskmgr")
    Start-Sleep -M 100
    $KB.TypeKey(13)
    Start-Sleep 2
    
    $KB.PressKey(18)
     68, 70, 78     | % { $KB.TypeKey($_); Start-Sleep -M 100 }
    $KB.ReleaseKey(18)
    Start-Sleep 1
    $KB.TypeText("powershell")
    $KB.TypeKey(9)
    $KB.TypeKey(32)
    $KB.TypeKey(13)
    Start-Sleep 12

    $KB.TypeText("'ServerManager','TaskMgr','Shutdown' | % { Stop-Process -Name `$_ -EA 0 }; Remove-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -EA 0")
    $KB.TypeKey(13)
    Start-Sleep 4

    $KB.TypeText("`$Pw = Read-Host 'Enter password' -AsSecureString")
    $KB.TypeKey(13)
    Start-Sleep 1

    $KB.TypeText($Credential.GetNetworkCredential().Password)
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("`$Credential=[System.Management.Automation.PSCredential]::New(`"$($Credential.Username)@$Domain`",`$Pw)")
    $KB.TypeKey(13)
    Start-Sleep 2

    $KB.TypeText("Uninstall-ADDSDomainController -LocalAdministratorPassword `$Pw -DemoteOperationMasterRole:`$True -ForceRemoval:`$True -Credential `$Credential -Force -Confirm:`$False")
    $KB.TypeKey(13)
    Start-Sleep 3

    $C = @( )
    Do
    {
        $Item = Get-VM -Name $ID
        Write-Host "[$($T1.Elapsed)][Removing Domain Controller ($ID)]"
        Start-Sleep 1
    }
    Until ($Item.Uptime.TotalSeconds -le 2)

    Get-ADObject -LDAPFilter "(objectClass=server)"   -SearchBase "CN=Configuration,$Base" | ? Name -match $Server.Name | Remove-ADObject -Confirm:$False -Recursive -Verbose
    Get-ADObject -LDAPFilter "(objectClass=computer)" -SearchBase $Base | ? Name -match $Server.Name | Remove-ADObject -Confirm:$False -Recursive -Verbose

    $Server.Stop()
    $Server.Remove()
    #>

    $X ++
}
Until ($X -eq 1)
