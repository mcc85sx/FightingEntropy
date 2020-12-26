        Class _NbtObj
        {
            [String]      $ID
            [String]    $Type
            [String] $Service

            _NbtObj([String]$In)
            {
                $This.ID, $This.Type, $This.Service = $In -Split "/"
            }
        }

        Class _NbtRef 
        {
            [String[]] $String = (("00/{0}/Workstation {4};01/{0}/Messenger {6};01/{1}/Master Browser;03/{0}/Messenger {6};" + 
            "06/{0}/RAS Server {6};1F/{0}/NetDDE {6};20/{0}/File Server {6};21/{0}/RAS Client {6};22/{0}/{2} Interchange(MSMail C" + 
            "onnector);23/{0}/{2} Exchange Store;24/{0}/{2} Directory;30/{0}/{4} Server;31/{0}/{4} Client;43/{0}/{3} Control;44/{" + 
            "0}/SMS Administrators Remote Control Tool {6};45/{0}/{3} Chat;46/{0}/{3} Transfer;4C/{0}/DEC TCPIP SVC on Windows NT" +
            ";42/{0}/mccaffee anti-virus;52/{0}/DEC TCPIP SVC on Windows NT;87/{0}/{2} MTA;6A/{0}/{2} IMC;BE/{0}/{5} Agent;BF/{0}" + 
            "/{5} Application;03/{0}/Messenger {6};00/{1}/{7} Name;1B/{0}/{7} Master Browser;1C/{1}/{7} Controller;1D/{0}/Master " + 
            "Browser;1E/{1}/Browser {6} Elections;2B/{0}/Lotus Notes Server;2F/{1}/Lotus Notes ;33/{1}/Lotus Notes ;20/{1}/DCA Ir" + 
            "maLan Gateway Server;01/{1}/MS NetBIOS Browse Service") -f "UNIQUE","GROUP","Microsoft Exchange","SMS Clients Remote",
            "Modem Sharing","Network Monitor","Service","Domain").Split(";")
            [Object[]] $Output

            _NbtRef()
            {
                $This.Output = @( )
                $This.String | % { 

                    $This.Output += [_NbtObj]::New($_)   
                }
            }
        }

        Class _ServerFeature
        {
            [String] $Name
            [String] $DisplayName
            [Bool]   $Installed

            _ServerFeature([String]$Name,[String]$DisplayName,[Int32]$Installed)
            {
                $This.Name           = $Name -Replace "-","_"
                $This.DisplayName    = $Displayname
                $This.Installed      = $Installed
            }
        }

        Class _ServerFeatures
        {
            Static [String[]] $Names = ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCenter RSAT-AD-PowerShell RSAT-AD-T" +
                                        "ools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Server RSAT-Role-Tools WDS WDS-Admin" + 
                                        "Pack WDS-Deployment WDS-Transport").Split(" ")
            [Object[]]     $Features

            _ServerFeatures()
            { 
                $This.Features       =  @( )
                
                Get-WindowsFeature | ? Name -in ([_ServerFeatures]::Names) | % { 
                    
                    $This.Features += [_ServerFeature]::New($_.Name, $_.DisplayName, $_.Installed)
                }
            }
        }

        Class _DomainName
        {
            [String]             $String
            [String]               $Type
    
            Hidden [Object]        $Slot = @{ NetBIOS = @{ Min = 1; Max = 15 }; Domain = @{ Min = 2; Max = 63 }; SiteName = @{ Min = 2; Max = 63 } }
            Hidden [Char[]]       $Allow = [Char[]]@(45,46;48..57;65..90;97..122)
            Hidden [Char[]]        $Deny = [Char[]]@(32..44;47;58..64;91..96;123..126)
            Hidden [Hashtable] $Reserved = @{
    
                Words             = ( "ANONYMOUS;AUTHENTICATED USER;BATCH;BUILTIN;CREATOR GROUP;CREATOR GROUP SERVER;CREATOR OWNER;CREATOR OWNER SERVER;" + 
                                      "DIALUP;DIGEST AUTH;INTERACTIVE;INTERNET;LOCAL;LOCAL SYSTEM;NETWORK;NETWORK SERVICE;NT AUTHORITY;NT DOMAIN;NTLM AU" + 
                                      "TH;NULL;PROXY;REMOTE INTERACTIVE;RESTRICTED;SCHANNEL AUTH;SELF;SERVER;SERVICE;SYSTEM;TERMINAL SERVER;THIS ORGANIZ" + 
                                      "ATION;USERS;WORLD") -Split ";"
                DNSHost           = ( "-GATEWAY","-GW","-TAC" )
                SDDL              = ( "AN,AO,AU,BA,BG,BO,BU,CA,CD,CG,CO,DA,DC,DD,DG,DU,EA,ED,HI,IU,LA,LG,LS,LW,ME,MU,NO,NS,NU,PA,PO,PS,PU,RC,RD,RE,RO,RS," + 
                                      "RU,SA,SI,SO,SU,SY,WD") -Split ','
            }

            _DomainName([String]$Type,[String]$String)
            {
                If ( $Type -notin $This.Slot.Keys )
                {
                    Throw "Invalid type"
                }

                $This.String = $String
                $This.Type   = $Type
                $This.Slot   = $This.Slot["$($Type)"]

                If ( $This.String -in $This.Reserved.Words )
                {
                    Throw "Entry is reserved"
                }

                If ( $This.String.Length -le $This.Slot.Min )
                {
                    Throw "Input does not meet minimum length"
                }

                If ( $This.String.Length -ge $This.Slot.Max )
                {
                    Throw "Input exceeds maximum length"
                }

                If ( $This.String.ToCharArray() | ? { $_ -notin $This.Allow -or $_ -in $This.Deny } )
                { 
                    Throw "Name has invalid characters"
                }
        
                If ( $This.String[0,-1] -notmatch "(\w)" )
                {
                    Throw "First/Last Character not alphanumeric" 
                }

                Switch($This.Type)
                {
                    NetBIOS  
                    { 
                        If ( "." -in $This.String.ToCharArray() ) 
                        { 
                            Throw "Period found in NetBIOS Domain Name, breaking" 
                        }
                    }

                    Domain
                    { 
                        If ( $This.String.Split('.').Count -lt 2 )
                        {
                            Throw "Not a valid domain name, single label domain names are disabled"
                        }
                
                        If ( $This.String -in $This.Reserved.SDDL )
                        { 
                            Throw "Name is reserved" 
                        }

                        If ( ( $This.String.Split('.')[-1].ToCharArray() | ? { $_ -match "(\D)" } ).Count -eq 0 )
                        {
                            Throw "Top Level Domain must contain a non-numeric."   
                        }
                    }

                    Default {}
                }
            }
        }

        Class _FEPromoDomain
        {
            [String] $Name
            [Bool]   $IsEnabled
            [String] $Text

            _FEPromoDomain([String]$Name,[Bool]$IsEnabled)
            {
                $This.Name      = $Name
                $This.IsEnabled = $IsEnabled
                $This.Text      = ""
            }
        }

        Class _FEPromoRoles
        {
            [String] $Name
            [Bool]   $IsEnabled
            [Bool]   $IsChecked

            _FEPromoRoles([String]$Name,[Bool]$IsEnabled,[Bool]$IsChecked)
            {
                $This.Name      = $Name
                $This.IsEnabled = $IsEnabled
                $This.IsChecked = $IsChecked
            }
        }

        Class _FEPromo
        {
            [String]                             $Command
            [Int32]                                 $Mode
            [String]                                $Slot
            [String]                          $DomainType
            [String]                          $ForestMode
            [String]                          $DomainMode
            [String]                    $ParentDomainName

            [Object]                          $InstallDNS
            [Object]                 $CreateDNSDelegation
            [Object]                     $NoGlobalCatalog
            [Object]             $CriticalReplicationOnly

            [Object]                        $DatabasePath
            [Object]                             $LogPath
            [Object]                          $SysvolPath
    
            [Object]                          $Credential
            [Object]                          $DomainName
            [Object]                   $DomainNetBIOSName
            [Object]                       $NewDomainName
            [Object]                $NewDomainNetBIOSName
            [Object]                 $ReplicationSourceDC
            [Object]                            $SiteName

            [SecureString] $SafeModeAdministratorPassword
            [String]                             $Profile

            SetMode([Int32]$Mode)
            {
                $This.DomainType                   = @("-","TreeDomain","ChildDomain","-")[$Mode]

                $This.Credential                   = [_FEPromoDomain]::New(             "Credential", (0,1,1,1)[$Mode])
                $This.DomainName                   = [_FEPromoDomain]::New(             "DomainName", (1,0,0,1)[$Mode])
                $This.DomainNetBIOSName            = [_FEPromoDomain]::New(      "DomainNetBIOSName", (1,0,0,0)[$Mode])
                $This.NewDomainName                = [_FEPromoDomain]::New(          "NewDomainName", (0,1,1,0)[$Mode])
                $This.NewDomainNetBIOSName         = [_FEPromoDomain]::New(   "NewDomainNetBIOSName", (0,1,1,0)[$Mode])
                $This.ReplicationSourceDC          = [_FEPromoDomain]::New(    "ReplicationSourceDC", (0,0,0,1)[$Mode])
                $This.SiteName                     = [_FEPromoDomain]::New(               "SiteName", (0,1,1,1)[$Mode])
                $This.InstallDNS                   = [_FEPromoRoles]::New(              "InstallDNS", (1,1,1,1)[$Mode], (1,1,1,1)[$Mode])
                $This.CreateDNSDelegation          = [_FEPromoRoles]::New(     "CreateDNSDelegation", (1,1,1,1)[$Mode], (0,0,1,0)[$Mode])
                $This.NoGlobalCatalog              = [_FEPromoRoles]::New(         "NoGlobalCatalog", (0,1,1,1)[$Mode], (0,0,0,0)[$Mode])
                $This.CriticalReplicationOnly      = [_FEPromoRoles]::New( "CriticalReplicationOnly", (0,0,0,1)[$Mode], (0,0,0,0)[$Mode])
            }

            _FEPromo([Int32]$Mode)
            {
                $This.Command                = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
                $This.Slot                   = Switch ([Int32]$Mode) { 0 { "Forest" } 1 { "Tree" } 2 { "Child" } 3 { "Clone" } }
                $This.SetMode($Mode)
            }
        }
        
        $NBT                               = [_NbtRef]::New()

        Write-Theme "Searching [:] For Valid Domain Controllers"
        
        $Module                            = Get-FEModule
        $Module.Role.Host                  | % { 

            $_._Network()
            $Network                       = $_.Network
            $Adapter                       = $Network.Adapter
            $Vendor                        = $Network.Vendor
            $Interface                     = $Network.Interface
        }

        $Return                            = $Interface | ? { $_.IPV4.Gateway }
        $Server                            = [_ServerFeatures]::New().Features
        $Window                            = Get-XamlWindow -Type FEDCPromo
        $IO                                = $Window.Host

        $IO.Forest.Add_Click(
        {
            $IO.Forest.IsChecked           = $True
            $IO.Tree.IsChecked             = $False
            $IO.Child.IsChecked            = $False
            $IO.Clone.IsChecked            = $False
            $CTRL                          = [_FEPromo]::New(0)
        })

        $IO.Tree.Add_Click(
        {
            $IO.Forest.IsChecked           = $False
            $IO.Tree.IsChecked             = $True
            $IO.Child.IsChecked            = $False
            $IO.Clone.IsChecked            = $False
            $CTRL                          = [_FEPromo]::New(1)
        })

        $IO.Child.Add_Click(
        {
            $IO.Forest.IsChecked           = $False
            $IO.Tree.IsChecked             = $False
            $IO.Child.IsChecked            = $True
            $IO.Clone.IsChecked            = $False
            $CTRL                          = [_FEPromo]::New(2)
        })

        $IO.Clone.Add_Click(
        {
            $IO.Forest.IsChecked           = $False
            $IO.Tree.IsChecked             = $False
            $IO.Child.IsChecked            = $False
            $IO.Clone.IsChecked            = $True
            $CTRL                          = [_FEPromo]::New(3)
        })

        $IO.Cancel.Add_Click(
        {
            $IO.DialogResult               = $False
        })

        [_ServerFeatures]::New().Features  | % {
            
            $IO.$($_.Name).IsChecked       =  $_.Installed 
            $IO.$($_.Name).IsEnabled       = !$_.Installed
                
        }

        $Window.Invoke()
