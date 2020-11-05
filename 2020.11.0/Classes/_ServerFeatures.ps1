Class _ServerFeatures
{
    [String[]]        $Names = ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCenter RSAT-AD-PowerShell RSAT-AD-T" +
                                "ools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Server RSAT-Role-Tools WDS WDS-Admin" + 
                                "Pack WDS-Deployment WDS-Transport").Split(" ")
    [Object[]]     $Features

    _ServerFeatures(){}
    Get()
    { 
        $This.Features       =  Get-WindowsFeature | ? Name -in $This.Names | % { [_ServerFeature]::New($_.Name,$_.DisplayName,$_.Installed) }
    }
}
