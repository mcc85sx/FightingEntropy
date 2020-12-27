Class _Manifest
{
    [String[]]     $Names = ( "Name Version Provider Date Path Status Type" -Split " " )
    [String]     $Version = ( "2020.12.0" )
    [String]        $GUID = ( "67b283d9-72c6-413a-aa80-a24af5d4ea8f" )
    [String[]]      $Role = ( "Win32_Client Win32_Server UnixBSD RHELCentOS" -Split " " )
    [String[]]   $Folders = ( " Classes Control Functions Graphics Role" -Split " " )
    [String[]]   $Classes = (("Root Module File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme", 
                              "Object Flag OS Hive Manifest Banner VendorList V4Network V6Network DNSSuffix DomainName",  
                              "NetInterface Network Info ViperBomb Brand Branding Certificate Company Key RootVar PingSweep PingObject",
                              "Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo UISwitch", 
                              "Image Images Updates ArpHost ArpScan ArpStat NbtHost NbtScan NbtStat NbtObj NbtRef FEPromo",
                              "FEPromoDomain FEPromoRoles Role Win32_Client Win32_Server UnixBSD RHELCentOS RestObject" -join " " 
                              ).Split(" ") | % { "_$_.ps1" })
    [String[]] $Functions = (("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write-Banner", 
                              "Install-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotification New-FECompany", 
                              "Get-ServerDependency Get-FEService Get-FEHost Get-FEOS Get-FEManifest Get-FEHive Get-XamlWindow Get-FEDCPromo" -join " " 
                              ).Split(" ") | % { "$_.ps1" })
    [String[]]   $Control = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                              "ServerMod.xml" ) -Split " "
    [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

    _Manifest(){}
}
