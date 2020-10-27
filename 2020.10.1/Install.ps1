Class Install
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.10.1"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date
    [String]             $Status
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1"

    [String]           $Registry
    [String]               $Path
    [Object]               $File 
    [Object]           $Manifest
    [Hashtable]            $Base

    [Object]            $Classes
    [Object]            $Control
    [Object]          $Functions
    [Object]           $Graphics
    [Object]              $Tools
    [Object]             $Shares

    [Hashtable]          $Module = @{

        Path                     = "{0}"
        File                     = "{0}\FightingEntropy.psm1"
        Manifest                 = "{0}\FightingEntropy.psd1"
        Folders                  = "/Classes/Control/Functions/Graphics" -Split "/"
        Classes                  = ("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme " + 
                                    "Object Flag Banner UISwitch Toast XamlWindow XamlObject VendorList V4Network V6Network NetInterface " + 
                                    "Network Info Service Services ViperBomb Brand Branding Certificate Company Key RootVar Share Master " + 
                                    "Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo Xaml " + 
                                    "XamlGlossaryItem" ).Split(" ") | % { "_$_" }
        Control                  = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                                    "ServerMod.xml") -Split " "
        Functions                = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                                    "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                                    "tion New-FECompany Get-ServerDependency").Split(" ") | % { "$_" }
        Graphics                 = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
        String                   = "{0}\FightingEntropy.mtn"
    }

    [Object]               $Load
    [Object]             $Output

    [String] Root([String]$Root)
    {
        Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }

    BuildModule()
    {        
        $This.Load               = @( )
        $This.Load              += "# FightingEntropy.psm1 [Module]"
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
        @{ 
            GUID                 = "e21f2e0e-36f4-4a22-9094-9206dcef9365"
            Path                 = $This.Manifest
            ModuleVersion        = $This.Version
            Copyright            = "(c) 2020 mcc85sx. All rights reserved."
            CompanyName          = "Secure Digits Plus LLC" 
            Author               = "mcc85sx / Michael C. Cook Sr."
            Description          = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule           = $This.File

        }                        | % { New-ModuleManifest @_ }
        
        Get-Item $This.Manifest
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
            $Item                = $This.Path, $I -join '\'

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

        $This.BuildModule()
        $This.BuildManifest()

        Import-Module $This.Manifest -Verbose -Force

        Write-Theme "Module [+] Loaded"

        @{  
            Type        = 4
            Image       = "https://raw.githubusercontent.com/secure-digits-plus-llc/FightingEntropy/master/Graphics/logo.jpg"
            GUID        = New-GUID
            Header      = "Secure Digits Plus LLC"
            Body        = "FightingEntropy"
            Footer      = "2020.10.1"
    
        }               | % { Show-ToastNotification @_ }
    }
}

# Add-Type -AssemblyName PresentationFramework
# $Return = [Install]::new() #"https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1")

#@{  
#    Type        = 4
#    Image       = "https://raw.githubusercontent.com/secure-digits-plus-llc/FightingEntropy/master/Graphics/logo.jpg"
#    GUID        = New-GUID
#    Header      = "Secure Digits Plus LLC"
#    Body        = "FightingEntropy"
#    Footer      = "2020.10.1"
#    
#}               | % { Show-ToastNotification @_ }
