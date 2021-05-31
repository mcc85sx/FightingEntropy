$ID      = "BossMode" 
$Ext     = "StorableColorTheme.ps1xml"
$Name    = "$ID.$Ext"
$Value   = "https://github.com/mcc85sx/FightingEntropy/blob/master/ISETheme/$Name`?raw=true"
$Content = Invoke-WebRequest -Uri $Value -UseBasicParsing | % Content
$Reg     = "HKCU:\Software\Microsoft\PowerShell\3\Hosts\PowerShellISE\ColorThemes"

If ( ( Get-ItemProperty -Path $Reg ) -ne $Null )
{
    If ( Get-ItemProperty -Path $Reg | Get-Member | ? Name -match $ID )
    {
        Remove-ItemProperty -Path $Reg -Name $ID -Verbose

        Write-Host " [Flushing theme...] " -F 10 -B 12
    }

    Set-ItemProperty -Path $Reg -Name $ID -Value $Content -Verbose
}

$XML     = [XML]( Get-ItemProperty -Path $Reg ).$ID

$Array   = @( )
$Hash    = @{ }

ForEach ( $X in 0..72 )
{
    $ItemName  = $XML.StorableColorTheme.Keys.String[$X]
    $ItemValue = $XML.StorableColorTheme.Values.Color[$X]

    $Array    += $ItemName
    $Hash.Add($ItemName,$ItemValue)
}

ForEach ( $Item in $Array )
{
    "________________________________________"
    "[ $Item ]"
    "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"
    $Hash[$ItemName] | FT
}
