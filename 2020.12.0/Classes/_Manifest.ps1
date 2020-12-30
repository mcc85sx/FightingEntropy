Class _Manifest
{
    [String[]]     $Names = ( "Name Version Provider Date Path Status Type" -Split " " )
    [String]     $Version = ( "2020.12.0" )
    [String]        $GUID = ( "67b283d9-72c6-413a-aa80-a24af5d4ea8f" )
    [String[]]      $Role = ( "Win32_Client Win32_Server UnixBSD RHELCentOS" -Split " " )
    [String[]]   $Folders = ( " Classes Control Functions Graphics Role" -Split " " )

    # //          Classes
    # \\          -------
    # //    Module (Core)      Manifest Hive Root Module OS Info RestObject
    # \\      Write-Theme      Block Faces Track Theme Object Flag Banner
    # // Network(ARP/NBT)      VendorList ArpHost ArpScan ArpStat NbtRef NbtHost NbtScan NbtStat NbtObj V4Network V6Network
    # \\    Network(Main)      Network NetInterface PingSweep PingObject Host FirewallRule
    # //           System      Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding
    # \\         Active D.     DNSSuffix DomainName ADLogin ADConnection FEDCPromo
    # //           Server      Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS
    # \\          Imaging      Image Images Updates
    # //             Role      Role Win32_Client Win32_Server UnixBSD RHELCentOS

    [String[]]   $Classes = (("Manifest Hive Root Module OS Info RestObject",
                              "Block Faces Track Theme Object Flag Banner",
                              "VendorList ArpHost ArpScan ArpStat NbtRef NbtHost NbtScan NbtStat NbtObj V4Network V6Network",
                              "Network NetInterface PingSweep PingObject Host FirewallRule",
                              "Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding",
                              "DNSSuffix DomainName ADLogin ADConnection FEDCPromo",
                              "Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS",
                              "Image Images Updates",
                              "Role Win32_Client Win32_Server UnixBSD RHELCentOS" -join " ").Split(" ") | % { "_$_.ps1" })

    [String[]] $Functions = (("Get-FEModule Get-FEOS Get-FEManifest Get-FEHive Get-FEHost Get-FEService Get-XamlWindow",
                              "Write-Theme Write-Flag Write-Banner Show-ToastNotification Get-Certificate Get-ViperBomb",
                              "Get-FEDCPromoProfile Get-FEDCPromo Remove-FEShare Add-ACL New-ACLObject Install-IISServer",
                              "Configure-IISServer New-FECompany Get-ServerDependency" -join " ").Split(" ") | % { "$_.ps1" })

    [String[]]   $Control = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                              "ServerMod.xml" ) -Split " "
    [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

    _Manifest()
    {
    
    }

    [String[]] CheckLib([String]$URL,[String]$Type)
    {
        $Filter = "{0}(\w+)(.ps1)" -f @{ Classes = "(_*)"; Functions = "(\w+\-)" }[$Type]
        Return @( [Regex]::Matches((Invoke-RestMethod "$URL/$Type"),$Filter).Value | Select -Unique | ? { $_ -notin $This.$Type } )
    }
}
