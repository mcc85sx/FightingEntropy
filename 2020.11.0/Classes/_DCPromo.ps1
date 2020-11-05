Class _DCPromo
{
    [String[]]    $Command = "{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain" -Split " "
    [Int32[]]     $Process = @(0..3)
    [String[]]       $Menu = "Forest","Tree","Child","Clone"
    [String[]] $DomainType = "-","TreeDomain","ChildDomain","-"
    [String[]]       $Mode = "ForestMode","DomainMode","ParentDomainName"
    [String[]]   $Services = [_ServerFeatures]::New().Names
    [String[]]      $Roles = "InstallDNS","CreateDNSDelegation","NoGlobalCatalog","CriticalReplicationOnly"
    [String[]]      $Paths = "DatabasePath","LogPath","SysvolPath"
    [String[]]     $Domain = "Credential {0}Name {0}{1}Name New{0}Name New{0}{1}Name ReplicationSourceDC SiteName" -f "Domain","NetBIOS" -Split " "
    [String[]]    $Buttons = "Start","Cancel","CredentialButton"

    _DCPromo(){}
}
