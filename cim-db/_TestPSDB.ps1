$Base = "https://github.com/mcc85sx/FightingEntropy/blob/master/cim-db"
$Init = Invoke-RestMethod "$Base/Functions/init.cim-db.ps1?raw=true"
Invoke-Expression $Init

$DB   = init.cim-db https://github.com/mcc85sx/FightingEntropy/blob/master/cim-db

0..1000 | % { 
    
    $x = Get-Random -Maximum 8
    $DB.AddUID($x)
    Write-Host ("Added [+] {0}" -f $DB.UID[$_].Type)
}
