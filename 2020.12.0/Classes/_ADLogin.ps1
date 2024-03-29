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
    [Object]                                $Test
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
