Class Sitemap
    {
        [String]$Organization
        [String]$CommonName
        [Object]$Sitemap
        Sitemap([String]$Organization,$CommonName)
        {
            $This.Organization = $Organization
            $This.CommonName   = $CommonName
            $This.Sitemap      = @( )
        }
    }