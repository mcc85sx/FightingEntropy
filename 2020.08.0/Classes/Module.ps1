Class FERoot # // Folder for installation and database, accesses Registry for forward info
{
    [String] $Name
    [String] $Date
    [String] $Path

    FERoot([String]$Path)
    {
        $This.Date = Get-Date -UFormat "%Y_%m%d-%H%M%S"
        $This.Path = $Path
    }
}

Class FEModule # // Module Provisioning (Installs Module/Validates Existence)
{
    [String] $Name               = "FightingEntropy"
    [String] $Version            = "2020.08.0"
    [String] $Provider           = "Secure Digits Plus LLC"
    [String] $Registry           = "HKLM:\SOFTWARE\Policies\{0}\{1}\{2}"
    [String] $Path               = "$Env:ProgramData\{0}\{1}\{2}"
    [Object] $Content

    Hidden [String[]] $Folders   = "Archive","Classes","Control","Graphics","Network"
    Hidden [String[]] $Files     = "FightingEntropy.ps1","FightingEntropy.psm1"

    [String] GetRoot([String]$Root)
    {
        Return ( $Root -f $This.Provider, $This.Name, $This.Version )
    }

    GetModule()
    {
        $This.Registry           = $This.GetRoot($This.Registry)
        $This.Path               = $This.GetRoot($This.Path)
    }

    FEModule()
    {
        $This.GetModule()
        
        If ( ! ( Test-Path $This.Registry ) )
        {
            ForEach ( $I in 3..5 ) 
            { 
                $This.Registry.Split('\')[0..$I] -join '\' | ? { ! ( Test-Path $_ ) } | % { New-Item $_ -Verbose }
            }
        }

        If ( ! ( Test-Path $This.Path ) )
        {
            New-Item -Path $This.Path -ItemType Directory -Verbose
        }

        $This.Folders            | % { "{0}\$_" -f $This.Path } | ? { ! ( Test-Path $_ ) } | % { New-Item -Path $_ -ItemType Directory -Verbose }
        $This.Content            = Get-ChildItem $This.Path
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
            Path        = ( GCI ( GP "HKLM:\Software\Microsoft\Deployment 4" ).Install_Dir "*Toolkit.psd1" -Recurse ).FullName
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

            If ( Get-SMBShare | ? { $_.Name -eq $Name -or $_.Path -eq $Root } )
            {
                Throw "Share exists"
            }

            @{  Name        = "Microsoft Deployment Toolkit" 
                Path        = ( GCI ( GP "HKLM:\Software\Microsoft\Deployment 4" ).Install_Dir "*Toolkit.psd1" -Recurse ).FullName
                Description = ("The [Microsoft Deployment Toolkit]\\_It is *the* toolkit...\_...that Microsoft themselves uses...\" +
                               "_...to deploy additional toolkits.\\_It's not that weird.\_You're just thinking way too far into it" +
                               ", honestly.\\_Regardless... it is quite a fearsome toolkit to have in one's pocket.\_Or, wherever " +
                               "really...\_...at any given time.\\_When you need to be taken seriously...?\_Well, it *should* be t" +
                               "he first choice on one's agenda.\_But that's up to you.\\_The [Microsoft Deployment Toolkit].\_Eve" +
                               "n Mr. Gates thinks it's awesome." ).Replace("_","    ").Split('\') } | % {

                If ( $_.Path -eq $Null )
                {
                    Throw ( "{0} is not installed" -f $_.Names )
                }

                Import-Module $_.Path -Verbose

                Write-Theme $_.Description
            }

            $This.Names        = ( Get-MDTPersistentDrive ).Name
            $This.Roots        = ( Get-MDTPersistentDrive ).Path

            If ( $Name -in $This.Names -or $Root -in $This.Roots )
            {
                Throw "MDT/FE Share exists"
            }

            If ( $This.Names -ne $Null )
            {
                $This.Name     = $This.Names | % { @($_,$_[-1])[[Int32]($_.Count -gt 1)].Replace("DS","") } | % { "FE{0:d3}" -f ( [Int32]$_ + 1 ) }
            }

            $This.PSProvider   = "MDTProvider" 
            $This.Root         = $Root
            $This.Description  = If ( $Description -ne $Null ) { $Description }
            $This.NetworkPath  = $NetworkPath

            @{  
                Path           = $Root
                ItemType       = "Directory"      
            
            }                  | % { New-Item @_ -Verbose }

            @{  
                Name           = $Name
                Path           = $Root 
                FullAccess     = "Administrators" 
            
            }                  | % { New-SMBShare @_ -Verbose }

            @{  
                Name           = $This.Name 
                PSProvider     = $This.PSProvider
                Root           = $This.Root
                Description    = $This.Description
                NetworkPath    = $This.NetworkPath
                Verbose        = $True  

            } | % { New-PSDrive @_ | add-MDTPersistentDrive -Verbose }
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