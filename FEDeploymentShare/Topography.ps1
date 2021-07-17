$NetworkManifest = $Xaml.IO.Stack.Items
$Networks        = Get-ADObject -LDAPFilter "(objectClass=subnet)" -SearchBase "CN=Configuration,DC=securedigitsplus,DC=com"
ForEach ( $Item in $NetworkManifest )
{
    $Network = "{0}/{1}" -f $Item.Network, $Item.Prefix
    If ( $Network -notin $Networks.Name )
    {
        New-ADReplicationSubnet -Name $Network -Verbose
    }
}

$SiteManifest    = $Xaml.IO.Topography.Items
$Sites           = Get-ADObject -LDAPFilter "(objectClass=site)" -SearchBase "CN=Configuration,DC=securedigitsplus,DC=com"

ForEach ( $Item in $SiteManifest )
{
    If ($Item.Sitelink -notin $Sites.Name)
    {
        New-ADReplicationSite -Name $Item.Sitelink -Verbose
    }
}

$Sites        = Get-ADObject -LDAPFilter "(objectClass=site)" -SearchBase "CN=Configuration,DC=securedigitsplus,DC=com"

$OU      = Get-ADObject -LDAPFilter "(objectClass=organizationalUnit)" -SearchBase "DC=securedigitsplus,DC=com"

ForEach ($Item in $Objects)
{
    If ( $Item.Name -notin $OU.Name)
    {
        New-ADOrganizationalUnit -Name $Item.Name -Verbose
    }
}

$OU      = Get-ADObject -LDAPFilter "(objectClass=organizationalUnit)" -SearchBase "DC=securedigitsplus,DC=com"
