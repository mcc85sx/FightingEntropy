
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

    Init([Object]$Credential)
    {
        $This.Searcher     = [System.DirectoryServices.DirectorySearcher]::New()
        $This.Searcher     | % {
                    
            $_.SearchRoot  = [ DirectoryEntry ]::New( $AD , $DCCred.Username , $DCCred.GetNetworkCredential().Password )
            $_.PageSize    = 1000
            $_.PropertiesToLoad.Clear()
        }

        $This.Return       = $This.Searcher.FindAll()
    }
}
