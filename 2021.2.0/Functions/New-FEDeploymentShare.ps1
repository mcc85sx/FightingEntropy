Function New-FEDeploymentShare
{
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
        [Object]              $Ping
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
        [String]        $DCPassword
        [String]         $DCConfirm
        [String]           $DNSName
        [String]       $NetBIOSName
        [String]            $OUName
        [Object]        $IISInstall
        [String]           $IISName
        [String]        $IISAppPool
        [String]    $IISVirtualHost
        [String]         $ISOSource
        [String]         $WIMSource
        [String]        $LMUsername
        [String]        $LMPassword
        [String]         $LMConfirm
        [Object]        $MDTInstall
        [String]              $Path
        [String]         $Sharename
        [String]       $Description
        [PSCredential]  $Credential
        [Object]               $Key

        _DeploymentShare()
        {
            $This.Window      = Get-XamlWindow -Type FEShare
            $This.IO          = $This.Window.IO
            $This.Graphics    = Get-FEModule -Graphics
            $This.GetGraphics()
            $This.GetDomain()
            $This.GetMDT()
            $This.GetIIS()

            $This.GetPing()
            $This.GetSiteLink()

            $This.Description          = $This.GetDate()
            $This.IO._Description.Text = $This.Description
        }

        GetGraphics()
        {
            $This.Logo                = $This.Graphics | ? Name -match OEMlogo.bmp | % FullName
            $This.IO._Logo.Text       = $This.Logo

            $This.Background          = $This.Graphics | ? Name -match OEMbg.jpg | % FullName
            $This.IO._Background.Text = $This.Background
        }

        GetDomain()
        {
            $This.IsDomain            = Get-CimInstance Win32_ComputerSystem | % PartOfDomain

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
        }

        GetMDT()
        {
            $This.MDTInstall = @("MDT","PSD")[$This.IO._MDTInstall.SelectedIndex]
        }

        GetIIS()
        {
            $This.IISInstall = @(0,1)[$This.IO._IISInstall.SelectedIndex]
            
            Switch ($This.IISInstall)
            {
                0
                {
                    $This.IISName                      = "N/A"
                    $This.IO._IISName.IsEnabled        = $False
                    $This.IISAppPool                   = "N/A"
                    $This.IO._IISAppPool.IsEnabled     = $False
                    $This.IISVirtualHost               = "N/A"
                    $This.IO._IISVirtualHost.IsEnabled = $False
                }

                1
                {
                    $This.IISName                      = "<Enter IIS Name>"
                    $This.IO._IISName.IsEnabled        = $True
                    $This.IISAppPool                   = "<Enter App Pool Name>"
                    $This.IO._IISAppPool.IsEnabled     = $True
                    $This.IISVirtualHost               = "<Enter Virtual Hostname>"
                    $This.IO._IISVirtualHost.IsEnabled = $True
                }
            }

            $This.IO._IISName.Text        = $This.IISName
            $This.IO._IISAppPool.Text     = $This.IISAppPool
            $This.IO._IISVirtualHost.Text = $This.IISVirtualHost
        }

        GetPing()
        {
            $This.Ping              = Invoke-RestMethod "http://ipinfo.io/$($This.ExternalIP)"
            $This.Location          = $This.Ping.City
            $This.IO._Location.Text = $This.Ping.City
            
            $This.Region            = $This.Ping.Region
            $This.IO._Region.Text   = $This.Ping.Region

            $This.Country           = $This.Ping.Country
            $This.IO._Country.Text  = $This.Ping.Country
            
            $This.Postal            = $This.Ping.Postal
            $This.IO._Postal.Text   = $This.Ping.Postal
            
            $This.TimeZone          = $This.Ping.TimeZone
            $This.IO._TimeZone.Text = $This.Ping.TimeZone

            $This.SiteLink          = $This.GetSiteLink()
            $This.IO._SiteLink.Text = $This.SiteLink
        }
         
        [String] GetSiteLink()
        {
            $Return = @( )
            $Return += ( $This.Ping.City -Split " " | % { $_[0] } ) -join ''
            $Return += ( $This.Ping.Region -Split " " | % { $_[0] } ) -join ''
            $Return += $This.Ping.Country
            $Return += $This.Ping.Postal

            Return @( $Return -join '-' )
        }

        [String] ToString()
        {
            Return $This.SiteLink
        }

        [String] GetBranch([String]$Domain)
        {
            Return "$($This.GetSiteLink()).$Domain".ToLower()
        }

        [String] FileDialog([String]$Default)
        {
            $Item = New-Object System.Windows.Forms.OpenFileDialog
            $Item.InitialDirectory = $This.Graphics | Select-Object -Unique | % Directory | % FullName
            $Item.ShowDialog()
                
            Return @( If ($Item.FileName) { $Item.Filename } Else { $Default } )
        }

        [String] GetDate()
        {
            Return @( Get-Date -UFormat "[%Y-%m%d(MCC/SDP)]")
        }

        [Bool] Validate([SecureString]$Password,[SecureString]$Confirm)
        {
            Return @( $Password -match $Confirm )
        }

    }

    $Root = [_DeploymentShare]::New()

    $Root.IO._Cancel.Add_Click({ $Root.IO.DialogResult = $False })
    
    $Root.IO._Start.Add_Click(
    {  
        $Root.DCUsername = $Root.IO._DCUsername.Text
        If (!$Root.DCUsername)
        {
            [System.Windows.MessageBox]::Show("Invalid Username","[!] Error")
        }

        $Root.DCPassword      = $Root.IO._DCPassword.Password
        $Root.DCConfirm       = $Root.IO._DCConfirm.Password
        
        If ( $Root.DCPassword -notmatch $Root.DCConfirm )
        {
            [System.Windows.MessageBox]::Show("Invalid Password/Confirm","[!] Error")
        }

        $Root.Credential      = New-Object System.Management.Automation.PSCredential -ArgumentList $Root.DCUsername,$Root.IO._DCPassword.SecurePassword

        $Root.LMUsername      = $Root.IO._LMUsername.Text
        If (!$Root.LMUsername)
        {
            $Root.LMUsername  = "Administrator"
        }

        $Root.LMPassword      = $Root.IO._LMPassword.Password
        $Root.LMConfirm       = $Root.IO._LMConfirm.Password
        
        If ( $Root.LMPassword -notmatch $Root.LMConfirm )
        {
            [System.Windows.MessageBox]::Show("Invalid Password/Confirm","[!] Error")
        }

        $Root.ISOSource       = $Root.IO._ImageRoot.Text
        $Root.WIMSource       = $Root.IO._ImageSwap.Text
        $Root.OUName          = $Root.IO._OU.Text
        $Root.IO.DialogResult = $True 
    })

    $Root.IO._LogoDialog.Add_Click(
    {
        $Root.Logo            = $Root.FileDialog($Root.Logo)
        $Root.IO._Logo.Text   = $Root.Logo
    })

    $Root.IO._BackgroundDialog.Add_Click(
    {
        $Root.Background          = $Root.FileDialog($Root.Background)
        $Root.IO._Background.Text = $Root.Background
    })

    $Root.IO._IISInstall.Add_SelectionChanged({ $Root.GetIIS() })
    $Root.IO._MDTInstall.Add_SelectionChanged({ $Root.GetMDT() })

    $Root.IO._Organization.Add_TextChanged(    
    {
        $Root.Organization        = $Root.IO._Organization.Text
    })

    $Root.IO._CommonName.Add_TextChanged(    
    {
        $Root.CommonName          = $Root.IO._CommonName.Text.ToString()
        $Root.IO._CommonName.Text = $Root.CommonName

        $Root.Branch              = ("{0}.{1}" -f ($Root.SiteLink -Replace "-","."),$Root.CommonName).ToLower()
        $Root.IO._Branch.Text     = $Root.Branch
    })

    $Root.IO._Phone.Add_TextChanged(
    { 
        $Root.Phone               = $Root.IO._Phone.Text.ToString()
    })

    $Root.IO._Hours.Add_TextChanged(
    {
        $Root.Hours               = $Root.IO._Hours.Text.ToString()
    })

    $Root.IO._Website.Add_TextChanged(
    {
        $Root.Website             = $Root.IO._Website.Text.ToString()
    })

    $Root.IO._Path.Add_TextChanged(
    {
        $Root.Path                = $Root.IO._Path.Text.ToString()
    })

    $Root.IO._ShareName.Add_TextChanged(
    {
        $Root.ShareName           = $Root.IO._ShareName.Text.ToString()
    })

    $Root.Window.Invoke()
    $Root
}
