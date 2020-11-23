
Class _ServerFeatures
{
    static [String[]] $Names = ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCenter RSAT-AD-PowerShell RSAT-AD-T" +
                         "ools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Server RSAT-Role-Tools WDS WDS-Admin" + 
                         "Pack WDS-Deployment WDS-Transport").Split(" ")
    [Object[]]     $Features

    _ServerFeatures()
    {
        $This.Features     = (Get-WindowsFeature | ? Name -in ([_ServerFeatures]::Names) | Select Name, DisplayName, Installed)
    }
}


Class _DCPromo
{
    [String[]]    $Command = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain") -Split " "
    [String[]]       $Menu = "Forest","Tree","Child","Clone"
    [String[]] $DomainType = "-","TreeDomain","ChildDomain","-"
    [String[]]       $Mode = "ForestMode","DomainMode","ParentDomainName"
    [String[]]   $Services = [_ServerFeatures]::New()
    [String[]]      $Roles = "InstallDNS","CreateDNSDelegation","NoGlobalCatalog","CriticalReplicationOnly"
    [String[]]      $Paths = "DatabasePath","LogPath","SysvolPath"
    [String[]]     $Domain = "Credential {0}Name {0}{1}Name New{0}Name New{0}{1}Name ReplicationSourceDC SiteName" -f "Domain","NetBIOS" -Split " "
    [String[]]    $Buttons = "Start","Cancel","CredentialButton"

    _DCPromo([Int32]$Mode)
    {
        If ( $Mode -notin 0..3 )
        {
            Throw "Invalid mode"
        }
    }
}

Class _FEPromoRoles
{
    [String] $Name
    [Bool]   $IsEnabled
    [Bool]   $IsChecked

    _FEPromoRoles([String]$Name,[Bool]$IsEnabled,[Bool]$IsChecked)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.IsChecked = $IsChecked
    }
}

Class _FEPromoDomain
{
    [String] $Name
    [Bool]   $IsEnabled
    [String] $Text

    _FEPromoDomain([String]$Name,[Bool]$IsEnabled)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.Text      = ""
    }
}

Class _FEPromo
{
    [String]                             $Command
    [Int32]                                 $Mode
    [String]                                $Slot
    [String]                          $DomainType
    [String]                          $ForestMode
    [String]                          $DomainMode
    [String]                    $ParentDomainName

    [Object]                          $InstallDNS
    [Object]                 $CreateDNSDelegation
    [Object]                     $NoGlobalCatalog
    [Object]             $CriticalReplicationOnly

    [String]                        $DatabasePath
    [String]                             $LogPath
    [String]                          $SysvolPath
    
    [Object]                          $Credential
    [String]                          $DomainName
    [String]                   $DomainNetBIOSName
    [String]                       $NewDomainName
    [String]                $NewDomainNetBIOSName
    [String]                 $ReplicationSourceDC
    [String]                            $SiteName

    [SecureString] $SafeModeAdministratorPassword
    [String]                             $Profile

    [Object[]]                          $Features

    SetMode([Int32]$Mode)
    {
        $This.DomainType                   = @("-","TreeDomain","ChildDomain","-")[$Mode]

        $This.Credential                   = [_FEPromoDomain]::New(             "Credential", (0,1,1,1)[$Mode])
        $This.DomainName                   = [_FEPromoDomain]::New(             "DomainName", (1,0,0,1)[$Mode])
        $This.DomainNetBIOSName            = [_FEPromoDomain]::New(      "DomainNetBIOSName", (1,0,0,0)[$Mode])
        $This.NewDomainName                = [_FEPromoDomain]::New(          "NewDomainName", (0,1,1,0)[$Mode])
        $This.NewDomainNetBIOSName         = [_FEPromoDomain]::New(   "NewDomainNetBIOSName", (0,1,1,0)[$Mode])
        $This.ReplicationSourceDC          = [_FEPromoDomain]::New(    "ReplicationSourceDC", (0,0,0,1)[$Mode])
        $This.SiteName                     = [_FEPromoDomain]::New(               "SiteName", (0,1,1,1)[$Mode])
        $This.InstallDNS                   = [_FEPromoRoles]::New(              "InstallDNS", (1,1,1,1)[$Mode], (1,1,1,1)[$Mode])
        $This.CreateDNSDelegation          = [_FEPromoRoles]::New(     "CreateDNSDelegation", (1,1,1,1)[$Mode], (0,0,1,0)[$Mode])
        $This.NoGlobalCatalog              = [_FEPromoRoles]::New(         "NoGlobalCatalog", (0,1,1,1)[$Mode], (0,0,0,0)[$Mode])
        $This.CriticalReplicationOnly      = [_FEPromoRoles]::New( "CriticalReplicationOnly", (0,0,0,1)[$Mode], (0,0,0,0)[$Mode])
    }

    [Object[]] GetFeatures()
    {
        Return ([_ServerFeatures]::New().Features)
    }

    _FEPromo([Int32]$Mode)
    {
        $This.Command                = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
        $This.Slot                   = Switch ([Int32]$Mode) { 0 { "Forest" } 1 { "Tree" } 2 { "Child" } 3 { "Clone" } }
        $This.Features               = $This.GetFeatures
        $This.SetMode($Mode)
    }
}
