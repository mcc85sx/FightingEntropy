#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯\\   
#   //¯¯\\__[ Section    ]__________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   
#   //¯¯¯                                                                                                           //   
#   \\       Install CentOS Server [2021-07-14]                                                                     \\   
#   //                                                                                                              //   
#   \\       Module: [FightingEntropy(π)][(2021.7.0)]                                                               \\   
#   //          URL: https://github.com/mcc85sx/FightingEntropy/blob/master/CentOS/Install-CentOS(2021_0714).ps1    //    
#   \\         Name: mail.securedigitsplus.com                                                                      \\   
#   //                                                                                                           ___//   
#   \\___                                                                                                    ___//¯¯\\   
#   //¯¯\\__________________________________________________________________________________________________//¯¯¯___//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Press enter to continue    ]__________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$Kerb = Get-Credential # Kerberos Administrator
$Unix = Get-Credential # Unix Administrator

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
            $KB.PressKey(16)
            $KB.TypeKey([KeyEntry]::SKey["$Key"])
            $KB.ReleaseKey(16)
        }
        Else
        {
            $KB.TypeKey([KeyEntry]::Keys["$Key"])
        }

        Start-Sleep -Milliseconds 50
    }
}

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ Preliminary [+] Info & VM Declaratives                                                         ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

$Zone                  = "securedigitsplus.com"
$ScopeID               = Get-DhcpServerv4Scope | % ScopeID
$ID                    = "mail"

$VMSwitch              = Get-VMSwitch | ? SwitchType -eq External | % Name
$ISOPath               = "C:\Images\CentOS-8.4.2105-x86_64-boot.iso"
$VMC                   = Get-VMHost
$Name                  = "mail"
$Time                  = [System.Diagnostics.Stopwatch]::StartNew()
$Log                   = @{ } 
$VM                    = @{  

    Name               = $Name
    MemoryStartupBytes = 2048MB
    Path               = "{0}\{1}.vmx"  -f $VMC.VirtualMachinePath,  $Name
    NewVHDPath         = "{0}\{1}.vhdx" -f $VMC.VirtualHardDiskPath, $Name
    NewVHDSizeBytes    = 100GB
    Generation         = 1
    SwitchName         = $VMSwitch
}

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ Purging/Building VM    ]______________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

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
$VMNet = Get-VMNetworkAdapter -VMName $Name 

#  ____                                                                                                    ________    
# //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
# \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#  ¯¯¯\\__[ Starting VM    ]______________________________________________________________________________//¯¯¯        
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

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

#  ____    ____________________________________________________________________________________________________        
# //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
# \\__//¯¯¯ Install [?] CentOS 8                                                                           ___//¯¯\\   
#  ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

KeyEntry $KB i
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

#    ____    ____________________________________________________________________________________________________        
#   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    
#   \\__//¯¯¯ CentOS [+] Welcome to CentOS Linux 8                                                           ___//¯¯\\   
#    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Welcome to CentOS Linux 8")
$KB.TypeKey(13)
Start-Sleep 1

# Enter the GUI menu
9,9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Start-Sleep 6

# Main menu -> Network
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Network configuration...")
$KB.PressKey(18)
KeyEntry $KB n
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 3

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Network Menu   ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Setting VM Adapter Mac [$($VMNet.MacAddress)]")
Get-DhcpServerv4Reservation -ScopeId $ScopeID | Set-DhcpServerv4Reservation -ClientId $VMNet.MacAddress

9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
$KB.TypeKey(32)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] IP Address / Network Engaged")

9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
KeyEntry $KB "$ID.$Zone"
9,32 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
Start-Sleep 2
$KB.TypeKey(32)
Start-Sleep 1

9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Hostname/Network configured")
Start-Sleep 8

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installation Destination   ]__________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$KB.PressKey(18)
KeyEntry $KB d
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 8

$KB.TypeKey(13)
Start-Sleep 8

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Auto-partitioning selected")
$KB.TypeKey(13)
Write-Theme "Auto-Partition [+] Set"
Start-Sleep 10
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Destination")

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installation Source    ]______________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$KB.PressKey(18)
KeyEntry $KB i
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 1

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Source")
9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

