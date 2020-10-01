Class Certificate
{
    [String]       $ExternalIP
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
            
        # This line is all Chrissie Lamaire's
        Invoke-RestMethod http://ipinfo.io/$( Invoke-WebRequest http://ifconfig.me/ip | % Content ) -Method Get | % { 

            $This.ExternalIP   = $_.IP
            $This.Organization = $Organization
            $This.CommonName   = $CommonName
            $This.Location     = $_.City
            $This.Region       = $_.Region
            $This.Country      = $_.Country
            $This.Postal       = $_.Postal
            $This.TimeZone     = $_.TimeZone
        }
    }
}
