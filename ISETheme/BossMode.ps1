$Name    = "BossMode.StorableColorTheme.ps1xml"
$Path    = "$home\Desktop\{0}" -f $Name
$Value   = "https://github.com/mcc85sx/FightingEntropy/blob/master/ISETheme/$Name`?raw=true"
$Content = Invoke-WebRequest -Uri $Value -UseBasicParsing -OutFile $Path | % Content
