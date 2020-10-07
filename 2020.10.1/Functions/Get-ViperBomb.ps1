Function Get-ViperBomb
{
    $Viper = [_ViperBomb]::New()
    $UI    = [_XamlWindow]::New($Viper.Xaml)

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

        $UI.Host.Profile_0.Add_Click{0}
        $UI.Host.Profile_1.Add_Click{1}
        $UI.Host.Profile_2.Add_Click{2}
        $UI.Host.Profile_3.Add_Click{3}
        $UI.Host.Profile_4.Add_Click{4}
        $UI.Host.Profile_5.Add_Click{5}
        $UI.Host.Profile_6.Add_Click{6}
        $UI.Host.Profile_7.Add_Click{7}
        $UI.Host.Profile_8.Add_Click{8}
        $UI.Host.Profile_9.Add_Click{9}

        $UI.Host.Title = ("{0}v{1}" -f $Viper.Name, $Viper.Version )

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

        $UI.Host.URL.Add_Click(       {        Start              $Viper.URL                   })
        $UI.Host.About.Add_Click(     { Show-Message     "About" ($Viper.About     -join "`n") })
        $UI.Host.Copyright.Add_Click( { Show-Message "Copyright" ($Viper.Copyright -join "`n") })
        $UI.Host.MadBomb.Add_Click(   {        Start              $Viper.MadBomb               })
        $UI.Host.BlackViper.Add_Click({        Start              $Viper.BlackViper            })
        $UI.Host.Site.Add_Click(      {        Start              $Viper.Site                  })
        $UI.Host.Help.Add_Click(      { Show-Message      "Help" ($Viper.Help      -join "`n") })

        # TabControl                                                   #
        # [Service Dialog] | [Preferences] | [Console] | [Diagnostics] # 
        # [OS/Caption]     | [ReleaseID]   | [Version] | [Chassis]     #

        $UI.Host.Caption.Content               = $Viper.Info.Caption
        $UI.Host.ReleaseID.Content             = $Viper.Info.ReleaseID
        $UI.Host.Version.Content               = $Viper.Info.Version
        $UI.Host.Chassis.Content               = $Viper.Info.Chassis

        # DispActive / DispInactive / DispSkipped
        $UI.Host.DispActive.IsChecked          = $Viper.DispActive
        $UI.Host.DispInactive.IsChecked        = $Viper.DispInactive
        $UI.Host.DispSkipped.IsChecked         = $Viper.DispSkipped

        # MiscSimulate / MiscXbox / MiscChange / MiscStopDisabled
        $UI.Host.MiscSimulate.IsChecked        = $Viper.MiscSimulate
        $UI.Host.MiscXbox.IsChecked            = $Viper.MiscXbox
        $UI.Host.MiscChange.IsChecked          = $Viper.MiscChange
        $UI.Host.MiscStopDisabled.IsChecked    = $Viper.MiscStopDisabled

        # DevErrors / DevLog / DevConsole / DevReport
        $UI.Host.DevErrors.IsChecked           = $Viper.DevErrors 
        $UI.Host.DevLog.IsChecked              = $Viper.DevLog  
        $UI.Host.DevConsole.IsChecked          = $Viper.DevConsole
        $UI.Host.DevReport.IsChecked           = $Viper.DevReport

        # ByBuild / ByEdition / ByLaptop
        $UI.Host.ByBuild.IsChecked             = $Viper.ByBuild
        $UI.Host.ByEdition.SelectedItem        = $Viper.ByEdition
        $UI.Host.ByLaptop.IsChecked            = $Viper.ByLaptop 
        
        # LogSvcSwitch / LogSvcBrowse / LogSvcLabel
             $UI.Host.LogSvcSwitch.IsChecked   = 0 ;   $UI.Host.LogSvcBrowse.IsEnabled = 0
        If ( $UI.Host.LogSvcSwitch.IsChecked -eq 0 ) { $UI.Host.LogSvcBrowse.IsEnabled = 0 }
        If ( $UI.Host.LogSvcSwitch.IsChecked -eq 1 ) { $UI.Host.LogSvcBrowse.IsEnabled = 1 }

        # LogScrSwitch / LogScrBrowse / LogScrLabel
             $UI.Host.LogScrSwitch.IsChecked   = 0 ;   $UI.Host.LogScrBrowse.IsEnabled = 0
        If ( $UI.Host.LogScrSwitch.IsChecked -eq 1 ) { $UI.Host.LogScrBrowse.IsEnabled = 1 }
        If ( $UI.Host.LogScrSwitch.IsChecked -eq 0 ) { $UI.Host.LogScrBrowse.IsEnabled = 0 }
        
        # RegSwitch / RegBrowse / RegLabel
             $UI.Host.RegSwitch.IsChecked      = 0 ;   $UI.Host.RegBrowse.IsEnabled    = 0
        If ( $UI.Host.RegSwitch.IsChecked    -eq 0 ) { $UI.Host.RegBrowse.IsEnabled    = 0 }
        If ( $UI.Host.RegSwitch.IsChecked    -eq 1 ) { $UI.Host.RegBrowse.IsEnabled    = 1 }

        # CsvSwitch / CsvBrowse / CsvLabel
             $UI.Host.CsvSwitch.IsChecked      = 0 ;   $UI.Host.CsvBrowse.IsEnabled    = 0
        If ( $UI.Host.CsvSwitch.IsChecked    -eq 1 ) { $UI.Host.CsvBrowse.IsEnabled    = 1 }
        If ( $UI.Host.CsvSwitch.IsChecked    -eq 0 ) { $UI.Host.CsvBrowse.IsEnabled    = 0 }

        $UI.Host.LogSvcFile.Text                = "<Activate to designate a different file name/path>" 
        $UI.Host.LogScrFile.Text                = "<Activate to designate a different file name/path>" 
        $UI.Host.RegFile.Text                   = "<Activate to designate a different file name/path>" 
        $UI.Host.CsvFile.Text                   = "<Activate to designate a different file name/path>" 

        $UI.Host.LogSvcBrowse.IsEnabled        = 0 ; $UI.Host.LogScrBrowse.IsEnabled          = 0
        $UI.Host.RegBrowse.IsEnabled           = 0 ; $UI.Host.CsvBrowse.IsEnabled             = 0

        # ServiceConfig / ServiceConfigLabel
        $UI.Host.ServiceLabel.Content    = $UI.Host.ServiceConfig.SelectedItem.Content
       
        # ScriptConfig /  ScriptConfigLabel
        $UI.Host.ScriptLabel.Content     = $UI.Host.ScriptConfig.SelectedItem.Content
        
        # Start
        $UI.Host.Start.Add_Click( 
        { 
            Show-Message "Initialization" "The process returns info here."
            $UI.IO.DialogResult                = $True 
        })

        # Cancel
        $UI.Host.Cancel.Add_Click(
        {     
            Show-Message "Exception!" "The user cancelled, or the dialog failed."
            $UI.IO.DialogResult                = $False
        })

        #$UI.Host.DataGridLabel.Content         = "Select a profile from the configuration menu to begin"
        #$UI.Host.DataGrid.ItemsSource          = $Viper.Current
    }

    # SetProfile([Int32]$Index)
    # {
    #     $UI.Host.DataGrid.IsEnabled            = 1
    #     $UI.Host.Search.Content                = $Null

    #     Search
    #     Select
    #     DataGridLabel
    #     DataGrid
    # }

    # SetConsole()
    # {
    #     Console
    #     Diagnostic
    # }