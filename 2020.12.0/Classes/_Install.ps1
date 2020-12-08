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
    [Object]               $Type
    
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
                        $This.Classes   += ([_RestObject]::New("$($This.Resource)/Classes/$X","$($This.Hive.Path)/Classes/$X"))
                    }
                }

                Functions
                {
                    ForEach ( $X in $This.Manifest.Functions )
                    {
                        $This.Functions += ([_RestObject]::New("$($This.Resource)/Functions/$X","$($This.Hive.Path)/Functions/$X"))
                    }
                }

                Control
                {
                    ForEach ( $X in $This.Manifest.Control )
                    {
                        $This.Control   += ([_RestObject]::New("$($This.Resource)/Control/$X","$($This.Hive.Path)/Control/$X"))
                    }
                }

                Graphics
                {
                    ForEach ( $X in $This.Manifest.Graphics )
                    {
                        $This.Graphics  += ([_RestObject]::New("$($This.Resource)/Graphics/$X","$($This.Hive.Path)/Graphics/$X"))
                    }
                }

                Default {}
            }
        }
    }
    
    BuildModule()
    {
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
        
        $This.WriteModule()
    }
    
    WriteModule()
    {
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
        
        Switch -Regex ($This.Type)
        {
            "Win32"      { $This.Scaffold("Program Files") } "RHELCentOS" { $This.Scaffold("microsoft") }
        }
    }
    
    Scaffold([String]$String)
    {
        ForEach ( $ModulePath in $This.Hive.PSModule )
        {
            If ( $ModulePath -match $String )
            {
                Copy-Item $This.Hive.Manifest -Destination $ModulePath -Verbose
            }
        }
    }

    _Install([String]$Version)
    {
        $This.OS                 = [_OS]::New()
        $This.Type               = $This.OS.Type
        $This.Manifest           = [_Manifest]::New()
        $This.Hive               = [_Hive]::New($This.Type,$Version)

        $This.Resource           = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/{0}" -f $This.Version
        $This.Classes            = @( )
        $This.Functions          = @( )
        $This.Control            = @( )
        $This.Graphics           = @( )
        $This.Load               = @( )
        
        $This.BuildTree()
        $This.BuildModule()
        $This.BuildManifest()
    }
}
