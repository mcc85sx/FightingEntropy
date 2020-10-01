# External reference for ipinfo.io/$IP doesn't seem to be working correctly in PS7... 5.1/ISE works fine
    Class Certificate
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

        Certificate(
        [String]     $Organization ,
        [String]       $CommonName )
        {
            If ( ! ( Test-Connection 1.1.1.1 -Count 1 ) ) 
            { 
                Throw "Unable to verify internet connection" 
            }
            
            [Net.ServicePointManager]::SecurityProtocol = 3072
            
            # This (2) lines from Chrissie Lamaire's script, 
            # https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

            $This.ExternalIP       = Invoke-WebRequest http://ifconfig.me/ip | % Content 
            $This.Ping             = Invoke-RestMethod http://ipinfo.io/$( $This.ExternalIP ) -Method Get
            $This.Organization     = $Organization
            $This.CommonName       = $CommonName
            $This.Location         = $This.Ping.City
            $This.Region           = $This.Ping.Region
            $This.Country          = $This.Ping.Country
            $This.Postal           = $This.Ping.Postal
            $This.TimeZone         = $This.Ping.TimeZone
        }
    }
    
    [Certificate]::New("Secure Digits Plus LLC","securedigitsplus.com")
