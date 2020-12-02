Class Install
{
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.11.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date = (Get-Date -UFormat %Y_%m%d-%H%M%S)
    [String]             $Status = "Initialized"
    [String]               $Type
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.11.0"

    [String]           $Registry = "HKLM:\SOFTWARE\Policies"
    [String]               $Path = $Env:ProgramData
    [Object]               $File 
    [Object]           $Manifest 
    [Object]               $Base 

    [Object[]]          $Classes
    [Object[]]          $Control
    [Object[]]        $Functions
    [Object[]]         $Graphics

    [Hashtable]          $Module = @{

        Names                    = ("Name Version Provider Date Path Status Type" -Split " ")
        Folders                  = "/Classes/Control/Functions/Graphics" -Split "/"
        Classes                  = ("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme " + 
                                    "Object Flag Banner UISwitch Toast XamlWindow XamlObject VendorList V4Network V6Network NetInterface " + 
                                    "Network Info Service Services ViperBomb Brand Branding Certificate Company Key RootVar Share Master " + 
                                    "Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo Xaml XamlGlossar" + 
                                    "yItem Image Images Updates ArpHost ArpScan ArpStat NbtHost NbtScan NbtStat FEPromo FEPromoDomain FEP" + 
                                    "romoRoles" ).Split(" ") | % { "_$_" }
        Control                  = ("Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                                    "ServerMod.xml") -Split " "
        Functions                = @("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write" + 
                                    "-Banner Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotifica" + 
                                    "tion New-FECompany Get-ServerDependency Get-FEServices Get-FEHost").Split(" ") | % { "$_" }
        Graphics                 = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp") -Split " "
    }

    Hidden [Object]        $Load
    Hidden [Object]      $Output

    [String] Root([String]$Root)
    {
        Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }

    BuildModule()
    {
        $This.Load               = @( )
        $This.Load              += "# FightingEntropy.psm1 [Module]"

        ( "{0}.AccessControl,{0}.Principal,Management.Automation,DirectoryServices" -f "Security" ).Split(',') | % { 
        
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
        @{ 
            GUID                 = "6b0418f5-adc3-4020-a0f9-7010439a93ce"
            Path                 = $This.Manifest
            ModuleVersion        = $This.Version
            Copyright            = "(c) 2020 mcc85sx. All rights reserved."
            CompanyName          = "Secure Digits Plus LLC" 
            Author               = "mcc85sx / Michael C. Cook Sr."
            Description          = "Beginning the fight against Identity Theft, and Cybercriminal Activities"
            RootModule           = $This.File

        }                        | % { New-ModuleManifest @_ }

        "$Env:ProgramFiles\WindowsPowershell\Modules\{0}\{1}" -f $This.Name, $This.Version | % { 

            If ( ! ( Test-Path $_ ) )
            {
                New-Item -Path $_ -ItemType Directory -Verbose
            }
            
            Copy-Item -Path $This.Manifest $_ -Verbose -Force
        }
    }

    BuildRegistry()
    {
        ForEach ( $I in 3..5 ) 
        {      
            $This.Registry.Split('\')[0..$I] -join '\' | ? { ! ( Test-Path $_ ) } | % { New-Item $_ -Verbose }
        }

        $Item                    = Get-ItemProperty -Path $This.Registry
        $Names                   = ($This.Module.Names)
        $Values                  = ($This.Name, $This.Version, $This.Provider, $This.Date, $This.Path, $This.Status, $This.Type)

        ForEach ( $I in 0..6 )
        {
            If ( $Item.$( $Names[$I] ) -eq $Null )
            {
                Set-ItemProperty -Path $This.Registry -Name $Names[$I] -Value $Values[$I] -Verbose
            }
        }
    }

    BuildPath()
    {
        If ( ! ( Test-Path $This.Path ) )
        {
            New-Item -Path $This.Path -ItemType Directory -Verbose
        }
    }

    Install()
    {
        If ( Get-Item Variable:\PSVersionTable | % Value | % PSVersion | ? Major -ge 6 )
        {
            If ( Get-Item Variable:\IsLinux | % Value )
            {
                Throw "Linux install not yet supported"
            }
        }
        
        $This.Type               = @("Client","Server")[( Get-Ciminstance -Class Win32_OperatingSystem | % Caption ) -match "Server" ]
        $This.Registry           = $This.Root("HKLM:\SOFTWARE\Policies")
        $This.BuildRegistry()
        
        $This.Path               = $This.Root($env:ProgramData)
        $This.BuildPath()

        [Net.ServicePointManager]::SecurityProtocol = 3072

        $This.File               = "{0}\FightingEntropy.psm1" -f $This.Path
        $This.Manifest           = "{0}\FightingEntropy.psd1" -f $This.Path

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

        Import-Module FightingEntropy -Verbose -Force
        
        Write-Theme 'Module [+] Installed'

        @{

            Type        = 4
            Image       = 'https://raw.githubusercontent.com/secure-digits-plus-llc/FightingEntropy/master/Graphics/logo.jpg'
            GUID        = '6b0418f5-adc3-4020-a0f9-7010439a93ce'
            Header      = 'Secure Digits Plus LLC'
            Body        = 'FightingEntropy'
            Footer      = '2020.11.0'
        
        }               | % { Show-ToastNotification @_ }
    }
}

[Install]::New()
