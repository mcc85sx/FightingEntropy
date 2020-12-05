Class Manifest
{
    [Object]   $Module
    [String[]] $Names     = ( "Name Version Provider Date Path Status Type" -Split " " )
    [String[]] $GUID      = ( "67b283d9-72c6-413a-aa80-a24af5d4ea8f" )
    [String[]] $Role      = ( "{0}Client {0}Server UnixBSD RHEL/CentOS" -f "Win32_" -Split " " )
    [String[]] $Folders   = ( " Classes Control Functions Graphics Role" -Split " " )
    [String[]] $Classes   = (("Root Module QMark File FirewallRule Drive Cache Icons Shortcut Drives Host Block Faces Track Theme " + 
                              "Object Flag Banner UISwitch Toast XamlWindow XamlObject VendorList V4Network V6Network NetInterface " + 
                              "Network Info Service Services ViperBomb Brand Branding Certificate Company Key RootVar Share Master " + 
                              "Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS DCPromo Xaml XamlGlossar" + 
                              "yItem Image Images Updates ArpHost ArpScan ArpStat NbtHost NbtScan NbtStat FEPromo FEPromoDomain FEP" + 
                              "romoRoles Role Win32_Client Win32_Server UnixBSD RHELCentOS" ).Split(" ") | % { "_$_" })
    [String[]] $Control   = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                              "ServerMod.xml" ) -Split " "
    [String[]] $Functions = (("Get-Certificate Get-FEModule Get-ViperBomb Remove-FEShare Write-Theme Write-Flag Write-Banner Instal" +
                              "l-IISServer Add-ACL New-ACLObject Configure-IISServer Show-ToastNotification New-FECompany Get-Serve" + 
                              "rDependency Get-FEServices Get-FEHost").Split(" ") | % { "$_" })
    [String[]] $Graphics  = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

    Manifest(){}
}
