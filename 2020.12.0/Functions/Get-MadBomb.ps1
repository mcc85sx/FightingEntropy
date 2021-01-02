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

    Class Madbomb
    {
        [Object]                     $Window
        [Object]                         $IO
        [Object]                     $Config

        MadBomb([Object]$Window)
        {
            $This.Window                     = $Window
            $This.IO                         = $Window.IO
            $This.Config                     = [Config]::New()
        }
    }

    $UI = [MadBomb]::New((Get-XamlWindow -Type MBWin10))
    
    # Controls go here, everything pivots around the above variable.
    
    # Once the controls are linked, then use $UI.Window.Invoke()
    $UI.Window.Invoke()
}
