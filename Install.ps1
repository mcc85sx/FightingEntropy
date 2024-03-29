Function Install-FEModule
{
    [CmdLetBinding()]
    Param(
    
    [ValidateSet("2021.1.0","2021.1.1","2021.2.0","2021.3.0","2021.3.1","2021.4.0")]
    [Parameter(Mandatory)]
    [String]$Version)

    [Net.ServicePointManager]::SecurityProtocol = 3072
    $Install = @( )
    
    ForEach ( $Item in "OS Root Manifest RestObject Hive Install" -Split " " )
    {
        $Install += Invoke-RestMethod https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/$Version/Classes/_$Item.ps1
    }
    
    Invoke-Expression ( $Install -join "`n" )
    
    [_Install]::New($Version)
    
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Add-Type -AssemblyName PresentationFramework
    Import-Module FightingEntropy

    $Item              = (New-Object -ComObject WScript.Shell).CreateShortcut("$Env:Public\Desktop\FightingEntropy.lnk")

    $Item.TargetPath   = "powershell"
    $Item.Arguments    = "-NoExit -ExecutionPolicy Bypass -Command `"Add-Type -AssemblyName PresentationFramework;Import-Module FightingEntropy;`$Module = Get-FEModule;`$Module`""
    $Item.Description  = "Beginning the fight against identity theft and cybercriminal activities."
    $Item.IconLocation = Get-FEModule -Graphics | ? Name -match icon.ico | % Fullname

    $Item.Save()
}

$Install = Install-FEModule -Version 2021.4.0
