#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯\\   
#   //¯¯\\__[ The Situation ]_______________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   
#   //¯¯¯                                                                                                           //   
#   \\       You're a network administrator that wants to build a PKI infrastructure.                               \\   
#   //       You're about as tough as they come too. So... you don't mess around or play games.                     //   
#   \\       Some people might mess around or play games..? But- not you. Nope.                                     \\   
#   //       ¯¯¯¯ ¯¯¯¯¯¯                                         ¯¯¯ ¯¯¯                                            //   
#   \\       You want each site to pull variables from the environment, to assist with certifcate                   \\   
#   //       distribution, as well as allocation of Active Directory Sites and Services, Group Policy,              //   
#   \\       DHCP scopes, DNS registry, all of that fun stuff.                                                      \\   
#   //                                  ¯¯¯ ¯¯ ¯¯¯¯ ¯¯¯ ¯¯¯¯¯                                                       //   
#   \\       Because you're about as tough as they come, you want to scale out the topology logically.              \\   
#   //       Using network 172.128.0.0/19 [Reserve 172.128.0.*], build a virtual machine network.                   //   
#   \\                                                                                                              \\   
#   //       Network       Netmask       Start         End             Range                   Broadcast            //   
#   \\       -------       -------       -----         ---             -----                   ---------
#   //       172.128.0.0   255.255.224.0 172.128.0.0   172.128.31.255  172/128/0..31/0..255    172.128.31.255
#   \\       172.128.32.0  255.255.224.0 172.128.32.0  172.128.63.255  172/128/32..63/0..255   172.128.63.255
#   //       172.128.64.0  255.255.224.0 172.128.64.0  172.128.95.255  172/128/64..95/0..255   172.128.95.255
#   \\       172.128.96.0  255.255.224.0 172.128.96.0  172.128.127.255 172/128/96..127/0..255  172.128.127.255
#   //       172.128.128.0 255.255.224.0 172.128.128.0 172.128.159.255 172/128/128..159/0..255 172.128.159.255
#   \\       172.128.160.0 255.255.224.0 172.128.160.0 172.128.191.255 172/128/160..191/0..255 172.128.191.255
#   //       172.128.192.0 255.255.224.0 172.128.192.0 172.128.223.255 172/128/192..223/0..255 172.128.223.255
#   \\       172.128.224.0 255.255.224.0 172.128.224.0 172.128.255.255 172/128/224..255/0..255 172.128.255.255
#   \\                                                                                                              \\   
#   //       Site list: Clifton Park, Waterford, Ballston Spa, Ballston Lake, Albany, Troy, Schenectady             //
#   \\                                                                                                              \\
#            --------      ------   ------- ------ --------         --------       -------                          //
#            Location      Region   Country Postal TimeZone         SiteLink       Network                          \\
#            --------      ------   ------- ------ --------         --------       -------                          //
#            Clifton Park  New York US       12065 America/New_York CP-NY-US-12065 172.128.32.0                     \\   
#            Waterford     New York US       12188 America/New_York WA-NY-US-12188 172.128.64.0
#            Ballston Spa  New York US       12020 America/New_York BS-NY-US-12020 172.128.96.0
#            Ballston Lake New York US       12019 America/New_York BL-NY-US-12019 172.128.128.0
#            Albany        New York US       12201 America/New_York AL-NY-US-12201 172.128.160.0
#            Troy          New York US       12180 America/New_York TR-NY-US-12180 172.128.192.0
#            Schenectady   New York US       12301 America/New_York SC-NY-US-12301 172.128.224.0
#            ------------------------------------------------------------------------------------------

#            Certificates and DNS settings depend on the sitemap being built correctly.
#            Routing and remote access depend on proper gateway configuration.
#
#            Start by building out the logical topology for the gateways using virtual machines in Hyper-V
# 
#            Once the gateways are set, then each site can have a domain controller distributed via PXE

