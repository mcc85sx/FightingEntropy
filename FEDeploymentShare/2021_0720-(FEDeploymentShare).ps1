#Function New-FEDeploymentShare # based off of https://github.com/mcc85sx/FightingEntropy/blob/master/FEDeploymentShare/FEDeploymentShare.ps1
#{
   
    # Load Assemblies
    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName System.Windows.Forms

    # Check for server operating system
    If ( (Get-CimInstance Win32_OperatingSystem).Caption -notmatch "Server" )
    {
        Throw "Must use Windows Server operating system"
    }

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
        Static [String] Name([String]$Code)
        {
            Return @( [States]::List | % GetEnumerator | ? Value -match $Code | % Name )
        }
        Static [String] Code([String]$State)
        {
            Return @( [States]::List | % GetEnumerator | ? Name -eq $State | % Value )
        }
        States(){}
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
        Hidden [UInt32[]]$Network_
        Hidden [UInt32] $Prefix
        [String]$Netmask
        Hidden [UInt32[]]$Netmask_
        [UInt32]$HostCount
        [Object]$HostObject
        [String]$Start
        [String]$End
        [String]$Range
        [String]$Broadcast
        Scope([String]$Network,[String]$Prefix,[String]$Netmask)
        {
            $This.Network    = $Network
            $This.Network_   = $Network -Split "\."
            $This.Prefix     = $Prefix
            $This.Netmask    = $Netmask
            $This.Netmask_   = $Netmask -Split "\."

            $WC             = ForEach ( $X in 0..3 )
            { 
                Switch($This.Netmask_[$X])
                {
                    255 { 1 } 0 { 256 } Default { 256 - $This.Netmask_[$X] }
                }
            }

            $This.HostCount = (Invoke-Expression ($WC -join "*")) - 2
            $SRange = @{}

            ForEach ( $X in 0..3 )
            {
                $SRange.Add($X,@(Switch($WC[$X])
                {
                    1 { $This.Network_[$X] }
                    Default 
                    {
                        "{0}..{1}" -f $This.Network_[$X],(([UInt32]$This.Network_[$X] + (256-$This.Netmask_[$X]))-1)
                    }
                    256 { "0..255" }
                }))
            }

            $This.Range      = @( 0..3 | % { $SRange[$_] }) -join '/'

            $XRange          = @{ }

            ForEach ( $0 in $SRange[0] | Invoke-Expression )
            {
                ForEach ( $1 in $SRange[1] | Invoke-Expression )
                {
                    ForEach ( $2 in $SRange[2] | Invoke-Expression )
                    {
                        ForEach ( $3 in $SRange[3] | Invoke-Expression )
                        {
                            $XRange.Add($XRange.Count,"$0.$1.$2.$3")
                        }
                    }
                }
            }

            $This.HostObject = @( 0..($XRange.Count-1) | % { $XRange[$_] } )
            $This.Start     = $This.HostObject[1]
            $This.End       = $This.HostObject[-2]
            $This.Broadcast = $This.HostObject[-1]
        }
        [String] ToString()
        {
            Return @($This.Network)
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

            $This.Stack = 0..( $Contain.Count - 1 ) | % { [Scope]::New($Contain[$_],$This.Prefix,$This.Netmask) }
        }
    }

    Class Topography
    {
        Hidden [String[]] $Enum = "True","False"
        [String] $SiteLink
        [String] $SiteName
        [UInt32] $Exists
        [Object] $DistinguishedName
        Topography([Object]$SM)
        {
            $This.Sitelink = $SM.Sitelink
            $This.Sitename = $SM.Sitename
            $Tmp           = Get-ADReplicationSite -Filter * | ? Name -match $SM.SiteLink
            If (!$Tmp)
            {
                $This.Exists = 0
            }

            Else
            {
                $This.Exists = 1
            }

            $This.DistinguishedName = $Tmp.DistinguishedName
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

            $This.SiteLink = ($Return[0..3] -join "-").ToUpper()
            $This.SiteName = ("{0}.{1}" -f ($Return[0..3] -join "-"),$This.CommonName).ToLower()
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
        [Object]$Stack
        [Object]$Control
        [Object]$Subject
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
            $This.Stack        = [Network]::New($Network).Stack
        }
        [Void] GetControl([String]$Master)
        {
            $This.Control      = $This.Stack | ? Network -eq $Master
        }
        [Void] GetGateway()
        {
            If ($This.Stack.Count -lt $This.Sitemap.Count)
            {
                Throw "Insufficient networks"
            }

            $This.Gateway = @( )
            ForEach ($X in 0..($This.Sitemap.Count - 1))
            {
                $This.Gateway += [Site]::New($This.Sitemap[$X],$This.Stack[$X])
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
    
    Class WindowsImage
    {
        [Uint32] $Index
        [String] $Name
        [String] $Description
        Hidden [Float]   $FileSize
        [String] $Size
        WindowsImage([Object]$Image)
        {
            If (!$Image)
            {
                Throw "No image input"
            }

            $This.Index       = $Image.ImageIndex
            $This.Name        = $Image.ImageName
            $This.Description = $Image.ImageDescription
            $This.FileSize    = $Image.ImageSize/1GB
            $This.Size        = "{0:n3} GB" -f $This.FileSize 
        }
    }

    Class ImageQueue
    {
        [String]  $Name
        [String]  $FullName
        [String]  $Index
        [String]  $Description
        ImageQueue([String]$FullName,[String]$Index,[String]$Description)
        {
            If (!$FullName -or !$Index)
            {
                Throw "Invalid selection"
            }

            $This.Name          = $FullName | Split-Path -Leaf
            $This.FullName      = $FullName
            $This.Index         = $Index
            $This.Description   = $Description
        }
    }

    Class ImageIndex
    {
        Hidden [UInt32] $Rank
        Hidden [UInt32] $SourceIndex
        Hidden [String] $SourceImagePath
        Hidden [String] $Path
        Hidden [String] $DestinationImagePath
        Hidden [String] $DestinationName
        Hidden [Object] $Disk
        [Object] $Label
        [UInt32] $ImageIndex            = 1
        [String] $ImageName
        [String] $ImageDescription
        [String] $Version
        [String] $Architecture
        [String] $InstallationType
        ImageIndex([Object]$Iso)
        {
            $This.SourceIndex           = $Iso.SourceIndex
            $This.SourceImagePath       = $Iso.SourceImagePath
            $This.DestinationImagePath  = $Iso.DestinationImagePath
            $This.DestinationName       = $Iso.DestinationName
            $This.Disk                  = Get-DiskImage -ImagePath $This.SourceImagePath
        }
        Load([String]$Target)
        {
            Get-WindowsImage -ImagePath $This.Path -Index $This.SourceIndex | % {

                $This.ImageName         = $_.ImageName
                $This.ImageDescription  = $_.ImageDescription
                $This.Architecture      = Switch ([UInt32]($_.Architecture -eq 9)) { 0 { 86 } 1 { 64 } }
                $This.Version           = $_.Version
                $This.InstallationType  = $_.InstallationType.Split(" ")[0]
            }

            Switch($This.InstallationType)
            {
                Server
                {
                    $Year    = [Regex]::Matches($This.ImageName,"(\d{4})").Value
                    $Edition = Switch -Regex ($This.ImageName) { STANDARD { "Standard" } DATACENTER { "Datacenter" } }
                    $This.DestinationName = "Windows Server $Year $Edition (x64)"
                    $This.Label           = "{0}{1}" -f $(Switch -Regex ($This.ImageName){Standard{"SD"}Datacenter{"DC"}}),[Regex]::Matches($This.ImageName,"(\d{4})").Value
                }

                Client
                {
                    $This.DestinationName = "{0} (x{1})" -f $This.ImageName, $This.Architecture
                    $This.Label           = "10{0}{1}"   -f $(Switch -Regex ($This.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }),$This.Architecture
                }
            }

            $This.DestinationImagePath    = "{0}\({1}){2}\{2}.wim" -f $Target,$This.Rank,$This.Label

            $Folder                       = $This.DestinationImagePath | Split-Path -Parent

            If (!(Test-Path $Folder))
            {
                New-Item -Path $Folder -ItemType Directory -Verbose
            }
        }
    }
    
    Class ImageFile
    {
        [ValidateSet("Client","Server")]
        [String]        $Type
        [String]        $Name
        [String] $DisplayName
        [String]        $Path
        [UInt32[]]     $Index
        ImageFile([String]$Type,[String]$Path)
        {
            $This.Type  = $Type

            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            $This.Name        = ($Path -Split "\\")[-1]
            $This.DisplayName = "($Type)($($This.Name))"
            $This.Path        = $Path
            $This.Index       = @( )
        }
        AddMap([UInt32[]]$Index)
        {
            ForEach ( $I in $Index )
            {
                $This.Index  += $I
            }
        }
    }

    Class ImageStore
    {
        [String]   $Source
        [String]   $Target
        [Object[]]  $Store
        [Object[]]   $Swap
        [Object[]] $Output
        ImageStore([String]$Source,[String]$Target)
        {
            If ( ! ( Test-Path $Source ) )
            {
                Throw "Invalid image base path"
            }

            If ( !(Test-Path $Target) )
            {
                New-Item -Path $Target -ItemType Directory -Verbose
            }

            $This.Source = $Source
            $This.Target = $Target
            $This.Store  = @( )
        }
        AddImage([String]$Type,[String]$Name)
        {
            $This.Store += [ImageFile]::New($Type,"$($This.Source)\$Name")
        }
        GetSwap()
        {
            $This.Swap = @( )
            $Ct        = 0

            ForEach ( $Image in $This.Store )
            {
                ForEach ( $Index in $Image.Index )
                {
                    $Iso                     = @{ 

                        SourceIndex          = $Index
                        SourceImagePath      = $Image.Path
                        DestinationImagePath = ("{0}\({1}){2}({3}).wim" -f $This.Target, $Ct, $Image.DisplayName, $Index)
                        DestinationName      = "{0}({1})" -f $Image.DisplayName,$Index
                    }

                    $Item                    = [ImageIndex]::New($Iso)
                    $Item.Rank               = $Ct
                    $This.Swap              += $Item
                    $Ct                     ++
                }
            }
        }
        GetOutput()
        {
            $Last = $Null

            ForEach ( $X in 0..( $This.Swap.Count - 1 ) )
            {
                $Image       = $This.Swap[$X]

                If ( $Last -ne $Null -and $Last -ne $Image.SourceImagePath )
                {
                    Write-Theme "Dismounting... $Last" 12,4,15,0
                    Dismount-DiskImage -ImagePath $Last -Verbose
                }

                If (!(Get-DiskImage -ImagePath $Image.SourceImagePath).Attached)
                {
                    Write-Theme ("Mounting [+] {0}" -f $Image.SourceImagePath) 14,6,15,0
                    Mount-DiskImage -ImagePath $Image.SourceImagePath
                }

                $Image.Path = "{0}:\sources\install.wim" -f (Get-DiskImage -ImagePath $Image.SourceImagePath | Get-Volume | % DriveLetter)

                $Image.Load($This.Target)

                $ISO                        = @{

                    SourceIndex             = $Image.SourceIndex
                    SourceImagePath         = $Image.Path
                    DestinationImagePath    = $Image.DestinationImagePath
                    DestinationName         = $Image.DestinationName
                }

                Write-Theme "Extracting [~] $($Iso.DestinationImagePath)" 11,7,15,0
                Export-WindowsImage @ISO
                Write-Theme "Extracted [+] $($Iso.DestinationName)" 10,10,15,0

                $Last                       = $Image.SourceImagePath
                $This.Output               += $Image
            }

            Dismount-DiskImage -ImagePath $Last
        }
    }
    
    Class XamlWindow 
    {
        Hidden [Object]        $XAML
        Hidden [Object]         $XML
        [String[]]            $Names
        [Object]               $Node
        [Object]                 $IO
        [String[]] FindNames()
        {
            Return @( [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % { 

                ($_-Replace "(\s+)(Name|=|'|`"|\s)","").Split('"')[1] 

            } | Select-Object -Unique ) 
        }
        XamlWindow([String]$XAML)
        {           
            If ( !$Xaml )
            {
                Throw "Invalid XAML Input"
            }

            [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

            $This.Xaml               = $Xaml
            $This.XML                = [XML]$Xaml
            $This.Names              = $This.FindNames()
            $This.Node               = [System.XML.XmlNodeReader]::New($This.XML)
            $This.IO                 = [System.Windows.Markup.XAMLReader]::Load($This.Node)

            ForEach ( $I in 0..( $This.Names.Count - 1 ) )
            {
                $Name                = $This.Names[$I]
                $This.IO             | Add-Member -MemberType NoteProperty -Name $Name -Value $This.IO.FindName($Name) -Force 
            }
        }
        Invoke()
        {
            $This.IO.Dispatcher.InvokeAsync({ $This.IO.ShowDialog() }).Wait()
        }
    }
    
    Class DGList
    {
        [String]$Name
        [Object]$Value
        DGList([String]$Name,[Object]$Value)
        {
            $This.Name  = $Name
            $This.Value = $Value
        }
    }

    Class Domain
    {
        [String] $Organization
        [String] $CommonName
        [String] $Location
        [String] $Region
        [String] $Country
        [String] $Postal
        [String] $TimeZone
        [String] $SiteLink
        [String] $SiteName
        Domain([Object]$Domain)
        {

        }
    }
    
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
    
    Class Key
    {
        [String]     $NetworkPath
        [String]    $Organization
        [String]      $CommonName
        [String]      $Background
        [String]            $Logo
        [String]           $Phone
        [String]           $Hours
        [String]         $Website
        Key([Object]$Root)
        {
            $This.NetworkPath     = $Root[0]
            $This.Organization    = $Root[1]
            $This.CommonName      = $Root[2]
            $This.Background      = $Root[3]
            $This.Logo            = $Root[4]
            $This.Phone           = $Root[5]
            $This.Hours           = $Root[6]
            $This.Website         = $Root[7]
        }
    }

    Class WimFile
    {
        [UInt32] $Rank
        [Object] $Label
        [UInt32] $ImageIndex            = 1
        [String] $ImageName
        [String] $ImageDescription
        [String] $Version
        [String] $Architecture
        [String] $InstallationType
        [String] $SourceImagePath
        WimFile([UInt32]$Rank,[String]$Image)
        {
            If ( ! ( Test-Path $Image ) )
            {
                Throw "Invalid Path"
            }

            $This.SourceImagePath       = $Image
            $This.Rank                  = $Rank

            Get-WindowsImage -ImagePath $Image -Index 1 | % {
                
                $This.Version           = $_.Version
                $This.Architecture      = @(86,64)[$_.Architecture -eq 9]
                $This.InstallationType  = $_.InstallationType
                $This.ImageName         = $_.ImageName
                $This.Label             = Switch($This.InstallationType)
                {
                    Server
                    {
                        "{0}{1}" -f $(Switch -Regex ($This.ImageName){Standard{"SD"}Datacenter{"DC"}}),[Regex]::Matches($This.ImageName,"(\d{4})").Value
                    }

                    Client
                    {
                        "10{0}{1}" -f $(Switch -Regex ($This.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }),$This.Architecture
                    }
                }

                $This.ImageDescription  = Get-Date -UFormat "[%Y-%m%d (MCC/SDP)][$($This.Label)]"

                If ( $This.ImageName -match "Evaluation" )
                {
                    $This.ImageName     = $This.ImageName -Replace "Evaluation \(Desktop Experience\) ",""
                }
            }
        }
    }

    Class BootImage
    {
        [Object] $Path
        [Object] $Name
        [Object] $Type
        [Object] $ISO
        [Object] $WIM
        [Object] $XML
        BootImage([String]$Path,[String]$Name)
        {
            $This.Path = $Path
            $This.Name = $Name
            $This.Type = Switch ([UInt32]($This.Name -match "\(x64\)")) { 0 { "x86" } 1 { "x64" } }
            $This.ISO  = "$Path\$Name.iso"
            $This.WIM  = "$Path\$Name.wim"
            $This.XML  = "$Path\$Name.xml"
        }
    }

    Class BootImages
    {
        [Object] $Images
        BootImages([Object]$Directory)
        {
            $This.Images = @( )

            ForEach ( $Item in Get-ChildItem $Directory | ? Extension | % BaseName | Select-Object -Unique )
            {
                $This.Images += [BootImage]::New($Directory,$Item)
            }
        }
    }
    
    Class FEDeploymentShareGUI
    {
        Static [String] $Tab = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://New Deployment Share" Width="640" Height="780" Topmost="True" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\icon.ico" ResizeMode="NoResize" FontWeight="SemiBold" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">
        <Window.Resources>
            <Style TargetType="GroupBox" x:Key="xGroupBox">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="Background" Value="LightYellow"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="GroupBox">
                            <Border CornerRadius="10" Background="LightYellow" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="Button">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="VerticalAlignment" Value="Center"/>
                <Setter Property="FontWeight" Value="Medium"/>
                <Setter Property="Padding" Value="10"/>
                <Setter Property="Margin" Value="10"/>
                <Setter Property="Height" Value="32"/>
                <Setter Property="Foreground" Value="White"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border CornerRadius="10" Background="#007bff" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="TabControl">
                <Setter Property="Background" Value="LightYellow"/>
            </Style>
            <Style TargetType="TabItem">
                <Setter Property="TextBlock.TextAlignment" Value="Center"/>
                <Setter Property="VerticalAlignment" Value="Center"/>
                <Setter Property="FontWeight" Value="Medium"/>
                <Setter Property="Padding" Value="10"/>
                <Setter Property="Margin" Value="10"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="TabItem">
                            <Border CornerRadius="10" Background="#007bff" BorderBrush="Black" BorderThickness="3">
                                <ContentPresenter x:Name="ContentPresenter" ContentTemplate="{TemplateBinding ContentTemplate}" Margin="5"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType="TextBox">
                <Setter Property="TextBlock.TextAlignment" Value="Left"/>
                <Setter Property="VerticalContentAlignment" Value="Center"/>
                <Setter Property="HorizontalContentAlignment" Value="Left"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="TextWrapping" Value="Wrap"/>
                <Setter Property="Height" Value="24"/>
            </Style>
            <Style TargetType="DataGrid">
                <Setter Property="Margin" Value="5"/>
                <Setter Property="HorizontalAlignment" Value="Center"/>
                <Setter Property="AutoGenerateColumns" Value="False"/>
                <Setter Property="AlternationCount" Value="2"/>
                <Setter Property="HeadersVisibility" Value="Column"/>
                <Setter Property="CanUserResizeRows" Value="False"/>
                <Setter Property="CanUserAddRows" Value="False"/>
                <Setter Property="IsTabStop" Value="True" />
                <Setter Property="IsTextSearchEnabled" Value="True"/>
                <Setter Property="IsReadOnly" Value="True"/>
                <Setter Property="TextBlock.HorizontalAlignment" Value="Left"/>
            </Style>
            <Style TargetType="DataGridRow">
                <Setter Property="TextBlock.HorizontalAlignment" Value="Left"/>
                <Style.Triggers>
                    <Trigger Property="AlternationIndex" Value="0">
                        <Setter Property="Background" Value="White"/>
                    </Trigger>
                    <Trigger Property="AlternationIndex" Value="1">
                        <Setter Property="Background" Value="#FFCDF7F7"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
            <Style TargetType="DataGridColumnHeader">
                <Setter Property="FontSize"   Value="10"/>
            </Style>
            <Style TargetType="DataGridCell">
                <Setter Property="TextBlock.TextAlignment" Value="Left"/>
            </Style>
            <Style TargetType="PasswordBox">
                <Setter Property="Height" Value="24"/>
                <Setter Property="HorizontalContentAlignment" Value="Left"/>
                <Setter Property="VerticalContentAlignment" Value="Center"/>
                <Setter Property="TextBlock.HorizontalAlignment" Value="Stretch"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="PasswordChar" Value="*"/>
            </Style>
            <Style TargetType="ComboBox">
                <Setter Property="Margin" Value="10"/>
                <Setter Property="Height" Value="24"/>
            </Style>
        </Window.Resources>
        <Grid Background="LightYellow">
            <GroupBox Style="{StaticResource xGroupBox}"  Grid.Row="0" Margin="10" Padding="10" Foreground="Black" Background="LightYellow">
                <TabControl Grid.Row="1" BorderBrush="Black" Foreground="{x:Null}">
                    <TabControl.Resources>
                        <Style TargetType="TabItem">
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="TabItem">
                                        <Border Name="Border" BorderThickness="1,1,1,0" BorderBrush="Gainsboro" CornerRadius="4,4,0,0" Margin="2,0">
                                            <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Center" ContentSource="Header" Margin="10,2"/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property="IsSelected" Value="True">
                                                <Setter TargetName="Border" Property="Background" Value="LightSkyBlue"/>
                                            </Trigger>
                                            <Trigger Property="IsSelected" Value="False">
                                                <Setter TargetName="Border" Property="Background" Value="GhostWhite"/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </TabControl.Resources>
                    <TabItem Header="Config">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="200"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="60"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[CfgServices (Dependency Snapshot)]">
                                <DataGrid Name="CfgServices">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"      Binding="{Binding Name}"  Width="150"/>
                                        <DataGridTextColumn Header="Installed/Meets minimum requirements" Binding="{Binding Value}" Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <TabControl Grid.Row="1">
                                <TabItem Header="Dhcp">
                                    <GroupBox Header="[CfgDhcp (Dynamic Host Control Protocol)]">
                                        <DataGrid Name="CfgDhcp">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="Dns">
                                    <GroupBox Header="[CfgDns (Domain Name Service)]">
                                        <DataGrid Name="CfgDns">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="Adds">
                                    <GroupBox Header="[CfgAdds (Active Directory Directory Service)">
                                        <DataGrid Name="CfgAdds">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="Wds">
                                    <GroupBox Header="[CfgWds (Windows Deployment Services)]">
                                        <DataGrid Name="CfgWds">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="Mdt">
                                    <GroupBox Header="[CfgMdt (Microsoft Deployment Toolkit)]">
                                        <DataGrid Name="CfgMdt">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="WinAdk">
                                    <GroupBox Header="[CfgWinAdk (Windows Assessment and Deployment Kit)]">
                                        <DataGrid Name="CfgWinAdk">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="WinPE">
                                    <GroupBox Header="[CfgWinPE (Windows Preinstallation Environment Kit)]">
                                        <DataGrid Name="CfgWinPE">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                                <TabItem Header="IIS">
                                    <GroupBox Header="[CfgIIS (Internet Information Services)]">
                                        <DataGrid Name="CfgIIS">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="150"/>
                                                <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </GroupBox>
                                </TabItem>
                            </TabControl>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Domain" BorderBrush="{x:Null}">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="120"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[DcOrganization]">
                                    <TextBox Name="DcOrganization"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[DcCommonName]">
                                    <TextBox Name="DcCommonName"/>
                                </GroupBox>
                                <Button Grid.Column="2" Name="DcGetSitename" Content="Get Sitename"/>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[DcAggregate]">
                                <DataGrid Name="DcAggregate"
                                                  ScrollViewer.CanContentScroll="True"
                                                  ScrollViewer.IsDeferredScrollingEnabled="True"
                                                  ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Location" Binding='{Binding Location}' Width="100"/>
                                        <DataGridTextColumn Header="Region"   Binding='{Binding Region}' Width="60"/>
                                        <DataGridTextColumn Header="Country"  Binding='{Binding Country}' Width="60"/>
                                        <DataGridTextColumn Header="Postal"   Binding='{Binding Postal}' Width="60"/>
                                        <DataGridTextColumn Header="SiteLink" Binding='{Binding SiteLink}' Width="120"/>
                                        <DataGridTextColumn Header="TimeZone" Binding='{Binding TimeZone}' Width="120"/>
                                        <DataGridTextColumn Header="SiteName" Binding='{Binding SiteName}' Width="Auto"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="2" Margin="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="120"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="DcAddSitename" Content="Add"/>
                                <GroupBox Grid.Column="1" Header="[DcAddSitenameZip]">
                                    <TextBox Name="DcAddSitenameZip"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[DcAddSitenameTown]" IsEnabled="False">
                                    <TextBox Name="DcAddSitenameTown"/>
                                </GroupBox>
                                <Button Grid.Column="3" Name="DcRemoveSitename" Content="Remove"/>
                            </Grid>
                            <GroupBox Grid.Row="3" Header="[DcViewer]">
                                <DataGrid Name="DcViewer">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Name}'  Width="125"/>
                                        <DataGridTextColumn Header="Value" Binding='{Binding Value}' Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <GroupBox Grid.Row="4" Header="[DcTopography]">
                                <DataGrid Name="DcTopography"
                                                  ScrollViewer.CanContentScroll="True"
                                                  ScrollViewer.IsDeferredScrollingEnabled="True"
                                                  ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="SiteLink" Binding="{Binding SiteLink}" Width="150"/>
                                        <DataGridTextColumn Header="Sitename" Binding="{Binding SiteName}" Width="200"/>
                                        <DataGridTemplateColumn Header="Exists" Width="50">
                                            <DataGridTemplateColumn.CellTemplate>
                                                <DataTemplate>
                                                    <ComboBox SelectedIndex="{Binding Exists}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">
                                                        <ComboBoxItem Content="No"/>
                                                        <ComboBoxItem Content="Yes"/>
                                                    </ComboBox>
                                                </DataTemplate>
                                            </DataGridTemplateColumn.CellTemplate>
                                        </DataGridTemplateColumn>
                                        <DataGridTextColumn Header="Distinguished Name" Binding="{Binding DistinguishedName}" Width="400"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="6">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="DcGetTopography" Content="Get"/>
                                <Button Grid.Column="1" Name="DcNewTopography" Content="New"/>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Network" BorderBrush="{x:Null}">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="100"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Row="0" Header="[NwScope]">
                                    <TextBox Grid.Column="0" Name="NwScope"/>
                                </GroupBox>
                                <Button Grid.Column="1" Name="NwScopeLoad" Content="Load" IsEnabled="False"/>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[NwStack]">
                                <DataGrid Name="NwStack"
                                                  ScrollViewer.CanContentScroll="True" 
                                                  ScrollViewer.IsDeferredScrollingEnabled="True"
                                                  ScrollViewer.HorizontalScrollBarVisibility="Visible">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Network"   Binding="{Binding Network}"   Width="*"/>
                                        <DataGridTextColumn Header="Netmask"   Binding="{Binding Netmask}"   Width="*"/>
                                        <DataGridTextColumn Header="HostCount" Binding="{Binding HostCount}" Width="*"/>
                                        <DataGridTextColumn Header="Start"     Binding="{Binding Start}"     Width="*"/>
                                        <DataGridTextColumn Header="End"       Binding="{Binding End}"       Width="*"/>
                                        <DataGridTextColumn Header="Range"     Binding="{Binding Range}"     Width="*"/>
                                        <DataGridTextColumn Header="Broadcast" Binding="{Binding Broadcast}" Width="Auto"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[NwSelected]">
                                <DataGrid Name="NwSelected">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"   Binding="{Binding Network}"   Width="200"/>
                                        <DataGridTextColumn Header="Value"   Binding="{Binding Netmask}"   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="NwAddNetwork" Content="Add"/>
                                <Button Grid.Column="1" Name="NwRemoveNetwork" Content="Remove"/>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[NwSlated]">
                                <DataGrid Name="NwSlated">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"   Binding="{Binding Network}"   Width="*"/>
                                        <DataGridTextColumn Header="Value"   Binding="{Binding Netmask}"   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="NwGetNetwork" Content="Get"/>
                                <Button Grid.Column="1" Name="NwNewNetwork" Content="New"/>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Gateway" BorderBrush="{x:Null}">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[GwSiteCount]">
                                    <TextBox Name="GwSiteCount"></TextBox>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[GwNetworkCount]">
                                    <TextBox Name="GwNetworkCount"></TextBox>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="1" Header="[GwAggregate)]">
                                <DataGrid Name="GwAggregate">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Network}" Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[GwSelected]">
                                <DataGrid Name="GwSelected">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"   Binding="{Binding Network}"   Width="200"/>
                                        <DataGridTextColumn Header="Value"   Binding="{Binding Netmask}"   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="GwAddGateway" Content="Add"/>
                                <Button Grid.Column="1" Name="GwRemoveGateway" Content="Remove"/>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[GwSlated]">
                                <DataGrid Name="GwSlated">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"   Binding="{Binding Network}"   Width="200"/>
                                        <DataGridTextColumn Header="Value"   Binding="{Binding Netmask}"   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="GwGetGateway" Content="Get"/>
                                <Button Grid.Column="1" Name="GwNewGateway" Content="New"/>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Imaging" BorderBrush="{x:Null}">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="125"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="125"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="100"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Header="[IsoPath (Source Directory)]">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="100"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Button Name="IsoSelect" Grid.Column="0" Content="Select"/>
                                        <TextBox Name="IsoPath"  Grid.Column="1"/>
                                    </Grid>
                                </GroupBox>
                                <Button Name="IsoScan" Grid.Column="1" Content="Scan"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <GroupBox Header="[IsoList (*.iso)]">
                                    <DataGrid Name="IsoList">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Name" Binding='{Binding Name}' Width="*"/>
                                            <DataGridTextColumn Header="Path" Binding='{Binding Fullname}' Width="2*"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="IsoMount" Content="Mount" IsEnabled="False"/>
                                <Button Grid.Column="1" Name="IsoDismount" Content="Dismount" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="3">
                                <GroupBox Header="[IsoView (Image Viewer)]">
                                    <DataGrid Name="IsoView">
                                        <DataGrid.Columns>
                                            <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="40"/>
                                            <DataGridTextColumn Header="Name"  Binding='{Binding Name}' Width="*"/>
                                            <DataGridTextColumn Header="Size"  Binding='{Binding Size}' Width="100"/>
                                        </DataGrid.Columns>
                                    </DataGrid>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="WimQueue" Content="Queue" IsEnabled="False"/>
                                <Button Grid.Column="1" Name="WimDequeue" Content="Dequeue" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="5">
                                <GroupBox Header="[WimIso (Queue)]">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="40"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <Grid Margin="5">
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height="*"/>
                                                <RowDefinition Height="*"/>
                                            </Grid.RowDefinitions>
                                            <Button Grid.Row="0" Name="WimIsoUp" Content="˄" Margin="0"/>
                                            <Button Grid.Row="1" Name="WimIsoDown" Content="˅" Margin="0"/>
                                        </Grid>
                                        <DataGrid Grid.Column="1" Name="WimIso">
                                            <DataGrid.Columns>
                                                <DataGridTextColumn Header="Name"  Binding='{Binding FullName}' Width="*"/>
                                                <DataGridTextColumn Header="Index" Binding='{Binding Index}' Width="100"/>
                                            </DataGrid.Columns>
                                        </DataGrid>
                                    </Grid>
                                </GroupBox>
                            </Grid>
                            <GroupBox Grid.Row="7" Header="[WimPath (Target)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="100"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="100"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Name="WimSelect" Grid.Column="0" Content="Select"/>
                                    <TextBox Grid.Column="1" Name="WimPath"/>
                                    <Button Grid.Column="2" Name="WimExtract" Content="Extract"/>
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Updates" BorderBrush="{x:Null}">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="150"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row="0" Header="[UpdPath (Updates)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="100"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="100"/>
                                    </Grid.ColumnDefinitions>
                                    <Button Grid.Column="0" Name="UpdSelect" Content="Select"/>
                                    <TextBox Grid.Column="1" Name="UpdPath"/>
                                    <Button Grid.Column="2" Name="UpdScan" Content="Scan"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row="1" Header="[UpdList]">
                                <DataGrid Name="UpdList">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                                        <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="*"/>
                                        <DataGridCheckBoxColumn Header="Install" Binding="{Binding Install}" Width="50"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <GroupBox Grid.Row="2" Header="[UpdSelected]">
                                <DataGrid Name="UpdSelected">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="200"/>
                                        <DataGridTextColumn Header="Value" Binding="{Binding value}" Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="UpdAddUpdate" Content="Add"/>
                                <Button Grid.Column="1" Name="UpdRemoveUpdate" Content="Remove"/>
                            </Grid>
                            <GroupBox Grid.Row="4" Header="[UpdWim]">
                                <DataGrid Name="UpdWim">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                                        <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="*"/>
                                        <DataGridCheckBoxColumn Header="Install" Binding="{Binding Install}" Width="50"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </GroupBox>
                            <Grid Grid.Row="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="UpdInstallUpdate" Content="Install"/>
                                <Button Grid.Column="1" Name="UpdUninstallUpdate" Content="Uninstall"/>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header="Share">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="75"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="75"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0" Margin="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="100"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="150"/>
                                </Grid.ColumnDefinitions>
                                <Button Name="DsRootSelect" Grid.Column="0" Content="Select"/>
                                <GroupBox Grid.Column="1" Header="[DsRootPath (FileSystem Root)]">
                                    <TextBox Name="DsRootPath"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[DsShareName (SAMBA)]">
                                    <TextBox Name="DsShareName"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="150"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="150"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[DsDriveName (PSDrive)]">
                                    <TextBox Name="DsDriveName"/>
                                </GroupBox>
                                <GroupBox Grid.Column="1" Header="[DsDescription]">
                                    <TextBox Name="DsDescription"/>
                                </GroupBox>
                                <GroupBox Grid.Column="2" Header="[Legacy MDT/PSD]">
                                    <ComboBox Name="DsType">
                                        <ComboBoxItem Content="MDT" IsSelected="True"/>
                                        <ComboBoxItem Content="PSD"/>
                                    </ComboBox>
                                </GroupBox>
                            </Grid>
                            <TabControl Grid.Row="2">
                                <TabItem Header="Domain Admin">
                                    <Grid  VerticalAlignment="Top">
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row="0" Header="[Domain Admin Username]">
                                            <TextBox Name="DsDcUsername"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="1" Header="[Password/Confirm]">
                                            <Grid>
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="*"/>
                                                </Grid.ColumnDefinitions>
                                                <PasswordBox Grid.Column="0" Name="DsDcPassword" HorizontalContentAlignment="Left"/>
                                                <PasswordBox Grid.Column="1" Name="DsDcConfirm"  HorizontalContentAlignment="Left"/>
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                </TabItem>
                                <TabItem Header="Local Admin">
                                    <Grid VerticalAlignment="Top">
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row="0" Header="[Local Admin Username]">
                                            <TextBox Name="DsLmUsername"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="1" Header="[Password/Confirm]">
                                            <Grid>
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="*"/>
                                                </Grid.ColumnDefinitions>
                                                <PasswordBox Grid.Column="0" Name="DsLmPassword"  HorizontalContentAlignment="Left"/>
                                                <PasswordBox Grid.Column="1" Name="DsLmConfirm"  HorizontalContentAlignment="Left"/>
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                </TabItem>
                                <TabItem Header="Branding">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="80"/>
                                            <RowDefinition Height="80"/>
                                            <RowDefinition Height="80"/>
                                            <RowDefinition Height="80"/>
                                        </Grid.RowDefinitions>
                                        <Grid Grid.Row="0">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="100"/>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="*"/>
                                            </Grid.ColumnDefinitions>
                                            <Button Name="DsBrCollect" Content="Collect" IsEnabled="True"/>
                                            <GroupBox Grid.Column="1" Header="[BrPhone (Support Phone)]">
                                                <TextBox Name="DsBrPhone"/>
                                            </GroupBox>
                                            <GroupBox Grid.Column="2" Header="[BrHours (Support Hours)]">
                                                <TextBox Name="DsBrHours"/>
                                            </GroupBox>
                                        </Grid>
                                        <GroupBox Grid.Row="1" Header="[BrWebsite (Support Website)]">
                                            <TextBox Name="DsBrWebsite"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="2" Header="[BrLogo (120x120 Bitmap/*.bmp)]">
                                            <Grid>
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="100"/>
                                                    <ColumnDefinition Width="*"/>
                                                </Grid.ColumnDefinitions>
                                                <Button Grid.Column="0" Name="DsBrLogoSelect" Content="Select"/>
                                                <TextBox Grid.Column="1" Name="DsBrLogo"/>
                                            </Grid>
                                        </GroupBox>
                                        <GroupBox Grid.Row="3" Header="[BrBackground (Common Image File)]">
                                            <Grid>
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="100"/>
                                                    <ColumnDefinition Width="*"/>
                                                </Grid.ColumnDefinitions>
                                                <Button Grid.Column="0" Name="DsBrBackgroundSelect" Content="Select"/>
                                                <TextBox Grid.Column="1" Name="DsBrBackground"/>
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                </TabItem>
                                <TabItem Header="Network">
                                    <Grid VerticalAlignment="Top">
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row="0" Header="[NetBios Name]">
                                            <TextBox Name="DsNetBiosName"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="1" Header="[Dns Name]">
                                            <TextBox Name="DsDnsName"/>
                                        </GroupBox>
                                        <GroupBox Grid.Row="2" Header="[Machine OU Name]">
                                            <TextBox Name="DsMachineOuName"/>
                                        </GroupBox>
                                    </Grid>
                                </TabItem>
                                <TabItem Header="Bootstrap">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="75"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <Grid Grid.Row="0">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="100"/>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="100"/>
                                            </Grid.ColumnDefinitions>
                                            <Button Grid.Column="0" Name="DsSelectBootstrap" Content="Select"/>
                                            <Button Grid.Column="2" Name="DsGetBootstrap" Content="Generate"/>
                                        </Grid>
                                        <TextBlock Grid.Row="1" Name="DsBootstrap" Margin="5" Padding="5"/>
                                    </Grid>
                                </TabItem>
                                <TabItem Header="CustomSettings">
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height="75"/>
                                            <RowDefinition Height="*"/>
                                        </Grid.RowDefinitions>
                                        <Grid Grid.Row="0">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="100"/>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="100"/>
                                            </Grid.ColumnDefinitions>
                                            <Button Grid.Column="0" Name="DsSelectCustomSettings" Content="Select"/>
                                            <Button Grid.Column="2" Name="DsGetCustomSettings" Content="Generate"/>
                                        </Grid>
                                        <TextBlock Grid.Row="1" Name="DsCustomSettings" Margin="5" Padding="5"/>
                                    </Grid>
                                </TabItem>
                            </TabControl>
                            <Grid Grid.Row="3">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Button Grid.Column="0" Name="DsCreate" Content="Create"/>
                                <Button Grid.Column="1" Name="DsUpdate" Content="Update"/>
                            </Grid>
                        </Grid>
                    </TabItem>
                </TabControl>
            </GroupBox>
        </Grid>
    </Window>
"@
    }

    # Controller class
    Class Main
    {
        Static [String]       $Base = "$Env:ProgramData\Secure Digits Plus LLC\FightingEntropy"
        Static [String]        $GFX = "$([Main]::Base)\Graphics"
        Static [String]       $Icon = "$([Main]::GFX)\icon.ico"
        Static [String]       $Logo = "$([Main]::GFX)\OEMLogo.bmp"
        Static [String] $Background = "$([Main]::GFX)\OEMbg.jpg"
        Static [String]        $Tab = [FEDeploymentShareGUI]::New()
        [Object]               $Win 
        [Object]               $Reg 
        [Object]                $SM
        Main()
        {
            $This.Win               = Get-WindowsFeature
            $This.Reg               = "","\WOW6432Node" | % { "HKLM:\Software$_\Microsoft\Windows\CurrentVersion\Uninstall\*" }
        }
    }
    
    # These two variables do most of the work
    $Main                           = [Main]::New()
    $Xaml                           = [XamlWindow][FEDeploymentShareGUI]::Tab

    # $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % {
    #    $X = "    # `$Xaml.IO.$_"
    #    $Y = $Xaml.IO.$_.GetType().Name 
    #    "{0}{1} # $Y" -f $X,(" "*(40-$X.Length) -join '')
    #}

    # ---------------------- #
    # Variables and controls #
    # ---------------------- #

    # [Default Settings]
    # Configuration
    # -------------
    # $Xaml.IO.CfgServices              # DataGrid
    # $Xaml.IO.CfgDhcp                  # DataGrid
    # $Xaml.IO.CfgDns                   # DataGrid
    # $Xaml.IO.CfgAdds                  # DataGrid
    # $Xaml.IO.CfgWds                   # DataGrid
    # $Xaml.IO.CfgMdt                   # DataGrid
    # $Xaml.IO.CfgWinAdk                # DataGrid
    # $Xaml.IO.CfgWinPE                 # DataGrid
    # $Xaml.IO.CfgIIS                   # DataGrid

    $Xaml.IO.CfgServices.ItemsSource    = @( )
    $Xaml.IO.CfgDhcp.ItemsSource        = @( )
    $Xaml.IO.CfgDns.ItemsSource         = @( )
    $Xaml.IO.CfgAdds.ItemsSource        = @( )
    $Xaml.IO.CfgWds.ItemsSource         = @( )
    $Xaml.IO.CfgMdt.ItemsSource         = @( )
    $Xaml.IO.CfgWinAdk.ItemsSource      = @( )
    $Xaml.IO.CfgWinPE.ItemsSource       = @( )
    $Xaml.IO.CfgIIS.ItemsSource         = @( )

    # Domain
    # ------
    # $Xaml.IO.DcOrganization           # Text
    # $Xaml.IO.DcCommonName             # Text
    # $Xaml.IO.DcGetSitename            # Button
    # $Xaml.IO.DcAggregate              # DataGrid
    # $Xaml.IO.DcAddSitename            # Button
    # $Xaml.IO.DcAddSitenameZip         # Text
    # $Xaml.IO.DcAddSitenameTown        # Text
    # $Xaml.IO.DcRemoveSitename         # Button
    # $Xaml.IO.DcViewer                 # DataGrid
    # $Xaml.IO.DcTopography             # DataGrid
    # $Xaml.IO.DcGetTopography          # Button
    # $Xaml.IO.DcNewTopography          # Button

    $Xaml.IO.DcAggregate.ItemsSource    = @( )
    $Xaml.IO.DcViewer.ItemsSource       = @( )
    $Xaml.IO.DcTopography.ItemsSource   = @( )

    # Network
    # -------
    # $Xaml.IO.NwScope                  # Text
    # $Xaml.IO.NwScopeLoad              # Button
    # $Xaml.IO.NwStack                  # DataGrid
    # $Xaml.IO.NwSelected               # DataGrid
    # $Xaml.IO.NwAddNetwork             # Button
    # $Xaml.IO.NwRemoveNetwork          # Button
    # $Xaml.IO.NwSlated                 # DataGrid
    # $Xaml.IO.NwGetNetwork             # Button
    # $Xaml.IO.NwNewNetwork             # Button
    
    $Xaml.IO.NwStack.ItemsSource        = @( )
    $Xaml.IO.NwSelected.ItemsSource     = @( )
    $Xaml.IO.NwSlated.ItemsSource       = @( )

    # Gateway
    # -------
    # $Xaml.IO.GwSiteCount              # Text
    # $Xaml.IO.GwNetworkCount           # Text
    # $Xaml.IO.GwAggregate              # DataGrid
    # $Xaml.IO.GwSelected               # DataGrid
    # $Xaml.IO.GwAddGateway             # Button
    # $Xaml.IO.GwRemoveGateway          # Button
    # $Xaml.IO.GwSlated                 # DataGrid
    # $Xaml.IO.GwGetGateway             # Button
    # $Xaml.IO.GwNewGateway             # Button

    $Xaml.IO.GwAggregate.ItemsSource    = @()
    $Xaml.IO.GwSelected.ItemsSource     = @()
    $Xaml.IO.GwSlated.ItemsSource       = @()

    # Imaging
    # -------
    # $Xaml.IO.IsoSelect                # Button
    # $Xaml.IO.IsoPath                  # Text
    # $Xaml.IO.IsoScan                  # Button
    # $Xaml.IO.IsoList                  # DataGrid
    # $Xaml.IO.IsoMount                 # Button
    # $Xaml.IO.IsoDismount              # Button
    # $Xaml.IO.IsoView                  # DataGrid
    # $Xaml.IO.WimQueue                 # Button
    # $Xaml.IO.WimDequeue               # Button
    # $Xaml.IO.WimIsoUp                 # Button
    # $Xaml.IO.WimIsoDown               # Button
    # $Xaml.IO.WimIso                   # DataGrid
    # $Xaml.IO.WimSelect                # Button
    # $Xaml.IO.WimPath                  # Text
    # $Xaml.IO.WimExtract               # Button

    $Xaml.IO.IsoList.ItemsSource        = @( )
    $Xaml.IO.IsoView.ItemsSource        = @( )
    $Xaml.IO.WimIso.ItemsSource         = @( )

    # Updates
    # -------
    # $Xaml.IO.UpdSelect                # Button
    # $Xaml.IO.UpdPath                  # Text
    # $Xaml.IO.UpdScan                  # Button
    # $Xaml.IO.UpdList                  # DataGrid
    # $Xaml.IO.UpdSelected              # DataGrid
    # $Xaml.IO.UpdAddUpdate             # Button
    # $Xaml.IO.UpdRemoveUpdate          # Button
    # $Xaml.IO.UpdWim                   # DataGrid
    # $Xaml.IO.UpdInstallUpdate         # Button
    # $Xaml.IO.UpdUninstallUpdate       # Button

    $Xaml.IO.UpdList.ItemsSource        = @( )
    $Xaml.IO.UpdSelected.ItemsSource    = @( )
    $Xaml.IO.UpdWim.ItemsSource         = @( )

    # Deployment Share
    # ----------------
    # $Xaml.IO.DsRootSelect             # Button
    # $Xaml.IO.DsRootPath               # Text
    # $Xaml.IO.DsShareName              # Text
    # $Xaml.IO.DsDriveName              # Text
    # $Xaml.IO.DsDescription            # Text
    # $Xaml.IO.DsType                   # ComboBox

    # Domain Credential
    # -----------------
    # $Xaml.IO.DsDcUsername             # Text
    # $Xaml.IO.DsDcPassword             # Password
    # $Xaml.IO.DsDcConfirm              # Password

    # Local Credential
    # ----------------
    # $Xaml.IO.DsLmUsername             # Text
    # $Xaml.IO.DsLmPassword             # Password
    # $Xaml.IO.DsLmConfirm              # Password

    # Branding
    # --------
    # $Xaml.IO.DsBrCollect              # Button
    # $Xaml.IO.DsBrPhone                # Text
    # $Xaml.IO.DsBrHours                # Text
    # $Xaml.IO.DsBrWebsite              # Text
    # $Xaml.IO.DsBrLogoSelect           # Button
    # $Xaml.IO.DsBrLogo                 # Text
    # $Xaml.IO.DsBrBackgroundSelect     # Button
    # $Xaml.IO.DsBrBackground           # Text

    # Network Ext.
    # ------------
    # $Xaml.IO.DsNetBiosName            # Text
    # $Xaml.IO.DsDnsName                # Text
    # $Xaml.IO.DsMachineOuName          # Text

    # Config Ext.
    # -----------
    # $Xaml.IO.DsSelectBootstrap         # Button
    # $Xaml.IO.DsGetBootstrap            # Button
    # $Xaml.IO.DsBootstrap               # TextBlock

    # $Xaml.IO.DsSelectCustomSettings    # Button
    # $Xaml.IO.DsGetCustomSettings       # Button
    # $Xaml.IO.DsCustomSettings          # TextBlock

    # $Xaml.IO.DsCreate                  # Button
    # $Xaml.IO.DsUpdate                  # Button

    # ----------------- #
    # Configuration Tab #
    # ----------------- #

    $Xaml.IO.CfgServices.ItemsSource = @( 
        
        ForEach ( $Item in "DHCP","DNS","AD-Domain-Services","WDS","Web-WebServer")
        {
            [DGList]::New( $Item, [Bool]( $Main.Win | ? Name -eq $Item | % Installed ) )
        }
        
        ForEach ( $Item in "MDT","WinADK","WinPE")
        {
            $Slot = Switch($Item)
            {
                MDT    { $Main.Reg[0], "Microsoft Deployment Toolkit"                       , "6.3.8456.1000" }
                WinADK { $Main.Reg[1], "Windows Assessment and Deployment Kit - Windows 10" , "10.1.17763.1"  }
                WinPE  { $Main.Reg[1], "Preinstallation Environment Add-ons - Windows 10"   , "10.1.17763.1"  }
            }
                
            [DGList]::New( $Item, [Bool]( Get-ItemProperty $Slot[0] | ? DisplayName -match $Slot[1] | ? DisplayVersion -ge $Slot[2] ) )
        }
    )

    If ( $Xaml.IO.CfgServices.Items | ? Name -eq MDT | ? Value -eq $True )
    {   
        $MDT     = Get-ItemProperty HKLM:\Software\Microsoft\Deployment* | % Install_Dir | % TrimEnd \
        Import-Module "$MDT\Bin\MicrosoftDeploymentToolkit.psd1"

        If (Get-MDTPersistentDrive)
        {
            $Persist = Restore-MDTPersistentDrive
        }

        $Xaml.IO.DsDriveName.Text = ("FE{0:d3}" -f @($Persist.Count + 1))
    }

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Domain Tab ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

    $Xaml.IO.DcGetSitename.Add_Click(
    {
        If (!$Xaml.IO.DcOrganization.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid/null organization entry","Error")
        }

        ElseIf (!$Xaml.IO.DcCommonName.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid/null common name entry","Error")
        }

        Else
        {   #$Main.SM = [Control]::New("Secure Digits Plus LLC","securedigitsplus.com")
            $Main.SM = [Control]::New($Xaml.IO.DcOrganization.Text,$Xaml.IO.DcCommonName.Text)
            $Main.SM.Pull()
            $Xaml.IO.DcAggregate.ItemsSource  += $Main.SM.Sitemap
            $Xaml.IO.DcGetSitename.IsEnabled   = 0
            $Xaml.IO.NwScopeLoad.IsEnabled     = 1
        }
    })

    $Xaml.IO.DcAggregate.Add_MouseDoubleClick(
    {
        $Object = $Xaml.IO.DcAggregate.SelectedItem
        $Xaml.IO.DcViewer.ItemsSource = @( )
        $Xaml.IO.DcViewer.ItemsSource = ForEach ( $Item in "Location Region Country Postal TimeZone SiteLink SiteName" -Split " " )
        {
            [DGList]::New($Item,$Object.$Item)
        }
    })

    $Xaml.IO.DcAddSitename.Add_Click(
    {
        If (!$Xaml.IO.DcAddSitenameZip.Text)
        {
            [System.Windows.MessageBox]::Show("Zipcode text entry error","Error")
        }

        Else
        {
            $Tmp  = $Main.SM.NewCertificate()
            $Item = $Main.SM.ZipStack.ZipTown($Xaml.IO.DcAddSitenameZip.Text)

            $Tmp[0].Location = $Item.Name
            $Tmp[0].Postal   = $Item.Zip
            $Tmp[0].Region   = [States]::Name($Item.State)

            $Tmp.GetSiteLink()
        }

        $Xaml.IO.DcTopography.ItemsSource += $Tmp
        $Xaml.IO.DcAddSitenameZip.Text     = ""
    })

    $Xaml.IO.DcRemoveSitename.Add_Click(
    {
        If ( $Xaml.IO.DcAggregate.SelectedIndex -gt -1 )
        {
            $Xaml.DcAggregate.Items.Remove($Xaml.IO.DcAggregate.SelectedItem)
        }
    })

    $Xaml.IO.DcGetTopography.Add_Click(
    {
        $Tmp = @( $Xaml.IO.DcAggregate.Items | % { [Topography]$_ } )
        $Xaml.IO.DcTopography.ItemsSource = @( )
        $Xaml.IO.DcTopography.ItemsSource = @( $Tmp )
    })
    
    $Xaml.IO.DcNewTopography.Add_Click(
    {
        #$SearchBase = "CN=Configuration,DC={0}" -f ("securedigitsplus.com".Split(".") -join ",DC=")
        $SearchBase = "CN=Configuration,DC={0}" -f ($Xaml.IO.DcCommonName.Text -Split "." -join ",DC=")
        $Sites      = Get-ADObject -LDAPFilter "(objectClass=site)" -SearchBase $SearchBase

        ForEach ( $Item in $Xaml.IO.DcTopography.Items )
        {
            If ($Item.Sitelink -notin $Sites.Name)
            {
                Switch((Host).UI.PromptForChoice("ADReplicationSite","Item $($Item.Sitelink) does not exist.",@("&Yes","&No"),0))
                {
                    0 { New-ADReplicationSite -Name $Item.Sitelink -Verbose }
                    1 { Write-Host "Skipping $($Item.Sitelink)" }
                }
            }
        }
    })

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Network Tab    ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            

    $Xaml.IO.NwScopeLoad.Add_Click(
    {
        If ($Xaml.IO.NwScope.Text -notmatch "((\d+\.+){3}\d+\/\d+)")
        {
            [System.Windows.MessageBox]::Show("Invalid/null network string (Use 'IP/Prefix' notation)","Error")
        }

        Else
        {
            #$Main.SM.GetNetwork("172.16.0.1/19")
            $Main.SM.GetNetwork($Xaml.IO.NwScope.Text)
            $Xaml.IO.NwStack.ItemsSource    = @( )
            $Xaml.IO.NwSelected.ItemsSource = @( )
            $Xaml.IO.NwStack.ItemsSource    = $Main.SM.Stack
        }
    })

    $Xaml.IO.NwStack.Add_MouseDoubleClick(
    {
        If ( $Xaml.IO.NwStack.SelectedIndex -gt -1 )
        {
            $Network                         = $Main.SM.Stack | ? Network -match $Xaml.IO.NwStack.SelectedItem.Network
            
            $List = "Network Netmask HostCount HostObject Start End Range Broadcast".Split(" ") | % { 
                
                [DGList]::New($_,$Network.$_) 
            }

            $Xaml.IO.NwSelected.ItemsSource     = @( )
            $Xaml.IO.NwSelected.ItemsSource     = $List
        }
    })

    $Xaml.IO.NwAddNetwork.Add_Click(
    {
        If ( $Xaml.IO.NwSlated.SelectedIndex -gt -1 )
        {
            $Prefix = $Xaml.IO.NwStack.SelectedItem | % { "{0}/{1}" -f $_.Network, $_.Prefix }
            If ( $Prefix -notin $Xaml.IO.NwSlated.Items )
            {
                $Xaml.IO.NwSlated.ItemsSource += [DGList]::New($Prefix,"<Process>")
            }
        }
    })

    $Xaml.IO.NwRemoveNetwork.Add_Click(
    {
        If ( $Xaml.IO.NwSlated.SelectedIndex -gt -1 )
        {
            $Tmp = $Xaml.IO.NwSlated.ItemsSource 
            $Xaml.IO.NwSlated.ItemsSource = @( )
            $Xaml.IO.NwSlated.ItemsSource = $Tmp | ? Name -ne $Xaml.IO.NwSlated.SelectedItem
        }
    })

    $Xaml.IO.NwGetNetwork.Add_Click(
    {
        $SearchBase   = "CN=Configuration,DC={0}" -f ($Xaml.IO.DcCommonName.Text -Split "." -join ",DC=")
        $Networks     = Get-ADObject -LDAPFilter "(objectClass=subnet)" -SearchBase "CN=Configuration,DC=securedigitsplus,DC=com"
        If (!$Networks)
        {
            Throw "No valid networks detected"
        }
        $Xaml.IO.NwSlated.ItemsSource = @( )

        ForEach ( $Item in $Networks )
        {
            $Xaml.IO.NwSlated.ItemsSource += [DGList]::New($Item.Name,$Item.DistinguishedName)
        }
    })

    $Xaml.IO.NwNewNetwork.Add_Click(
    {
        $SearchBase   = "CN=Configuration,DC={0}" -f ($Xaml.IO.DcCommonName.Text -Split "." -join ",DC=")
        $Networks     = Get-ADObject -LDAPFilter "(objectClass=subnet)" -SearchBase "CN=Configuration,DC=securedigitsplus,DC=com"
        If (!$Networks)
        {
            Throw "No valid networks detected"
        }

        ForEach ( $Item in $Xaml.IO.NwSlated.Items )
        {
            If ( $Item.Name -notin $Networks.Name )
            {
                New-ADReplicationSubnet -Name $Item.Name -Verbose
            }

            Else
            {
                Write-Host "[!] $Network Item already exists"
            }
        }
    })

    $Xaml.Invoke()

    # Imaging Tab
    $Xaml.IO.IsoSelect.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.FolderBrowserDialog
        $Item.ShowDialog()
        
        If (!$Item.SelectedPath)
        {
            $Item.SelectedPath  = ""
        }

        $Xaml.IO.IsoPath.Text = $Item.SelectedPath
    })

    $Xaml.IO.IsoPath.Add_TextChanged(
    {
        If ( $Xaml.IO.IsoPath.Text -ne "" )
        {
            $Xaml.IO.IsoScan.IsEnabled = 1
        }
    
        Else
        {
            $Xaml.IO.IsoScan.IsEnabled = 0
        }
    })
    
    $Xaml.IO.IsoScan.Add_Click(
    {
        If (!(Test-Path $Xaml.IO.IsoPath.Text))
        {
            [System.Windows.MessageBox]::Show("Invalid image root path","Error")
        }
    
        $Tmp = Get-ChildItem $Xaml.IO.IsoPath.Text *.iso | Select-Object Name, FullName
    
        If (!$Tmp)
        {
            [System.Windows.MessageBox]::Show("No images detected","Error")
        }

        $Xaml.IO.IsoList.ItemsSource = @( $Tmp )
    })
    
    $Xaml.IO.IsoList.Add_SelectionChanged(
    {
        If ( $Xaml.IO.IsoList.SelectedIndex -gt -1 )
        {
            $Xaml.IO.IsoMount.IsEnabled = 1
        }
    
        Else
        {
            $Xaml.IO.IsoMount.IsEnabled = 0
        }
    })
    
    $Xaml.IO.IsoMount.Add_Click(
    {
        If ( $Xaml.IO.IsoList.SelectedIndex -eq -1)
        {
            [System.Windows.MessageBox]::Show("No image selected","Error")
        }
    
        $ImagePath  = $Xaml.IO.IsoList.SelectedItem.FullName
        Write-Host "Mounting [~] [$ImagePath]"
    
        Mount-DiskImage -ImagePath $ImagePath -Verbose
    
        $Letter    = Get-DiskImage $ImagePath | Get-Volume | % DriveLetter
        
        If (!$Letter)
        {
            [System.Windows.MessageBox]::Show("Image failed mounting to drive letter","Error")
        }
    
        ElseIf (!(Test-Path "${Letter}:\sources\install.wim"))
        {
            [System.Windows.MessageBox]::Show("Not a valid Windows disc/image","Error")
            Dismount-Diskimage -ImagePath $ImagePath
        }
    
        Else
        {
            $Xaml.IO.IsoView.ItemsSource     = Get-WindowsImage -ImagePath "${Letter}:\sources\install.wim" | % { [WindowsImage]$_ }
            $Xaml.IO.IsoList.IsEnabled       = 0
            $Xaml.IO.IsoDismount.IsEnabled   = 1
            Write-Host "Mounted [+] [$ImagePath]"
        }
    })
    
    $Xaml.IO.IsoDismount.Add_Click(
    {
        $ImagePath                           = $Xaml.IO.IsoList.SelectedItem.FullName
        Dismount-DiskImage -ImagePath $ImagePath
        $Xaml.IO.IsoView.ItemsSource         = $Null
        $Xaml.IO.IsoList.IsEnabled           = 1
    
        Write-Host "Dismounted [+] [$ImagePath]"
        $ImagePath                           = $Null
    
        $Xaml.IO.IsoDismount.IsEnabled       = 0
    })
    
    $Xaml.IO.IsoView.Add_SelectionChanged(
    {
        If ( $Xaml.IO.IsoView.Items.Count -eq 0 )
        {
            $Xaml.IO.WimQueue.IsEnabled     = 0
        }
    
        If ( $Xaml.IO.IsoView.Items.Count -gt 0 )
        {
            $Xaml.IO.WimQueue.IsEnabled     = 1
        }
    })
    
    $Xaml.IO.WimIso.Add_SelectionChanged(
    {
        If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled   = 0
            $Xaml.IO.WimIsoUp.IsEnabled     = 0
            $xaml.IO.WimIsoDown.IsEnabled   = 0
        }
    
        If ( $Xaml.IO.WimIso.Items.Count -gt 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled   = 1
            $Xaml.IO.WimIsoUp.IsEnabled     = 1
            $xaml.IO.WimIsoDown.IsEnabled   = 1
        }
    })
    
    $Xaml.IO.WimQueue.Add_Click(
    {
        If ($Xaml.IO.IsoList.SelectedItem.Fullname -in $Xaml.IO.WimIso.Items.Name)
        {
            [System.Windows.MessageBox]::Show("Image already selected","Error")
        }
    
        Else
        {
            $Indexes      = $Xaml.IO.IsoView.SelectedItems.Index -join ","
            $Descriptions = $Xaml.IO.IsoView.SelectedItems.Description -join ","
            $Xaml.IO.WimIso.ItemsSource += [ImageQueue]::New($Xaml.IO.IsoList.SelectedItem.Fullname,$Indexes,$Descriptions)
        }
    })
    
    $Xaml.IO.WimDequeue.Add_Click(
    {
        $Grid = $Xaml.IO.WimIso.ItemsSource
        $Items = @( )
    
        ForEach ( $Item in $Grid )
        {
            If ( $Item -ne $Xaml.IO.WimIso.SelectedItem )
            {
                $Items += $Item
            }
        }
    
        $Xaml.IO.WimIso.ItemsSource = @( )
        $Xaml.IO.WimIso.ItemsSource = $Items
        $Grid                       = $Null
        $Items                      = $Null
    
        If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled = 0
        }
    })
    
    $Xaml.IO.WimIsoUp.Add_Click(
    {
        If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
        {
            $Rank  = $Xaml.IO.WimIso.SelectedIndex
            $Grid  = $Xaml.IO.WimIso.ItemsSource
            $Items = 0..($Grid.Count-1)
    
            If ($Rank -ne 0)
            {
                ForEach ($I in 0..($Grid.Count-1))
                {
                    If ( $I -eq $Rank - 1 )
                    {
                        $Items[$I] = $Grid[$I+1]
                    }
    
                    ElseIf ( $I -eq $Rank )
                    {
                        $Items[$I] = $Grid[$I-1]   
                    }
    
                    Else
                    {
                        $Items[$I] = $Grid[$I]
                    }
                }
    
                $Xaml.IO.WimIso.ItemsSource = @( )
                $Xaml.IO.WimIso.ItemsSource = $Items
                $Items = $Null
                $Rank  = $Null
                $Grid  = $Null
            }
        }
    })
    
    $Xaml.IO.WimIsoDown.Add_Click(
    {
        If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
        {
            $Rank  = $Xaml.IO.WimIso.SelectedIndex
            $Grid  = $Xaml.IO.WimIso.ItemsSource
            $Items = 0..($Grid.Count - 1)
    
            If ($Rank -ne $Grid.Count - 1)
            {
                ForEach ($I in 0..($Grid.Count-1))
                {
                    If ( $I -eq $Rank )
                    {
                        $Items[$I] = $Grid[$I+1]   
                    }
    
                    ElseIf ( $I -eq $Rank + 1 )
                    {
                        $Items[$I] = $Grid[$I-1]
                    }
    
                    Else
                    {
                        $Items[$I] = $Grid[$I]
                    }
                }
                
                $Xaml.IO.WimIso.ItemsSource = @( )
                $Xaml.IO.WimIso.ItemsSource = $Items
                $Items = $Null
                $Rank  = $Null
                $Grid  = $Null
            }
        }
    })
    
    $Xaml.IO.WimExtract.Add_Click(
    {
        If (Test-Path $Xaml.IO.WimPath.Text)
        {
            $Children = Get-ChildItem $Xaml.IO.WimPath.Text *.wim -Recurse | % FullName

            If ($Children.Count -gt 0)
            {
                Switch([System.Windows.MessageBox]::Show("Wim files detected at provided path.","Purge and rebuild?","YesNo"))
                {
                    Yes
                    {
                        ForEach ( $Child in $Children )
                        {
                            Remove-Item $Child -Force -Verbose
                        }
                    }

                    No
                    {
                        Break
                    }
                }
            }
        }

        If (!(Test-Path $Xaml.IO.WimPath.Text))
        {
            New-Item -Path $Xaml.IO.WimPath.Text -ItemType Directory -Verbose
        }
    
        $Images = [ImageStore]::New($Xaml.IO.IsoPath.Text,$Xaml.IO.WimPath.Text)
    
        $X      = 0
        ForEach ( $Item in $Xaml.IO.WimIso.Items )
        {
            $Type = Switch -Regex ($Item.Description)
            {
                Server { "Server" } Default { "Client" }
            }
    
            $Images.AddImage($Type,$Item.Name)
            $Images.Store[$X].AddMap($Item.Index.Split(","))
            $X ++
        }
    
        $Images.GetSwap()
        $Images.GetOutput()
        Write-Theme "Complete [+] Images Collected"
    })
    
    $Xaml.IO.WimSelect.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.FolderBrowserDialog
        $Item.ShowDialog()
        
        If (!$Item.SelectedPath)
        {
            $Item.SelectedPath  = ""
        }

        $Xaml.IO.WimPath.Text = $Item.SelectedPath
    })

    $Xaml.IO.WimPath.Add_TextChanged(
    {
        If ( $Xaml.IO.WimPath.Text -ne "" )
        {
            $Xaml.IO.WimExtract.IsEnabled = 1
        }
    
        If ( $Xaml.IO.WimPath.Text -eq "" )
        {
            $Xaml.IO.WimExtract.IsEnabled = 0
        }
    })

    # Branding Tab
    $Xaml.IO.Collect.Add_Click(
    {
        $OEM = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation' -EA 0

        If ($OEM)
        {
            If ($OEM.Logo)
            {
                $Xaml.IO.Logo.Text = $Oem.Logo
            }

            If ($OEM.SupportPhone)
            {
                $Xaml.IO.Phone.Text = $Oem.SupportPhone
            }

            If ($OEM.SupportHours)
            {
                $Xaml.IO.Hours.Text = $Oem.SupportHours
            }

            If ($OEM.SupportURL)
            {
                $Xaml.IO.Website.Text = $Oem.SupportURL
            }
        }

        $OEM = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -EA 0
        
        If ($OEM)
        {
            If ($OEM.Wallpaper)
            {
                $Xaml.IO.Background.Text = $OEM.Wallpaper
            }
        }
    })

    $Xaml.IO.LogoSelect.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.OpenFileDialog
        $Item.InitialDirectory = [Main]::Base
        $Item.ShowDialog()
        
        If (!$Item.Filename)
        {
            $Item.Filename     = [Main]::Logo
        }

        $Xaml.IO.Logo.Text = $Item.FileName
    })
    
    $Xaml.IO.BackgroundSelect.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.OpenFileDialog
        $Item.InitialDirectory = [Main]::Base
        $Item.ShowDialog()
        
        If (!$Item.Filename)
        {
            $Item.Filename     = [Main]::Background
        }

        $Xaml.IO.Background.Text = $Item.FileName
    })

    # Share Tab
    $Xaml.IO.DSRootSelect.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.FolderBrowserDialog
        $Item.ShowDialog()
        
        If (!$Item.SelectedPath)
        {
            $Item.SelectedPath  = ""
        }

        $Xaml.IO.DSRootPath.Text = $Item.SelectedPath
    })

    $Xaml.IO.DSRootPath.Add_TextChanged(
    {
        If ( $Xaml.IO.DSRootPath.Text -ne "" )
        {
            $Xaml.IO.DSShareName.Text = ("{0}$" -f $Xaml.IO.DSRootPath.Text.Split("(\/|\.)")[-1] )
        }
    })

    $Xaml.IO.DSInitialize.Add_Click(
    {
        If ( $Xaml.IO.Services.Items | ? Name -eq MDT | ? Value -ne $True )
        {
            Throw "Unable to initialize, MDT not installed"
        }

        ElseIf ( $PSVersionTable.PSEdition -ne "Desktop" )
        {
            Throw "Unable to initialize, use Windows PowerShell v5.1"
        }

        ElseIf (!$Xaml.IO.DSDCUsername.Text)
        {
            [System.Windows.MessageBox]::Show("Missing the deployment share domain account name","Error")
        }

        ElseIf ($Xaml.IO.DSDCPassword.SecurePassword -notmatch $Xaml.IO.DSDCConfirm.SecurePassword)
        {
            [System.Windows.MessageBox]::Show("Invalid domain account password/confirm","Error")
        } 

        ElseIf (!$Xaml.IO.DSLMUsername.Text)
        {
            [System.Windows.MessageBox]::Show("Missing the child item local account name","Error")
        }

        ElseIf ($Xaml.IO.DSLMPassword.SecurePassword -notmatch $Xaml.IO.DSLMConfirm.SecurePassword)
        {
            [System.Windows.MessageBox]::Show("Invalid domain account password/confirm","Error")
        }

        ElseIf (!(Get-ADObject -Filter * | ? DistinguishedName -eq $Xaml.IO.DSOrganizationalUnit.Text))
        {
            [System.Windows.MessageBox]::Show("Invalid OU specified","Error")
        }

        Else
        {
            Write-Theme "Creating [~] Deployment Share"

            #$MDT     = Get-ItemProperty HKLM:\Software\Microsoft\Deployment* | % Install_Dir | % TrimEnd \
            #Import-Module "$MDT\Bin\MicrosoftDeploymentToolkit.psd1"
        }

        If (Get-MDTPersistentDrive)
        {
            $Persist = Restore-MDTPersistentDrive
        }

        $SMB     = Get-SMBShare
        $PSD     = Get-PSDrive

        If ($Xaml.IO.DSRootPath.Text -in $Persist.Root)
        {
            [System.Windows.MessageBox]::Show("That path belongs to an existing deployment share","Error")
        }

        ElseIf($Xaml.IO.DSShareName.Text -in $SMB.Name)
        {
            [System.Windows.MessageBox]::Show("That share name belongs to an existing SMB share","Error")
        }

        ElseIf ($Xaml.IO.DSDriveName.Text -in $PSD.Name)
        {
            [System.Windows.MessageBox]::Show("That (DSDrive|PSDrive) label is already being used","Error")
        }

        Else
        {
            If (!(Test-Path $Xaml.IO.DSRootPath.Text))
            {
                New-Item $Xaml.IO.DSRootPath.Text -ItemType Directory -Verbose
            }

            $Hostname       = @($Env:ComputerName,"$Env:ComputerName.$Env:UserDNSDomain")[[Int32](Get-CimInstance Win32_ComputerSystem | % PartOfDomain)].ToLower()

            $SMB            = @{

                Name        = $Xaml.IO.DSShareName.Text
                Path        = $Xaml.IO.DSRootPath.Text
                Description = $Xaml.IO.DSDescription.Text
                FullAccess  = "Administrators"
            }

            $PSD            = @{ 

                Name        = $Xaml.IO.DSDriveName.Text
                PSProvider  = "MDTProvider"
                Root        = $Xaml.IO.DSRootPath.Text
                Description = $Xaml.IO.DSDescription.Text
                NetworkPath = ("\\{0}\{1}" -f $Hostname, $Xaml.IO.DSShareName.Text)
            }

            New-SMBShare @SMB
            New-PSDrive  @PSD -Verbose | Add-MDTPersistentDrive -Verbose

            # Load Module / Share Drive Mount
            $Module                = Get-FEModule
            $Root                  = "$($PSD.Name):\"
            $Control               = "$($PSD.Root)\Control"
            $Script                = "$($PSD.Root)\Scripts"

            # To propogate the environment keys to child item [server/client]
            $DS                    = @($PSD.NetworkPath,
                $Xaml.IO.Organization.Text,
                $Xaml.IO.CommonName.Text,
                $Xaml.IO.Background.Text,
                $Xaml.IO.Logo.Text,
                $Xaml.IO.Phone.Text,
                $Xaml.IO.Hours.Text,
                $Xaml.IO.Website.Text)
            $Key                   = [Key]$DS
            
            # Copies the background and logo if they were selected
            ForEach ($File in $Key.Background, $Key.Logo)
            {
                If (Test-Path $File)
                {
                    Copy-Item -Path $File -Destination $Script -Verbose

                    If ($File -eq $Key.Background)
                    {
                        $Key.Background = "$($Key.NetworkPath)\Scripts\$($Key.Background | Split-Path -Leaf)"
                    }

                    If ($File -eq $Key.Logo)
                    {
                        $Key.Logo       = "$($Key.NetworkPath)\Scripts\$($Key.Logo | Split-Path -Leaf)"
                    }
                }
            }

            # For the little computer icon in PXE
            ForEach ( $File in $Module.Control | ? Extension -eq .png )
            {
                Copy-Item -Path $File.Fullname -Destination $Script -Force -Verbose
            }

            # Copies custom template for FightingEntropy to post install/configure
            ForEach ( $File in $Module.Control | ? Name -match Mod.xml )
            {
                Copy-Item -Path $File.FullName -Destination "$env:ProgramFiles\Microsoft Deployment Toolkit\Templates" -Force -Verbose
            }

            # Used to spawn the correct environment keys on child items
            Set-Content -Path "$($PSD.Root)\DSKey.csv" -Value ($Key | ConvertTo-CSV) -Verbose

            Write-Theme "Collecting [~] images"
            $Images      = @( )
            
            # Extract/order the WIM files and prime for MDT Injection
            Get-ChildItem -Path $Xaml.IO.WimPath.Text -Recurse *.wim | % { 
                
                Write-Host "Processing [$($_.FullName)]"
                $Images += [WimFile]::New($Images.Count,$_.FullName) 
            }

            # Import OS/TS to MDT Share
            $OS          = "$($PSD.Name):\Operating Systems"
            $TS          = "$($PSD.Name):\Task Sequences"
            $Comment     = Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]"

            # Create folders in the new MDT share
            ForEach ( $Type in "Server","Client" )
            {
                ForEach ( $Version in $Images | ? InstallationType -eq $Type | % Version | Select-Object -Unique )
                {
                    ForEach ( $Slot in $OS, $TS )
                    {
                        If (!(Test-Path "$Slot\$Type"))
                        {
                            New-Item -Path $Slot -Enable True -Name $Type -Comments $Comment -ItemType Folder -Verbose
                        }

                        If (!(Test-Path "$Slot\$Type\$Version"))
                        {
                            New-Item -Path "$Slot\$Type" -Enable True -Name $Version -Comments $comment -ItemType Folder -Verbose
                        }
                    }
                }
            }

            ForEach ( $Image in $Images )
            {
                $Type                   = $Image.InstallationType
                $Path                   = "$OS\$Type\$($Image.Version)"

                $OperatingSystem        = @{

                    Path                = $Path
                    SourceFile          = $Image.SourceImagePath
                    DestinationFolder   = $Image.Label
                }
                
                Import-MDTOperatingSystem @OperatingSystem -Move -Verbose

                $TaskSequence           = @{ 
                    
                    Path                = "$TS\$Type\$($Image.Version)"
                    Name                = $Image.ImageName
                    Template            = "FE{0}Mod.xml" -f $Type
                    Comments            = $Comment
                    ID                  = $Image.Label
                    Version             = "1.0"
                    OperatingSystemPath = Get-ChildItem -Path $Path | ? Name -match $Image.Label | % { "{0}\{1}" -f $Path, $_.Name }
                    FullName            = $Xaml.IO.DCLMUsername
                    OrgName             = $Xaml.IO.Organization
                    HomePage            = $Xaml.IO.Website
                    AdminPassword       = $Xaml.IO.DCLMPassword.Password
                }

                Import-MDTTaskSequence @TaskSequence -Verbose
            }

            Write-Theme "OS/TS [+] Imported, removing Wim Swap directory" 11,3,15,0
            Remove-Item -Path $Xaml.IO.WimPath.Text -Recurse -Force -Verbose

            # FightingEntropy(π) Installation propogation
            $Install = @( 
            "[Net.ServicePointManager]::SecurityProtocol = 3072",
            "Invoke-RestMethod https://github.com/mcc85s/FightingEntropy/blob/main/Install.ps1?raw=true | Invoke-Expression",
            "`$Key = '$( $Key | ConvertTo-Json )'",
            "New-EnvironmentKey -Key `$Key | % Apply",
            "`$Module = Get-FEModule",
            "`$Module.Role.Choco()",
            "choco install pwsh vscode microsoft-edge microsoft-windows-terminal ccleaner -y" -join ";`n")

            Set-Content -Path $Script\Install.ps1 -Value $Install -Force -Verbose

            Write-Theme "Setting [~] Share properties [($Root)]"

            # Share Settings
            Set-ItemProperty $Root -Name Comments    -Value $("[FightingEntropy({0})]{1}" -f [Char]960,(Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]") ) -Verbose
            Set-ItemProperty $Root -Name MonitorHost -Value $HostName -Verbose

            # Image Names/Background
            ForEach ($x in 64,86)
            {
                $Names  = $X | % { "Boot.x$_" } | % { "$_.Generate{0}ISO $_.{0}WIMDescription $_.{0}ISOName $_.BackgroundFile" -f "LiteTouch" -Split " " }
                $Values = $X | % { "$($Module.Name)[$($Module.Version)](x$_)" } | % { "True;$_;$_.iso;$($Xaml.IO.Background.Text)" -Split ";" }
                0..3         | % { Set-ItemProperty -Path $Root -Name $Names[$_] -Value $Values[$_] -Verbose } 
            }

            # Bootstrap.ini
            Export-Ini -Path $Control\Bootstrap.ini -Value @{ 

                Settings           = @{ Priority             = "Default"                      }
                Default            = @{ DeployRoot           = $Key.NetworkPath
                                        UserID               = $Xaml.IO.DSDCUserName.Text
                                        UserPassword         = $Xaml.IO.DSDCPassword.Password
                                        UserDomain           = $Xaml.IO.CommonName.Text
                                        SkipBDDWelcome       = "YES"                          }
            } | % Output

            # CustomSettings.ini
            Export-Ini -Path $Control\CustomSettings.ini -Value @{

                Settings           = @{ Priority             = "Default" 
                                        Properties           = "MyCustomProperty" }
                Default            = @{ _SMSTSOrgName        = $Xaml.IO.Organization.Text
                                        JoinDomain           = $Xaml.IO.CommonName.Text
                                        DomainAdmin          = $Xaml.IO.DSDCUserName.Text
                                        DomainAdminPassword  = $Xaml.IO.DSDCPassword.Password
                                        DomainAdminDomain    = $Xaml.IO.CommonName.Text
                                        MachineObjectOU      = $Xaml.IO.DSOrganizationalUnit.Text
                                        SkipDomainMembership = "YES"
                                        OSInstall            = "Y"
                                        SkipCapture          = "NO"
                                        SkipAdminPassword    = "YES" 
                                        SkipProductKey       = "YES" 
                                        SkipComputerBackup   = "NO" 
                                        SkipBitLocker        = "YES" 
                                        KeyboardLocale       = "en-US" 
                                        TimeZoneName         = "$(Get-TimeZone | % ID)"
                                        EventService         = ("http://{0}:9800" -f $Key.NetworkPath.Split("\")[2]) }
            } | % Output

            # Update FEShare(MDT)
            Update-MDTDeploymentShare -Path $Root -Force -Verbose

            # Update/Flush FEShare(Images)
            $ImageLabel = Get-ItemProperty -Path $Root | % { 

                @{  64 = $_.'Boot.x64.LiteTouchWIMDescription'
                    86 = $_.'Boot.x86.LiteTouchWIMDescription' }
            }

            # Rename the Litetouch_ files
            Get-ChildItem -Path "$($Xaml.IO.DSRootPath.Text)\Boot" | ? Extension | % { 

                $Label          = $ImageLabel[$(Switch -Regex ($_.Name) { 64 {64} 86 {86}})]
                $Image          = @{ 

                    Path        = $_.FullName
                    Name        = $_.Name
                    NewName     = "{0}{1}" -f $Label,$_.Extension
                    Extension   = $_.Extension
                }

                If ( $Image.Name -match "LiteTouchPE_" )
                {
                    If ( Test-Path $Image.NewName )
                    {
                        Remove-Item -Path $Image.NewName -Force -Verbose
                    }

                    Rename-Item -Path $Image.Path -NewName $Image.NewName
                }
            }

            If (!(Get-Service | ? Name -eq WDSServer))
            {
                Throw "WDS Server not installed"
            }

            # Update/Flush FEShare(WDS)
            ForEach ( $Image in [BootImages]::New("$($Xaml.IO.DSRootPath.Text)\Boot").Images )
            {        
                If (Get-WdsBootImage -Architecture $Image.Type -ImageName $Image.Name -EA 0)
                {
                    Write-Theme "Detected [!] $($Image.Name), removing..." 12,4,15,0
                    Remove-WDSBootImage -Architecture $Image.Type -ImageName $Image.Name -Verbose
                }

                Write-Theme "Importing [~] $($Image.Name)" 11,3,15,0
                Import-WdsBootImage -Path $Image.Wim -NewDescription $Image.Name -Verbose
            }

            Restart-Service -Name WDSServer

            Write-Theme -Flag

            $Xaml.IO.DialogResult = $True
        }
    })

    # Set initial TextBox values
    $Xaml.IO.NetBIOSName.Text   = $Env:UserDomain
    $Xaml.IO.DNSName.Text       = @{0=$Env:ComputerName;1="$Env:ComputerName.$Env:UserDNSDomain"}[[Int32](Get-CimInstance Win32_ComputerSystem | % PartOfDomain)].ToLower()
    $Xaml.IO.DSDescription.Text = "[FightingEntropy({0})][(2021.7.0)]" -f [char]960
    $Xaml.IO.DSLMUsername.Text  = "Administrator"
    
    $Xaml.Invoke()
#}

# Add-Type -AssemblyName PresentationFramework
# ( GC $Home\Desktop\New-FEDeploymentShare.ps1 ) -join "`n" | IEX ; New-FEDeploymentShare

# $Xaml.IO.Topography.ItemsSource 
# $Xaml.IO.SiteMap.Items

#$Xaml.IO.Stack.Items