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
