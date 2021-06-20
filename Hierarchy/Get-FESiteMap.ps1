Function Get-FESiteMap
{
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory,Position=0)][String]$Organization,
        [Parameter(Mandatory,Position=1)][String]$CommonName
    )

    Class States
    {
        Static [Hashtable] $List            = @{

            "Alabama"                       = "AL" ; "Alaska"                        = "AK" ;
            "Arizona"                       = "AZ" ; "Arkansas"                      = "AR" ;
            "California"                    = "CA" ; "Colorado"                      = "CO" ;
            "Connecticut"                   = "CT" ; "Delaware"                      = "DE" ;
            "Florida"                       = "FL" ; "Georgia"                       = "GA" ;
            "Hawaii"                        = "HI" ; "Idaho"                         = "ID" ;
            "Illinois"                      = "IL" ; "Indiana"                       = "IN" ;
            "Iowa"                          = "IA" ; "Kansas"                        = "KS" ;
            "Kentucky"                      = "KY" ; "Louisiana"                     = "LA" ;
            "Maine"                         = "ME" ; "Maryland"                      = "MD" ;
            "Massachusetts"                 = "MA" ; "Michigan"                      = "MI" ;
            "Minnesota"                     = "MN" ; "Mississippi"                   = "MS" ;
            "Missouri"                      = "MO" ; "Montana"                       = "MT" ;
            "Nebraska"                      = "NE" ; "Nevada"                        = "NV" ;
            "New Hampshire"                 = "NH" ; "New Jersey"                    = "NJ" ;
            "New Mexico"                    = "NM" ; "New York"                      = "NY" ;
            "North Carolina"                = "NC" ; "North Dakota"                  = "ND" ;
            "Ohio"                          = "OH" ; "Oklahoma"                      = "OK" ;
            "Oregon"                        = "OR" ; "Pennsylvania"                  = "PA" ;
            "Rhode Island"                  = "RI" ; "South Carolina"                = "SC" ;
            "South Dakota"                  = "SD" ; "Tennessee"                     = "TN" ;
            "Texas"                         = "TX" ; "Utah"                          = "UT" ;
            "Vermont"                       = "VT" ; "Virginia"                      = "VA" ;
            "Washington"                    = "WA" ; "West Virginia"                 = "WV" ;
            "Wisconsin"                     = "WI" ; "Wyoming"                       = "WY" ;
            "American Samoa"                = "AS" ; "District of Columbia"          = "DC" ;
            "Guam"                          = "GU" ; "Marshall Islands"              = "MH" ;
            "Northern Mariana Island"       = "MP" ; "Puerto Rico"                   = "PR" ;
            "Virgin Islands"                = "VI" ; "Armed Forces Africa"           = "AE" ;
            "Armed Forces Americas"         = "AA" ; "Armed Forces Canada"           = "AE" ;
            "Armed Forces Europe"           = "AE" ; "Armed Forces Middle East"      = "AE" ;
            "Armed Forces Pacific"          = "AP" ;
        }

        States(){}

        Static [String] Name([String]$Code)
        {
            Return @( [States]::List | % GetEnumerator | ? Value -match $Code | % Name )
        }
    }

    Class ZipEntry
    {
        [String]       $Zip
        [String]      $Type
        [String]      $Name
        [String]     $State
        [String]   $Country
        [Float]       $Long
        [Float]        $Lat

        ZipEntry([String]$Line)
        {
            $String         = $Line -Split "`t"
            
            $This.Zip       = $String[0]
            $This.Type      = @("UNIQUE","STANDARD","PO_BOX","MILITARY")[$String[1]]
            $This.Name      = $String[2]
            $This.State     = $String[3]
            $This.Country   = $String[4]
            $This.Long      = $String[5]
            $This.Lat       = $String[6]
        }
    }

    Class ZipStack
    {
        [String]    $Path
        [Object] $Content
        ZipStack([String]$Path)
        {
            $This.Path    = $Path
            $This.Content = IRM $Path
        }

        [Object[]] ZipTown([String]$Zip)
        {
            $Value = [Regex]::Matches($This.Content,"($Zip)+.+").Value 
            
            If ( $Value -eq $Null )
            {
                Throw "No result found"
            }

            Else
            {
                $Return = @( )

                ForEach ($Item in $Value)
                {
                    $Return += [ZipEntry]$Item    
                }

                Return $Return
            }   
        }

        [Object[]] TownZip([String]$Town)
        {
            $Value = [Regex]::Matches($This.Content,"\d{5}\t\d{1}\t($Town)+.+").Value 
            
            If ( $Value -eq $Null )
            {
                Throw "No result found"
            }

            Else
            {
                $Return = @( )

                ForEach ($Item in $Value)
                {
                    $Return += [ZipEntry]$Item    
                }

                Return $Return
            }  
        }
    }
    
    Class Certificate
    {
        Hidden[String] $ExternalIP
        Hidden[Object]       $Ping
        [String]     $Organization
        [String]       $CommonName
        [String]         $Location
        [String]           $Region
        [String]          $Country
        [Int32]            $Postal
        [String]         $TimeZone
        [String]         $SiteName
        [String]         $SiteLink

        Certificate(
        [String]     $Organization ,
        [String]       $CommonName )
        {
            $This.Organization     = $Organization
            $This.CommonName       = $CommonName  
            $This.Prime()
        }

        Certificate([Object]$Sitemap)
        {
            $This.Organization     = $Sitemap.Organization
            $This.CommonName       = $Sitemap.CommonName
            $This.Prime()
        }

        Prime()
        {
            # These (2) lines are from Chrissie Lamaire's script
            # https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

            $This.ExternalIP       = Invoke-RestMethod http://ifconfig.me/ip 
            $This.Ping             = Invoke-RestMethod http://ipinfo.io/$($This.ExternalIP)

            $This.Location         = $This.Ping.City
            $This.Region           = $This.Ping.Region
            $This.Country          = $This.Ping.Country
            $This.Postal           = $This.Ping.Postal
            $This.TimeZone         = $This.Ping.TimeZone

            $This.SiteName         = $This.GetSiteLink(".")
            $This.SiteLink         = $This.GetSiteLink("-")
        }

        [String] GetSiteLink([String]$Token)
        {
            $Return                = @{ }

            # City
            $Return.Add(0,@(Switch -Regex ($This.Location)
            {
                "\s"
                {
                    ( $This.Location | % Split " " | % { $_[0] } ) -join ''
                }

                Default
                {
                    $This.Location[0,1] -join ''
                }
    
            }).ToUpper())

            # State
            $Return.Add(1,[States]::List[$This.Region])

            # Country
            $Return.Add(2,$This.Country)

            # Zip
            $Return.Add(3,$This.Postal)

            Return $Return[0..3] -join "$Token"
        }
    }

    Class Control
    {
        [String]$Organization
        [String]$CommonName
        Hidden [Object]$ZipStack
        [Object]$SiteMap
        Control([String]$Organization,[String]$CommonName)
        {
            $This.Organization = $Organization
            $This.CommonName   = $CommonName
            $This.ZipStack     = [ZipStack]::New("github.com/mcc85sx/FightingEntropy/blob/master/scratch/zcdb.txt?raw=true")
            $This.SiteMap      = @( )
        }

        [Object] NewCertificate()
        {
            Return @( [Certificate]::New($This.Organization,$This.CommonName) )
        }

        [Void]Load([Object]$Item)
        {
            If ($Item -eq $Null)
            {
                Throw "Item is null"
            }

            ElseIf ( $Item.Sitelink -in $This.Sitemap.Sitelink )
            {
                Throw "Item already exists"
            }

            Else
            {
                $This.SiteMap += $Item | Select-Object Location, Region, Country, Postal, Timezone, Sitelink
            }
        }

        [Void]Pull()
        {
            $This.Load([Certificate]::New($This))
        }
    }
    
    [Control]::New($Organization,$CommonName)
}

