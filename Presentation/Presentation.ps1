
# [Begin]
    $Credential = Get-Credential  # [Service Account]
    $Time       = [System.Diagnostics.Stopwatch]::StartNew()
    $Log        = @( )

# [Starting VM-Variables]
    $ID         = "10P64"
    $VMHost     = Get-VMHost
    $VMSwitch   = Get-VMSwitch
    $VMPath     = $VMHost.VirtualMachinePath
    $VHDPath    = "{0}\{1}.vhdx" -f $VMHost.VirtualHardDiskPath,$ID

# [Stop/Remove existing VM]
    Stop-VM -Name $ID -Force -EA 0 -Verbose
    Remove-VM -Name $ID -Force -EA 0 -Verbose
    Remove-Item -Path $VHDPath -Force -EA 0 -Verbose
    $Log += ("@({0})[{1} removed]" -f $Time.Elapsed,$ID)

# [Remove workstation from AD]
    $Identity   = Get-ADComputer -Filter * | ? Name -match $ID | % DistinguishedName 
    If ( $Identity )
    {
        Remove-ADObject -Identity $Identity -Recursive
    }

# [(Imaging/Sharing) Variables]
    $Source     = "C:\Images"     # [Folder where Windows ISO's are located]
    $Target     = "C:\ImageTest"  # [Target Swap directory]
    $Path       = "C:\FlightTest"
    $ShareName  = "FightingEntropy$"
    $Log        = @( )

# [Remove any existing image(s)]
    Remove-Item $Target -Force -Recurse -Verbose -EA 0
    $Log       += ("@({0})[{1} removed]" -f $Time.Elapsed,$Target)

# [Remove Module]
    Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
    Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
    Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
    $Log       += ("@({0})[Traces of module removed]" -f $Time.Elapsed)

# [Install Module]
    Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )
    $Log       += ("@({0})[Module Installed]" -f $Time.Elapsed)

# [Execute/Import Module]
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Add-Type -AssemblyName PresentationFramework
    Import-Module FightingEntropy -Verbose
    Write-Theme "Loaded Module [+] FightingEntropy($([Char]960))" 10,3,15,0

    $Log       += ("@({0})[Module Imported]" -f $Time.Elapsed)

# [Company Info]
    $Key             = @{

        Organization = "Secure Digits Plus LLC" 
        CommonName   = "securedigitsplus.com" 
        Phone        = "(518)406-8569"
        Website      = "www.securedigitsplus.com"
        Hours        = "24h/d;7d/w;365.25d/y;"
    
    }                | % { New-EnvironmentKey @_ }

    $Log       += ("@({0})[        Key created]" -f $Time.Elapsed)

# [New Image Extraction]
    New-FEImage -Source $Source -Target $Target
    $Log += ("@({0})[     Images created]" -f $Time.Elapsed)

# [Remove Existing FE/Deployment Shares]
    Get-FEShare -Name $ShareName | Remove-FEShare

# [New Share]
    New-FEShare -Path $Path -ShareName $ShareName -Credential $Credential -Key $Key
    $Log += ("@({0})[      Share created]" -f $Time.Elapsed)

# [New Image Extraction]
    Import-FEImage -ShareName $ShareName -Source $Target -Admin Administrator -Password password -Key $Key
    $Log += ("@({0})[     Images imported]" -f $Time.Elapsed)

# [Update Share with Image
    Update-FEShare -ShareName $ShareName -Mode 0 -Credential $Credential -Key $Key
    $Log += ("@({0})[Share updated]" -f $Time.Elapsed)

    New-VM -Name $ID -MemoryStartupBytes 4GB -Path $VMPath -NewVHDPath $VHDPath -NewVHDSizeBytes 40GB -Generation 2 -SwitchName $VMSwitch.Name
    Set-VM -Name $ID -ProcessorCount 2
    $Log += ("@({0})[{1} removed]" -f $Time.Elapsed,$ID)

    Start-VM -Name $ID
    $Log += ("@({0})[{1} started]" -f $Time.Elapsed,$ID)

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
