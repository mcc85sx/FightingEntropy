Function Install-FEModule
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Version)

    Class _OS
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

        _OS()
        {
            $This.Environment    = Get-ChildItem Env:\
            $This.Variable       = Get-ChildItem Variable:\
            $This.PSVersionTable = Get-Item Variable:\PSVersionTable | % Value
            $This.PSVersion      = Get-Item Variable:\PSVersionTable | % Value | % PSVersion
            $This.Major          = $This.PSVersion.Major
            $This.Type           = $This.GetOSType()
        }
    }

    Class _Manifest
    {
        [String[]]     $Names = ( "Name Version Provider Date Path Status Type" -Split " " )
        [String]     $Version
        [String]        $GUID = ( "d2402c18-0529-4e55-919f-ac477c49d4fe" )
        [String[]]      $Role = ( "Win32_Client Win32_Server UnixBSD RHELCentOS" -Split " " )
        [String[]]   $Folders = ( " Classes Control Functions Graphics Role" -Split " " )

        # //          Classes
        # \\          -------
        # //    Module (Core)      Manifest Hive Root Module OS Info RestObject
        # \\    Network(Main)      Host FirewallRule
        # //           System      Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding
        # \\         Active D.     DNSSuffix DomainName ADLogin ADConnection FEDCPromo
        # //           Server      Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS
        # \\          Imaging      Image Images Updates
        # //             Role      Role Win32_Client Win32_Server UnixBSD RHELCentOS

        [String[]]   $Classes = (("Manifest Hive Root Install Module OS Info RestObject",
                                  "Host FirewallRule",
                                  "Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding",
                                  "DNSSuffix DomainName ADLogin ADConnection FEDCPromo",
                                  "Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS",
                                  "Image Images Updates",
                                  "Role Win32_Client Win32_Server UnixBSD RHELCentOS" -join " ").Split(" ") | % { "_$_.ps1" })

        [String[]] $Functions = ("Get-FEManifest","Get-FEModule","Get-FEOS","Get-FEHive","Get-FEHost","Get-FEService","Get-XamlWindow","Get-FENetwork",
                                 "Import-MDTModule","Write-Theme","Show-ToastNotification","Get-Certificate","Get-ViperBomb","Get-FEDCPromo",
                                 "Get-FEDCPromoProfile","Remove-FEShare","Add-ACL","New-ACLObject","Install-IISServer","Configure-IISServer",
                                 "New-FECompany","Get-ServerDependency","Get-DiskInfo" | % { "$_.ps1" })

        [String[]]   $Control = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                                  "ServerMod.xml" ) -Split " "
        [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

        _Manifest([String]$Version)
        {
            $This.Version = $Version
        }

        [String[]] CheckLib([String]$URL,[String]$Type)
        {
            $Filter = "{0}(\w+)(.ps1)" -f @{ Classes = "(_*)"; Functions = "(\w+\-)" }[$Type]
            Return @( [Regex]::Matches((Invoke-RestMethod "$URL/$Type"),$Filter).Value | Select -Unique | ? { $_ -notin $This.$Type } )
        }
    }

    Class _RestObject
    {
        [String]           $Type
        [String]           $Name
        [Object]         $Object
        Hidden [String]     $URI
        Hidden [String] $Outfile
    
        _RestObject([String]$URI,[String]$Outfile)
        {
            $This.Type    = $URI.Split("/")[-2]
            $This.Name    = $URI.Split("/")[-1]
            $This.URI     = $URI
            $This.Outfile = $Outfile.Replace("\","/")

            Invoke-RestMethod -URI $URI -Outfile $Outfile -Verbose
        
            $This.Object  = (Get-Item $Outfile)
        }
    }

    Class _Hive
    {
        [String]        $Type
        [String]     $Version
        Hidden [String] $Name = "{0}\Secure Digits Plus LLC\FightingEntropy\{1}"
        Hidden [String] $File = "{0}\FightingEntropy.ps{1}1"
        [String[]]  $PSModule
        [String]        $Root
        [Object]        $Path
        [Object]    $Manifest
        [Object]      $Module

        [String[]] PSModule_()
        {
            Return @( Get-Item Env:\ | % GetEnumerator | ? Name -eq PSModulePath | % Value | % Split @{  
        
                Win32_Client = ";"
                Win32_Server = ";"
                RHELCentOS   = ":" 
                UnixBSD      = ":"
            
            }[$This.Type])
        }

        [String] Root_()
        {
            Return ($This.Name -f @{
        
                Win32_Client = "HKLM:\Software\Policies"
                Win32_Server = "HKLM:\Software\Policies"
                RHELCentOS   = "/etc/Maestro"
                UnixBSD      = "/etc/Maestro"
            
            }[$This.Type],$This.Version)
        }

        [String] Path_()
        {
            Return ($This.Name -f @{  
        
                Win32_Client = Get-Item Env:\ProgramData | % Value
                Win32_Server = Get-Item Env:\ProgramData | % Value
                RHELCentOS   = "/etc/FEUnix"
                UnixBSD      = "/etc/FEUnix"
            
            }[$This.Type],$This.Version)
        }

        [Void] Check([String]$Path)
        {
            $Items = $Path.Split("\")
            $Item  = $Items[0]

            ForEach ( $I in 1..( $Items.Count - 1 ) )
            {
                $Item += ( "\{0}" -f $Items[$I] )

                If ( ! ( Test-Path $Item ) )
                {
                    New-Item $Item -ItemType Directory -Force -Verbose
                }
            }
        }

        _Hive([String]$Type,[String]$Version)
        {
            $This.Type      = $Type
            $This.Version   = $Version

            $This.PSModule  = $This.PSModule_()
            $This.Root      = $This.Root_()
            $This.Path      = $This.Path_()

            If ( $This.Type -eq "RHELCentOS" )
            {
                $This.Root  = $This.Root.Replace("\","/")
                $This.Path  = $This.Path.Replace("\","/")
            }

            $This.Check($This.Root)
            $This.Check($This.Path)

            $This.Manifest = $This.File -f $This.Path,"d"
            $This.Module   = $This.File -f $This.Path,"m"
        }
    }

    Class _Install
    {
        [Object]                 $OS
        [Object]           $Manifest
        [Object]               $Hive

        [String]               $Name = "FightingEntropy"
        [String]            $Version
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
                $This.Load          += @( Get-Content "$($This.Hive.Path)\Classes\$_" )
            }

            $This.Manifest.Functions | % {

                $This.Load          += ""
                $This.Load          += "# Function/$_"
                $This.Load          += @( Get-Content "$($This.Hive.Path)\Functions\$_" )
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
            @{  GUID                 = "d2402c18-0529-4e55-919f-ac477c49d4fe"
                Path                 = $This.Hive.Manifest
                ModuleVersion        = $This.Hive.Version
                Copyright            = "(c) 2021 mcc85sx. All rights reserved."
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
            $Tree = "FightingEntropy\{0}" -f $This.Version

            ForEach ( $Path in $This.Hive.PSModule )
            {
                If ( $Path -match $String -and $Path -match "(Program Files)" )
                {
                    "{0},{0}\{1}" -f "FightingEntropy",$This.Version -Split "," | % { 
                    
                        If ( ! ( Test-Path "$Path\$_" ) ) 
                        { 
                            New-Item -Path "$Path\$_" -ItemType Directory -Verbose
                        }
                    }

                    Copy-Item $This.Hive.Module   -Destination "$Path\$Tree" -Verbose
                    Copy-Item $This.Hive.Manifest -Destination "$Path\$Tree" -Verbose
                }
            }
        }

        _Install([String]$Version)
        {
            $This.Version            = $Version
            $This.OS                 = [_OS]::New()
            $This.Type               = $This.OS.Type
            $This.Manifest           = [_Manifest]::New($Version)
            $This.Hive               = [_Hive]::New($This.Type,$Version)

            $This.Resource           = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/{0}" -f $Version
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

    [_Install]::New($Version)
}

Install-FEModule -Version 2021.1.1
