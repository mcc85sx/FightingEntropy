Class Site
    {
        [String]$Location
        [String]$Region
        [String]$Country
        [String]$Postal
        [String]$TimeZone
        [String]$SiteLink
        [String]$SiteName
        [String]$Network
        [String]$Netmask
        [String]$Start
        [String]$End
        [String]$Range
        [String]$Broadcast
        Site([Object]$Sitemap,[Object]$Network)
        {
            $This.Location  = $Sitemap.Location
            $This.Region    = $Sitemap.Region
            $This.Country   = $Sitemap.Country
            $This.Postal    = $Sitemap.Postal
            $This.Timezone  = $Sitemap.Timezone
            $This.Sitelink  = $Sitemap.Sitelink
            $This.Sitename  = $Sitemap.Sitename
            $This.Network   = $Network.Network
            $This.Netmask   = $Network.Netmask
            $This.Start     = $Network.Start
            $This.End       = $Network.End
            $This.Range     = $Network.Range
            $This.Broadcast = $Network.Broadcast
        }
    }