Function Remove-FEModule
{
    [CmdLetBinding()]Param(
    [ValidateSet("2021.1.0","2021.1.1")]
    [Parameter(Mandatory)][Object]$Version)

    If ( !$Version -or $Version -notmatch "(\d{4}\.\d+\.\d+)" )
    {
        Throw "Invalid Version"
    }

    "Secure Digits Plus LLC\FightingEntropy" | % {

        ($Env:PSModulePath -Split ";" | ? { Test-Path $_ } | Get-ChildItem | ? Name -match FightingEntropy | % FullName)
        Get-ChildItem -Path "$env:ProgramData\$_"                          | ? Name -match $Version | % FullName
        Get-Item      -Path "HKLM:\SOFTWARE\Policies\$_"                   | ? Name -match $Version
        
    } | Remove-Item -Verbose -Recurse
}

Remove-FEModule -Version 2021.1.1

# Install
Invoke-Expression ( Invoke-RestMethod https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/Install.ps1 )

# Import
Set-ExecutionPolicy Bypass -Scope Process -Force
Add-Type -AssemblyName PresentationFramework
Import-Module FightingEntropy

# Load
$Module = Get-FEModule

ForEach ( $File in @( 

    "ADConnection ADLogin DNSSuffix DomainName ServerFeatures FEDCPromo".Split(" ") | % { 

        $Module.Classes | ? Name -match $_ | % FullName
    }

    "Get-FEDCPromo","Get-FEDCPromoProfile" | % { 

        $Module.Functions | ? Name -Match $_ | % FullName
    }
) | Select-Object -Unique )

{
    $PSISE.CurrentPowerShellTab.Files.Add($File) | Out-Null 
}
