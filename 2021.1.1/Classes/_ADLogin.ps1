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

    [String]                            $Username
    [Object]                            $Password
    [Object]                             $Confirm

    [String]                                  $DC
    [String]                           $Directory
    [Object]                                $Test
    [Object]                            $Searcher
    [Object]                              $Result

    _ADLogin([Object]$Target)
    {
        $This.Window       = Get-XamlWindow -Type ADLogin
        $This.IO           = $This.Window.IO
        $This.IPAddress    = $Target.IPAddress
        $This.DNSName      = $Target.Hostname
        $This.NetBIOS      = $Target.NetBIOS
        $This.Port         = 389
        $This.DC           = $This.DNSName.Split(".")[0]
        $This.Domain       = $This.DNSName.Replace($This.DC + '.','')
        $This.Directory    = "LDAP://$( $This.DNSName )/CN=Partitions,CN=Configuration,DC=$( $This.Domain.Split( '.' ) -join ',DC=' )"
    }

    ClearCredential()
    {
        $This.Credential   = $Null
        $This.Username     = $Null
        $This.Password     = $Null
        $This.Confirm      = $Null
    }

    StartCredential()
    {
        $This.Username     = $This.IO.Username.Text
        $This.Password     = $This.IO.Password.Password
        $This.Confirm      = $This.IO.Confirm.Password
    }

    CheckCredential()
    {
        $This.StartCredential()
        
        If (!$This.Username)
        {
            [System.Windows.MessageBox]::Show("Invalid Username","Error")
            $This.ClearCredential()
        }
        
        ElseIf (!$This.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid Password","Error")
            $This.ClearCredential()
        }
        
        ElseIf ($This.Password -notmatch $This.Confirm)
        {
            [System.Windows.MessageBox]::Show("Passwords do not match","Error")
            $This.ClearCredential()
        }

        Else
        {
            $This.Credential = [System.Management.Automation.PSCredential]::New($This.Username,$This.IO.Password.SecurePassword)
            $This.Test       = $This.TestCredential($This.Credential)

            If (!$This.Test)
            {
                [System.Windows.MessageBox]::Show("Login Error")
                $This.ClearCredential()
            }

            Else
            {
                $This.Initialize($This.Test)
            }
        }
    }

    [Object] TestCredential([Object]$Credential)
    {
        Return @( Try 
        {
            [System.DirectoryServices.DirectoryEntry]::New($This.Directory,$Credential.Username,$Credential.GetNetworkCredential().Password)
        }

        Catch
        {
            $Null
        })
    }

    Initialize([Object]$SearchRoot)
    {
        $This.Searcher                     = [System.DirectoryServices.DirectorySearcher]::New()
        $This.Searcher.SearchRoot          = $SearchRoot
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
