Class OS
{
    [Object[]] $Environment
    [Object[]] $Variable
    [Object]   $PSVersionTable
    [Object]   $PSVersion
    [Object]   $Major
    [Object]   $Type

    [Object] GetItem([String]$Item)
    {
        $Return = @{ }

        ForEach ( $X in ( Get-Item -Path $Item | % GetEnumerator ) )
        { 
            $Return.Add($X.Name,$X.Value)
        }

        Return $Return
    }

    [String] GetWinType()
    {
        Return @( Switch -Regex ( Invoke-Expression "[wmiclass]'\\.\ROOT\CIMV2:Win32_OperatingSystem' | % GetInstances | % Caption" )
        {
            "Windows 10" { "Win32_Client" } "Windows Server" { "Win32_Server" }
        })
    }

    [String] GetOSType()
    {
        Return @( If ( $This.Major -gt 5 )
        {
            If ( Get-Item Variable:\IsLinux | % Value )
            {
                "RHELCentOS"
            }

            Else
            {
                $This.GetWinType()
            }
        }

        Else
        {
            $This.GetWinType()
        })
    }

    OS()
    {
        $This.Environment    = $This.GetItem("Env:\")
        $This.Variable       = $This.GetItem("Variable:\")
        $This.PSVersionTable = $This.Variable.PSVersionTable
        $This.PSVersion      = $This.PSVersionTable.PSVersion
        $This.Major          = $This.PSVersion.Major
        $This.Type           = $This.GetOSType()
    }
}

Class Manifest
{
    [String[]]     $Names = ( "Name Version Provider Date Path Status Type" -Split " " )
    [String]        $GUID = ( "67b283d9-72c6-413a-aa80-a24af5d4ea8f" )
    [String[]]      $Role = ( "{0}Client {0}Server UnixBSD RHEL/CentOS" -f "Win32_" -Split " " )
    [String[]]   $Folders = ( " Classes Control Functions Graphics Role" -Split " " )
    [String[]]   $Classes = (("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme " + 
                              "Object Flag Manifest Banner UISwitch XamlWindow XamlObject VendorList V4Network V6Network NetInterface " + 
                              "Network Info Service Services ViperBomb Brand Branding Certificate Company Key RootVar Share Master " + 
                              "Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo Xaml XamlGlossar" + 
                              "yItem Image Images Updates ArpHost ArpScan ArpStat NbtHost NbtScan NbtStat FEPromo FEPromoDomain FEP" + 
                              "romoRoles Role Win32_Client Win32_Server UnixBSD RHELCentOS" ).Split(" ") | % { "_$_" })
    [String[]]   $Control = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                              "ServerMod.xml" ) -Split " "
    [String[]] $Functions = (("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write-Banner Instal" +
                              "l-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotification New-FECompany Get-Serve" + 
                              "rDependency Get-FEServices Get-FEHost").Split(" ") | % { "$_" })
    [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

    Manifest(){}
}

Class Install
{
    [Object]                 $OS = [OS]::New()
    [Object]             $Module = [Manifest]::New()

    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.12.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date = (Get-Date -UFormat %Y_%m%d-%H%M%S)
    [String]             $Status = "Initialized"
    [String]               $Type
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.12.0"

        [String]           $Registry
        [String]               $Path
        [Object]               $File 
        [Object]           $Manifest 
        [Object]               $Base 

        [Object[]]          $Classes
        [Object[]]          $Control
        [Object[]]        $Functions
        [Object[]]         $Graphics

        Hidden [Object]        $Load
        Hidden [Object]      $Output

        [String] Root([String]$Root)
        {
            Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
        }

        [Object] GetItem([String]$Object)
        {
            $Return = @{ }

            Foreach ( $Item in ( Get-Item -Path $Object | % GetEnumerator ) ) 
            { 
                $Return.Add($Item.Name,$Item.Value) 
            }

            Return $Return
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
                GUID                 = "67b283d9-72c6-413a-aa80-a24af5d4ea8f"
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

        BuildRegistry([String]$Type)
        {
            If ( $Type -match "Win32" )
            {
                ForEach ( $I in 3..5 ) 
                {      
                    $This.Registry.Split('\')[0..$I] -join '\' | ? { ! ( Test-Path $_ ) } | % { New-Item $_ -Verbose }
                }
            }
            
            If ( $Type -match "RHELCentOS" )
            {
                sudo mkdir /etc/SDP/FEUnix

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
            $This.Type               = $This.OS.Type

            If ( $This.Type -match "Win32" )
            {
                $This.Registry       = $This.Root("HKLM:\Software\Policies")
                $This.Path           = $This.Root($Env:ProgramData)
                
            }
            
            If ( $This.Type -match "RHELCentOS" )
            {
                $This.Registry       = $This.Root("/etc/FEUnix")
                $This.Path           = $This.Root("/etc/FEUnix")
                
            }

            $This.BuildRegistry()
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

                            Invoke-RestMethod -URI $URI -Outfile $OutFile -ContentType "text/plain" -Verbose

                            $This.Classes   += $OutFile
                        }
                    }

                    Functions
                    {
                        ForEach ( $X in $This.Module.Functions )
                        {
                            $URI             = "$($This.Resource)/Functions/$X.ps1"
                            $Outfile         = "$($This.Path)\Functions\$X.ps1"

                            Invoke-RestMethod -URI $URI -Outfile $OutFile -ContentType "text/plain" -Verbose

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

            Import-Module FightingEntropy -Verbose -Force
            
            Write-Theme @("--- Module Installed ---";@{ Info = "To load the module, use Get-FEModule" };" ","Installation variable saved to `$Module")
            Start-Sleep -Seconds 5
            
            $PowerShell = @("PowerShell 7 + Windows Terminal, a match made by the gods themselves";"-"*80;("Once upon a time, there was a bunch of peop" +
              "le sitting around.");" ";("One that, they decided to *really* up the ante on their (widely/historically) known");("ability to engineer t" + 
              "he best software on planet Earth.");("After a number of years continually attempting to one-up themselves...?");("They took notice of an" + 
              "ameteur who stood no chance whatsoever, against the cosmos, alone.");" ";("Impressed, with his imbuement of mystical power of (writing/n" + 
              "arration) capabilities...");("...when combined with the total raw horsepower behind PowerShell 7...?");" ";("Maybe you oughtta stop and " + 
              "ask yourself...");"...if you somehow got invited to an action packed cinematic event.";" ";("The only problem with PowerShell 7 + Window" + 
              "s Terminal...");"...is that you won't want to stop using it.";"It's like pringles, but better.";("No contenders on the table, that have " + 
              "as much potential.";" ";"Could you imagine if perhaps... some guys that have been doing this a long time...";("didn't think that it coul" + 
              "d come down to this?");" ";"Some senior engineers sat around and watched in shock and awe at the ameteur...";("...as if he were slaying " +
              "demons in a video game. On Mars. Or, wherever.");"Sometimes in life, that's what ya gotta do. Watch the new kid kick some ass.";("We hav" + 
              "e no idea if he ever needed any bubble gum... just went around kicking asses, unabated...";" ";" -Microsoft")
            
            (Host).UI.PromptForChoice("Funny Stuff?","Do you have a sense of humor?",[String[]]@("&Yes","&Maybe","&No","&Piss off..."),0)
            {
                0 { Write-Theme $PowerShell; Start-Sleep -Seconds 60} 1 { Write-Theme PowerShell; Start-Sleep -Seconds 60 }
                Default {}
            }
        }
    }
        
    $Module = [Install]::New()
