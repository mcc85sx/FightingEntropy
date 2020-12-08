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
    [Object[]]          $Classes
    [Object[]]        $Functions
    [Object[]]          $Control
    [Object[]]         $Graphics
    
    [Object]               $Host
    [Object]               $Info
    [Object]               $Role
    
    _Module()
    {
        $This.OS                 = (Get-FEOS)
        $This.Type               = $This.OS.Type
        $This.Manifest           = (Get-FEManifest)
        $This.Hive               = (Get-FEHive($This.Type,$This.Version))

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

        $This.Classes            = $This.Manifest.Classes   | % { "{0}\Classes\$_"   -f $This.Hive.Path }
        $This.Control            = $This.Manifest.Control   | % { "{0}\Control\$_"   -f $This.Hive.Path }
        $This.Functions          = $This.Manifest.Functions | % { "{0}\Functions\$_" -f $This.Hive.Path } 
        $This.Graphics           = $This.Manifest.Graphics  | % { "{0}\Graphics\$_"  -f $This.Hive.Path }
    }
}
