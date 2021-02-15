# [Begin]
    $Credential = Get-Credential  # [Service Account]
    $Time       = [System.Diagnostics.Stopwatch]::StartNew()

# [Starting VM-Variables]
    $ID         = "10P64"
    $VMHost     = Get-VMHost
    $VMSwitch   = Get-VMSwitch
    $VMPath     = $VMHost.VirtualMachinePath
    $VHDPath    = "{0}\{1}.vhdx" -f $VMHost.VirtualHardDiskPath,$ID

# [Stop/Remove existing VM]
    Stop-VM -Name $ID -Force -EA 0
    Remove-VM -Name $ID -Force -EA 0
    Remove-Item -Path $VHDPath -Force -EA 0
    $Log += ("@($($Time.Elapsed))[{0} removed]" -f $ID)

# [Remove workstation from AD]
    $Identity   = Get-ADComputer -Filter * | ? Name -match $ID | % DistinguishedName 
    If ( $Identity )
    {
        Remove-ADObject -Identity $Identity -Recursive -Force
    }

# [(Imaging/Sharing) Variables]
    $Source     = "C:\Images"     # [Folder where Windows ISO's are located]
    $Target     = "C:\ImageTest"  # [Target Swap directory]
    $Path       = "C:\FlightTest"
    $ShareName  = "FightingEntropy$"
    $Log        = @( )

# [Remove any existing image(s)]
    Remove-Item $Target -Force -Recurse -Verbose -EA 0
    $Log += ("@($($Time.Elapsed))[{0} removed]" -f $Target)

# [Remove Module]
    Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
    Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
    Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
    $Log += ("@($($Time.Elapsed))[Traces of module removed]")

# [Install Module]
    Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )
    $Log += ("@($($Time.Elapsed))[Module Installed]")

# [Execute/Import Module]
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Add-Type -AssemblyName PresentationFramework
    Import-Module FightingEntropy -Verbose
    Write-Theme "Loaded Module [+] FightingEntropy($([Char]960))" 10,3,15,0

    $Log += ("@($($Time.Elapsed))[Module Imported]")

# [Company Info]
    $Key  = New-EnvironmentKey -Organization "Secure Digits Plus LLC" -CommonName securedigitsplus.com -Phone "(518)-406-8569" -Website www.securedigitsplus.com -Hours "24h/d;7d/w;365.25d/y;"
    $Log += "@($($Time.Elapsed))[        Key created]"

# [New Image Extraction]
    New-FEImage -Source $Source -Target $Target
    $Log += "@($($Time.Elapsed))[     Images created]"

# [Remove Existing FE/Deployment Shares]
    Get-FEShare -Name $ShareName | Remove-FEShare

# [New Share]
    New-FEShare -Path $Path -ShareName $ShareName -Credential $Credential -Key $Key
    $Log += "@($($Time.Elapsed))[      Share created]"

# [New Image Extraction]
    Import-FEImage -ShareName $ShareName -Source $Target -Admin Administrator -Password password -Key $Key
    $Log += "@($($Time.Elapsed))[     Images imported]"

# [Update Share with Image
    Update-FEShare -ShareName $ShareName -Mode 0 -Credential $Credential -Key $Key
    $Log += "@($($Time.Elapsed))[      Share updated]"

    New-VM -Name $ID -MemoryStartupBytes 4GB -Path $VMHost.VirtualMachinePath -NewVHDPath ("{0}\{1}.vhdx" -f $VMHost.VirtualHardDiskPath,$ID) -NewVHDSizeBytes 40GB -Generation 2 -SwitchName $VMSwitch.Name
    Set-VM -Name $ID -ProcessorCount 2
    $Log += ("@($($Time.Elapsed))[{0} removed]" -f $ID)

    Start-VM -Name $ID
    $Log += ("@($($Time.Elapsed))[{0} started]" -f $ID)

    Do 
    {
        Start-Sleep 5
        Write-Host "..."
        $Object = Get-MDTOData -Server dsc0.securedigitsplus.com -Port 9801 | ? Name -match $ID
        Switch -Regex ($Object.DeploymentStatus)
        {
            "Active/Running"
            {
                $Running = $True
            }

            "Failed"
            {
                $Running = $False
                Write-Theme "Failed [!] Deployment failed" 12,4,15,0
            }

            "Complete"
            {
                $Running = $False
                Write-Theme "Success [+] Deployment successful" 10,10,15,0
            }
        }
    }
    Until (!$Running)
    $Time.Stop()
    $Log += ("@($($Time.Elapsed))[{0} Time Complete]" -f $ID)

# @(00:00:18.3821989)[C:\ImageTest removed]
# @(00:00:42.6803810)[10P64 removed]
# @(00:00:42.9965113)[Traces of module removed]
# @(00:01:02.4350559)[Module Installed]
# @(00:01:03.3896154)[Module Imported]
# @(00:07:13.6454704)[     Images created]
# @(00:07:33.0530893)[      Share created]
# @(00:07:48.7245965)[     Images imported]
# @(00:20:38.0011844)[      Share updated]
# @(00:20:42.6075071)[10P64 removed]
# @(00:21:16.6291694)[10P64 removed]
# @(00:32:49.3821125)[10P64 MDT/OS Installed]
# @(00:41:18.3211494)[10P64 Windows Pre-Desktop]
# @(00:45:36.5253549)[10P64 Windows Desktop]
# @(00:47:21.0458156)[10P64 Deployment Complete]
# @(00:47:34.0614904)[10P64 Time Complete]
