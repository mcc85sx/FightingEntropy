Class FEServerFeature
{
    [String] $Name
    [String] $DisplayName
    [Int32]  $Installed

    FEServerFeature([String]$Name,[String]$DisplayName,[Int32]$Installed)
    {
        $This.Name           = $Name
        $This.DisplayName    = $Displayname
        $This.Installed      = $Installed
    }
}
    
Class FEServerFeatureList
{
    [Object[]]      $Feature

    FEServerFeatureList() 
    { 
        $This.Feature        =  ( Get-WindowsFeature | ? Name -in ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCe" + 
                                "nter RSAT-AD-PowerShell RSAT-AD-Tools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Se" + 
                                "rver RSAT-Role-Tools WDS WDS-AdminPack WDS-Deployment WDS-Transport").Split(" ") | % { 
                                [FEServerFeature]::New($_.Name,$_.DisplayName,$_.Installed) } )
    }
}
