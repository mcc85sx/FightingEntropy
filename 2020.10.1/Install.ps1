Class Install
{
    Hidden [Object]  $Master
    [String]           $Path = "$Env:ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.1" 
    [String]            $URL

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

    [Object[]]   $Classes
    [Object[]]   $Control
    [Object[]] $Functions
    [Object[]]  $Graphics
    [String[]]      $Load
    
    Install([String]$URL)
    {
        [Net.ServicePointManager]::SecurityProtocol = 3072

        $This.URL         = $URL

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
                        $File            = "$($This.Path)\Classes\$X.ps1"
                        $Link            = "$($This.URL )/Classes/$X.ps1"

                        Invoke-RestMethod -URI $Link -Outfile $File -Verbose

                        $This.Classes   += $File
                    }
                }

                Functions
                {
                    ForEach ( $X in $This.Hash.Functions )
                    {
                        $File            = "$($This.Path)\Functions\$X.ps1"
                        $Link            = "$($This.URL )/Functions/$X.ps1"

                        Invoke-RestMethod -URI $Link -Outfile $File -Verbose

                        $This.Functions += $File
                    }
                }

                Control
                {
                    ForEach ( $X in $This.Hash.Control )
                    {
                        $File            = "$($This.Path)\Control\$X"
                        $Link            = "$($This.URL )/Control/$X"

                        Invoke-RestMethod -URI $Link -OutFile $File -Verbose

                        $This.Control   += $File
                    }
                }

                Graphics
                {
                    ForEach ( $X in $This.Hash.Graphics )
                    {
                        $File            = "$($This.Path)\Graphics\$X"
                        $Link            = "$($This.URL )/Graphics/$X"

                        Invoke-RestMethod -URI $Link -OutFile $File -Verbose

                        $This.Graphics  += $File
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

        $This.Master                     =  ( $This.Load -join "`n" )

        Set-Content -Path "$($This.Path)\FightingEntropy.psm1" -Value $This.Master
        
        Import-Module "$($This.Path)\FightingEntropy.psm1" -Verbose
        
        Get-FEModule | Out-Null
        
        Write-Flag
    }
}

Add-Type -AssemblyName PresentationFramework
$Return = [Install]::new("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1")
