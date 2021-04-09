# [Remove Module]
Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules" | ? Name -match FightingEntropy | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.4.0 | Remove-Item -Verbose -Recurse
Get-ChildItem -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\FightingEntropy" | ? Name -match 2021.4.0 | Remove-Item -Verbose -Recurse

# [Install Module]
Invoke-Expression ( Invoke-RestMethod https://github.com/mcc85sx/FightingEntropy/blob/master/Install.ps1?raw=true )

Set-ExecutionPolicy Bypass -Scope Process -Force
Add-Type -AssemblyName PresentationFramework
Import-Module FightingEntropy
