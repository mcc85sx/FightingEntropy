Function Install
{
    Class FEModule
    {
        [String]             $Base  = ("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.12.0")
        [String[]]        $Classes_ = ("_OS _Manifest _Install" -Split " " | % { "Classes/$_.ps1" })
        Hidden [Object[]] $Classes 
        Hidden [String[]]    $Swap
        [String]           $Output
        
        FEModule()
        {
            $This.Classes      = $This.Classes_ | % { Invoke-RestMethod -URI "$($This.Base)/$_" -Verbose }
            $This.Swap         = $This.Classes -Join "`n"
            $This.Output       = $This.Swap -Join "`n"
        }
    }

    Invoke-Expression ([FEModule]::New().Output)

    [_Install]::New()
}
