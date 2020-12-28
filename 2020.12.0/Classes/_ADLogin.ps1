
Class _ADLogin
{
    [Object]                              $Window
    [Object]                                  $IO

    [String]                           $IPAddress
    [String]                             $DNSName
    [String]                             $NetBIOS

    [Object]                          $Credential
    [UInt32]                                $Port

    [String]                                  $DC
    [String]                           $Directory
    [Object]                            $Searcher
    [Object]                              $Return

    _ADLogin([Object]$Window,[Object]$Target)
    {
        $This.Window       = $Window
        $This.IO           = $This.Window.Host
        $This.IPAddress    = $Target.IPAddress
        $This.DNSName      = $Target.Hostname
        $This.NetBIOS      = $Target.NetBIOS
        $This.Port         = 389
        $This.DC           = $This.DNSName.Split(".")[0]
        $This.Directory    = "LDAP://$($This.DC)/CN=Partitions,CN=Configuration,DC=$($This.DNSName.Replace($This.DC + '.','').Split('.') -join ',DC=')"
    }

    TestCredential()
    {
        $Username      = $This.IO.Username.Text
        $Password      = $This.IO.Password.Password
        $Confirm       = $This.IO.Confirm.Password

        If (!$Username)
        {
            [Void][System.Windows.MessageBox]::Show("Invalid Username","Error")
        }

        ElseIf (!$Password)
        {
            [Void][System.Windows.MessageBox]::Show("Invalid Password","Error")
        }

        ElseIf (!$Password -match $Confirm)
        {
            [Void][System.Windows.MessageBox]::Show("Passwords do not match","Error")
        }

        Else
        {
            $This.Credential               = [System.Management.Automation.PSCredential]::New($Username,$This.IO.Confirm.SecurePassword)
        }
    }

    Init()
    {
        If ( ! $This.Credential )
        {
            Throw "No Credential"
        }

        $This.Searcher     = [System.DirectoryServices.DirectorySearcher]::New()
        $This.Searcher     | % {
                    
            $_.SearchRoot  = [System.DirectoryServices.DirectoryEntry ]::New($This.Directory,$This.Credential.Username,$This.Credential.GetNetworkCredential().Password)
            $_.PageSize    = 1000
            $_.PropertiesToLoad.Clear()
        }

        $This.Return       = ForEach ( $Item in $This.Searcher.FindAll() ) { $Item.Properties | ? netbiosname }
    }
}
