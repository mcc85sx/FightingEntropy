Class FERoot # // Details for root tools directory
    {
        Hidden [String[]]     $Names = ("Name Version Provider Date Path Status" -Split " ") 
        [String]               $Name
        [String]            $Version
        [String]           $Provider
        [String]               $Date
        [String]               $Path
        [String]             $Status

        FERoot([String]$Registry,[String]$Name,[String]$Version,[String]$Provider,[String]$Path)
        {
            $This.Name               = $Name
            $This.Version            = $Version
            $This.Provider           = $Provider
            $This.Date               = Get-Date -UFormat %Y_%m%d-%H%M%S
            $This.Path               = $Path
            $This.Status             = "Initialized"
            $This.Names              | % { Set-ItemProperty -Path $Registry -Name $_ -Value $This.($_) -Verbose }
        }
    }

    Class FEModule # // Module Path Definitions
    {
        [String]               $Name = "FightingEntropy"
        [String]            $Version = "2020.09.0"
        [String]           $Provider = "Secure Digits Plus LLC"
        [String]                $URL = "https://github.com/mcc85sx/FightingEntropy/blob/master/2020.09.0"

        [String]           $Registry = "HKLM:\SOFTWARE\Policies"
        [Object]         $Properties

        [String]               $Path = $Env:ProgramData
        [Object]               $Base

        Hidden [String[]]   $Folders = "Archives Classes Control Functions Graphics Network Services" -Split " "
        Hidden [String[]]     $Files = ( "{0}.ps1 {0}.psm1" -f "FightingEntropy" ) -Split " "

        [String] GetRoot([String]$Root)
        {
            Return ( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
        }

        FEModule()
        {
            $This.Registry           = $This.GetRoot($This.Registry)
            $This.Path               = $This.GetRoot($This.Path)
            
            If ( ! ( Test-Path $This.Path ) )
            {
                New-Item -Path $This.Path -ItemType Directory -Verbose
            }

            If ( ! ( Test-Path $This.Registry ) )
            {
                ForEach ( $I in 3..5 )
                { 
                    $This.Registry.Split('\')[0..$I] -join '\' | ? { ! ( Test-Path $_ ) } | % { New-Item $_ -Verbose }
                }

                [FERoot]::New($This.Registry,$This.Name,$This.Version,$This.Provider,$This.Path)
            }

            $This.Properties         = Get-ItemProperty -Path $This.Registry | Select-Object Name, Version, Provider, Date, Path, Status
            $This.Folders            | % { "{0}\$_" -f $This.Path } | ? { ! ( Test-Path $_ ) } | % { New-Item -Path $_ -ItemType Directory -Verbose }
            $This.Base               = Get-ChildItem $This.Path
        }
    }

    Class FEMaster
    {
        [String]               $Name
        [String]            $Version
        [String]           $Provider
        [Object]             $Module

        [Object[]]         $Archives
        [Object[]]          $Classes
        [Object[]]        $Functions
        [Object[]]         $Graphics
        [Object[]]          $Network
        [Object[]]         $Services

        [Object]               $Path

        FEMaster()
        {
            $This.Module        = [FEModule]::New()
            
            $This.Module        | % { 

                $This.Name      = $_.Name
                $This.Version   = $_.Version
                $This.Provider  = $_.Provider
                $This.Archives  = $_.Base | ? Name -eq Archives   | Get-ChildItem
                $This.Classes   = $_.Base | ? Name -eq Classes    | Get-ChildItem
                $This.Functions = $_.Base | ? Name -eq Functions  | Get-ChildItem
                $This.Network   = $This.Archives | ? Name -eq Network | Get-ChildItem
                $This.Services  = $_.Base | ? Name -eq Services   | Get-ChildItem
            }

            # TODO: Set Background, Icons, System Badge/Info, Group Policy, etc.
            # "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
            # "ClassicStartMenu" , "NewStartPanel"

        }
    }

    Class FEShare # // Creates an MDT/FE Share for MDT/FE Deployments
    {
        [String]           $Name = "FE001"
        [String]     $PSProvider
        [String]           $Root
        [String]    $Description = $Null
        [String]    $NetworkPath
        [Object]        $Company = [FECompany]::New()

        Hidden [String[]] $Names
        Hidden [String[]] $Roots

        Hidden [Hashtable] $Hash = @{

            Name        = "Microsoft Deployment Toolkit" 
            Path        = ( Get-ChildItem ( Get-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" ).Install_Dir "*Toolkit.psd1" -Recurse ).FullName
            Description = ("The [Microsoft Deployment Toolkit]\\_It is *the* toolkit...\_...that Microsoft themselves uses...\" +
                            "_...to deploy additional toolkits.\\_It's not that weird.\_You're just thinking way too far into it" +
                            ", honestly.\\_Regardless... it is quite a fearsome toolkit to have in one's pocket.\_Or, wherever " +
                            "really...\_...at any given time.\\_When you need to be taken seriously...?\_Well, it *should* be t" +
                            "he first choice on one's agenda.\_But that's up to you.\\_The [Microsoft Deployment Toolkit].\_Eve" +
                            "n Mr. Gates thinks it's awesome." ).Replace("_","    ").Split('\')
        }

        FEShare([String]$Name,[String]$Root,[String]$Description,[String]$NetworkPath)
        {
            If ( Test-Path $Root )
            {
                Throw "Path exists"
            }

            Else
            {
                $This.Root = $Root
            }

            If ( Get-SMBShare | ? Name -eq $Name -or Path -eq $Root )
            {
                Throw "Share exists"
            }

            If ( !$This.Hash.Path )
            {
                Throw ( "{0} is not installed" -f $_.Names )
            }

            Import-Module $This.Hash.Path -Verbose

            $This.Names        = ( Get-MDTPersistentDrive ).Name
            $This.Roots        = ( Get-MDTPersistentDrive ).Path

            If ( $Name -in $This.Names -or $Root -in $This.Roots )
            {
                Throw "MDT/FE Share exists"
            }

            If ( !! $This.Names )
            {
                $This.Name     = $This.Names        | % { @($_,$_[-1])[[Int32]($_.Count -gt 1)].Replace("DS","") } | % { "FE{0:d3}" -f ( [Int32]$_ + 1 ) }
            }

            $This.PSProvider   = "MDTProvider" 
            $This.Root         = $Root
            $This.Description  = $Description       | % { If ( !$_ ) { $_ } Else { $_ } }
            $This.NetworkPath  = $NetworkPath

            @{  Path           = $Root
                ItemType       = "Directory"      } | % { New-Item @_ -Verbose }

            @{  Name           = $Name
                Path           = $Root 
                FullAccess     = "Administrators" } | % { New-SMBShare @_ -Verbose }

            @{  Name           = $This.Name 
                PSProvider     = $This.PSProvider
                Root           = $This.Root
                Description    = $This.Description
                NetworkPath    = $This.NetworkPath
                Verbose        = $True            } | % { New-PSDrive @_ | add-MDTPersistentDrive -Verbose }
        }
    }

    Class FECompany # // Object for Company information needed to fulfill post install/branding
    {
        [String] $Name
        [String] $Branch
        [String] $Background
        [String] $Logo
        [String] $Phone
        [String] $Website
        [String] $Hours

        FECompany() {}

        Load([String]$Name,[String]$Branch,[String]$Background,[String]$Logo,[String]$Phone,[String]$Website,[String]$Hours)
        { 
            $This.Name       = $Name
            $This.Branch     = $Branch
            $This.Background = $Background
            $This.Logo       = $Logo
            $This.Phone      = $Phone
            $This.Website    = $Website
            $This.Hours      = $Hours
        }
    }