# $SM                = @{  

#     Organization   = "Secure Digits Plus LLC"
#     CommonName     = "securedigitsplus.com"

# }                  | % { Get-FESiteMap @_ -Verbose } 

# $SM                | % Pull                          # Main

# ForEach ( $Town in "Waterford","Ballston Spa","Ballston Lake","Albany","Troy","Schenectady")
# {
#    $Item              = $SM.ZipStack.TownZip($Town) | ? State -eq NY
    
#    If ( $Item.Count -gt 1 ) 
#    {
#        $Item          = $Item | Select-Object -First 1
#    }

#    $Tmp               = $SM.NewCertificate()
#    $Tmp[0].Location   = $Item.Name
#    $Tmp[0].Postal     = $Item.Zip

#    $Tmp[0].SiteLink   = $Tmp.GetSiteLink("-")
#    $Tmp[0].SiteName   = $Tmp.GetSiteLink(".")

#    Write-Theme 
#    $SM.Load($Tmp[0])
#}

# PS C:\windows\system32> $SM.Sitemap | FT

# Location      Region   Country Postal TimeZone         SiteLink       SiteName      
# --------      ------   ------- ------ --------         --------       --------      
# Clifton Park  New York US       12065 America/New_York CP-NY-US-12065 CP.NY.US.12065
# Waterford     New York US       12188 America/New_York WA-NY-US-12188 WA.NY.US.12188
# Ballston Spa  New York US       12020 America/New_York BS-NY-US-12020 BS.NY.US.12020
# Ballston Lake New York US       12019 America/New_York BL-NY-US-12019 BL.NY.US.12019
# Albany        New York US       12201 America/New_York AL-NY-US-12201 AL.NY.US.12201
# Troy          New York US       12180 America/New_York TR-NY-US-12180 TR.NY.US.12180
# Schenectady   New York US       12301 America/New_York SC-NY-US-12301 SC.NY.US.12301
