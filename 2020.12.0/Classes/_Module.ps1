Class _Module
{
    [Object]                 $OS
    [Object]           $Manifest
    [Object]               $Hive
    
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.12.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date
    [String]             $Status
    [String]               $Type
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.12.0"

    [Object]               $Host
    [Object]               $Info
    [Object]               $Role
    
    [Object[]]          $Classes
    [Object[]]          $Control
    [Object[]]        $Functions
    [Object[]]         $Graphics
    
    _Module()
    {
        $This.OS                 = [_OS]::New()
        $This.Module             = [_Manifest]::New()
        $This.Hive               = [_Hive]::New()

        Get-ItemProperty -Path $This.Hive.Root | % { 

            $This.Name           = $_.Name
            $This.Version        = $_.Version
            $This.Provider       = $_.Provider
            $This.Date           = $_.Date
            $This.Status         = $_.Status
        }
        
        $This.Host               = [_Host]::New()
        $This.Info               = [_Info]::New()
        $This.Role               = [_Role]::New()

        $This.Classes            = $This.Manifest.Classes   | % { "{0}\Classes\$_.ps1"   -f $This.Hive.Path }
        $This.Control            = $This.Manifest.Control   | % { "{0}\Control\$_"       -f $This.Hive.Path }
        $This.Functions          = $This.Manifest.Functions | % { "{0}\Functions\$_.ps1" -f $This.Hive.Path } 
        $This.Graphics           = $This.Manifest.Graphics  | % { "{0}\Graphics\$_"      -f $This.Hive.Path }
    }
}
