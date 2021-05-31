$ID      = "BossMode" 
$Ext     = "StorableColorTheme.ps1xml"
$Name    = "$ID.$Ext"
$Value   = "https://github.com/mcc85sx/FightingEntropy/blob/master/ISETheme/$Name`?raw=true"
$Content = Invoke-WebRequest -Uri $Value -UseBasicParsing | % Content
$Reg     = "HKCU:\Software\Microsoft\PowerShell\3\Hosts\PowerShellISE\ColorThemes"

If ( ( Get-ItemProperty $Reg ) -ne $Null )
{
    If ( Get-ItemProperty $Reg | Get-Member | ? Name -match $ID )
    {
        Remove-ItemProperty $Reg -Name $ID -Verbose

        Write-Host " [Flushing theme...] " -F 10 -B 12
    }

    Set-ItemProperty $Reg -Name $ID -Value $Content -Verbose
}
