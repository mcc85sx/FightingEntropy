Function New-FEDeploymentShare
{
    Class _DeploymentShare
    {
        [Object]            $Window
        [Object]                $IO
        [Object]          $Graphics
        [Object]            $Shares
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
        [String]           $DNSName
        [String]       $NetBIOSName
        [String]            $OUName

        [Object]        $MDTInstall

        [Object]        $IISInstall
        [String]           $IISName
        [String]        $IISAppPool
        [String]    $IISVirtualHost

        Hidden [String] $DCUsername
        Hidden [String] $DCPassword
        Hidden [String]  $DCConfirm

        Hidden [String] $LMUsername = "Administrator"
        Hidden [String] $LMPassword
        Hidden [String]  $LMConfirm

        [Object]         $ImageRoot
        [Object]         $ImageSwap

        [String]              $Path # // 
        [String]         $ShareName # \\ 
        [String]       $Description # // 
        [PSCredential]  $Credential # \\ 
        [Object]               $Key # // 

        _DeploymentShare()
        {
            $This.Window      = Get-XamlWindow -Type FEShare
            $This.IO          = $This.Window.IO
            $This.Graphics    = Get-FEModule -Graphics
            $This.Shares      = Get-FEShare
            $This.GetGraphics()
            $This.GetDomain()
            $This.GetMDT()
            $This.GetIIS()
            $This.GetPing()
            $This.GetSiteLink()

            $This.Description          = ("[FightingEntropy({0})({1})]:\\Development Share" -f [Char]960,$This.GetDate())
            $This.IO._Description.Text = $This.Description

            $This.LMUserName           = "Administrator" 
            $This.IO._LMUsername.Text  = $This.LMUserName
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
            $This.Ping              = Invoke-RestMethod http://ipinfo.io/$($This.ExternalIP)
            $This.Location          = $This.Ping.City
            $This.IO._Location.Text = $This.Location
            
            $This.Region            = $This.Ping.Region
            $This.IO._Region.Text   = $This.Region

            $This.Country           = $This.Ping.Country
            $This.IO._Country.Text  = $This.Country
            
            $This.Postal            = $This.Ping.Postal
            $This.IO._Postal.Text   = $This.Postal
            
            $This.TimeZone          = $This.Ping.TimeZone
            $This.IO._TimeZone.Text = $This.TimeZone

            $This.SiteLink          = $This.GetSiteLink()
            $This.IO._SiteLink.Text = $This.SiteLink
        }
         
        [String] GetSiteLink()
        {
            $Return = @( )
            $Return += ( $This.Location -Split " " | % { $_[0] } ) -join ''
            $Return += ( $This.Region -Split " " | % { $_[0] } ) -join ''
            $Return += $This.Country
            $Return += $This.Postal

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
            Return @( Get-Date -UFormat "%Y-%m%d" )
        }

        NewFEImage()
        {
            New-FEImage -Source $This.ImageRoot -Target $This.ImageSwap
        }

        NewFEShare()
        {
            Get-FEShare -Name $This.ShareName | Remove-FEShare
            New-FEShare -Path $This.Path -ShareName $This.ShareName -Credential $This.Credential -Key $This.Key
        }

        ImportFEImage()
        {
            Import-FEImage -ShareName $This.ShareName -Source $This.ImageSwap -Admin $This.LMUsername -Password $This.LMPassword -Key $This.Key
        }

        UpdateFEShare([UInt32]$Mode)
        {
            Update-FEShare -ShareName $This.ShareName -Mode $Mode -Credential $This.Credential -Key $This.Key
        }
    }

    $Root = [_DeploymentShare]::New()

    $Root.IO._Cancel.Add_Click({ $Root.IO.DialogResult = $False })
    $Root.IO._Start.Add_Click(
    {  
        If ($Root.ShareName -in $Root.Shares.Name)
        {
            [System.Windows.MessageBox]::Show("A share with that name already exists","[!] Error")
        }

        ElseIf ($Root.Path -in $Root.Shares.Path)
        {
            [System.Windows.MessageBox]::Show("A share with that path already exists","[!] Error")
        }

        ElseIf (!$Root.IO._DCUsername.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid Username","[!] Error")
        }

        ElseIf ($Root.IO._DCPassword.Password -notmatch $Root.IO._DCConfirm.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid Password/Confirm","[!] Error")
        }
        
        ElseIf ($Root.IO._LMPassword.Password -notmatch $Root.IO._LMConfirm.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid Password/Confirm","[!] Error")
        }

        ElseIf (!(Test-Path $Root.IO._ImageRoot.Text))
        {
            [System.Windows.MessageBox]::Show("Invalid image source folder","[!] Error")
        }

        ElseIf (Test-Path $Root.IO._ImageSwap.Text)
        {
            [System.Windows.MessageBox]::Show("Path exists","[!] Error")
        }

        $Root.DCUsername      = $Root.IO._DCUsername.Text
        $Root.DCPassword      = $Root.IO._DCPassword.Password
        $Root.DCConfirm       = $Root.IO._DCConfirm.Password
        $Root.Credential      = [System.Management.Automation.PSCredential]::New($Root.DCUsername,$Root.IO._DCPassword.SecurePassword)
        $Root.LMUsername      = $Root.IO._LMUsername.Text
        $Root.LMPassword      = $Root.IO._LMPassword.Password
        $Root.LMConfirm       = $Root.IO._LMConfirm.Password
        $Root.ImageRoot       = $Root.IO._ImageRoot.Text
        $Root.ImageSwap       = $Root.IO._ImageSwap.Text
        $Root.OUName          = $Root.IO._OU.Text
        $Root.Key             = @{ 

            Organization      = $Root.Organization
            CommonName        = $Root.CommonName
            Background        = $Root.Background
            Logo              = $Root.Logo
            Phone             = $Root.Phone
            Hours             = $Root.Hours
            Website           = $Root.Website
            NetworkRoot       = ("\\{0}.{1}\{2}" -f $Env:ComputerName,$Root.CommonName,$Root.ShareName)
        }

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

    If ($Root.Window.IO.DialogResult)
    {
        $Root.NewFEImage()
        $Root.NewFEShare()
        $Root.ImportFEImage()
        $Root.UpdateFEShare(0)
    }
}
