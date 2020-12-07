Class _Install
{
    [Object]                 $OS
    [Object]           $Manifest
    [Object]               $Hive

    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.12.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date = (Get-Date -UFormat %Y_%m%d-%H%M%S)
    [String]             $Status = "Initialized"
    [String]               $Type

    [String[]]             $Load
    [String]             $Output

    BuildModule()
    {
        $This.Load               = @( )
        $This.Load              += "# FightingEntropy.psm1 [Module]"

            "{0}.AccessControl {0}.Principal Management.Automation DirectoryServices" -f "Security" -Split " " | % { 

            $This.Load          += "using namespace System.$_" 
        }

        $This.Load              += "using namespace Windows.UI.Notifications"
        $This.Load              += "Add-Type -AssemblyName PresentationFramework"

        $This.Module.Classes     | % { 

            $This.Load          += ""
            $This.Load          += "# Class/$_"
            $This.Load          += @( Get-Content "$($This.Path)\Classes\$_.ps1" )
        }

        $This.Module.Functions   | % {

            $This.Load          += ""
            $This.Load          += "# Function/$_"
            $This.Load          += @( Get-Content "$($This.Path)\Functions\$_.ps1" )
        }

        $This.Output             = $This.Load -join "`n"

        Set-Content -Path $This.File -Value $This.Output
    }

    BuildManifest()
    {
        @{  GUID                 = "67b283d9-72c6-413a-aa80-a24af5d4ea8f"
            Path                 = $This.Manifest
            ModuleVersion        = $This.Version
            Copyright            = "(c) 2020 mcc85sx. All rights reserved."
            CompanyName          = "Secure Digits Plus LLC" 
            Author               = "mcc85sx / Michael C. Cook Sr."
            Description          = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule           = $This.File
            
        }                        | % { New-ModuleManifest @_ }
    }

    _Install([String]$Version)
    {
        $This.OS                 = [_OS]::New()
        $This.Manifest           = [_Manifest]::New()
        $This.Hive               = [_Hive]::New($This.OS.Type,$This.Version)
    }
}
