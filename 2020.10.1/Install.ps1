Class Install
{
    Hidden [Object]  $Master
    [String]           $Name = "FightingEntropy"
    [String]        $Version = "2020.10.1"
    [String]       $Provider = "Secure Digits Plus LLC"
    [String]         $Author = "Michael C. Cook Sr."
    [String]           $Path
    [String]            $URL
    [Object]           $File
    [Object]       $Manifest
    [Object[]]      $Classes
    [Object[]]      $Control
    [Object[]]    $Functions
    [Object[]]     $Graphics
    [String[]]         $Load

    Hidden [Hashtable] $Hash = @{ 

        Folders   = ("/Classes/Control/Functions/Graphics" -Split "/")

        Classes   = ("_QMark _File _FirewallRule _Drive _Cache _Icons _Shortcut _Drives _Host _Block _Faces " +
                     "_Track _Theme _Object _Flag _Banner _UISwitch _Toast _XamlWindow _XamlObject _Root _Mo" + 
                     "dule _VendorList _V4Network _V6Network _NetInterface _Network _Info _Service _Services" + 
                     " _ViperBomb _Brand _Branding _Certificate _Company _Key _RootVar _Share _Master _Sourc" + 
                     "e _Target _ServerDependency _ServerFeature _ServerFeatures _IISFeatures _IIS _DCPromo " + 
                     "_Xaml _XamlGlossaryItem" ) -Split " "
                     
        Control   = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f 
                     "ClientMod.xml","ServerMod.xml") -Split " "
                     
        Functions = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                     "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                     "tion") -Split " "
                     
        Graphics  = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
    }
    
    Install([String]$URL)
    {
        [Net.ServicePointManager]::SecurityProtocol = 3072

        $This.URL         = $URL
        $This.Path        = $env:ProgramData, $This.Provider, $This.Name, $This.Version -join '\'
        $This.File        = $This.Path, "FightingEntropy.psm1" -join '\'
        $This.Manifest    = $This.Path, "FightingEntropy.psd1" -join '\'

        ForEach ( $I in $This.Hash.Folders )
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
                    Set-Content -Path "$($This.Path)\Classes\__index.txt" -Value $This.Hash.Classes -Force
                    ForEach ( $X in $This.Hash.Classes )
                    {
                        $iFile           = "$($This.Path)\Classes\$X.ps1"
                        $Link            = "$($This.URL )/Classes/$X.ps1"

                        Invoke-RestMethod -URI $Link -Outfile $iFile -Verbose

                        $This.Classes   += $iFile
                    }
                }

                Functions
                {
                    Set-Content -Path "$($This.Path)\Functions\__index.txt" -Value $This.Hash.Functions -Force
                    ForEach ( $X in $This.Hash.Functions )
                    {
                        $iFile           = "$($This.Path)\Functions\$X.ps1"
                        $Link            = "$($This.URL )/Functions/$X.ps1"

                        Invoke-RestMethod -URI $Link -Outfile $iFile -Verbose

                        $This.Functions += $iFile
                    }
                }

                Control
                {
                    Set-Content -Path "$($This.Path)\Control\__index.txt" -Value $This.Hash.Control -Force
                    ForEach ( $X in $This.Hash.Control )
                    {
                        $iFile           = "$($This.Path)\Control\$X"
                        $Link            = "$($This.URL )/Control/$X"

                        Invoke-RestMethod -URI $Link -OutFile $iFile -Verbose

                        $This.Control   += $iFile
                    }
                }

                Graphics
                {
                    Set-Content -Path "$($This.Path)\Graphics\__index.txt" -Value $This.Hash.Functions -Force

                    ForEach ( $X in $This.Hash.Graphics )
                    {
                        $iFile           = "$($This.Path)\Graphics\$X"
                        $Link            = "$($This.URL )/Graphics/$X"

                        Invoke-RestMethod -URI $Link -OutFile $iFile -Verbose

                        $This.Graphics  += $iFile
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

        $Module                          = Get-FEModule
        
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

Add-Type -AssemblyName PresentationFramework
$Return = [Install]::new("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1")

@{  
    Type        = 4
    Image       = "https://raw.githubusercontent.com/secure-digits-plus-llc/FightingEntropy/master/Graphics/logo.jpg"
    GUID        = New-GUID
    Header      = "Secure Digits Plus LLC"
    Body        = "FightingEntropy"
    Footer      = "2020.10.1"
    
}               | % { Show-ToastNotification @_ }
