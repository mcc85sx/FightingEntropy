    $Path      = "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.0"
    $Load      = @( )
    $Classes   = Get-ChildItem $Path | ? Name -eq Classes   | % FullName

    ("_QMark _File _FirewallRule _Drive _Cache _Icons _Shortcut _Drives _Host _Block _Track _Theme _Object _UISwitch" +
     " _Toast _XamlWindow _Root _Module _VendorList _V4Network _V6Network _NetInterface _Network _Info _Service _Ser" + 
     "vices _ViperBomb _Brand _Branding _Certificate _Company _Key _RootVar _Share _Master _Source _Target") -Split " " | % { 

        $Load += ( Get-Content -Path "$Classes\$_.ps1")
    }

    $Functions = Get-ChildItem $Path | ? Name -eq Functions | % FullName

    ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme") -Split " " | % {

        $Load += ( Get-Content -Path "$Functions\$_.ps1" -Verbose )
    }

    Invoke-Expression ( $Load -join "`n" )
