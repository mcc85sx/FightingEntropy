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
    [String]           $Resource

    [Object[]]          $Classes
    [Object[]]        $Functions
    [Object[]]          $Control
    [Object[]]         $Graphics

    Hidden [String[]]      $Load
    Hidden [String]      $Output

    BuildTree()
    {
        ForEach ( $Path in $This.Manifest.Folders )
        {
            $Item = $This.Hive.Path,$Path -join "\"
            If ( ! ( Test-Path $Item ) )
            {
                New-Item $Item -ItemType Directory -Force -Verbose
            }
            
            Switch ($Path)
            {
                Classes 
                {
                    ForEach ( $X in $This.Manifest.Classes )
                    {
                        $This.Classes   += ( Invoke-RestMethod -URI "$($This.Resource)/Classes/$X.ps1" -Verbose )
                    }
                }

                Functions
                {
                    ForEach ( $X in $This.Manifest.Functions )
                    {
                        $This.Functions += ( Invoke-RestMethod -URI "$($This.Resource)/Functions/$X.ps1" -Verbose )
                    }
                }

                Control
                {
                    ForEach ( $X in $This.Manifest.Control )
                    {
                        $This.Control   += ( Invoke-RestMethod -URI "$($This.Resource)/Control/$X" -Verbose )
                    }
                }

                Graphics
                {
                    ForEach ( $X in $This.Manifest.Graphics )
                    {
                        $This.Graphics  += ( Invoke-RestMethod -URI "$($This.Resource)/Graphics/$X" -Verbose )
                    }
                }

                Default {}
            }
        }
    }
    
    BuildModule()
    {
        $This.Load               = @( )
        $This.Load              += "# FightingEntropy.psm1 [Module]"

            "{0}.AccessControl {0}.Principal Management.Automation DirectoryServices" -f "Security" -Split " " | % { 

            $This.Load          += "using namespace System.$_" 
        }

        $This.Load              += "using namespace Windows.UI.Notifications"
        $This.Load              += "Add-Type -AssemblyName PresentationFramework"

        $This.Manifest.Classes   | % { 

            $This.Load          += ""
            $This.Load          += "# Class/$_"
            $This.Load          += @( Get-Content "$($This.Hive.Path)\Classes\$_.ps1" )
        }

        $This.Manifest.Functions | % {

            $This.Load          += ""
            $This.Load          += "# Function/$_"
            $This.Load          += @( Get-Content "$($This.Hive.Path)\Functions\$_.ps1" )
        }

        $This.Output             = $This.Load -join "`n"

        Set-Content -Path $This.Hive.Module -Value $This.Output -Force -Verbose
    }

    BuildManifest()
    {
        @{  GUID                 = "67b283d9-72c6-413a-aa80-a24af5d4ea8f"
            Path                 = $This.Hive.Manifest
            ModuleVersion        = $This.Hive.Version
            Copyright            = "(c) 2020 mcc85sx. All rights reserved."
            CompanyName          = "Secure Digits Plus LLC" 
            Author               = "mcc85sx / Michael C. Cook Sr."
            Description          = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule           = $This.Hive.Module
            
        }                        | % { New-ModuleManifest @_ }
        
        If ( $This.Type -match "Win32" )
        {
            $Destination = $This.Hive.PSModule | ? { $_ -match "Program Files" }
            Copy-Item -Path $This.Hive.Manifest -Destination $Destination -Verbose
        }
        
        If ( $This.Type -match "RHELCentOS" )
        {
            $Destination = $This.Hive.PSModule | ? { $_ -match "microsoft" }
            Copy-Item -Path $This.Hive.Manifest -Destination $Destination -Verbose
        }
    }

    Prime()
    {
        $This.Resource           = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/{0}" -f $This.Version
        $This.Classes            = @( )
        $This.Functions          = @( )
        $This.Control            = @( )
        $This.Graphics           = @( )
        $This.Load               = @( )
    }

    _Install([String]$Version)
    {
        $This.OS                 = [_OS]::New()
        $This.Manifest           = [_Manifest]::New()
        $This.Hive               = [_Hive]::New($This.OS.Type,$Version)
        $This.Type               = $This.OS.Type
        $This.Prime()
        $This.BuildTree()
        $This.BuildModule()
        $This.BuildManifest()
    }
}
