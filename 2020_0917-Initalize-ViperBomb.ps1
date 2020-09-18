
Class XamlWindow # Originally based on Dr. Weltner's work, but also Jason Adkinson from Pluralsight (His method wasn't able to PassThru variables)
{
    Hidden [String]        $Xaml
    [String[]]            $Names 
    [String[]]         $Assembly = "PresentationFramework PresentationCore WindowsBase".Split(" ")
    [XML.XMLReader]        $Node
    [Object]               $Host
    [Windows.Window]         $IO

    XamlWindow([String]$XAML)
    {
        If ( !$Xaml ) 
        {
            Throw "Invalid XAML Input"
        }

        $This.Xaml               = $Xaml
        $This.Names              = ([Regex]"((Name)\s*=\s*('|`")\w+('|`"))").Matches($This.Xaml).Value | % { $_ -Replace "(Name|=|'|`"|\s)","" } | Select-Object -Unique
        $This.Assembly           | % { Add-Type -AssemblyName $_ }
        $This.Node               = [XML.XMLReader]::Create([IO.StringReader]$This.Xaml)
        $This.Host               = [Windows.Markup.XAMLReader]::Load($This.Node)
    
        ForEach ( $I in 0..( $This.Names.Count - 1 ) )
        {
            $This.Host           | Add-Member -MemberType NoteProperty -Name $This.Names[$I] -Value $This.Host.FindName($This.Names[$I]) -Force 
        }

        $This.IO                 = [Windows.Window]::new()
    }

    Invoke()
    {
        $This.IO.Dispatcher.InvokeAsync({
        
            $Output              = $This.Host.ShowDialog()
            Set-Variable -Name Output -Value $Output -Scope Global

        }).Wait()
    }
}

Class Info
{
    [Object]                 $OS = (Get-CimInstance -ClassName Win32_OperatingSystem)
    [Object]                 $CS = (Get-CimInstance -ClassName Win32_ComputerSystem)
    Hidden [Object]         $Env = ([PSCustomObject][Environment]::GetEnvironmentVariables().GetEnumerator() | Sort-Object Name)

    Hidden [Hashtable]     $Hash = @{ 

                         Edition = ("10240,Threshold 1,Release To Manufacturing;10586,Threshold 2,November {1};14393,{0} 1,Anniversary {1};15063," + 
                                    "{0} 2,{2} {1};16299,{0} 3,Fall {2} {1};17134,{0} 4,April 2018 {1};17763,{0} 5,October 2018 {1};18362,19H1,Ma" + 
                                    "y 2019 {1};18363,19H2,November 2019 {1};19000,20H1,Unreleased") -f 'Redstone','Update','Creators' -Split ";"

                         Chassis = "N/A Desktop Mobile/Laptop Workstation Server Server Appliance Server Maximum" -Split " "
                             SKU = ("Undefined,Ultimate {0},Home Basic {0},Home Premium {0},{3} {0},Home Basic N {0},Business {0},Standard {2} {0" + 
                                    "},Datacenter {2} {0},Small Business {2} {0},{3} {2} {0},Starter {0},Datacenter {2} Core {0},Standard {2} Cor" +
                                    "e {0},{3} {2} Core {0},{3} {2} IA64 {0},Business N {0},Web {2} {0},Cluster {2} {0},Home {2} {0},Storage Expr" + 
                                    "ess {2} {0},Storage Standard {2} {0},Storage Workgroup {2} {0},Storage {3} {2} {0},{2} For Small Business {0" + 
                                    "},Small Business {2} Premium {0},TBD,{1} {3},{1} Ultimate,Web {2} Core,-,-,-,{2} Foundation,{1} Home {2},-,{" + 
                                    "1} {2} Standard No Hyper-V Full,{1} {2} Datacenter No Hyper-V Full,{1} {2} {3} No Hyper-V Full,{1} {2} Datac" + 
                                    "enter No Hyper-V Core,{1} {2} Standard No Hyper-V Core,{1} {2} {3} No Hyper-V Core,Microsoft Hyper-V {2},Sto" + 
                                    "rage {2} Express Core,Storage {2} Standard Core,{2} Workgroup Core,Storage {2} {3} Core,Starter N,Profession" + 
                                    "al,Professional N,{1} Small Business {2} 2011 Essentials,-,-,-,-,-,-,-,-,-,-,-,-,Small Business {2} Premium " + 
                                    "Core,{1} {2} Hyper Core V,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,--,-,-,{1} Thin PC,-,{1} Embedded Industry,-,-" +
                                    ",-,-,-,-,-,{1} RT,-,-,Single Language N,{1} Home,-,{1} Professional with Media Center,{1} Mobile,-,-,-,-,-,-" + 
                                    ",-,-,-,-,-,-,-,{1} Embedded Handheld,-,-,-,-,{1} IoT Core") -f "Edition","Windows","Server","Enterprise" -Split ","
    }

    Hidden [Object]      $VTable = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' )
    [String]            $Caption
    [Object]            $Version
    [String]              $Build
    [Int32]           $ReleaseID
    [String]           $CodeName
    [String]               $Name
    [String]                $SKU
    [String]            $Chassis

    Info()
    {
        $This.Version            = (Get-Host).Version.ToString()
        $This.ReleaseID          = $This.VTable.ReleaseID
        $ID                      = Switch ($This.ReleaseID) { 1507 {0} 1511 {1} 1607 {2} 1703 {3} 1709 {4} 1803 {5} 1809 {6} 1903 {7} 1909 {8} 2004 {9} }

        $This.Build, $This.CodeName, $This.Name = $This.Hash.Edition[$ID].Split(",")

        $This.Caption            = $This.OS.Caption
        $This.SKU                = $This.Hash.SKU[$This.OS.OperatingSystemSKU]
        $This.Chassis            = $This.Hash.Chassis[$This.CS.PCSystemType]
    }
}

Class FEQMark
{
    [String] $PID
                
    FEQMark()
    {
        $This.PID                = (Get-Service *_* -EA 0 | ? ServiceType -eq 224 | Select-Object -First 1).Name.Split('_')[-1]
    }
}

Class FEConfig
{
    # Module Details
    [String]               $Name = "FightingEntropy/ViperBomb"
    [String]        $Description = "ViperBomb... it's like throwing a flashbang in Counter-Strike. But, for Windows Services though."
    [String]            $Version = "2020.09.0"
    [String]            $Release = "Development"

    # Resources
    [String]                $URL = "https://github.com/secure-digits-plus-llc/FightingEntropy"
    [String]            $MadBomb = "https://github.com/madbomb122/BlackViperScript"
    [String]         $BlackViper = "http://www.blackviper.com"
    [String]               $Site = "https://www.securedigitsplus.com"
    Hidden [String[]] $Copyright = ("Copyright (c) 2019 Zero Rights Reserved;Services Configuration by Charles 'Black Viper' Sparks;;The MIT Licens" + 
                                    "e (MIT) + an added Condition;;Copyright (c) 2017-2019 Madbomb122;;[Black Viper Service Script];Permission is her" + 
                                    "eby granted, free of charge, to any person obtaining a ;copy of this software and associated documentation files" + 
                                    " (the Software),;to deal in the Software without restriction, including w/o limitation;the rights to: use/copy/m" + 
                                    "odify/merge/publish/distribute/sublicense,;and/or sell copies of the Software, and to permit persons to whom the" + 
                                    ";Software is furnished to do so, subject to the following conditions:;;The above copyright notice(s), this permi" + 
                                    "ssion notice and ANY original;donation link shall be included in all copies or substantial portions of;the Softw" + 
                                    "are.;;The software is provided 'As Is', without warranty of any kind, express;or implied, including but not limi" + 
                                    "ted to warranties of merchantibility,;or fitness for a particular purpose and noninfringement. In no event;shall" + 
                                    " the authors or copyright holders be liable for any claim, damages;or other liability, whether in an action of c" + 
                                    "ontract, tort or otherwise,;arising from, out of or in connection with the software or the use or;other dealings" + 
                                    " in the software.;;In other words, these terms of service must be accepted in order to use,;and in no circumstan" + 
                                    "ce may the author(s) be subjected to any liability;or damage resultant to its use.").Split(";")

    # About the project
    Hidden [String[]]     $About = ("This utility provides an interface to load and customize;service configuration profiles, such as:;;    Default" + 
                                    ": Black Viper (Sparks v1.0);    Custom: If in proper format;    Backup: Created via this utility").Split(";")

    # Help on usage
    Hidden [String[]]      $Help = (("[Basic];;_-atos___Accepts ToS;_-auto___Automates Process | Aborts upon user input/errors;;[Profile];;_-defaul" + 
                                    "t__Standard;_-safe___Sparks/Safe;_-tweaked__Sparks/Tweaked;_-lcsc File.csv  Loads Custom Service Configuration, " + 
                                    "File.csv = Name of your backup/custom file;;[Template];;_-all___ Every windows services will change;_-min___ Jus" + 
                                    "t the services different from the default to safe/tweaked list;_-sxb___ Skips changes to all XBox Services;;[Upd" + 
                                    "ate];;_-usc___ Checks for Update to Script file before running;_-use___ Checks for Update to Service file before" + 
                                    " running;_-sic___ Skips Internet Check, if you can't ping GitHub.com for some reason;;[Logging];;_-log___ Makes " + 
                                    "a log file named using default name Script.log;_-log File.log_Makes a log file named File.log;_-baf___ Log File " + 
                                    "of Services Configuration Before and After the script;;[Backup];;_-bscc___Backup Current Service Configuration C" + 
                                    "sv File;_-bscr___Backup Current Service Configuration, Reg File;_-bscb___Backup Current Service Configuration, C" + 
                                    "sv and Reg File;;[Display];;_-sas___ Show Already Set Services;_-snis___Show Not Installed Services;_-sss___ Sho" + 
                                    "wSkipped Services;;[Miscellaneous];;_-dry___ Runs the Script and Shows what services will be changed;_-css___ Ch" + 
                                    "ange State of Service;_-sds___ Stop Disabled Service;;[Experimental];;_-secp___Skips Edition Check by Setting Ed" + 
                                    "ition as Pro;_-sech___Skips Edition Check by Setting Edition as Home;_-sbc___ Skips Build Check;;[Development];;" + 
                                    "_-devl___Makes a log file with various Diagnostic information, Nothing is Changed;_-diag___Shows diagnostic info" + 
                                    "rmation, Stops -auto;_-diagf__   Forced diagnostic information, Script does nothing else;;[Help];;_-help___Shows" +
                                    " list of switches, then exits script.. alt -h;_-copy___Shows Copyright/License Information, then exits script" + 
                                    ";").Replace("_","    ")).Split(";")
    
    # GUI/Object Labels
    Hidden [String[]]      $Type = "10H:D+ 10H:D- 10P:D+ 10P:D- DT:S+ DT:S- DT:T+ DT:T- LT:S+ LT:S-".Split(" ")
    Hidden [String[]]     $Title = (("{0} Home | {1};{0} Pro | {1};{2} | Safe;{2} | Tweaked;Laptop | Safe" -f "Windows 10","Default","Desktop"
                                 ).Split(";") | % { "$_ Max" , "$_ Min" })
    
    # System Info
    [Info]                 $Info = [Info]::New()

    # Services        
    Hidden [String[]]       $PID = (Get-Service *_* -EA 0 | ? ServiceType -eq 224 | Select-Object -First 1 ).Name.Split('_')[-1]

    # Display Filters
    Hidden [Hashtable]  $Display = @{ 

                            Xbox = ("XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc xbgm".Split(" "))
                          NetTCP = ("Msmq Pipe Tcp".Split(" ") | % { "Net$_`Activator" })
                            Skip = (@(("AppXSVC BrokerInfrastructure ClipSVC CoreMessagingRegistrar DcomLaunch EntAppSvc gpsvc LSM MpsSvc msiserver NgcCt" + 
                                       "nrSvc NgcSvc RpcEptMapper RpcSs Schedule SecurityHealthService sppsvc StateRepository SystemEventsBroker tiledata" + 
                                       "modelsvc WdNisSvc WinDefend") -Split " " ;
                                       ("BcastDVRUserService DevicePickerUserSvc DevicesFlowUserSvc PimIndexMaintenanceSvc PrintWorkflowUserSvc UnistoreS" + 
                                       "vc UserDataSvc WpnUserService") -Split " " | % { "$_`_$([FEQMark]::New().PID)" }) | Sort-Object)
    }

    # BlackViper Default Config
    Hidden [Hashtable]   $Config = @{
    
                         Names   = (("AJRouter;ALG;AppHostSvc;AppIDSvc;Appinfo;AppMgmt;AppReadiness;AppVClient;aspnet_state;AssignedAccessManagerSvc;" + 
                                      "AudioEndpointBuilder;AudioSrv;AxInstSV;BcastDVRUserService_{0};BDESVC;BFE;BITS;BluetoothUserService_{0};Browser;B" +
                                      "TAGService;BthAvctpSvc;BthHFSrv;bthserv;c2wts;camsvc;CaptureService_{0};CDPSvc;CDPUserSvc_{0};CertPropSvc;COMSysA" + 
                                      "pp;CryptSvc;CscService;defragsvc;DeviceAssociationService;DeviceInstall;DevicePickerUserSvc_{0};DevQueryBroker;Dh" +
                                      "cp;diagnosticshub.standardcollector.service;diagsvc;DiagTrack;DmEnrollmentSvc;dmwappushsvc;Dnscache;DoSvc;dot3svc" +
                                      ";DPS;DsmSVC;DsRoleSvc;DsSvc;DusmSvc;EapHost;EFS;embeddedmode;EventLog;EventSystem;Fax;fdPHost;FDResPub;fhsvc;Font" +
                                      "Cache;FontCache3.0.0.0;FrameServer;ftpsvc;GraphicsPerfSvc;hidserv;hns;HomeGroupListener;HomeGroupProvider;HvHost;" +
                                      "icssvc;IKEEXT;InstallService;iphlpsvc;IpxlatCfgSvc;irmon;KeyIso;KtmRm;LanmanServer;LanmanWorkstation;lfsvc;Licens" + 
                                      "eManager;lltdsvc;lmhosts;LPDSVC;LxssManager;MapsBroker;MessagingService_{0};MSDTC;MSiSCSI;MsKeyboardFilter;MSMQ;M" +
                                      "SMQTriggers;NaturalAuthentication;NcaSVC;NcbService;NcdAutoSetup;Netlogon;Netman;NetMsmqActivator;NetPipeActivato" +
                                      "r;netprofm;NetSetupSvc;NetTcpActivator;NetTcpPortSharing;NlaSvc;nsi;OneSyncSvc_{0};p2pimsvc;p2psvc;PcaSvc;PeerDis" +
                                      "tSvc;PerfHost;PhoneSvc;pla;PlugPlay;PNRPAutoReg;PNRPsvc;PolicyAgent;Power;PrintNotify;PrintWorkflowUserSvc_{0};Pr" +
                                      "ofSvc;PushToInstall;QWAVE;RasAuto;RasMan;RemoteAccess;RemoteRegistry;RetailDemo;RmSvc;RpcLocator;SamSs;SCardSvr;S" +
                                      "cDeviceEnum;SCPolicySvc;SDRSVC;seclogon;SEMgrSvc;SENS;Sense;SensorDataService;SensorService;SensrSvc;SessionEnv;S" + 
                                      "grmBroker;SharedAccess;SharedRealitySvc;ShellHWDetection;shpamsvc;smphost;SmsRouter;SNMPTRAP;spectrum;Spooler;SSD" + 
                                      "PSRV;ssh-agent;SstpSvc;StiSvc;StorSvc;svsvc;swprv;SysMain;TabletInputService;TapiSrv;TermService;Themes;TieringEn" +
                                      "gineService;TimeBroker;TokenBroker;TrkWks;TrustedInstaller;tzautoupdate;UevAgentService;UI0Detect;UmRdpService;up" + 
                                      "nphost;UserManager;UsoSvc;VaultSvc;vds;vmcompute;vmicguestinterface;vmicheartbeat;vmickvpexchange;vmicrdv;vmicshu" +
                                      "tdown;vmictimesync;vmicvmsession;vmicvss;vmms;VSS;W32Time;W3LOGSVC;W3SVC;WaaSMedicSvc;WalletService;WarpJITSvc;WA" +
                                      "S;wbengine;WbioSrvc;Wcmsvc;wcncsvc;WdiServiceHost;WdiSystemHost;WebClient;Wecsvc;WEPHOSTSVC;wercplsupport;WerSvc;" + 
                                      "WFDSConSvc;WiaRpc;WinHttpAutoProxySvc;Winmgmt;WinRM;wisvc;WlanSvc;wlidsvc;wlpasvc;wmiApSrv;WMPNetworkSvc;WMSVC;wo" + 
                                      "rkfolderssvc;WpcMonSvc;WPDBusEnum;WpnService;WpnUserService_{0};wscsvc;WSearch;wuauserv;wudfsvc;WwanSvc;xbgm;XblA" + 
                                      "uthManager;XblGameSave;XboxGipSvc;XboxNetApiSvc") -f [FEQMark]::New().PID ).Split(";")

                         Masks   = (("0;1;2;3;3;4;3;5;3;6;2;2;3;3;3;2;7;3;3;0;0;0;0;3;3;4;7;2;0;3;2;8;3;3;3;3;3;2;3;3;2;3;1;2;7;3;2;3;3;3;2;3;3;3;2;2" + 
                                      ";1;3;3;3;2;3;1;2;3;3;6;3;3;1;1;3;3;9;0;1;3;3;2;2;1;3;3;3;2;3;1;0;3;3;1;11;2;2;0;3;3;0;0;3;2;2;3;3;2;1;2;2;7;3;3;" + 
                                      "2;8;3;1;3;3;3;3;3;2;3;3;2;3;3;3;3;12;12;1;3;1;2;12;1;1;3;3;1;2;6;13;13;13;0;7;1;3;2;12;3;1;1;3;2;3;3;3;3;3;3;3;2" + 
                                      ";13;3;0;2;3;3;3;2;3;12;5;3;0;3;2;3;3;3;6;1;1;1;1;1;1;1;1;14;3;3;3;2;3;3;3;3;3;3;2;0;3;3;0;3;3;3;3;13;3;3;2;1;1;1" + 
                                      "5;3;3;3;1;3;1;1;3;2;2;7;7;3;3;1;3;1;1;3;1").Split(";"))

                        Values   = (("2,2,2,2,2,2,1,1,2,2;2,2,2,2,1,1,1,1,1,1;3,0,3,0,3,0,3,0,3,0;2,0,2,0,2,0,2,0,2,0;0,0,2,2,2,2,1,1,2,2;0,0,1,0,1,0" + 
                                      ",1,0,1,0;0,0,2,0,2,0,2,0,2,0;4,0,4,0,4,0,4,0,4,0;0,0,2,2,1,1,1,1,1,1;3,3,3,3,3,3,1,1,3,3;4,4,4,4,1,1,1,1,1,1;0,0" + 
                                      ",0,0,0,0,0,0,0,0;1,0,1,0,1,0,1,0,1,0;2,2,2,2,1,1,1,1,2,2;0,0,3,0,3,0,3,0,3,0;3,3,3,3,2,2,2,2,3,3").Split(";"))
    }

    # XAML Import
    Hidden [String]        $Xaml = @"
    <Window             xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                      xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                        Title = '[FightingEntropy] @ ViperBomb'
                       Height = '800'
                        Width = '800'
                      Topmost = 'True'
                  BorderBrush = 'Black'
                   ResizeMode = 'NoResize'
          HorizontalAlignment = 'Center'
        WindowStartupLocation = 'CenterScreen'>
        <Window.Resources>
            <Style      x:Key = 'SeparatorStyle1' 
                   TargetType = '{x:Type Separator}'>
                <Setter Property = 'SnapsToDevicePixels' 
                        Value    = 'True'/>
                <Setter Property = 'Margin' 
                        Value    = '0,0,0,0'/>
                <Setter Property = 'Template'>
                    <Setter.Value>
                        <ControlTemplate TargetType     = '{x:Type Separator}'>
                            <Border Height              = '24' 
                                    SnapsToDevicePixels = 'True' 
                                    Background          = '#FF4D4D4D' 
                                    BorderBrush         = 'Azure' 
                                    BorderThickness     = '1,1,1,1' 
                                    CornerRadius        = '5,5,5,5'/>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
            </Style>
            <Style TargetType    = '{x:Type ToolTip}'>
                <Setter Property = 'Background' 
                        Value    = '#FFFFFFBF'/>
            </Style>
        </Window.Resources>
        <Window.Effect>
            <DropShadowEffect/>
        </Window.Effect>
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height = '20'/>
                <RowDefinition Height = '*'/>
                <RowDefinition Height = '60'/>
            </Grid.RowDefinitions>
            <Menu            Grid.Row = '0'
                           IsMainMenu = 'True'>
                <MenuItem      Header = 'Configuration'>
                    <MenuItem    Name = 'Profile_0' Header = '0 - Windows 10 Home / Default Max'/>
                    <MenuItem    Name = 'Profile_1' Header = '1 - Windows 10 Home / Default Min'/>
                    <MenuItem    Name = 'Profile_2' Header = '2 - Windows 10 Pro / Default Max'/>
                    <MenuItem    Name = 'Profile_3' Header = '3 - Windows 10 Pro / Default Min'/>
                    <MenuItem    Name = 'Profile_4' Header = '4 - Desktop / Default Max'/>
                    <MenuItem    Name = 'Profile_5' Header = '5 - Desktop / Default Min'/>
                    <MenuItem    Name = 'Profile_6' Header = '6 - Desktop / Default Max'/>
                    <MenuItem    Name = 'Profile_7' Header = '7 - Desktop / Default Min'/>
                    <MenuItem    Name = 'Profile_8' Header = '8 - Laptop / Default Max'/>
                    <MenuItem    Name = 'Profile_9' Header = '9 - Laptop / Default Min'/>
                </MenuItem>
                <MenuItem     Header         = 'Info'>
                    <MenuItem Name           = 'URL'
                            Header         = 'Resources'/>
                    <MenuItem Name           = 'About'
                            Header         = 'About'/>
                    <MenuItem Name           = 'Copyright'
                            Header         = 'Copyright'/>
                    <MenuItem Name           = 'MadBomb'
                            Header         = 'MadBomb122'/>
                    <MenuItem Name           = 'BlackViper'
                            Header         = 'BlackViper'/>
                    <MenuItem Name           = 'Site'
                            Header         = 'Company Website'/>
                    <MenuItem Name           = 'Help'
                            Header         = 'Help'/>
                </MenuItem>
            </Menu>
            <Grid Grid.Row                   = '1'>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width  = '*'/>
                </Grid.ColumnDefinitions>
                <TabControl BorderBrush      = 'Gainsboro' 
                            Grid.Row         = '1' 
                            Name             = 'TabControl'>
                    <TabControl.Resources>
                        <Style TargetType    = 'TabItem'>
                            <Setter Property = 'Template'>
                                <Setter.Value>
                                    <ControlTemplate TargetType                   = 'TabItem'>
                                        <Border Name                              = 'Border' 
                                                BorderThickness                   = '1,1,1,0' 
                                                BorderBrush                       = 'Gainsboro' 
                                                CornerRadius                      = '4,4,0,0' 
                                                Margin                            = '2,0'>
                                            <ContentPresenter x:Name              = 'ContentSite' 
                                                            VerticalAlignment   = 'Center' 
                                                            HorizontalAlignment = 'Center' 
                                                            ContentSource       = 'Header' 
                                                            Margin              = '10,2'/>
                                        </Border>
                                        <ControlTemplate.Triggers>
                                            <Trigger Property      = 'IsSelected' 
                                                    Value         = 'True'>
                                                <Setter TargetName = 'Border' 
                                                        Property   = 'Background' 
                                                        Value      = 'LightSkyBlue'/>
                                            </Trigger>
                                            <Trigger Property      = 'IsSelected' 
                                                    Value         = 'False'>
                                                <Setter TargetName = 'Border' 
                                                        Property   = 'Background' 
                                                        Value      = 'GhostWhite'/>
                                            </Trigger>
                                        </ControlTemplate.Triggers>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                        </Style>
                    </TabControl.Resources>
                    <TabItem Header = 'Service Dialog'>
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height = '60'/>
                                <RowDefinition Height = '32'/>
                                <RowDefinition Height =  '*'/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '0.45*'/>
                                    <ColumnDefinition Width = '0.15*'/>
                                    <ColumnDefinition Width = '0.25*'/>
                                    <ColumnDefinition Width = '0.15*'/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column = "0" Header = "Operating System" Margin = "5">
                                    <Label Name = "Caption"/>
                                </GroupBox>
                                <GroupBox Grid.Column = "1" Header = "Release ID" Margin = "5">
                                    <Label Name = "ReleaseID"/>
                                </GroupBox>
                                <GroupBox Grid.Column = "2" Header = "Version" Margin = "5">
                                    <Label Name = "Version"/>
                                </GroupBox>
                                <GroupBox Grid.Column = "3" Header = "Chassis" Margin = "5">
                                    <Label Name = "Chassis"/>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Row            = '1'>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '0.66*'/>
                                    <ColumnDefinition Width = '0.33*'/>
                                    <ColumnDefinition Width = "1*"/>
                                </Grid.ColumnDefinitions>
                                <TextBox  Grid.Column = '0' Margin ='5' Name = 'Search' TextWrapping      = 'Wrap'>Search</TextBox>
                                <ComboBox Grid.Column = '1' Margin ='5' Name = 'Select' VerticalAlignment = 'Center'>
                                    <ComboBoxItem Content = 'Checked'/>
                                    <ComboBoxItem Content = 'Display Name' IsSelected='True'/>
                                    <ComboBoxItem Content = 'Name'/>
                                    <ComboBoxItem Content = 'Current Setting'/>
                                </ComboBox>                            
                                <TextBlock Grid.Column = '2' 
                                                Margin         = '5' 
                                                TextAlignment  = 'Center'>Service State:
                                            <Run   Background  = '#66FF66' 
                                                Text           = 'Compliant'/> /
                                            <Run   Background     = '#FFFF66' 
                                                Text           = 'Unspecified'/> /
                                            <Run   Background     = '#FF6666' 
                                                Text           = 'Non Compliant'/>
                                </TextBlock>
                            </Grid>
                            <DataGrid Grid.Row                 = '2'
                                    Grid.Column                = '0'
                                    Name                       = 'DataGrid'
                                    FrozenColumnCount          = '2' 
                                    AutoGenerateColumns        = 'False' 
                                    AlternationCount           = '2' 
                                    HeadersVisibility          = 'Column' 
                                    CanUserResizeRows          = 'False' 
                                    CanUserAddRows             = 'False' 
                                    IsTabStop                  = 'True' 
                                    IsTextSearchEnabled        = 'True' 
                                    SelectionMode              = 'Extended'>
                                <DataGrid.RowStyle>
                                    <Style TargetType          = '{x:Type DataGridRow}'>
                                        <Style.Triggers>
                                            <Trigger Property  = 'AlternationIndex'
                                                    Value      = '0'>
                                                <Setter Property = 'Background'
                                                        Value    = 'White'/>
                                            </Trigger>
                                            <Trigger Property    = 'AlternationIndex'
                                                    Value       = '1'>
                                                <Setter Property = 'Background'
                                                        Value    = '#FFD8D8D8'/>
                                            </Trigger>
                                            <Trigger Property    = 'IsMouseOver'
                                                    Value       = 'True'>
                                                <Setter Property = 'ToolTip'>
                                                    <Setter.Value>
                                                        <TextBlock Text         = '{Binding Description}'
                                                                TextWrapping = 'Wrap'
                                                                Width        = '400'
                                                                Background   = '#FFFFFFBF'
                                                                Foreground   = 'Black'/>
                                                    </Setter.Value>
                                                </Setter>
                                                <Setter Property                = 'ToolTipService.ShowDuration'
                                                        Value                   = '360000000'/>
                                            </Trigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'True'/>
                                                    <Condition Binding          = '{Binding Matches}' 
                                                            Value            = 'False'/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property                = 'Background' 
                                                        Value                   = '#F08080'/>
                                            </MultiDataTrigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'False'/>
                                                    <Condition Binding          = '{Binding Matches}' 
                                                            Value            = 'False'/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property                = 'Background' 
                                                        Value                   = '#FFFFFF64'/>
                                            </MultiDataTrigger>
                                            <MultiDataTrigger>
                                                <MultiDataTrigger.Conditions>
                                                    <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'True'/>
                                                    <Condition Binding          = '{Binding Matches}'
                                                            Value            = 'True'/>
                                                </MultiDataTrigger.Conditions>
                                                <Setter Property                = 'Background'
                                                        Value                   = 'LightGreen'/>
                                            </MultiDataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </DataGrid.RowStyle>
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header                  = 'Index' 
                                                        Width                   = '50'
                                                        Binding                 = '{Binding Index}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'Name'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding Name}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'Scoped' 
                                                        Width                   = '75'
                                                        Binding                 = '{Binding Scope}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'Profile'
                                                        Width                   = '100'
                                                        Binding                 = '{Binding Slot}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'Status'
                                                        Width                   = '75'
                                                        Binding                 = '{Binding Status}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'StartType' 
                                                        Width                   = '75' 
                                                        Binding                 = '{Binding StartMode}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'DisplayName'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding DisplayName}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'PathName'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding PathName}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                    <DataGridTextColumn Header                  = 'Description'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding Description}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </TabItem>
                    <TabItem                            Header                  = 'Preferences'>
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height = '1.25*'/>
                                <RowDefinition Height = '*'/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row = '0'>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '*'/>
                                    <ColumnDefinition Width = '*'/>
                                    <ColumnDefinition Width = '*'/>
                                </Grid.ColumnDefinitions>
                                <Grid Grid.Column = '2'>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*'/>
                                        <RowDefinition Height = '*'/>
                                    </Grid.RowDefinitions>
                                    <GroupBox Grid.Row = '0' Header = 'Bypass / Checks [ Risky Options ]' Margin = '5'>
                                        <Grid>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '*'/>
                                                <RowDefinition Height = '*'/>
                                                <RowDefinition Height = '*'/>
                                            </Grid.RowDefinitions>
                                            <CheckBox   Grid.Row = '1' Margin = '5' Name = 'BypassBuild' Content = "Skip Build/Version Check"/>
                                            <ComboBox   Grid.Row = '0' VerticalAlignment = 'Center' Height = '24' Name = 'BypassEdition'>
                                                <ComboBoxItem Content = 'Override Edition Check' IsSelected = 'True'/>
                                                <ComboBoxItem Content = 'Windows 10 Home'/>
                                                <ComboBoxItem Content = 'Windows 10 Pro'/>
                                            </ComboBox>
                                            <CheckBox   Grid.Row = '2' Margin = '5' Name = 'BypassLaptop' Content = 'Enable Laptop Tweaks'/>
                                        </Grid>
                                    </GroupBox>
                                    <GroupBox Grid.Row = '1' Header = 'Display' Margin = '5' >
                                        <Grid >
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                            </Grid.RowDefinitions>
                                            <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DisplayActive'    Content = "Show Active Services"           />
                                            <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DisplayInactive'  Content = "Show Inactive Services"         />
                                            <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DisplaySkipped'   Content = "Show Skipped Services"          />
                                        </Grid>
                                    </GroupBox>
                                </Grid>
                                <Grid Grid.Column = '0'>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*'/>
                                        <RowDefinition Height = '2*'/>
                                    </Grid.RowDefinitions>
                                    <GroupBox Grid.Row = '0' Header = 'Service Configuration' Margin = '5'>
                                        <ComboBox  Grid.Row = '1' Name = 'ServiceProfile' Height ='24'>
                                            <ComboBoxItem Content = 'Black Viper (Sparks v1.0)' IsSelected = 'True'/>
                                            <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsEnabled = 'False'/>
                                        </ComboBox>
                                    </GroupBox>
                                    <GroupBox Grid.Row = '1' Header = 'Miscellaneous' Margin = '5'>
                                        <Grid>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                            </Grid.RowDefinitions>
                                            <CheckBox  Grid.Row = '0' Margin = '5' Name = 'MiscSimulate'     Content = "Simulate Changes [ Dry Run ]"   />
                                            <CheckBox  Grid.Row = '1' Margin = '5' Name = 'MiscXbox'         Content = "Skip All Xbox Services"         />
                                            <CheckBox  Grid.Row = '2' Margin = '5' Name = 'MiscChange'       Content = "Allow Change of Service State"  />
                                            <CheckBox  Grid.Row = '3' Margin = '5' Name = 'MiscStopDisabled' Content = "Stop Disabled Services"         />
                                        </Grid>
                                    </GroupBox>
                                </Grid>
                                <Grid Grid.Column = '1'>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*'/>
                                        <RowDefinition Height = '2*'/>
                                    </Grid.RowDefinitions>
                                    <GroupBox Grid.Row = '0' Header = 'User Interface' Margin = '5'>
                                        <ComboBox  Grid.Row = '1' Name = 'ScriptProfile' Height = '24' >
                                            <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsSelected =  'True'/>
                                            <ComboBoxItem Content = 'MadBomb (MadBomb122 v1.0)' IsEnabled  = 'False' />
                                        </ComboBox>
                                    </GroupBox>
                                    <GroupBox Grid.Row='1' Header = 'Development' Margin='5'>
                                        <Grid >
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                                <RowDefinition Height = '30'/>
                                            </Grid.RowDefinitions>
                                            <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DevelDiagErrors'  Content = "Diagnostic Output [ On Error ]" />
                                            <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DevelLog'         Content = "Enable Development Logging"     />
                                            <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DevelConsole'     Content = "Enable Console"                 />
                                            <CheckBox  Grid.Row = '3' Margin = '5' Name = 'DevelDiagReport'  Content = "Enable Diagnostic"              />
                                        </Grid>
                                    </GroupBox>
                                </Grid>
                            </Grid>
                            <Grid Grid.Row = '1'>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*'/>
                                    <RowDefinition Height = '*'/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row = '0' Header = 'Logging: Create logs for all changes made via this utility' Margin = '5'>
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width = '75'/>
                                            <ColumnDefinition Width = '*'/>
                                            <ColumnDefinition Width = '6*'/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*' />
                                            <RowDefinition Height = '*' />
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row = '0' Grid.Column = '0' Margin = '5' Name = 'LoggingServiceSwitch' Content   = 'Services' FlowDirection = 'RightToLeft'/>
                                        <Button   Grid.Row = '0' Grid.Column = '1' Margin = '5' Name = 'LoggingServiceBrowse' Content   = 'Browse'  />
                                        <TextBox  Grid.Row = '0' Grid.Column = '2' Margin = '5' Name = 'LoggingServiceFile'   IsEnabled = 'False'   />
                                        <CheckBox Grid.Row = '1' Grid.Column = '0' Margin = '5' Name = 'LoggingScriptSwitch'  Content   = 'Script'   FlowDirection = 'RightToLeft' />
                                        <Button   Grid.Row = '1' Grid.Column = '1' Margin = '5' Name = 'LoggingScriptBrowse'  Content   = 'Browse'  />
                                        <TextBox  Grid.Row = '1' Grid.Column = '2' Margin = '5' Name = 'LoggingScriptFile'    IsEnabled = 'False'   />
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row = '1' Header = 'Backup: Save your current Service Configuration' Margin = '5'>
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width = '75'/>
                                            <ColumnDefinition Width = '*'/>
                                            <ColumnDefinition Width = '6*'/>
                                        </Grid.ColumnDefinitions>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*' />
                                            <RowDefinition Height = '*' />
                                        </Grid.RowDefinitions>
                                        <CheckBox Grid.Row = '0' Grid.Column = '0' Margin = '5' Name = 'BackupRegistrySwitch' Content   = 'reg.*'   FlowDirection = 'RightToLeft'/>
                                        <Button   Grid.Row = '0' Grid.Column = '1' Margin = '5' Name = 'BackupRegistryBrowse' Content   = 'Browse'  />
                                        <TextBox  Grid.Row = '0' Grid.Column = '2' Margin = '5' Name = 'BackupRegistryFile'   IsEnabled = 'False'   />
                                        <CheckBox Grid.Row = '1' Grid.Column = '0' Margin = '5' Name = 'BackupTemplateSwitch' Content   = 'csv.*'  FlowDirection = 'RightToLeft' />
                                        <Button   Grid.Row = '1' Grid.Column = '1' Margin = '5' Name = 'BackupTemplateBrowse' Content   = 'Browse'  />
                                        <TextBox  Grid.Row = '1' Grid.Column = '2' Margin = '5' Name = 'BackupTemplateFile'   IsEnabled = 'False'   />
                                    </Grid>
                                </GroupBox>
                            </Grid>
                        </Grid>
                    </TabItem>
                    <TabItem Header = 'Console'>
                        <Grid Background = '#FFE5E5E5'>
                            <ScrollViewer VerticalScrollBarVisibility = 'Visible'>
                                <TextBlock Name = 'ConsoleOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>
                            </ScrollViewer>
                        </Grid>
                    </TabItem>
                    <TabItem Header = 'Diagnostics'>
                        <Grid Background = '#FFE5E5E5'>
                            <ScrollViewer VerticalScrollBarVisibility = 'Visible'>
                                <TextBlock Name = 'DiagnosticOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>
                            </ScrollViewer>
                        </Grid>
                    </TabItem>
                </TabControl>
            </Grid>
            <Grid Grid.Row = '2'>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width = '2*'/>
                    <ColumnDefinition Width = '*'/>
                    <ColumnDefinition Width = '*'/>
                    <ColumnDefinition Width = '2*'/>
                </Grid.ColumnDefinitions>
                <GroupBox Grid.Column = "0" Header = "Service Configuration" Margin = "5">
                    <Label Name = "ServiceLabel"/>
                </GroupBox>
                <Button Grid.Column = '1' Name =  'Start' Content = 'Start'  FontWeight = 'Bold' Margin = '10'/>
                <Button Grid.Column = '2' Name = 'Cancel' Content = 'Cancel' FontWeight = 'Bold' Margin = '10'/>
                <GroupBox Grid.Column = "3" Header = "Module Version" Margin = "5">
                    <Label Name = "ScriptLabel" />
                </GroupBox>
            </Grid>
        </Grid>
    </Window>
"@

    # Service Sorting
    Hidden [Hashtable]    $Order
    Hidden [Array]         $Sort
    [Object[]]          $Current
    [Object[]]          $Profile

    # XAML Controls
    [String]         $PassedArgs = $Null
    [Int32]      $TermsOfService = 0

    [Int32]          $DispActive = 1
    [Int32]        $DispInactive = 1
    [Int32]         $DispSkipped = 1

    [Int32]        $MiscSimulate = 0
    [Int32]            $MiscXbox = 1
    [Int32]          $MiscChange = 0
    [Int32]    $MiscStopDisabled = 0

    [Int32]           $DevErrors = 0
    [Int32]              $DevLog = 0
    [Int32]          $DevConsole = 0
    [Int32]           $DevReport = 0

    [Int32]             $ByBuild = 0
    [Int32]           $ByEdition = 0
    [Int32]            $ByLaptop = 0

    [String]        $LogSvcLabel = "Service.log"
    [String]        $LogScrLabel = "Script.log"
    [String]           $RegLabel = "Backup.reg"
    [String]           $CSVLabel = "Backup.csv"
    [String]       $ServiceLabel = "Black Viper (Sparks v1.0)"
    [String]        $ScriptLabel = "DevOPS (MC/SDP v1.0)"

    [Service[]]         $Service
    
    FEConfig()
    {
        $This.Current            = ( Get-CimInstance -ClassName Win32_Service | Sort-Object Name )
        $This.Service            = @( $C = 0; Get-Service | % { [Service]::New($C,$_); $C ++ } )
        $This.Order              = @{ }

        ForEach ( $I in 0..( $This.Config.Names.Count - 1 ) )
        {
            $This.Order.Add($This.Config.Names[$I],$I)
        }

        $This.Sort               = $This.Config.Values[$This.Config.Masks]
    }
}

Class Service
{
    [Int32]               $Index
    [Object]            $Service
    [Object]          $WMIObject
    [Object]        $CimInstance
    [Object]           $Registry
    [String]               $Name
    [Bool]                $Scope
    [Int32[]]              $Slot
    [String]          $StartMode
    [String]              $State
    [String]             $Status
    [String]        $DisplayName
    [String]           $PathName
    [String]        $Description

    Service([Int32]$Index,[System.ComponentModel.Component]$Service)
    {
        $This.Index              = $Index
        $This.Service            = $Service
        $This.Name               = $Service.Name      
        $This.StartMode          = $Service.StartType
        $This.State              = $Service.State
        $This.Status             = $Service.Status
        $This.DisplayName        = $Service.DisplayName
        $This.Description        = $Service.Description
    }

    WMI()               { $This.WMIObject   = Get-WMIObject -Class Win32_Service | ? Name -match $This.Name }
    CIM()               { $This.CimInstance = Get-CimInstance -ClassName Win32_Service | ? Name -match $This.Name }
    REG()               { $This.Registry    = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$($This.Name)" }
    Load([String]$Slot) { $This.Slot        = Invoke-Expression $Slot }
}

Function Show-Message
{
    [CmdLetBinding(DefaultParameterSetName=0)]Param(
    [Parameter(ParameterSetName=0,Position=0,Mandatory)]
    [Parameter(ParameterSetName=1,Position=0,Mandatory)][String]$Message,
    [Parameter(ParameterSetName=0,Position=1)][String]$Title=$Null)
    
    If ( $Title )
    {
        [System.Windows.MessageBox]::Show($Title,$Message)
    }

    Else
    {
        [System.Windows.MessageBox]::Show($Message)
    }
}

Class FEViperBomb
{
    [Object] $Config
    [Object] $UI

    SetConfig()
    {
        ###################################################
        #¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯#
        # Menu                                            #
        #_________________________________________________#
        ### [Configuration] ## [Input] ####################
        #   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        #	'Profile_0' # Windows 10 Home / Default Max
        #	'Profile_1' # Windows 10 Home / Default Min
        #	'Profile_2' # Windows 10 Pro / Default Max
        #	'Profile_3' # Windows 10 Pro / Default Min
        #	'Profile_4' # Desktop / Default Max
        #	'Profile_5' # Desktop / Default Min
        #	'Profile_6' # Desktop / Default Max
        #	'Profile_7' # Desktop / Default Min
        #	'Profile_8' # Laptop / Default Max
        #	'Profile_9' # Laptop / Default Min

        $This.UI.Host.Profile_0.Add_Click{$This.SetProfile(0)}
        $This.UI.Host.Profile_1.Add_Click{$This.SetProfile(1)}
        $This.UI.Host.Profile_2.Add_Click{$This.SetProfile(2)}
        $This.UI.Host.Profile_3.Add_Click{$This.SetProfile(3)}
        $This.UI.Host.Profile_4.Add_Click{$This.SetProfile(4)}
        $This.UI.Host.Profile_5.Add_Click{$This.SetProfile(5)}
        $This.UI.Host.Profile_6.Add_Click{$This.SetProfile(6)}
        $This.UI.Host.Profile_7.Add_Click{$This.SetProfile(7)}
        $This.UI.Host.Profile_8.Add_Click{$This.SetProfile(8)}
        $This.UI.Host.Profile_9.Add_Click{$This.SetProfile(9)}
    }

    SetInfo()
    {
        $This.UI.Host.Title = ("{0}v{1}" -f $This.Config.Name, $This.Config.Version )

        ###################################################
        #¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯#
        # Menu                                            #
        #_________________________________________________#
        ### [Configuration] ###[Input]#####################
        #                      ¯¯¯¯¯¯¯
        # 'URL'
        # 'About'
        # 'Copyright'
        # 'MadBomb'
        # 'BlackViper'
        # 'Site'
        # 'Help'

        $This.UI.Host.URL.Add_Click(       {        Start              $This.Template.URL                   })
        $This.UI.Host.About.Add_Click(     { Show-Message     "About" ($This.Template.About     -join "`n") })
        $This.UI.Host.Copyright.Add_Click( { Show-Message "Copyright" ($This.Template.Copyright -join "`n") })
        $This.UI.Host.MadBomb.Add_Click(   {        Start              $This.Template.MadBomb               })
        $This.UI.Host.BlackViper.Add_Click({        Start              $This.Template.BlackViper            })
        $This.UI.Host.Site.Add_Click(      {        Start              $This.Template.Site                  })
        $This.UI.Host.Help.Add_Click(      { Show-Message      "Help" ($This.Template.Help      -join "`n") })

        # TabControl                                                   #
        # [Service Dialog] | [Preferences] | [Console] | [Diagnostics] # 
        # [OS/Caption]     | [ReleaseID]   | [Version] | [Chassis]     #

        $This.UI.Host.Caption.Content               = $This.Info.Caption
        $This.UI.Host.ReleaseID.Content             = $This.Info.ReleaseID
        $This.UI.Host.Version.Content               = $This.Info.Version
        $This.UI.Host.Chassis.Content               = $This.Info.Chassis
    }

    SetPreferences()
    {
        # ByBuild / ByEdition / ByLaptop
        $This.UI.Host.ByBuild.IsChecked             = $This.Config.ByBuild
        $This.UI.Host.ByEdition.SelectedItem        = $This.Config.ByEdition
        $This.UI.Host.ByLaptop.IsChecked            = $This.Config.ByLaptop 

        # DispActive / DispInactive / DispSkipped
        $This.UI.Host.DispActive.IsChecked          = $This.Config.DispActive
        $This.UI.Host.DispInactive.IsChecked        = $True.Config.DispInactive
        $This.UI.Host.DispSkipped.IsChecked         = $True.Config.DispSkipped

        # MiscSimulate / MiscXbox / MiscChange / MiscStopDisabled
        $This.UI.Host.MiscSimulate.IsChecked        = $This.Config.MiscSimulate
        $This.UI.Host.MiscXbox.IsChecked            = $This.Config.MiscXbox
        $This.UI.Host.MiscChange.IsChecked          = $This.Config.MiscChange
        $This.UI.Host.MiscStopDisabled.IsChecked    = $This.Config.MiscStopDisabled

        # DevErrors / DevLog / DevConsole / DevReport
        $This.UI.Host.DevErrors.IsChecked           = $This.Config.DevErrors 
        $This.UI.Host.DevLog.IsChecked              = $This.Config.DevLog  
        $This.UI.Host.DevConsole.IsChecked          = $This.Config.DevConsole
        $This.UI.Host.DevReport.IsChecked           = $This.Config.DevReport
        
        # LogSvcSwitch / LogSvcBrowse / LogSvcLabel
             $This.UI.Host.LogSvcSwitch.IsChecked   = 0 ;   $This.UI.Host.LogSvcBrowse.IsEnabled        = 0
        If ( $This.UI.Host.LogSvcSwitch.IsChecked -eq 0 ) { $This.UI.Host.LogSvcSwitch.Browse.IsEnabled = 0 }
        If ( $This.UI.Host.LogSvcSwitch.IsChecked -eq 1 ) { $This.UI.Host.LogSvcSwitch.Browse.IsEnabled = 1 }

        # LogScrSwitch / LogScrBrowse / LogScrLabel
             $This.UI.Host.LogScrSwitch.IsChecked   = 0 ;   $This.UI.Host.LogScrBrowse.IsEnabled        = 0
        If ( $This.UI.Host.LogScrSwitch.IsChecked -eq 1 ) { $This.UI.Host.LogScrSwitch.Browse.IsEnabled = 1 }
        If ( $This.UI.Host.LogScrSwitch.IsChecked -eq 0 ) { $This.UI.Host.LogScrSwitch.Browse.IsEnabled = 0 }
        
        # RegSwitch / RegBrowse / RegLabel
             $This.UI.Host.RegSwitch.IsChecked      = 0 ;   $This.UI.Host.RegBrowse.IsEnabled           = 0
        If ( $This.UI.Host.RegSwitch.IsChecked    -eq 0 ) { $This.UI.Host.RegBrowse.IsEnabled           = 0 }
        If ( $This.UI.Host.RegSwitch.IsChecked    -eq 1 ) { $This.UI.Host.RegBrowse.IsEnabled           = 1 }

        # CsvSwitch / CsvBrowse / CsvLabel
             $This.UI.Host.CsvSwitch.IsChecked      = 0 ;   $This.UI.Host.CsvBrowse.IsEnabled           = 0
        If ( $This.UI.Host.CsvSwitch.IsChecked    -eq 1 ) { $This.UI.Host.CsvBrowse.IsEnabled           = 1 }
        If ( $This.UI.Host.CsvSwitch.IsChecked    -eq 0 ) { $This.UI.Host.CsvBrowse.IsEnabled           = 0 }

        $This.UI.Host.LogSvcLabel.Text              = "<Activate to designate a different file name/path>" 
        $This.UI.Host.LogScrLabel.Text              = "<Activate to designate a different file name/path>" 
        $This.UI.Host.RegLabel.Text                 = "<Activate to designate a different file name/path>" 
        $This.UI.Host.CsvLabel.Text                 = "<Activate to designate a different file name/path>" 

        $This.UI.Host.LogSvcBrowse.IsEnabled        = 0 ; $This.UI.Host.LogScrBrowse.IsEnabled          = 0
        $This.UI.Host.RegBrowse.IsEnabled           = 0 ; $This.UI.Host.CsvBrowse.IsEnabled             = 0

        # ServiceConfig / ServiceConfigLabel
        $This.UI.Host.ServiceConfigLabel.Content    = $This.UI.Host.ServiceConfig.SelectedItem.Content
       
        # ScriptConfig /  ScriptConfigLabel
        $This.UI.Host.ScriptConfigLabel.Content     = $This.UI.Host.ScriptConfig.SelectedItem.Content
    }

    FEViperBomb()
    {
        $This.Config                                = [FEConfig]::New()
        $This.UI                                    = [XamlWindow]::New($This.Config.Xaml)

        $This.SetConfig()
        $This.SetInfo()
        $This.SetPreferences()
        
        # Start
        $This.UI.Host.Start.Add_Click( 
        { 
            Show-Message "Initialization" "The process returns info here."
            $This.UI.IO.DialogResult                = $True 
        })

        # Cancel
        $This.UI.Host.Cancel.Add_Click(
        {     
            Show-Message "Exception!" "The user cancelled, or the dialog failed."
            $This.UI.IO.DialogResult                = $False
        })

        $This.UI.Host.DataGridLabel.Content         = "Select a profile from the configuration menu to begin"
        $This.UI.Host.DataGrid.ItemsSource          = $This.Config.Profile
    }

    SetProfile([Int32]$Index)
    {
        $This.UI.Host.DataGrid.IsEnabled            = 1
        $This.UI.Host.Search.Content                = $Null

        # Search
        # Select
        # DataGridLabel
        # DataGrid
    }

    SetConsole()
    {
        # Console
        # Diagnostic
    }
}
