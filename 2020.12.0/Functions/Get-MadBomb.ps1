Function Get-MadBomb
{
    Class Privacy
    {
        [UInt32]                  $Telemetry = 1
        [UInt32]                  $WiFiSense = 1
        [UInt32]                $SmartScreen = 1
        [UInt32]           $LocationTracking = 1
        [UInt32]                   $Feedback = 1
        [UInt32]              $AdvertisingID = 1
        [UInt32]                    $Cortana = 1
        [UInt32]              $CortanaSearch = 1
        [UInt32]             $ErrorReporting = 1
        [UInt32]                $AutoLogging = 1
        [UInt32]        $DiagnosticsTracking = 1
        [UInt32]                 $WindowsApp = 1
        [UInt32]           $WindowsAppAutoDL = 0

        Privacy(){}
    }

    Class Service
    {
        [UInt32]                        $UAC = 2
        [UInt32]                  $SMBDrives = 2
        [UInt32]                $AdminShares = 1
        [UInt32]                   $Firewall = 1
        [UInt32]                $WinDefender = 1
        [UInt32]                 $HomeGroups = 1
        [UInt32]           $RemoteAssistance = 1
        [UInt32]              $RemoteDesktop = 2

        Service(){}
    }

    Class Context
    {
        [UInt32]               $CastToDevice = 1
        [UInt32]           $PreviousVersions = 1
        [UInt32]           $IncludeinLibrary = 1
        [UInt32]                 $PinToStart = 1
        [UInt32]           $PinToQuickAccess = 1
        [UInt32]                  $ShareWith = 1
        [UInt32]                     $SendTo = 1

        Context(){}
    }

    Class StartMenu 
    {
        [UInt32]         $StartMenuWebSearch = 1
        [UInt32]           $StartSuggestions = 1
        [UInt32]       $MostUsedAppStartMenu = 1
        [UInt32]        $RecentItemsFrequent = 1
        [UInt32]                 $UnpinItems = 0
        
        StartMenu(){}
    }

    Class Taskbar
    {
        [UInt32]               $BatteryUIBar = 1
        [UInt32]                 $ClockUIBar = 1
        [UInt32]           $VolumeControlBar = 1
        [UInt32]           $TaskbarSearchBox = 1
        [UInt32]             $TaskViewButton = 1
        [UInt32]            $TaskbarIconSize = 1
        [UInt32]            $TaskbarGrouping = 2
        [UInt32]                  $TrayIcons = 1
        [UInt32]             $SecondsInClock = 2
        [UInt32]            $LastActiveClick = 2
        [UInt32]      $TaskBarOnMultiDisplay = 1

        Taskbar(){}
    }
	
    Class Explorer
    {
        [UInt32]      $RecentFileQuickAccess = 1
        [UInt32] $FrequentFoldersQuickAccess = 1
        [UInt32]        $WinContentWhileDrag = 1
        [UInt32]              $StoreOpenWith = 1
        [UInt32]               $LongFilePath = 2
        [UInt32]            $ExplorerOpenLoc = 1
        [UInt32]             $WinXPowerShell = 1
        [UInt32]         $AppHibernationFile = 1
        [UInt32]                $PidTitleBar = 2
        [UInt32]            $AccessKeyPrompt = 1
        [UInt32]                   $Timeline = 1
        [UInt32]                   $AeroSnap = 1
        [UInt32]                  $AeroShake = 1
        [UInt32]            $KnownExtensions = 2
        [UInt32]                $HiddenFiles = 2
        [UInt32]                $SystemFiles = 2
        [UInt32]                   $AutoPlay = 1
        [UInt32]                    $AutoRun = 1
        [UInt32]                $TaskManager = 2
        [UInt32]                  $F1HelpKey = 1
        [UInt32]                 $ReopenApps = 1

        Explorer(){}
    }

    Class Icons
    {
        [UInt32]                 $MyComputer = 2
        [UInt32]                    $Network = 2
        [UInt32]                 $RecycleBin = 1
        [UInt32]                  $Documents = 2
        [UInt32]               $ControlPanel = 2

        Icons(){}
    }

    Class Paths
    {
        [UInt32]                    $Desktop = 1
        [UInt32]                  $Documents = 1
        [UInt32]                  $Downloads = 1
        [UInt32]                      $Music = 1
        [UInt32]                   $Pictures = 1
        [UInt32]                     $Videos = 1
        [UInt32]                  $3DObjects = 1

        Paths(){}
    }

    Class PhotoViewer 
    {
      	[UInt32] $PhotoViewerFileAssociation = 2
      	[UInt32]    $PhotoViewerOpenWithMenu = 2

        PhotoViewer(){}
    }

    Class LockScreen
    {
        [UInt32]                 $LockScreen = 1
        [UInt32]        $PowerMenuLockScreen = 1
        [UInt32]         $CameraOnLockScreen = 1

        LockScreen(){}
    }

    Class Miscellaneous
    {
        [UInt32]      $AccountProtectionWarn = 1
        [UInt32]               $ActionCenter = 1
        [UInt32]            $StickyKeyPrompt = 1
        [UInt32]            $NumblockOnStart = 2
        [UInt32]                 $F8BootMenu = 1
        [UInt32]      $RemoteUACAccountToken = 2
        [UInt32]                 $SleepPower = 1

        Miscellaneous(){}
    }

    Class WindowsApps
    {
        [UInt32]                   $OneDrive = 1
        [UInt32]            $OneDriveInstall = 1
        [UInt32]                    $XboxDVR = 1
        [UInt32]                $MediaPlayer = 1
        [UInt32]                $WorkFolders = 1
        [UInt32]                 $FaxAndScan = 1
        [UInt32]             $LinuxSubsystem = 2

        WindowsApps(){}
    }

    Class WindowsUpdate
    {
        [UInt32]          $CheckForWinUpdate = 1
        [UInt32]              $WinUpdateType = 3
        [UInt32]          $WinUpdateDownload = 1
        [UInt32]                 $UpdateMSRT = 1
        [UInt32]               $UpdateDriver = 1
        [UInt32]            $RestartOnUpdate = 1
        [UInt32]            $AppAutoDownload = 1
        [UInt32]       $UpdateAvailablePopup = 1

        WindowsUpdate(){}
    }

    Class Config
    {
        [Object]                    $Privacy
	    [Object]                    $Service
        [Object]                    $Context
        [Object]                    $Taskbar
        [Object]                   $Explorer
        [Object]                  $StartMenu
        [Object]                      $Paths
        [Object]                      $Icons
        [Object]                 $LockScreen
        [Object]              $Miscellaneous
        [Object]                $PhotoViewer
        [Object]                $WindowsApps
        [Object]              $WindowsUpdate

        Config()
        {
            $This.Reset()
        }

        Reset()
        {
            $This.Privacy                    = [Privacy]::New()
            $This.Service                    = [Service]::New()
            $This.Context                    = [Context]::New()
            $This.Taskbar                    = [Taskbar]::New()
            $This.Explorer                   = [Explorer]::New()
            $This.StartMenu                  = [StartMenu]::New()
            $This.Paths                      = [Paths]::New()
            $This.Icons                      = [Icons]::New()
            $This.LockScreen                 = [LockScreen]::New()
            $This.Miscellaneous              = [Miscellaneous]::New()
            $This.PhotoViewer                = [PhotoViewer]::New()
            $This.WindowsApps                = [WindowsApps]::New()
            $This.WindowsUpdate              = [WindowsUpdate]::New()
        }
    }

    Class AppXObject
    {
        Hidden [String[]] $Line
        [String] $AppXName
        [String] $CName
        [String] $VarName
        
        AppX([String]$Line)
        {
            $This.Line     = $Line.Split(";")
            $This.AppXName = $This.Line[0]
            $This.CName    = $This.Line[1]
            $This.VarName  = "`${0}" -f $This.Line[2]
        }
    }

    Class AppXCollection
    {
        [String] $List     = ('Microsoft.3DBuilder;3DBuilder;APP_3DBuilder,Microsoft.Microsoft3DViewer;3DViewer;APP_3DViewer,Microsoft' +
                              '.BingWeather;Bing Weather;APP_BingWeather,Microsoft.CommsPhone;Phone;APP_CommsPhone,Microsoft.windowsco' +
                              'mmunicationsapps;Calendar & Mail;APP_Communications,Microsoft.GetHelp;Microsofts Self-Help;APP_GetHelp,' +
                              'Microsoft.Getstarted;Get Started Link;APP_Getstarted,Microsoft.Messaging;Messaging;APP_Messaging,Micros' + 
                              'oft.MicrosoftOfficeHub;Get Office Link;APP_MicrosoftOffHub,Microsoft.MovieMoments;Movie Moments;APP_Mov' + 
                              'ieMoments,4DF9E0F8.Netflix;Netflix;APP_Netflix,Microsoft.Office.OneNote;Office OneNote;APP_OfficeOneNot' + 
                              'e,Microsoft.Office.Sway;Office Sway;APP_OfficeSway,Microsoft.OneConnect;One Connect;APP_OneConnect,Micr' + 
                              'osoft.People;People;APP_People,Microsoft.Windows.Photos;Photos;APP_Photos,Microsoft.SkypeApp;Skype;APP_' + 
                              'SkypeApp1,Microsoft.MicrosoftSolitaireCollection;Microsoft Solitaire;APP_SolitaireCollect,Microsoft.Mic' + 
                              'rosoftStickyNotes;Sticky Notes;APP_StickyNotes,Microsoft.WindowsSoundRecorder;Voice Recorder;APP_VoiceR' + 
                              'ecorder,Microsoft.WindowsAlarms;Alarms and Clock;APP_WindowsAlarms,Microsoft.WindowsCalculator;Calculat' +
                              'or;APP_WindowsCalculator,Microsoft.WindowsCamera;Camera;APP_WindowsCamera,Microsoft.WindowsFeedback;Win' + 
                              'dows Feedback;APP_WindowsFeedbak1,Microsoft.WindowsFeedbackHub;Windows Feedback Hub;APP_WindowsFeedbak2' +
                              ',Microsoft.WindowsMaps;Maps;APP_WindowsMaps,Microsoft.WindowsPhone;Phone Companion;APP_WindowsPhone,Mic' +
                              'rosoft.WindowsStore;Microsoft Store;APP_WindowsStore,Microsoft.Wallet;Stores Credit and Debit Card Info' +
                              'rmation;APP_WindowsWallet,$Xbox_Apps;Xbox Apps (All);APP_XboxApp,Microsoft.ZuneMusic;Groove Music;APP_Z' +
                              'uneMusic,Microsoft.ZuneVideo;Groove Video;APP_ZuneVideo')
        [Object] $Output
        
        Reference()
        {
            $This.Output = @( )

            ForEach ( $Item in $This.List -Split "," )
            {
                $This.Output += [AppxObject]::New($Item)
            }
        }
    }

    Class Script
    {
        # Script Revised by mcc85sx
        [String] $Author  = 'MadBomb122'
        [String] $Version = '3.7.0'
        [String] $Date    = 'Jan-02-2021'
        [String] $Release = 'Stable'
        [String] $Site    = 'https://GitHub.com/madbomb122/Win10Script'
        [String] $URL
        [String] $Donate  = 'https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/'

        Script(){}
    }

    Class Control
    {
        [Object] $UI_RestorePoint
        [Object] $UI_ShowSkipped
        [Object] $UI_Restart
        [Object] $UI_VersionCheck
        [Object] $UI_InternetCheck
        [Object] $UI_Save
        [Object] $UI_Load
        [Object] $UI_WinDefault
        [Object] $UI_ResetDefault

        Control(){}
    }

    Class Madbomb
    {
        [Object]                     $Window
        [Object]                         $IO
        [Object]                     $Config
        [Object]                     $Script
        [Object]                    $Control

        MadBomb([Object]$Window)
        {
            $This.Window                     = $Window
            $This.IO                         = $Window.IO
            $This.Config                     = [Config]::New()
            $This.Script                     = [Script]::New()
            $This.Control                    = [Control]::New()
        }

        [Void] Toggle([Object]$Item)
        {
            $Item = Switch ($Item)
            {
                0 { 1 }
                1 { 0 }
            }
        }
    }

    $UI = [MadBomb]::New((Get-XamlWindow -Type MBWin10))

    $UI.IO.UI_Feedback.Add_Click({      Start https://github.com/madbomb122/Win10Script/issues })
    $UI.IO.UI_FAQ.Add_Click({           Start https://github.com/madbomb122/Win10Script/blob/master/README.md })
    $UI.IO.UI_About.Add_Click({         [System.Windows.Messagebox]::Show('This script performs various settings/tweaks for Windows 10.','About','OK') })
    $UI.IO.UI_Copyright.Add_Click({     [System.Windows.Messagebox]::Show($Copyright) })
    $UI.IO.UI_Contact.Add_Click({ })
    $UI.IO.UI_Donation.Add_Click({      Start https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/ })
    $UI.IO.UI_Madbomb.Add_Click({       Start https://github.com/madbomb122/ })
    
    $UI.IO.UI_RestorePoint.Add_Click({  $UI.Toggle($UI.Control.UI_RestorePoint)  })  
    $UI.IO.UI_ShowSkipped.Add_Click({   $UI.Toggle($UI.Control.UI_ShowSkipped)   }) 
    $UI.IO.UI_Restart.Add_Click({       $UI.Toggle($UI.Control.UI_Restart)       }) 
    $UI.IO.UI_VersionCheck.Add_Click({  $UI.Toggle($UI.Control.UI_VersionCheck)  }) 
    $UI.IO.UI_InternetCheck.Add_Click({ $UI.Toggle($UI.Control.UI_InternetCheck) }) 
    $UI.IO.UI_Save.Add_Click({          $UI.Toggle($UI.Control.UI_Save)          }) 
    $UI.IO.UI_Load.Add_Click({          $UI.Toggle($UI.Control.UI_Load)          }) 
    $UI.IO.UI_WinDefault.Add_Click({    $UI.Toggle($UI.Control.UI_WinDefault)    }) 
    $UI.IO.UI_ResetDefault.Add_Click({  $UI.Toggle($UI.Control.UI_ResetDefault)  }) 

    #$UI.IO._Telemetry
    
    # Controls go here, everything pivots around the above variable.
    
    # Once the controls are linked, then use $UI.Window.Invoke()
    #
    $UI.Window.Invoke()

    $UI
}
