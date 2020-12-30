Class _ADLogin
{
    [Object]                              $Window
    [Object]                                  $IO

    [String]                           $IPAddress
    [String]                             $DNSName
    [String]                              $Domain
    [String]                             $NetBIOS

    [Object]                          $Credential
    [UInt32]                                $Port

    [String]                                  $DC
    [String]                           $Directory
    Hidden [Object]                         $Test
    [Object]                            $Searcher
    [Object]                              $Result

    _ADLogin([Object]$Window,[Object]$Target)
    {
        $This.Window       = $Window
        $This.IO           = $Window.IO
        $This.IPAddress    = $Target.IPAddress
        $This.DNSName      = $Target.Hostname
        $This.NetBIOS      = $Target.NetBIOS
        $This.Port         = 389
        $This.DC           = $This.DNSName.Split(".")[0]
        $This.Domain       = $This.DNSName.Replace($This.DC + '.','')
        $This.Directory    = "LDAP://$( $This.DC )/CN=Partitions,CN=Configuration,DC=$( $This.Domain.Split('.') -join ',DC=')"
    }

    TestCredential()
    {
        $Username      = $This.IO.Username
        $Password      = $This.IO.Password
        $Confirm       = $This.IO.Confirm

        If (!$Username.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid Username","Error")
        }

        ElseIf (!$Password.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid Password","Error")
        }

        ElseIf (!$Password.Password -notmatch $Confirm.Password)
        {
            [System.Windows.MessageBox]::Show("Passwords do not match","Error")
        }

        Else
        {
            Try 
            {
                $This.Credential           = [System.Management.Automation.PSCredential]::New($Username.Text,$Confirm.SecurePassword)
                $This.Test                 = [System.DirectoryServices.DirectoryEntry]::New($This.Directory,$Username.Text,$Password.Password)

                If ( $? -eq $True )
                {
                    $This.Initialize()
                }
            }

            Catch
            {
                $This.Credential           = $Null
                $This.Test                 = $Null
                $Username                  = $Null
                $Password                  = $Null
                $Confirm                   = $Null

                [System.Windows.MessageBox]::Show("Invalid Account","Error")
            }
        }
    }

    Initialize()
    {
        $This.Searcher                     = [System.DirectoryServices.DirectorySearcher]::New()
        $This.Searcher.SearchRoot          = $This.Test
        $This.Searcher.PageSize            = 1000
        $This.Searcher.PropertiesToLoad.Clear()
        $This.Result                       = $This.Searcher.FindAll()
    }

    [Object] Search([String]$Field)
    {
        Return @( ForEach ( $Item in $This.Result ) { $Item.Properties | ? $Field.ToLower() } )
    }

    [String] GetSiteName()
    {
        Return @( $This.Search("fsmoroleowner").fsmoroleowner.Split(",")[3].Split("=")[1] )
    }

    [String] GetNetBIOSName()
    {
        Return @( $This.Search("netbiosname").netbiosname )
    }
}
