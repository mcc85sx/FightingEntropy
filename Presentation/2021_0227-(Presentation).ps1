# [Begin]
$Time       = [System.Diagnostics.Stopwatch]::StartNew()
$Log        = @( )

# [(Imaging/Sharing) Variables]
$Server     = (Resolve-DNSName $Env:ComputerName | % Name | Select-Object -Unique)
$Port       = 9801
$Source     = "C:\Images"         # [Folder where Windows ISO's are located]
$Target     = "C:\ImageTest"      # [Target Swap directory]
$Path       = "C:\FlightTest"     # [Path to local file system deployment root]
$ShareName  = "FightingEntropy$"  # [Name of the SMB share, used to identify network root]
$NamedVM    = "DSC2","10P64"      # [Name of the test VM systems]

$Log       += ("@({0})[Variables declared]" -f $Time.Elapsed)

# [Remove Module]
Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.2.0 | Remove-Item -Verbose -Recurse
$Log += ("@({0})[Module removed]" -f $Time.Elapsed)

# [Install Module]
Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )
$Log += ("@({0})[Module Installed]" -f $Time.Elapsed)

# [Execute/Import Module]
Set-ExecutionPolicy Bypass -Scope Process -Force
Add-Type -AssemblyName PresentationFramework
Import-Module FightingEntropy
$Log += ("@({0})[Module Imported]" -f $Time.Elapsed)

New-FEDeploymentShare
$Log += ("@({0})[Deployment Share started]" -f $Time.Elapsed)

Start-VMGroup -NamedVM $NamedVM
$Log += ("@({0})[Started VMGroup]" -f $Time.Elapsed)

Install-VMGroup -Server $Server -Port $Port -NamedVM $NamedVM
$Log += ("@({0})[Installed VMGroup]" -f $Time.Elapsed)
