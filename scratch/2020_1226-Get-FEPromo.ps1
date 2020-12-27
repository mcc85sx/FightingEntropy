Class _NbtHost
{
    Hidden [String]    $Line
    [String]           $Name
    [String]             $ID
    [String]           $Type
    [String]        $Service

    [String] X ([Int32]$Start,[Int32]$End)
    {
        Return @( $This.Line.Substring($Start,$End).TrimEnd(" ") )
    }

    _NbtHost([String]$Line)
    {
        $This.Line    = $Line
        $This.Name    = $This.X(0,19).TrimStart(" ")
        $This.ID      = $This.X(20,2)
        $This.Type    = $This.X(25,12)
    }
}

Class _NbtStat
{
    Hidden [Object]   $Object
    [String]            $Name
    [String]       $IPAddress
    [Object[]]         $Hosts
        
    _NbtStat([Object[]]$Object)
    {
        $This.Object     = $Object
        $This.Name       = $Object[0].Split(":")[0]
        $This.IPAddress  = $Object[1].Split("[")[1].Split("]")[0]
        $This.Hosts      = $Object | ? { $_ -match "Registered" } | % { [_NBTHost]::New($_) }
    }
}

Class _NbtScan
{
    Hidden [Object]    $NBTStat = (nbtstat -N)
    Hidden [Object[]]  $Adapter = (Get-NetAdapter)
    Hidden [String[]]  $Service = (("00/{0}/Workstation {4};01/{0}/Messenger {6};01/{1}/Master Browser;03/{0}/Messenger {6};" + 
    "06/{0}/RAS Server {6};1F/{0}/NetDDE {6};20/{0}/File Server {6};21/{0}/RAS Client {6};22/{0}/{2} Interchange(MSMail C" + 
    "onnector);23/{0}/{2} Exchange Store;24/{0}/{2} Directory;30/{0}/{4} Server;31/{0}/{4} Client;43/{0}/{3} Control;44/{" + 
    "0}/SMS Administrators Remote Control Tool {6};45/{0}/{3} Chat;46/{0}/{3} Transfer;4C/{0}/DEC TCPIP SVC on Windows NT" +
    ";42/{0}/mccaffee anti-virus;52/{0}/DEC TCPIP SVC on Windows NT;87/{0}/{2} MTA;6A/{0}/{2} IMC;BE/{0}/{5} Agent;BF/{0}" + 
    "/{5} Application;03/{0}/Messenger {6};00/{1}/{7} Name;1B/{0}/{7} Master Browser;1C/{1}/{7} Controller;1D/{0}/Master " + 
    "Browser;1E/{1}/Browser {6} Elections;2B/{0}/Lotus Notes Server;2F/{1}/Lotus Notes ;33/{1}/Lotus Notes ;20/{1}/DCA Ir" + 
    "maLan Gateway Server;01/{1}/MS NetBIOS Browse Service") -f "UNIQUE","GROUP","Microsoft Exchange","SMS Clients Remote",
    "Modem Sharing","Network Monitor","Service","Domain").Split(";")
    Hidden [Hashtable] $Process 
    [Object[]]          $Output

    [String] SetService ([Object]$Hosts)
    {
        Return @( $This.Service | ? { $_ -match "$($Hosts.ID)/$($Hosts.Type)" } | % { $_.Split("/")[-1] } )
    }

    _NbtScan()
    {
        ForEach ( $I in 0..( $This.Service.Count - 1 ) )
        { 
            $This.Service[$I]  = $This.Service[$I]
        }

        $This.Output           = @( )
        $This.Process          = @{ }
        $X                     = -1

        ForEach ( $I in 1..( $This.NBTStat.Count - 1 ) )
        {
            $Item              = $This.NBTStat[$I].Split(":")[0]
        
            If ( $Item -in $This.Adapter.Name )
            {
                $X ++
                $This.Process.Add($X,@( ))
            }

            If ( $Item.Length -gt 0 ) 
            { 
                $This.Process[$X] += $This.NBTStat[$I]
            }
        }

        Switch ($This.Process.Count)
        {
            1 
            {
                $Item = [_NBTStat]::New($This.Process[0])

                ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                {
                    $Item.Hosts[$I].Service = $This.SetService($Item.Hosts[$I])
                }

                $This.Output += $Item
            }

            Default 
            { 
                ForEach ( $X in 0..( $This.Process.Count - 1 ) )
                {
                    $Item = [_NBTStat]::New($This.Process[$X])

                    ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                    {
                        $Item.Hosts[$I].Service = $This.SetService($Item.Hosts[$I])
                    }

                    $This.Output += $Item
                }
            }
        }

        $This.Output = $This.Output | Sort-Object Name
    }
}


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
            [Object]                       $Window
            [Object]                           $IO
            [Object]                         $Host
            [Object]                       $Output
            [Object]                      $Network

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
                $This.Mode                              = $Mode
                $This.Command                           = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
                $This.Slot                              = ("Forest Tree Child Clone" -Split " ")[$Mode]

                $This.IO.Forest.IsChecked               = $False
                $This.IO.Tree.IsChecked                 = $False
                $This.IO.Child.IsChecked                = $False
                $This.IO.Clone.IsChecked                = $False

                $This.IO.$($This.Slot).IsChecked        = $True

                $Tray                                   = @("Visible","Collapsed")[@{0=0,0,1;1=1,0,1;2=1,1,0;3=1,1,0}[$Mode]]
                $This.IO.ForestModeBox.Visibility       = $Tray[0]
                $This.IO.DomainModeBox.Visibility       = $Tray[1]
                $This.IO.ParentDomainNameBox.Visibility = $Tray[2]
                $This.IO.ParentDomainName.Text          = "<Domain Name>"

                $This.DomainType                        = @("-","TreeDomain","ChildDomain","-")[$Mode]
                
                $Tray                                   = Switch ($Mode)
                {
                    0 { $This.IO.ForestMode.SelectedIndex,$This.IO.DomainMode.SelectedIndex,"-" }
                    1 { $This.IO.ForestMode.SelectedIndex,"-","-" }
                    2 { "-","-","<Domain Name>" }
                    3 { "-","-","<Domain Name>" }
                }
                
                $This.ForestMode                        = $Tray[0]
                $This.DomainMode                        = $Tray[1]
                $This.ParentDomainName                  = $Tray[2]

                # Roles
                $This.InstallDNS                        = [_FEPromoRoles]::New("InstallDNS",              (1,1,1,1)[$Mode], (1,1,1,1)[$Mode])
                $This.CreateDNSDelegation               = [_FEPromoRoles]::New("CreateDNSDelegation",     (1,1,1,1)[$Mode], (0,0,1,0)[$Mode])
                $This.NoGlobalCatalog                   = [_FEPromoRoles]::New("NoGlobalCatalog",         (0,1,1,1)[$Mode], (0,0,0,0)[$Mode])
                $This.CriticalReplicationOnly           = [_FEPromoRoles]::New("CriticalReplicationOnly", (0,0,0,1)[$Mode], (0,0,0,0)[$Mode])

                ForEach ( $Item in "InstallDNS CreateDNSDelegation NoGlobalCatalog CriticalReplicationOnly".Split(" ") )
                {
                    $This.Set_FEPromo_Roles($This.$($Item))
                }

                # Names
                $This.Credential                   = [_FEPromoDomain]::New(             "Credential", (0,1,1,1)[$Mode])
                $This.DomainName                   = [_FEPromoDomain]::New(             "DomainName", (1,0,0,1)[$Mode])
                $This.DomainNetBIOSName            = [_FEPromoDomain]::New(      "DomainNetBIOSName", (1,0,0,0)[$Mode])
                $This.NewDomainName                = [_FEPromoDomain]::New(          "NewDomainName", (0,1,1,0)[$Mode])
                $This.NewDomainNetBIOSName         = [_FEPromoDomain]::New(   "NewDomainNetBIOSName", (0,1,1,0)[$Mode])
                $This.ReplicationSourceDC          = [_FEPromoDomain]::New(    "ReplicationSourceDC", (0,0,0,1)[$Mode])
                $This.SiteName                     = [_FEPromoDomain]::New(               "SiteName", (0,1,1,1)[$Mode])

                ForEach ( $Item in "Credential DomainName DomainNetBIOSName NewDomainName NewDomainNetBIOSName ReplicationSourceDC SiteName".Split(" ") )
                {    
                    $This.Set_FEPromo_Text($This.$($Item))
                }

                $This.Set_Default_NTDS_SYSVOL_Paths()
            }

            Set_FEPromo_Roles([Object]$Obj)
            {
                $This.IO.$( $Obj.Name ).IsEnabled       = $Obj.IsEnabled
                $This.IO.$( $Obj.Name ).IsChecked       = $Obj.IsChecked
            }

            Set_FEPromo_Text([Object]$Obj)
            {
                $This.IO."$( $Obj.Name    )".IsEnabled  = $Obj.IsEnabled
                $This.IO."$( $Obj.Name )Box".Visibility = @("Collapsed","Visible")[$Obj.IsEnabled]
                $This.IO."$( $Obj.Name    )".Text       = ""
            }

            Set_Default_NTDS_SYSVOL_Paths()
            {
                $This.DatabasePath                      = "$Env:SystemRoot\NTDS"
                $This.IO.DatabasePath.Text              = $This.DatabasePath

                $This.LogPath                           = "$Env:SystemRoot\NTDS"
                $This.IO.LogPath.Text                   = $This.LogPath 

                $This.SysvolPath                        = "$Env:SystemRoot\NTDS"
                $This.IO.SysvolPath.Text                = $This.SysvolPath 
            }

            _FEPromo([Object]$Window,[Int32]$Mode)
            {
                $This.Window                            = $Window
                $This.IO                                = $Window.Host
                $This.Host                              = Get-FEModule | % Role | % Host
                $This.Host._Network()
                $This.Network                           = $This.Host.Network

                ForEach ( $F in [_ServerFeatures]::New().Features )
                {
                    $This.IO.$($F.Name).IsEnabled       = !$F.Installed
                    $This.IO.$($F.Name).IsChecked       =  $F.Installed
                }

                $This.SetMode($Mode)
            }
        }

        Write-Theme "Loading Network [:] Domain Controller Initialization"

        $UI                                             = [_FEPromo]::New((Get-XamlWindow -Type FEDCPromo),0)

        $UI.IO.Forest.Add_Click{ $UI.SetMode(0) }
        $UI.IO.Tree.Add_Click{   $UI.SetMode(1) }
        $UI.IO.Child.Add_Click{  $UI.SetMode(2) }
        $UI.IO.Clone.Add_Click{  $UI.SetMode(3) }
        $UI.IO.Cancel.Add_Click{ $UI.IO.DialogResult = $False }

        $UI.Window.Invoke()

        # Forest
        # Tree
        # Child
        # Clone                            

        # DatabasePathBox               : System.Windows.Controls.GroupBox Header:DatabasePath Content:
        # DatabasePath                  : System.Windows.Controls.TextBox
        # SysvolPathBox                 : System.Windows.Controls.GroupBox Header:SysvolPath Content:
        # SysvolPath                    : System.Windows.Controls.TextBox
        # LogPathBox                    : System.Windows.Controls.GroupBox Header:LogPath Content:
        # LogPath                       : System.Windows.Controls.TextBox
        # CredentialBox                 : System.Windows.Controls.GroupBox Header:Credential Content:
        # CredentialButton              : System.Windows.Controls.Button: Credential
        # Credential                    : System.Windows.Controls.TextBox
        # DomainBox                     : 
        # Domain                        : 
        # DomainNetBIOSBox              : 
        # DomainNetBIOS                 : 
        # NewDomainBox                  : 
        # NewDomain                     : 
        # NewDomainNetBIOSBox           : 
        # NewDomainNetBIOS              : 
        # SiteBox                       : 
        # Site                          : 
        # ReplicationSourceDCBox        : System.Windows.Controls.GroupBox Header:ReplicationSourceDC Content:
        # ReplicationSourceDC           : System.Windows.Controls.TextBox
        # InstallDNS                    : System.Windows.Controls.CheckBox Content: IsChecked:False
        # CreateDNSDelegation           : System.Windows.Controls.CheckBox Content: IsChecked:False
        # NoGlobalCatalog               : System.Windows.Controls.CheckBox Content: IsChecked:False
        # CriticalReplicationOnly       : System.Windows.Controls.CheckBox Content: IsChecked:False
        # SafeModeAdministratorPassword : System.Windows.Controls.PasswordBox
        # Confirm                       : System.Windows.Controls.PasswordBox
        # Start                         : System.Windows.Controls.Button: Start
        # Cancel                        : System.Windows.Controls.Button: Cancel
