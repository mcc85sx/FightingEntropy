
    #[String]      $Path = "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.0"
    #[String[]]    $Load
    #[String[]] $Classes = ("_QMark _File _FirewallRule _Drive _Cache _Icons _Shortcut _Drives _Host _Block _Track _Theme _Object _UISwitch" +
    # " _Toast _XamlWindow _Root _Module _VendorList _V4Network _V6Network _NetInterface _Network _Info _Service _Ser" + 
    # "vices _ViperBomb _Brand _Branding _Certificate _Company _Key _RootVar _Share _Master _Source _Target") -Split " " | % { 

    #    $Load += ( Get-Content -Path "$Classes\$_.ps1")
    #}

    #$Functions = Get-ChildItem $Path | ? Name -eq Functions | % FullName

    #("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme") -Split " " | % {

    #    $Load += ( Get-Content -Path "$Functions\$_.ps1" -Verbose )
    #}

    #Invoke-Expression ( $Load -join "`n" )

Class Install
{
    [String]        $Path = "$Env:ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.1"
    [String]         $URL
    [String[]]   $Folders = ("/Classes/Control/Functions/Graphics" -Split "/")

    [String[]]   $Classes = ("_QMark _File _FirewallRule _Drive _Cache _Icons _Shortcut _Drives _Host _Block _Track " + 
                             "_Theme _Object _UISwitch _Toast _XamlWindow _Root _Module _VendorList _V4Network _V6Ne" + 
                             "twork _NetInterface _Network _Info _Service _Services _ViperBomb _Brand _Branding _Cer" + 
                             "tificate _Company _Key _RootVar _Share _Master _Source _Target") -Split " "
    [String[]]   $Control = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f 
                             "ClientMod.xml","ServerMod.xml") -Split " "
    [String[]] $Functions = ("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme") -Split " "
    [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "

    [String[]]     $Files
    [String[]]      $Load
    
    Install([String]$URL)
    {
        [Net.ServicePointManager]::SecurityProtocol = 3072

        $This.Load        = @( )

        ForEach ( $I in $This.Folders )
        {
            $Item = $This.Path,$I -join '\'

            If ( ! ( Test-Path $Item ) )
            {
                New-Item $Item -ItemType Directory -Verbose
            }

            Switch ($I)
            {
                Classes 
                {   
                    ForEach ( $X in $This.Classes )
                    {
                        $This.Load  += "$URL/Classes/$X.ps1"
                        $This.Files += "$($This.Path)\Classes\$X.ps1"
                    }
                }

                Functions
                {
                    ForEach ( $X in $This.Functions )
                    {
                        $This.Load  += "$($This.URL )/Functions/$X.ps1"
                        $This.Files += "$($This.Path)\Functions\$X.ps1"
                    }
                }

                Control
                {
                    ForEach ( $X in $This.Control )
                    {
                        $This.Load  += "$($This.URL )/Control/$X"
                        $This.Files += "$($This.Path)\Control\$X"
                    }
                }

                Graphics
                {
                    ForEach ( $X in $This.Graphics )
                    {
                        $This.Load  += "$($This.URL )/Graphics/$X"
                        $This.Files += "$($This.Path)\Graphics\$X"
                    }
                }
            }
        }

        ForEach ( $I in 0..( $This.Load.Count - 1 ) )
        {
            Set-Content -Path $This.Files[$I] -Value ( Invoke-RestMethod $This.Load[$I] ) -Verbose
        }
    }
}
