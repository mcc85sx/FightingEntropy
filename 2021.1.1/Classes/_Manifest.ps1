Class _Manifest
{
    [String[]]     $Names = ( "Name Version Provider Date Path Status Type" -Split " " )
    [String]     $Version
    [String]        $GUID = ( "d2402c18-0529-4e55-919f-ac477c49d4fe" )
    [String[]]      $Role = ( "Win32_Client Win32_Server UnixBSD RHELCentOS" -Split " " )
    [String[]]   $Folders = ( " Classes Control Functions Graphics Role" -Split " " )

    # //          Classes
    # \\          -------
    # //    Module (Core)      Manifest Hive Root Module OS Info RestObject
    # \\    Network(Main)      Host FirewallRule
    # //           System      Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding
    # \\         Active D.     DNSSuffix DomainName ADLogin ADConnection FEDCPromo
    # //           Server      Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS
    # \\          Imaging      Image Images Updates
    # //             Role      Role Win32_Client Win32_Server UnixBSD RHELCentOS

    [String[]]   $Classes = (("Manifest Hive Root Install Module OS Info RestObject",
                              "Host FirewallRule",
                              "Drive Drives ViperBomb File Cache Icons Shortcut Brand Branding",
                              "DNSSuffix DomainName ADLogin ADConnection FEDCPromo",
                              "Certificate Company Key RootVar Share Source Target ServerDependency ServerFeature ServerFeatures IISFeatures IIS",
                              "Image Images Updates",
                              "Role Win32_Client Win32_Server UnixBSD RHELCentOS" -join " ").Split(" ") | % { "_$_.ps1" })

    [String[]] $Functions = ("Get-FEManifest","Get-FEModule","Get-FEOS","Get-FEHive","Get-FEHost","Get-FEService","Get-XamlWindow","Get-FENetwork",
                             "Import-MDTModule","Write-Theme","Show-ToastNotification","Get-Certificate","Get-ViperBomb","Get-FEDCPromo",
                             "Get-FEDCPromoProfile","Remove-FEShare","Add-ACL","New-ACLObject","Install-IISServer","Configure-IISServer",
                             "New-FECompany","Get-ServerDependency","Get-DiskInfo" | % { "$_.ps1" })

    [String[]]   $Control = ( "Computer.png DefaultApps.xml MDT{0} MDT{1} PSD{0} PSD{1} header-image.png" -f "ClientMod.xml",
                              "ServerMod.xml" ) -Split " "
    [String[]]  $Graphics = ("background.jpg banner.png icon.ico OEMbg.jpg OEMlogo.bmp" -Split " ")

    _Manifest([String]$Version)
    {
        $This.Version = $Version
    }

    [String[]] CheckLib([String]$URL,[String]$Type)
    {
        $Filter = "{0}(\w+)(.ps1)" -f @{ Classes = "(_*)"; Functions = "(\w+\-)" }[$Type]
        Return @( [Regex]::Matches((Invoke-RestMethod "$URL/$Type"),$Filter).Value | Select -Unique | ? { $_ -notin $This.$Type } )
    }
}