#            Prerequisites: []
#            
#   //                                                                                                           ___//   
#   \\___                                                                                                    ___//¯¯\\   
#   //¯¯\\__________________________________________________________________________________________________//¯¯¯___//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Press enter to continue    ]__________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

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

    Class Scope
    {
        [String]$Network
        [String]$Netmask
        Hidden [String[]]$Wildcard
        [String]$Start
        [String]$End
        [String]$Range
        [String]$Broadcast
        Scope([String]$Network,[String]$Netmask,[String]$Wildcard)
        {
            $This.Network  = $Network
            $This.Netmask  = $Netmask
            $This.Wildcard = $Wildcard -Split ","

            $NetworkSplit  = $Network  -Split "\."
            $NetmaskSplit  = $Netmask  -Split "\."
            $xStart         = @{ }
            $xEnd           = @{ }
            $xRange         = @{ }
            $xBroadcast     = @{ }

            ForEach ( $I in 0..3 )
            {
                $WC = $This.Wildcard[$I]
                $NS = [Int32]$NetworkSplit[$I]

                Switch($WC)
                {
                    1
                    {
                        $xStart.Add($I,$NS)
                        $xEnd.Add($I,$NS)
                        $xRange.Add($I,"$NS")
                        $xBroadcast.Add($I,$NS)
                    }

                    256
                    {
                        $xStart.Add($I,0)
                        $xEnd.Add($I,255)
                        $xRange.Add($I,"0..255")
                        $xBroadcast.Add($I,255)
                    }

                    Default
                    {
                        $xStart.Add($I,$NS)
                        $xEnd.Add($I,$NS+($WC-1))
                        $xRange.Add($I,"$($NS)..$($NS+($WC-1))")
                        $xBroadcast.Add($I,$NS+($WC-1))
                    }
                }
            }

            $This.Start = $xStart[0..3] -join '.'
            $This.End   = $xEnd[0..3] -join '.'
            $This.Range = $xRange[0..3] -join '/'
            $This.Broadcast = $xBroadcast[0..3] -join '.'
        }
    }

    Class Network
    {
        [String]$Network
        [String]$Prefix
        [String]$Netmask
        [Object[]]$Stack
        Network([String]$Network)
        {
            $Hash           = @{ }
            $NetworkHash    = @{ }
            $NetmaskHash    = @{ }
            $HostHash       = @{ }

            $This.Network   = $Network.Split("/")[0]
            $This.Prefix    = $Network.Split("/")[1]

            $NWSplit        = $This.Network.Split(".")
            $BinStr         = "{0}{1}" -f ("1" * $this.Prefix),("0" * (32-$This.Prefix))

            ForEach ( $I in 0..3 )
            {
                $Hash.Add($I,$BinStr.Substring(($I*8),8).ToCharArray())
            }

            ForEach ( $I in 0..3 )
            {
                Switch([UInt32]("0" -in $Hash[$I]))
                {
                    0
                    {
                        $NetworkHash.Add($I,$NWSplit[$I])
                        $NetmaskHash.Add($I,255)
                        $HostHash.Add($I,1)
                    }

                    1
                    {
                        $NwCt = ($Hash[$I] | ? { $_ -eq "1" }).Count
                        $HostHash.Add($I,(256,128,64,32,16,8,4,2,1)[$NwCt])

                        If ( $NwCt -eq 0)
                        {
                            $NetworkHash.Add($I,0)
                            $NetmaskHash.Add($I,0)
                        }

                        Else
                        {
                            $NetworkHash.Add($I,(128,64,32,16,8,4,2,1)[$NwCt-1])
                            $NetmaskHash.Add($I,(128,192,224,240,248,252,254,255)[$NwCt-1])
                        }
                    }
                }
            }

            $This.Netmask = $NetmaskHash[0..3] -join '.'

            $Hosts   = @{ }

            ForEach ( $I in 0..3 )
            {
                Switch ($HostHash[$I])
                {
                    1
                    {
                        $Hosts.Add($I,$NetworkHash[$I])
                    }

                    256
                    {
                        $Hosts.Add($I,0)
                    }

                    Default
                    {
                        $Hosts.Add($I,@(0..255 | ? { $_ % $HostHash[$I] -eq 0 }))
                    }
                }
            }

            $Wildcard = $HostHash[0..3] -join ','

            $Contain = @{ }

            ForEach ( $0 in $Hosts[0] )
            {
                ForEach ( $1 in $Hosts[1] )
                {
                    ForEach ( $2 in $Hosts[2] )
                    {
                        ForEach ( $3 in $Hosts[3] )
                        {
                            $Contain.Add($Contain.Count,"$0.$1.$2.$3")
                        }
                    }
                }
            }

            $This.Stack = 0..( $Contain.Count - 1 ) | % { [Scope]::New($Contain[$_],$This.Netmask,$Wildcard) }
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

            $This.GetSiteLink()
        }

        GetSiteLink()
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

            $This.SiteLink = $Return[0..3] -join "-"
            $This.SiteName = "{0}.{1}" -f ($Return[0..3] -join "."),$This.CommonName
        }
    }

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

    Class Control
    {
        [String]$Organization
        [String]$CommonName
        Hidden [Object]$ZipStack
        [Object]$SiteMap
        [Object]$Network
        [Object]$Gateway
        Control([String]$Organization,[String]$CommonName)
        {
            $This.Organization = $Organization
            $This.CommonName   = $CommonName
            $This.ZipStack     = [ZipStack]::New("github.com/mcc85sx/FightingEntropy/blob/master/scratch/zcdb.txt?raw=true")
            $This.SiteMap      = @( )
        }

        [Void] GetNetwork([String]$Network)
        {
            $This.Network      = [Network]::New($Network)
        }

        [Void] GetGateway()
        {
            If ($This.Network.Stack.Count -lt $This.Sitemap.Count)
            {
                Throw "Insufficient networks"
            }

            $This.Gateway = @( )
            ForEach ($X in 0..($This.Sitemap.Count - 1))
            {
                $This.Gateway += [Site]::New($This.Sitemap[$X],$This.Network.Stack[$X])
            }

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
                $This.SiteMap += $Item | Select-Object Location, Region, Country, Postal, Timezone, Sitelink, Sitename
            }
        }

        [Void]Pull()
        {
            $This.Load([Certificate]::New($This))
        }
    }
    
    [Control]::New($Organization,$CommonName)
}

