Class _DeploymentShare
{
    [Object]            $Window
    [Object]                $IO
    [Object]          $Graphics
    Hidden [Bool]     $IsDomain
    [Object]            $Domain
    [Object]          $Provider = "Secure Digits Plus"
    [String]      $Organization
    [String]        $CommonName
    [String]        $ExternalIP = (Invoke-RestMethod http://ifconfig.me/ip)
    [Object]              $Ping = (Invoke-RestMethod http://ipinfo.io/$(Invoke-RestMethod http://ifconfig.me/ip))
    [String]          $Location
    [String]            $Region
    [String]           $Country
    [String]            $Postal
    [String]          $SiteLink
    [String]          $TimeZone
    [String]            $Branch
    [String]             $Phone
    [String]             $Hours
    [String]           $Website
    [String]              $Logo
    [String]        $Background
    [String]        $DCUsername
    [SecureString]  $DCPassword
    [SecureString]   $DCConfirm
    [String]           $DNSName
    [String]       $NetBIOSName
    [String]            $OUName
    [String]        $IISInstall
    [String]           $IISName
    [String]        $IISAppPool
    [String]    $IISVirtualHost
    [String]         $ISOSource
    [String]         $WIMSource
    [String]        $LMUsername
    [SecureString]  $LMPassword
    [SecureString]   $LMConfirm
    [String]              $Path
    [String]         $Sharename
    [String]       $Description
    [PSCredential]  $Credential
    [Object]               $Key

    # Main()
    _DeploymentShare()
    {
        $This.Window     = Get-XamlWindow -Type FEShare
        $This.IO         = $This.Window.IO
        $This.Graphics   = Get-FEModule -Graphics
        $This.IsDomain   = Get-CimInstance Win32_ComputerSystem | % PartOfDomain

        Switch([UInt32]($This.IsDomain))
        {
            0 # Non-domain
            {
                $This.Domain               = "-"
                $This.DNSName              = Get-Item Env:\UserDNSDomain | % Value
                $This.IO._DNS.Text         = $This.DNSName

                $This.NetBIOSName          = Get-Item Env:\UserDomain    | % Value
                $This.IO._NetBIOS.Text     = $This.NetBIOSName
            }

            1 # Domain Member
            {
                Import-Module ActiveDirectory
                $This.Domain               = Get-ADDomain
                $This.DNSName              = $This.Domain.DNSRoot
                $This.IO._DNS.Text         = $This.DNSName

                $This.NetBIOSName          = $This.Domain.NetBIOSName
                $This.IO._NetBIOS.Text     = $This.NetBIOSName
            }
        }

        $This.GetSiteLink($This.Ping)
        $This.SetIIS()
        $This.GetGraphics()
    }

    GetIIS()
    {
        If ($This.IO._InstallIIS.IsChecked)
        {
            $This.InstallIIS = 0
        }

        If ($This.IO._InstallIIS.IsChecked)
        {
            $This.InstallIIS = 1
        }
    }

    SetIIS()
    {
        Switch ($This.IISInstall)
        {
            0
            {
                $This.IISName         = "N/A"
                $This.IISAppPool      = "N/A"
                $This.IISVirtualHost  = "N/A"
            }

            1
            {
                $This.IISName         = "<Enter IIS Name>"
                $This.IISAppPool      = "<Enter App Pool Name>"
                $This.IISVirtualHost  = "<Enter Virtual Hostname>"
            }
        }

        $This.IO._IISName.Text        = $This.IISName
        $This.IO._IISAppPool.Text     = $This.IISAppPool
        $This.IO._IISVirtualHost.Text = $This.IISVhost
    }

    GetGraphics()
    {
        $This.Logo                = $This.Graphics | ? Name -match OEMlogo.bmp | % FullName
        $This.IO._Logo.Text       = $This.Logo

        $This.Background          = $This.Graphics | ? Name -match OEMbg.jpg | % FullName
        $This.IO._Background.Text = $This.Background
    }

    GetSiteLink([Object]$Ping)
    {
        $Return = @( )
        $This.Location          = $Ping.City
        $This.IO._Location.Text = $Ping.City
        
        $This.Region            = $Ping.Region
        $This.IO._Region.Text   = $Ping.Region

        $This.Country           = $Ping.Country
        $This.IO._Country.Text  = $Ping.Country
        
        $This.Postal            = $Ping.Postal
        $This.IO._Postal.Text   = $Ping.Postal
        
        $This.TimeZone          = $Ping.TimeZone
        $This.IO._TimeZone.Text = $Ping.TimeZone
        
        $Return += ( $Ping.City -Split " " | % { $_[0] } ) -join ''
        $Return += ( $Ping.Region -Split " " | % { $_[0] } ) -join ''
        $Return += $Ping.Country
        $Return += $Ping.Postal

        $This.Sitelink = $Return -join '-'
    }

    [String] ToString()
    {
        Return $This.SiteLink
    }

    [String] GetBranch([String]$Domain)
    {
        Return "$($This.Sitelink).$Domain"
    }
}
