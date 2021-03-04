Function New-ADObjectSet
{
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory)][Object]$Key)

    Class _DomainAdmin
    {
        [String] $Domain
        [String] $DN
        [String] $DC
        [String] $IPAddress
        [String] $HostName
        [String] $NetBIOS
        [String] $OU
        [String] $SG
        [Object] $Certificate

        _DomainAdmin(){}
    }

    Class _NewAccount
    {
        [Object]$Window
        [Object]$IO
        [Object]$Credential
        [Object]$Users
        [String]$GivenName
        [String]$Initials
        [String]$Surname
        [String]$DisplayName
        [String]$Username
        [String]$UserPrincipalName
        [Object]$Password

        _NewAccount([Object]$Credential)
        {
            $This.Credential = $Credential
            $This.GetWindow()
        }

        _NewAccount()
        {
            $This.Credential = Get-Credential
            $This.GetWindow()
        }

        GetWindow()
        {
            $This.Window = Get-XamlWindow -Type NewAccount
            $This.IO     = $This.Window.IO
            $This.Users  = Get-ADUser -Filter *
        }

        GetDisplayName()
        {
            If (!$This.IO._Initials.Text)
            {
                $This.DisplayName = "{0} {1}" -f $This.GivenName,$This.Surname
            }

            Else
            {
                $This.DisplayName = "{0} {1}. {2}" -f $This.GivenName,$This.Initials,$This.Surname
            }

            $This.IO._DisplayName.Text    = $This.DisplayName
        }

        GetUserName()
        {
            If (!$This.IO._Surname.Text)
            {
                If ($This.IO._GivenName.Text)
                {
                    $This.Username = $This.IO._GivenName.Text[0]
                }
                
                Else
                {
                    $This.Username = ""
                } 
            }

            Else
            {
                If (!$This.IO._GivenName.Text)
                {
                    $This.Username = ("{0}" -f $This.Surname.ToLower())
                }

                Else
                {
                    $This.Username = ("{0}{1}" -f $This.IO._GivenName.Text[0], $This.Surname.ToLower())
                }
            }

            $This.IO._Username.Text = $This.Username
        }
    }

    Class _TelemetryObject
    {
        [String]       $ExternalIP
        Hidden [Object]      $Ping
        [String]     $Organization
        [String]       $CommonName
        [String]         $Location
        [String]           $Region
        [String]          $Country
        [Int32]            $Postal
        [String]         $TimeZone
        [String]         $SiteLink
        [String]           $Branch

        _TelemetryObject([Object]$Key)
        {
            $This.ExternalIP       = Invoke-RestMethod "http://ifconfig.me/ip"
            $This.Ping             = Invoke-RestMethod "http://ipinfo.io/$($This.ExternalIP)"
            $This.Organization     = $Key.Organization
            $This.CommonName       = $Key.CommonName
            $This.Location         = $This.Ping.City
            $This.Region           = $This.Ping.Region
            $This.Country          = $This.Ping.Country
            $This.Postal           = $This.Ping.Postal
            $This.TimeZone         = $This.Ping.TimeZone
            $This.SiteLink         = $This.GetSiteLink($This.Ping)
            $This.Branch           = $This.Sitelink.Replace("-",".").tolower(), $This.CommonName -join '.'
        }

        [String] GetSiteLink([Object]$Ping)
        {
            $Return = @( )
            $Return += ( $Ping.City -Split " " | % { $_[0] } ) -join ''
            $Return += ( $Ping.Region -Split " " | % { $_[0] } ) -join ''
            $Return += $Ping.Country
            $Return += $Ping.Postal

            Return $Return -join '-'
        }

        [String] ToString()
        {
            Return $This.SiteLink
        }
    }

    Class _CompanyObject
    {
        [Object]        $Telemetry
        [String]             $Name
        [String]       $Background
        [String]             $Logo
        [String]            $Phone
        [String]          $Website
        [String]            $Hours

        _CompanyObject([Object]$Telemetry,[Object]$Key)
        {
            $This.Telemetry     = $Telemetry
            $This.Name          = $Key.Organization

            $Graphics           = Get-FEModule -Graphics

            If (!($Key.Background) -or (!(Test-Path $Key.Background)))
            {
                $Key.Background = $Graphics | ? Name -match OEMbg.jpg | % FullName
            }
        
            If (!($Key.Logo) -or (!(Test-Path $Key.Logo)))
            {
                $Key.Logo       = $Graphics | ? Name -match OEMlogo.bmp | % FullName
            }

            $This.Background    = $Key.Background
            $This.Logo          = $Key.Logo
            $This.Phone         = If(!$Key.Phone  ) { "N/A" } Else { $Key.Phone }
            $This.Website       = If(!$Key.Website) { "https://www.securedigitsplus.com" } Else { $Key.Website }
            $This.Hours         = If(!$Key.Hours  ) { "N/A" } Else { $Key.Hours }
        }

        [String] ToString()
        {
            Return $This.Name
        }
    }

    $Domain          = Get-ADDomain
    $Object          = [_TelemetryObject]::New($Key)
    $Company         = [_CompanyObject]::New($Object,$Key)

    $DN                = "DC=$( $Object.CommonName.Split( '.' ) -join ',DC=' )"
    $OUName            = "DevOPS(1)"
    $OUDN              = "OU=$OUName,$DN"

    # Check/Create OU
    $OrgUnit           = @{ 

        Name           = $OUName
        AuthType       = "Negotiate"
        DisplayName    = $OUName
        Description    = "App Developers / Security Engineers"
        State          = $Object.Region
        City           = $Object.Location
        Country        = $Object.Country
        PostalCode     = $Object.Postal
    }
    
    If (!( Get-ADOrganizationalUnit -Filter * | ? Name -eq $OUName ))
    {
        New-ADOrganizationalUnit @OrgUnit -Verbose
    }
    
    $SGName            = "Engineering(1)"
    $SGDN              = "CN=$SGName,$OUDN"

    # Create Security Group
    $SecGroup          = @{ 
    
        Name           = $SGName
        AuthType       = "Negotiate"
        GroupScope     = "Global"
        SamAccountName = $SGName
        Path           = $OUDN
        Description    = "Security Engineering"
        DisplayName    = $SGName
        GroupCategory  = "Security" 
    }

    If (!( Get-ADGroup -Filter * | ? Name -eq $SGName ))
    {
        New-ADGroup @SecGroup -Verbose
    }

    # Set Principal Group Membership
    $PG = @( )
    
    ForEach ( $Item in @(("Administrators","Builtin"),("Enterprise Admins","Users"),("Domain Admins","Users")))
    {
        $Splat             = @{ 
        
            Identity       = $SGName
            MemberOf       = "CN={0},CN={1},$DN" -f $Item[0,1]
        }

        If (!(Get-ADPrincipalGroupMembership -Identity $SGName))
        {
            Add-ADPrincipalGroupMembership @Splat -Verbose
        }

        $Splat

        $PG += $Splat
    }

    $DomainAdmin     = [_DomainAdmin]@{

        DN           = $Domain.DistinguishedName
        Domain       = $Domain.DNSRoot
        DC           = $Domain.PDCEmulator
        IPAddress    = $Domain.PDCEmulator | Resolve-DNSName | Select-Object -First 1 | % IPAddress
        Hostname     = $Domain.PDCEmulator
        NetBIOS      = $Domain.NetBIOSName
        OU           = $OUDN
        SG           = $SGDN
        Certificate  = @( )
    }

    $UI              = [_ADLogin]::New($DomainAdmin)
    
    $UI.IO.Switch.Add_Click({

        $UI.IO.Port.IsEnabled = $True
    })

    $UI.IO.Cancel.Add_Click(
    {
        $UI.Credential          = $Null
        $UI.IO.Username.Text    = ""
        $UI.IO.DialogResult     = $False
    })

     $UI.IO.Ok.Add_Click(
     {
        $UI.CheckADCredential()
        $UI.Port                = $UI.IO.Port.Text

        If ( $UI.Test.distinguishedName )
        {
            $UI.Searcher            = [System.DirectoryServices.DirectorySearcher]::New()
            $UI.Searcher            | % { 
                    
                $_.SearchRoot       = [System.DirectoryServices.DirectoryEntry]::New($UI.Directory,$UI.Credential.Username,$UI.Credential.GetNetworkCredential().Password)
                $_.PageSize         = 1000
                $_.PropertiestoLoad.Clear()
            }

            $UI.Result              = $UI.Searcher | % FindAll
            $UI.IO.DialogResult     = $True
        }

        Else
        {
            [System.Windows.MessageBox]::Show("Invalid Credentials")
        }
    })

    $UI.Window.Invoke()

    # Create Administrator Member

    $Credential                     = $UI.Credential
    $UI                             = [_NewAccount]::New($Credential)
    $UI.IO.Title                    = $UI.IO.Title.Replace("User","Admin")
    $UI.IO._Credential.Text         = $UI.Credential.UserName
    $UI.IO._Credential.IsEnabled    = $False

    $UI.IO._GivenName.Add_TextChanged({

        $UI.GivenName               = $UI.IO._GivenName.Text
        $UI.GetDisplayName()
        $UI.GetUserName()
    })

    $UI.IO._Initials.Add_TextChanged({

        $UI.Initials                = $UI.IO._Initials.Text
        $UI.GetDisplayName()
    })

    $UI.IO._Surname.Add_TextChanged({

        $UI.Surname                 = $UI.IO._Surname.Text
        $UI.GetDisplayName()
        $UI.GetUserName()
    })

    $UI.IO._Cancel.Add_Click({
        
        Write-Theme "Exception [!] Either the user cancelled, or the dialog failed." 12,4,15,0
        $UI.IO.DialogResult = $False
    })

    $UI.IO._Ok.Add_Click({
    
        If (($UI.IO._Password.Password -eq $Null)-or ($UI.IO._Password.Password -notmatch $UI.IO._Confirm.Password))
        {
            Write-Theme "Password [!] Does not match confirmation" 12,4,15,0
            [System.Windows.MessageBox]::Show("Invalid inpur","Exception [!]")
        }

        ElseIf (($UI.UserName -eq $Null) -or ($UI.UserName.Length -lt 4))
        {
            Write-Theme "Exception [!] Invalid Username input" 12,4,15,0
            [System.Windows.MessageBox]::Show("Invalid input","Exception [!]")
        }

        Else
        {
            $Member               = @{  
        
                Name              = $UI.Username
                GivenName         = $UI.GivenName
                Initials          = $UI.Initials
                Surname           = $UI.Surname
                DisplayName       = $UI.DisplayName
                UserPrincipalName = "{0}@{1}" -f $UI.Username,$Domain.DNSRoot
                AccountPassword   = $UI.IO._Password.SecurePassword
                Credential        = $Credential
                Enabled           = $True
                Path              = $OUDN
                Company           = $Company.Name
                City              = $Object.Location
                State             = $Object.Region
                Country           = $Object.Country
                PostalCode        = $Object.Postal
            }

            If ( $Member.UserPrincipalName -notin $UI.Users.UserPrincipalName )
            {
                Write-Theme "Creating [~] Username"
                
                New-ADUser @Member -Verbose 
                $User = Get-ADUser -Filter * | ? SamAccountName -eq $Member.Name 
                Add-ADGroupMember -Identity $SGDN -Members $User.DistinguishedName
                $User | Set-ADUser -Replace @{ 
                
                    primaryGroupID = ( Get-ADGroup $SGDN -Properties primaryGroupToken ).primaryGroupToken  
                    
                } -Verbose
                
                If ( $User )
                {
                    Write-Theme "Complete [+]"
                    $UI.IO.DialogResult   = $True
                }

                Else
                {
                    Throw "Error [!]"
                }
            }

            Else
            {
                Write-Theme "Exception [!] Invalid Username input" 12,4,15,0
                [System.Windows.MessageBox]::Show("Invalid Username","Exception [!]")
            }
        }
    })

    $UI.Window.Invoke()
}
