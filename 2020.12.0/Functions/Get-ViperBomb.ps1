Function Get-ViperBomb
{
    Invoke-Expression "Using Namespace System.Windows.Markup"
    Add-Type -AssemblyName PresentationFramework

    [Object] $Info     = [_Info]::New()
    [Object] $VB       = [_ViperBomb]::New()
    [Object] $Services = (Get-FEService)
    [Object] $UI       = (Get-XamlWindow -Type FEService)
    [Object] $DataGrid = (New-Object System.Collections.ObjectModel.ObservableCollection[Object])

    $UI.Host.Profile_0.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(0)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_1.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(1)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_2.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(2)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_3.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(3)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_4.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(4)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_5.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(5)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })
    
    $UI.Host.Profile_6.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(6)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_7.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(7)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Profile_8.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(8)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })
    
    $UI.Host.Profile_9.Add_Click(
    {
        $UI.Host.DataGrid.ItemsSource = $Null
        $Services.SetProfile(9)
        $UI.Host.DataGrid.ItemsSource = $DataGrid
    })

    $UI.Host.Title                         = ("{0} v{1}" -f $VB.Name, $VB.Version)

    $UI.Host.URL.Add_Click({                 Start $VB.URL                                                            })
    $UI.Host.About.Add_Click({               [System.Windows.MessageBox]::Show(($VB.About     -join "`n"),    "About") })
    $UI.Host.Copyright.Add_Click({           [System.Windows.MessageBox]::Show(($VB.Copyright -join "`n"),"Copyright") })
    $UI.Host.MadBomb.Add_Click({             Start $VB.MadBomb                                                        })
    $UI.Host.BlackViper.Add_Click({          Start $VB.BlackViper                                                     })
    $UI.Host.Site.Add_Click({                Start $VB.Site                                                           })
    $UI.Host.Help.Add_Click({                [System.Windows.MessageBox]::Show(($VB.Help      -join "`n"),     "Help") })
    $UI.Host.Caption.Content               = $Info.Caption
    $UI.Host.ReleaseID.Content             = $Info.ReleaseID
    $UI.Host.Version.Content               = $Info.Version
    $UI.Host.Chassis.Content               = $Info.Chassis
    $UI.Host.DispActive.IsChecked          = $VB.DispActive
    $UI.Host.DispInactive.IsChecked        = $VB.DispInactive
    $UI.Host.DispSkipped.IsChecked         = $VB.DispSkipped
    $UI.Host.MiscSimulate.IsChecked        = $VB.MiscSimulate
    $UI.Host.MiscXbox.IsChecked            = $VB.MiscXbox
    $UI.Host.MiscChange.IsChecked          = $VB.MiscChange
    $UI.Host.MiscStopDisabled.IsChecked    = $VB.MiscStopDisabled
    $UI.Host.DevErrors.IsChecked           = $VB.DevErrors 
    $UI.Host.DevLog.IsChecked              = $VB.DevLog  
    $UI.Host.DevConsole.IsChecked          = $VB.DevConsole
    $UI.Host.DevReport.IsChecked           = $VB.DevReport
    $UI.Host.ByBuild.IsChecked             = $VB.ByBuild
    $UI.Host.ByEdition.SelectedItem        = $VB.ByEdition
    $UI.Host.ByLaptop.IsChecked            = $VB.ByLaptop 
    $UI.Host.LogSvcSwitch.IsChecked        = 0
    $UI.Host.LogSvcBrowse.IsEnabled        = 0

    If ( $UI.Host.LogSvcSwitch.IsChecked -eq 0 ) { $UI.Host.LogSvcBrowse.IsEnabled    = 0 }
    If ( $UI.Host.LogSvcSwitch.IsChecked -eq 1 ) { $UI.Host.LogSvcBrowse.IsEnabled    = 1 }
        
    $UI.Host.LogScrSwitch.IsChecked        = 0
    $UI.Host.LogScrBrowse.IsEnabled        = 0
        
    If ( $UI.Host.LogScrSwitch.IsChecked -eq 1 ) { $UI.Host.LogScrBrowse.IsEnabled    = 1 }
    If ( $UI.Host.LogScrSwitch.IsChecked -eq 0 ) { $UI.Host.LogScrBrowse.IsEnabled    = 0 }
            
    $UI.Host.RegSwitch.IsChecked           = 0
    $UI.Host.RegBrowse.IsEnabled           = 0
        
    If ( $UI.Host.RegSwitch.IsChecked    -eq 0 ) { $UI.Host.RegBrowse.IsEnabled       = 0 }
    If ( $UI.Host.RegSwitch.IsChecked    -eq 1 ) { $UI.Host.RegBrowse.IsEnabled       = 1 }
        
    $UI.Host.CsvSwitch.IsChecked           = 0
    $UI.Host.CsvBrowse.IsEnabled           = 0
        
    If ( $UI.Host.CsvSwitch.IsChecked    -eq 1 ) { $UI.Host.CsvBrowse.IsEnabled       = 1 }
    If ( $UI.Host.CsvSwitch.IsChecked    -eq 0 ) { $UI.Host.CsvBrowse.IsEnabled       = 0 }
        
    $UI.Host.LogSvcFile.Text               = $VB.LogSvcLabel
    $UI.Host.LogScrFile.Text               = $VB.LogScrLabel
    $UI.Host.RegFile.Text                  = $VB.RegLabel
    $UI.Host.CsvFile.Text                  = $VB.CsvLabel 
        
    $UI.Host.LogSvcBrowse.IsEnabled        = 0
    $UI.Host.LogScrBrowse.IsEnabled        = 0
    $UI.Host.RegBrowse.IsEnabled           = 0
    $UI.Host.CsvBrowse.IsEnabled           = 0
        
    $UI.Host.ServiceLabel.Content          = $VB.ServiceLabel
    If ( $UI.Host.ServiceProfile.IsEnabledChanged )
    {
        $UI.Host.ServiceLabel.Content      = $UI.Host.ServiceProfile.SelectedItem.Content
    }
        
    $UI.Host.ScriptLabel.Content           = $VB.ScriptLabel
    If ( $UI.Host.ScriptProfile.IsEnabledChanged )
    {
        $UI.Host.ScriptLabel.Content       = $UI.Host.ScriptProfile.SelectedItem.Content
    }
        
    $UI.Host.Start.Add_Click( 
    {
        $UI.Host.DialogResult              = $True
    })
        
    $UI.Host.Cancel.Add_Click(
    {     
        $UI.Host.Close()
    })
        
    If ( $UI.Host.ServiceProfile.IsEnabledChanged )
    {
        $UI.Host.ServiceLabel.Content      = $UI.Host.ServiceProfile.SelectedItem.Content
    }

    ForEach ( $I in 0..( $Services.Output.Count - 1 ) )
    {
        $DataGrid.Add([Int32]1)
        $DataGrid[$I]                      = $Services.Output[$I]
    }

    $UI.Host.DataGrid.ItemsSource          = $DataGrid

    $UI.Host.ShowDialog()
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

}
