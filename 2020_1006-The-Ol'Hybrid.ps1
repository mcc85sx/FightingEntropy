# Source from 02-27-2020 - What I used to write then... https://github.com/secure-digits-plus-llc/Hybrid-DSC/blob/master/20190227_Original.ps1
# This is a revision of that particular script. So... we're talking, you get to see the jump I made in about 21 total months of programming in PowerShell...
# Hybrid original

    If ( [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() | % IsInRole Administrators )
    {
        Set-ExecutionPolicy Bypass -Scope Process -Force -Verbose
    }

    Else
    {
        Throw "Run As Administrator"
    }

    Class _Brand
    {
        [String] $Path
        [String] $Name
        [Object] $Value

        _Brand([String]$Path,[String]$Name,[Object]$Value)
        {
            $This.Path  = $Path
            $This.Name  = $Name
            $This.Value = $Value
        }
    }
        
    Class Branding
    {
        [String[]]        $Names = ("{0};{0}Style;Logo;Manufacturer;{1}Phone;{1}Hours;{1}URL;LockScreenImage;OEMBackground") -f "Wallpaper","Support" -Split ";"
        [Object]          $Items
        [Object]         $Values

        [Object]         $Output
        [Object]    $Certificate

        [String]       $Provider = "Secure Digits Plus LLC"
        [String]       $SiteLink = "CP-NY-US-12065"
        [String]     $Background = "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.0\Graphics\OEMbg.jpg"
        [String]           $Logo = "C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\2020.10.0\Graphics\OEMlogo.bmp"
        [String]          $Phone = "(518)406-8569"
        [String]        $Website = "securedigitsplus.com"
        [String]          $Hours = "24h/d;7d/w;365.25d/y;"

        [String[]]     $FilePath = ("{0}\{1};{0}\{1}\{2};{0}\{1}\{2}\Backgrounds;{0}\Web\Screen;{0}\Web\Wallpaper\Windows;C:\ProgramData\Microsoft\" + 
                                    "User Account Pictures") -f "C:\Windows" , "System32" , "OOBE\Info" -Split ";"

        [String[]] $RegistryPath = @(("HKCU:\{0}\{1}\Policies\System;HKLM:\{0}\{1}\OEMInformation;HKLM:\{0}\{1}\Authentication\LogonUI\Background;" +
                                    "HKLM:\{0}\Policies\Microsoft\Windows\Personalization") -f "Software","Microsoft\Windows\CurrentVersion" -Split ";")

        Branding([String]$Background,[String]$Logo)
        {
            If ( ! ( Test-Path -Path $Background ) )
            {
                Throw "Invalid Path"
            }

            $This.Background     = Get-Item $Background | % FullName

            If ( ! ( Test-Path -Path $Logo ) )
            {
                Throw "Invalid Path"
            }

            $This.Logo           = Get-Item $Logo | % FullName

            ForEach ( $I in 0..5 )
            {
                $This.FilePath[$I] | % {
                
                    If ( ! ( Test-Path $_ ) )
                    {
                        New-Item -Path $_ -Verbose
                    }

                    Copy-Item -Path @( $This.Logo, $This.Background )[[Int32]( $I -in 2..4 )] -Destination $_ -Verbose -Force
                }
            }

            $This.RegistryPath    | % {
                
                @{  Path          = $_ | Split-Path -Parent
                    Name          = $_ | Split-Path -Leaf   } | % {
                    
                    If ( ! ( Test-Path $_.Path ) )
                    {
                        New-Item -Path $_.Path -Name $_.Name -Verbose
                    }
                }
            }
            
            $This.Items           = $This.RegistryPath[0,0,1,1,1,1,1,3,2]
            $This.Values          = @($This.Background,2,$This.Logo,$This.Provider,$This.Phone,$This.Hours,$This.Website,$This.Background,1)
            $This.Output          = @( )

            ForEach ( $I in 0..8 ) 
            {
                $This.Output     += [_Brand]::New($This.Items[$I],$This.Names[$I],$This.Values[$I])

                $This.Output[$I]  | % { Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -Verbose }
            }
        }
    }

    Class UISwitch
    {
        [String]     $Title
        [String]    $Prompt
        [System.Management.Automation.Host.ChoiceDescription[]] $Options
        [Int32]    $Default
        [Object]    $Output

        UISwitch([String]$Title,[String]$Prompt,[String[]]$Options,[Int32]$Default)
        {
            $This.Title     = $Title
            $This.Prompt    = $Prompt
            $This.Options   = $Options
            $This.Default   = $Default
            $This.Output    = (Get-Host).UI.PromptForChoice($This.Title,$This.Prompt,$This.Options,$This.Default)
        }
    }

    Class Key
    {
        [String]           $Path
        [String]       $Username
        [Object]       $Password

        Key([String]$Path,[String]$Username,[Object]$Password)
        {
            $This.Path     = $Path
            $This.Username = $Username
            $This.Password = $Password | ConvertTo-SecureString -AsPlainText -Force
        }
    }

    Class Source
    {
        [String] $NetworkPath
        [String] $Branding
        [String] $Certificates
        [String] $Tools
        [String] $Snapshots
        [String] $Profiles

        Source([String]$NetworkPath)
        {
            #If ( ! ( Test-Path $NetworkPath ) )
            #{
            #    Throw "Invalid Path"
            #}

            #ForEach ( $I in 0..4 )
            #{
            #    ( "Branding Certificates Tools Snapshots Profiles" -Split " " )[$I] | % { 
            #    
            #        $This.$_ = "$NetworkPath\[$I]$_"
            #    }
            #}

            $This.NetworkPath   = "$NetworkPath"
            $This.Branding      = "$NetworkPath\[0]Branding"
            $This.Certificates  = "$NetworkPath\[1]Certificates"
            $This.Tools         = "$NetworkPath\[2]Tools"
            $This.Snapshots     = "$NetworkPath\[3]Snapshots"
            $This.Profiles      = "$NetworkPath\[4]Profiles"
        }
    }

    Class Target
    {
        [String] $Path
        [String] $ComputerName 
        [String] $Architecture
        [String] $SystemDrive 
        [String] $SystemRoot
        [String] $System32
        [String] $Resources
        [String] $ProgramData
        
        Target([String]$Path)
        {
            $This.Path         = $Path
            $This.ComputerName = $env:ComputerName
            $This.Architecture = $env:Processor_Architecture
            $This.SystemDrive  = $env:SystemDrive
            $This.SystemRoot   = $env:SystemRoot
            $This.System32     = "$env:SystemRoot\System32"
            $This.Resources    = "$Path\Resources"
            $THis.ProgramData  = $env:programdata
        }
    }

    Class RootVar
    {
        [String] $UNC
        [String] $CompanyName
        [String] $DCUser
        [String] $DCPass
        [String] $ShareName
        [String] $Website
        [String] $Phone
        [String] $Hours
        [String] $Background
        [String] $Logo
        [String] $Location
        [String] $DNSDomain
        [String] $LMUser
        [String] $LMPass
        [String] $Server
        [Object] $Source
        [Object] $Target

        RootVar()
        {
        
        }

        Default()
        {        
            $This.UNC            = '\\dsc2\secured$'                                          # $R.0
            $This.CompanyName    = 'Secure Digits Plus LLC'                                   # $R.1
            $This.DCUser         = 'dsc2'                                                     # $R.2
            $This.DCPass         = 'Int3264!'                                                 # $R.3
            $This.ShareName      = 'dsc-deploy'                                               # $R.4
            $This.Website        = 'https://www.securedigitsplus.com'                         # $R.5
            $This.Phone          = '(518)847-3459'                                            # $R.6
            $This.Hours          = '24/7'                                                     # $R.7
            $This.Background     = 'OEMbg.jpg'                                                # $R.8
            $This.Logo           = 'OEMlogo.bmp'                                              # $R.9
            $This.Location       = '(Vermont)'                                                # $R.10
            $This.DNSDomain      = 'vermont.securedigitsplus.com'                             # $R.11
            $This.LMUser         = 'Administrator'                                            # $R.12
            $This.LMPass         = 'Int3264!'                                                 # $R.13
            $This.Server         = 'dsc2'                                                     # $R.14
            $This.Source         = [Source]::New(("{0}\{1}" -f $This.UNC, $This.CompanyName)) # $R.15
            $This.Target         = [Target]::New("C:\$($This.CompanyName)")                   # $R.16
        }
    }

    $Root    = [RootVar]::New()
    $Root.Default()

    $LD      = $Root.Target.Path
    $LR      = $Root.Target.Resources
    $BG      = "{0}\{1}" -f $Root.Target.Resources, $Root.Background
    $LG      = "{0}\{1}" -f $Root.Target.Resources, $Root.Logo

    $Root.Server

    $DCCred  = [Key]::New($Root.UNC,$Root.DCUser,$Root.DCPass)
    $LMCred  = [Key]::New($Root.UNC,$Root.LMUser,$Root.LMPass)