$SM                = @{  

    Organization   = "Secure Digits Plus LLC"
    CommonName     = "securedigitsplus.com"

}                  | % { Get-FESiteMap @_ -Verbose }

$SM                | % Pull                          # Main
$SM.GetNetwork("172.128.0.0/19")
$SM.Network.Stack  = $SM.Network.Stack | ? Network -ne 172.128.0.0

ForEach ( $Town in "Waterford","Ballston Spa","Ballston Lake","Albany","Troy","Schenectady")
{
    $Item              = $SM.ZipStack.TownZip($Town) | ? State -eq NY
    
    If ( $Item.Count -gt 1 ) 
    {
        $Item = $Item | Select-Object -First 1
    }

    $Tmp               = $SM.NewCertificate()
    $Tmp[0].Location   = $Item.Name
    $Tmp[0].Postal     = $Item.Zip

    $Tmp.GetSiteLink()

    $SM.Load($Tmp[0])
}

$SM.GetGateway()

# Sample topology
$SM.Gateway

# Location  : Schenectady
# Region    : New York
# Country   : US
# Postal    : 12301
# TimeZone  : America/New_York
# SiteLink  : SC-NY-US-12301
# SiteName  : SC.NY.US.12301.securedigitsplus.com
# Network   : 172.128.224.0
# Netmask   : 255.255.224.0
# Start     : 172.128.224.0
# End       : 172.128.255.255
# Range     : 172/128/224..255/0..255
# Broadcast : 172.128.255.255
