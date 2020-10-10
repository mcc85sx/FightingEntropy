
Class _ServerFeatures
{
    [Object[]]      $Feature

    _ServerFeatures() 
    { 
        $This.Feature        =  Get-WindowsFeature | ? Name -in ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCe" + 
                                "nter RSAT-AD-PowerShell RSAT-AD-Tools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Se" + 
                                "rver RSAT-Role-Tools WDS WDS-AdminPack WDS-Deployment WDS-Transport").Split(" ") | % {
                                
                                    [_ServerFeature]::New($_.Name,$_.DisplayName,$_.Installed) 
                                }
    }
}
