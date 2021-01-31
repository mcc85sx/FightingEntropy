Class _ADLogin
{
    [Object]                              $Window
    [Object]                                  $IO

    [String]                           $IPAddress
    [String]                             $DNSName
    [String]                              $Domain
    [String]                             $NetBIOS
    [UInt32]                                $Port

    [Object]                          $Credential
    [String]                            $Username
    [Object]                            $Password
    [Object]                             $Confirm

    [Int32]                                 $Code
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

    ClearADCredential()
    {
        $This.Credential   = $Null
        $This.Username     = $Null
        $This.Password     = $Null
        $This.Confirm      = $Null
    }

    CheckADCredential()
    {
        $This.Code         = -1
        $This.Username     = $This.IO.Username.Text
        $This.Password     = $This.IO.Password.Password
        $This.Confirm      = $This.IO.Confirm.Password
        
        If (!$This.Username)
        {
            $This.ClearADCredential()
            $This.Code     = 0
        }
        
        ElseIf (!$This.Password)
        {
            $This.ClearADCredential()
            $This.Code     = 1
        }
        
        ElseIf ($This.Password -ne $This.Confirm)
        {
            $This.ClearADCredential()
            $This.Code     = 2
        }

        Else
        {
            $This.Credential = [System.Management.Automation.PSCredential]::New($This.Username,$This.IO.Password.SecurePassword)
            $This.Test       = @( Try 
            {
                [System.DirectoryServices.DirectoryEntry]::New($This.Directory,$This.Credential.Username,$This.Credential.GetNetworkCredential().Password)
            }

            Catch
            {
                [System.Windows.MessageBox]::Show("Invalid Username")
            })

            If ($This.Test -eq $Null)
            {
                $This.ClearADCredential()
                $This.Code   = 3
            }

            If ($This.Test -ne $Null)
            {
                $This.Code   = 4
            }
        }
    }

    Initialize()
    {
        If ( $This.Code -eq 4 )
        {
            $This.Searcher                     = [System.DirectoryServices.DirectorySearcher]::New()
            $This.Searcher.SearchRoot          = [System.DirectoryServices.DirectoryEntry]::New($This.Directory,$This.Credential.Username,$This.Credential.GetNetworkCredential().Password)
            $This.Searcher.PageSize            = 1000
            $This.Searcher.PropertiesToLoad.Clear()
            $This.Result                       = $This.Searcher.FindAll()
        }

        Else
        {
            "Invalid operation"
        }
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
