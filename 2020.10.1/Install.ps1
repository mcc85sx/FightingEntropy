Class Install
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.10.1"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1"

    [String]           $Registry
    [String]               $Path
    [Object]               $File 
    [Object]           $Manifest
    [Object]         $Properties
    [Object]               $Base
    [Object]            $Classes
    [Object]            $Control
    [Object]          $Functions
    [Object]           $Graphics
    [String]             $Status
    [Object]              $Tools
    [Object]             $Shares

    [Hashtable]          $Module = @{

        Path                     = "{0}"
        File                     = "{0}\FightingEntropy.psm1"
        Manifest                 = "{0}\FightingEntropy.psd1"
        Folders                  = ("/Classes/Control/Functions/Graphics" -Replace "\s+" , " " -Split "/")
        Classes                  = ("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track " + 
                                    "Theme Object Flag Banner UISwitch Toast XamlWindow XamlObject Root Module VendorList V4Networ" + 
                                    "k V6Network NetInterface Network Info Service Services ViperBomb Brand Branding Certificate C" + 
                                    "ompany Key RootVar Share Master Source Target ServerDependency ServerFeature ServerFeatures I" + 
                                    "ISFeatures IIS DCPromo Xaml XamlGlossaryItem" ) -Split " " | % { "_$_" }
        Control                  = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f 
                                    "ClientMod.xml","ServerMod.xml") -Split " "
        Functions                = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                                    "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                                    "tion New-FECompany Get-ServerDependency") -Split " "
        Graphics                 = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
    }

    [String] Root([String]$Root)
    {
        Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }

    Install()
    {
        $This.Registry           = $This.Root("HKLM:\SOFTWARE\Policies")
        $This.Path               = $This.Root($Env:ProgramData)

        [Net.ServicePointManager]::SecurityProtocol = 3072

        $This.File               = $This.Module.File     -f $This.Path
        $This.Manifest           = $This.Module.Manifest -f $This.Path

        ForEach ( $I in $This.Module.Folders )
        {
            $Item = $This.Path, $I -join '\'

            If ( ! ( Test-Path $Item ) )
            {
                New-Item $Item -ItemType Directory -Verbose
            }

            Switch ($I)
            {
                Classes 
                {   
                    ForEach ( $X in $This.Module.Classes )
                    {
                        $URI             = "$($This.Resource)/Classes/$X.ps1"
                        $Outfile         = "$($This.Path)\Classes\$X.ps1"

                        Invoke-RestMethod -URI $URI -Outfile $OutFile -Verbose

                        $This.Classes   += $OutFile
                    }
                }

                Functions
                {
                    ForEach ( $X in $This.Module.Functions )
                    {
                        $URI             = "$($This.Resource)/Functions/$X.ps1"
                        $Outfile         = "$($This.Path)\Functions\$X.ps1"

                        Invoke-RestMethod -URI $URI -Outfile $OutFile -Verbose

                        $This.Functions += $OutFile
                    }
                }

                Control
                {
                    ForEach ( $X in $This.Module.Control )
                    {
                        $URI             = "$($This.Resource)/Control/$X"
                        $OutFile         = "$($This.Path)\Control\$X"

                        Invoke-RestMethod -URI $URI -OutFile $OutFile -Verbose

                        $This.Control   += $OutFile
                    }
                }

                Graphics
                {
                    ForEach ( $X in $This.Module.Graphics )
                    {
                        $URI             = "$($This.Resource)/Graphics/$X"
                        $OutFile         = "$($This.Path)\Graphics\$X"

                        Invoke-RestMethod -URI $URI -OutFile $OutFile -Verbose

                        $This.Graphics  += $OutFile
                    }
                }
            }
        }

        $This.Load                       = @( )
        $This.Load                      += "# FightingEntropy Module Manifest"
        $This.Load                      += "Add-Type -AssemblyName PresentationFramework"
        $This.Load                      += ""

        ForEach ( $I in 0..( $This.Classes.Count - 1 ) )
        {
            $This.Load                  += ( Get-Content $This.Classes[$I] )
            $This.Load                  += ""
        }

        ForEach ( $I in 0..( $This.Functions.Count - 1 ) )
        {
            $This.Load                  += ( Get-Content $This.Functions[$I] )
            $This.Load                  += ""
        }

        $This.Master                     = $This.Load -join "`n"

        Set-Content -Path $This.File -Value $This.Master

        Import-Module $This.File -Verbose

        # $Module                          = Get-FEModule
        
        @{ 
            GUID                          = "e21f2e0e-36f4-4a22-9094-9206dcef9365"
            Path                          = $This.Manifest
            ModuleVersion                 = $This.Version
            Copyright                     = "(c) 2020 mcc85sx. All rights reserved."
            CompanyName                   = "Secure Digits Plus LLC" 
            Author                        = "mcc85sx / Michael C. Cook Sr."
            Description                   = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule                    = $This.File

        }                                 | % { New-ModuleManifest @_ }

        Write-Theme "Module [+] Loaded"
    }
}
