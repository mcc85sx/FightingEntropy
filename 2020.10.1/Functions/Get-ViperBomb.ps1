Function Get-ViperBomb
{
    Add-Type -AssemblyName PresentationFramework
    
    $Viper = [_ViperBomb]::New()
    $UI    = [_XamlWindow]::New($Viper.Xaml)

    $UI.Host.Profile_0.Add_Click({0})
    $UI.Host.Profile_1.Add_Click({1})
    $UI.Host.Profile_2.Add_Click({2})
    $UI.Host.Profile_3.Add_Click({3})
    $UI.Host.Profile_4.Add_Click({4})
    $UI.Host.Profile_5.Add_Click({5})
    $UI.Host.Profile_6.Add_Click({6})
    $UI.Host.Profile_7.Add_Click({7})
    $UI.Host.Profile_8.Add_Click({8})
    $UI.Host.Profile_9.Add_Click({9})

    $UI.Host.Title = ("{0}v{1}" -f $Viper.Name, $Viper.Version )

    $UI.Host.URL.Add_Click(       
    {
        Start $Viper.URL
    })

    $UI.Host.About.Add_Click(
    { 
        [System.Windows.MessageBox]::New($Viper.About -join "`n","About")
    })

    $UI.Host.Copyright.Add_Click( 
    { 
        [System.Windows.MessageBox]::New($Viper.Copyright -join "`n","Copyright")
    })

    $UI.Host.MadBomb.Add_Click(   
    {
        Start $Viper.MadBomb 
    })

    $UI.Host.BlackViper.Add_Click(
    {
        Start $Viper.BlackViper
    })

    $UI.Host.Site.Add_Click(      
    {
        Start $Viper.Site
    })

    $UI.Host.Help.Add_Click(
    { 
        [System.Windows.MessageBox]::New($Viper.Help -join "`n","Help")
    })

    $UI.Host.Caption.Content               = $Viper.Info.Caption
    $UI.Host.ReleaseID.Content             = $Viper.Info.ReleaseID
    $UI.Host.Version.Content               = $Viper.Info.Version
    $UI.Host.Chassis.Content               = $Viper.Info.Chassis

    $UI.Host.DispActive.IsChecked          = $Viper.DispActive
    $UI.Host.DispInactive.IsChecked        = $Viper.DispInactive
    $UI.Host.DispSkipped.IsChecked         = $Viper.DispSkipped

    $UI.Host.MiscSimulate.IsChecked        = $Viper.MiscSimulate
    $UI.Host.MiscXbox.IsChecked            = $Viper.MiscXbox
    $UI.Host.MiscChange.IsChecked          = $Viper.MiscChange
    $UI.Host.MiscStopDisabled.IsChecked    = $Viper.MiscStopDisabled

    $UI.Host.DevErrors.IsChecked           = $Viper.DevErrors 
    $UI.Host.DevLog.IsChecked              = $Viper.DevLog  
    $UI.Host.DevConsole.IsChecked          = $Viper.DevConsole
    $UI.Host.DevReport.IsChecked           = $Viper.DevReport

    $UI.Host.ByBuild.IsChecked             = $Viper.ByBuild
    $UI.Host.ByEdition.SelectedItem        = $Viper.ByEdition
    $UI.Host.ByLaptop.IsChecked            = $Viper.ByLaptop 
        
    $UI.Host.LogSvcSwitch.IsChecked        = 0
    $UI.Host.LogSvcBrowse.IsEnabled        = 0

    If ( $UI.Host.LogSvcSwitch.IsChecked -eq 0 ) 
    { 
        $UI.Host.LogSvcBrowse.IsEnabled    = 0 
    }

    If ( $UI.Host.LogSvcSwitch.IsChecked -eq 1 ) 
    { 
        $UI.Host.LogSvcBrowse.IsEnabled    = 1 
    }

    $UI.Host.LogScrSwitch.IsChecked        = 0
    $UI.Host.LogScrBrowse.IsEnabled        = 0

    If ( $UI.Host.LogScrSwitch.IsChecked -eq 1 ) 
    { 
        $UI.Host.LogScrBrowse.IsEnabled    = 1
    }
    
    If ( $UI.Host.LogScrSwitch.IsChecked -eq 0 ) 
    { 
        $UI.Host.LogScrBrowse.IsEnabled    = 0
    }
    
    $UI.Host.RegSwitch.IsChecked           = 0
    $UI.Host.RegBrowse.IsEnabled           = 0

    If ( $UI.Host.RegSwitch.IsChecked    -eq 0 ) 
    { 
        $UI.Host.RegBrowse.IsEnabled       = 0 
    }
    
    If ( $UI.Host.RegSwitch.IsChecked    -eq 1 ) 
    { 
        $UI.Host.RegBrowse.IsEnabled       = 1 
    }

    $UI.Host.CsvSwitch.IsChecked           = 0
    $UI.Host.CsvBrowse.IsEnabled           = 0

    If ( $UI.Host.CsvSwitch.IsChecked    -eq 1 ) 
    { 
        $UI.Host.CsvBrowse.IsEnabled       = 1 
    }
    
    If ( $UI.Host.CsvSwitch.IsChecked    -eq 0 ) 
    { 
        $UI.Host.CsvBrowse.IsEnabled       = 0 
    }

    $UI.Host.LogSvcFile.Text               = "<Activate to designate a different file name/path>" 
    $UI.Host.LogScrFile.Text               = "<Activate to designate a different file name/path>" 
    $UI.Host.RegFile.Text                  = "<Activate to designate a different file name/path>" 
    $UI.Host.CsvFile.Text                  = "<Activate to designate a different file name/path>" 

    $UI.Host.LogSvcBrowse.IsEnabled        = 0
    $UI.Host.LogScrBrowse.IsEnabled        = 0
    $UI.Host.RegBrowse.IsEnabled           = 0
    $UI.Host.CsvBrowse.IsEnabled           = 0

    $UI.Host.ServiceLabel.Content          = $UI.Host.ServiceConfig.SelectedItem.Content
    $UI.Host.ScriptLabel.Content           = $UI.Host.ScriptConfig.SelectedItem.Content

    $UI.Host.Start.Add_Click( 
    {
        $UI.Host.DialogResult                = $True
    })

    $UI.Host.Cancel.Add_Click(
    {     
        $UI.Host.Close()
    })

    #$UI.Host.DataGridLabel.Content         = "Select a profile from the configuration menu to begin"
    #$UI.Host.DataGrid.ItemsSource          = $Viper.Current

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

    $UI.Host.ShowDialog()

}