KeyEntry $KB "http://mirror.centos.org/centos/8/BaseOS/x86_64/os/"
Start-Sleep 1

$KB.PressKey(16)
Start-Sleep -Milliseconds 100

9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$KB.ReleaseKey(16)
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installation Source Selected")
Start-Sleep 3

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Software Selection ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$KB.PressKey(18)
KeyEntry $KB ss
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 3

9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }
KeyEntry $KB "˅˅"
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100
$KB.PressKey(16)
Start-Sleep -Milliseconds 100

9,9,9,9 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$KB.ReleaseKey(16)
$KB.TypeKey(13)
Start-Sleep -Milliseconds 100
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Software Selected")
Start-Sleep 4

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Root password  ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$KB.PressKey(18)
KeyEntry $KB r
$KB.ReleaseKey(18)
$KB.TypeKey(13)
Start-Sleep 1

KeyEntry $KB $Unix.GetNetworkCredential().Password
$KB.TypeKey(9)

KeyEntry $KB $Unix.GetNetworkCredential().Password
$KB.TypeKey(9)
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Start-Sleep 1
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Root password entered")

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installing...  ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

9,9,9,13 | % { $KB.TypeKey($_); Start-Sleep -Milliseconds 100 }

$C         = @( )
Do
{
    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installing...")
    Write-Host $Log[$Log.count-1]
}
Until((Get-Item $VM.NewVHDPath).Length -ge 2500000000)

$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [+] Files sourced, now validating")
Write-Host $Log[$Log.count-1]

Do
{
    Start-Sleep -Seconds 1
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Finalizing...")
    Write-Host $Log[$Log.count-1]
    $Item     = Get-VM -Name $Name
    
    Switch($Item.CPUUsage)
    {
        0       { $C +=   1  }
        Default { $C  = @( ) }
    }
}
Until($C.Count -gt 30)

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installed/Reboot   ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

$KB.TypeKey(9)
$KB.TypeKey(13)
$Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Installed, Rebooting...")

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
    $Item = Get-VM -Name $Name
    $Log.Add($Log.Count,"[$($Time.Elapsed)] CentOS [~] Booting...")
    Write-Host $Log[$Log.Count-1]
    Switch($Item.CPUUsage) { 0 { $C += 1 } Default { $C = @( ) } }
    Start-Sleep 1
}
Until ($C.Count -gt 5)

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ First Login    ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

KeyEntry $KB "root"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB $Unix.GetNetworkCredential().Password
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Installing additional packages ]______________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

KeyEntry $KB "curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB @("yum install powershell wget tar net-tools realmd cifs-utils sssd oddjob oddjob-mkhomedir",
           "adcli samba samba-common samba-common-tools krb5-workstation epel-release httpd httpd-tools",
           "mariadb mariadb-server postfix dovecot mod_ssl -y" -join ' ')
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)

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

KeyEntry $KB pwsh
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 2

KeyEntry $KB "IRM github.com/mcc85sx/FightingEntropy/blob/master/CentOS/CentOSMailServer.ps1?raw=true | IEX"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB '$Name       = "mail"'
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB '$Domain     = "securedigitsplus.com"'
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB '$ServerName = "$Name.$Domain"'
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB '_Content "/etc/sysconfig/selinux" "SELINUX=enforcing" "SELinux=disabled"'
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB "yum update -y"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB '_Network $ServerName'
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB "_JoinRealm '$($Kerb.Username.ToUpper())'"
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

KeyEntry $KB $Kerb.GetNetworkCredential().Password
Start-Sleep -Milliseconds 100
$KB.TypeKey(13)
Sleep 1

_JoinShare certsrv dsc0.securedigitsplus.com cert

# Copy Certicates 
ForEach ( $Cert in @("securedigitsplus.com" | % { "ca.cer","fullchain.cer","$_.cer","$_.key","$_.pfx" }) )
{
    Copy-Item "/mnt/securedigitsplus.com/$Cert" "/etc/ssl/certs/$Cert" -Verbose
}

_Apache
_Content "/etc/httpd/conf/httpd.conf" "#ServerName www.example.com" "ServerName $ServerName"
_MariaDB
_Postfix
_Dovecot
_PHP
_Roundcube "1.4.11"
