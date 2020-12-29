Function Get-ViperBomb
{
    Invoke-Expression "Using Namespace System.Windows.Markup"
    Add-Type -AssemblyName PresentationFramework

    [Object] $Info     = [_Info]::New()
    [Object] $VB       = [_ViperBomb]::New()
    [Object] $Services = (Get-FEService)
    [Object] $UI       = (Get-XamlWindow -Type FEService)
    [Object] $DataGrid = (New-Object System.Collections.ObjectModel.ObservableCollection[Object])

    $UI.IO.Profile_0.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(0)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_1.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(1)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_2.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(2)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_3.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(3)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_4.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(4)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_5.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(5)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })
    
    $UI.IO.Profile_6.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(6)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_7.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(7)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Profile_8.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(8)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })
    
    $UI.IO.Profile_9.Add_Click(
    {
        $UI.IO.DataGrid.ItemsSource = $Null
        $Services.SetProfile(9)
        $UI.IO.DataGrid.ItemsSource = $DataGrid
    })

    $UI.IO.Title                         = ("{0} v{1}" -f $VB.Name, $VB.Version)

    $UI.IO.URL.Add_Click({                 Start $VB.URL                                                            })
    $UI.IO.About.Add_Click({               [System.Windows.MessageBox]::Show(($VB.About     -join "`n"),    "About") })
    $UI.IO.Copyright.Add_Click({           [System.Windows.MessageBox]::Show(($VB.Copyright -join "`n"),"Copyright") })
    $UI.IO.MadBomb.Add_Click({             Start $VB.MadBomb                                                        })
    $UI.IO.BlackViper.Add_Click({          Start $VB.BlackViper                                                     })
    $UI.IO.Site.Add_Click({                Start $VB.Site                                                           })
    $UI.IO.Help.Add_Click({                [System.Windows.MessageBox]::Show(($VB.Help      -join "`n"),     "Help") })
    
    ForEach ( $Item in "Caption","ReleaseID","Version","Chassis" )
    { 
        $UI.IO.$Item.Content                 = $Info.$Item
    }

    ForEach ( $Item in ("DispActive DispInactive DispSkipped MiscSimulate MiscXbox MiscChange MiscStopDisabled " +
    "DevErrors DevLog DevConsole DevReport ByBuild").Split(" ") )
    { 
        $UI.IO.$Item.IsChecked               = $VB.$Item
    } 

    $UI.IO.ByEdition.SelectedItem        = $VB.ByEdition
    $UI.IO.ByLaptop.IsChecked            = $VB.ByLaptop 
    $UI.IO.LogSvcSwitch.IsChecked        = 0
    $UI.IO.LogSvcBrowse.IsEnabled        = 0

    If ( $UI.IO.LogSvcSwitch.IsChecked -eq 0 ) { $UI.IO.LogSvcBrowse.IsEnabled    = 0 }
    If ( $UI.IO.LogSvcSwitch.IsChecked -eq 1 ) { $UI.IO.LogSvcBrowse.IsEnabled    = 1 }
        
    $UI.IO.LogScrSwitch.IsChecked        = 0
    $UI.IO.LogScrBrowse.IsEnabled        = 0
        
    If ( $UI.IO.LogScrSwitch.IsChecked -eq 1 ) { $UI.IO.LogScrBrowse.IsEnabled    = 1 }
    If ( $UI.IO.LogScrSwitch.IsChecked -eq 0 ) { $UI.IO.LogScrBrowse.IsEnabled    = 0 }
            
    $UI.IO.RegSwitch.IsChecked           = 0
    $UI.IO.RegBrowse.IsEnabled           = 0
        
    If ( $UI.IO.RegSwitch.IsChecked    -eq 0 ) { $UI.IO.RegBrowse.IsEnabled       = 0 }
    If ( $UI.IO.RegSwitch.IsChecked    -eq 1 ) { $UI.IO.RegBrowse.IsEnabled       = 1 }
        
    $UI.IO.CsvSwitch.IsChecked           = 0
    $UI.IO.CsvBrowse.IsEnabled           = 0
        
    If ( $UI.IO.CsvSwitch.IsChecked    -eq 1 ) { $UI.IO.CsvBrowse.IsEnabled       = 1 }
    If ( $UI.IO.CsvSwitch.IsChecked    -eq 0 ) { $UI.IO.CsvBrowse.IsEnabled       = 0 }
        
    $UI.IO.LogSvcFile.Text               = $VB.LogSvcLabel
    $UI.IO.LogScrFile.Text               = $VB.LogScrLabel
    $UI.IO.RegFile.Text                  = $VB.RegLabel
    $UI.IO.CsvFile.Text                  = $VB.CsvLabel 
        
    $UI.IO.LogSvcBrowse.IsEnabled        = 0
    $UI.IO.LogScrBrowse.IsEnabled        = 0
    $UI.IO.RegBrowse.IsEnabled           = 0
    $UI.IO.CsvBrowse.IsEnabled           = 0
        
    $UI.IO.ServiceLabel.Content          = $VB.ServiceLabel
    If ( $UI.IO.ServiceProfile.IsEnabledChanged )
    {
        $UI.IO.ServiceLabel.Content      = $UI.IO.ServiceProfile.SelectedItem.Content
    }
        
    $UI.IO.ScriptLabel.Content           = $VB.ScriptLabel
    If ( $UI.IO.ScriptProfile.IsEnabledChanged )
    {
        $UI.IO.ScriptLabel.Content       = $UI.IO.ScriptProfile.SelectedItem.Content
    }
        
    $UI.IO.Start.Add_Click( 
    {
        $UI.IO.DialogResult              = $True
    })
        
    $UI.IO.Cancel.Add_Click(
    {     
        $UI.IO.Close()
    })
        
    If ( $UI.IO.ServiceProfile.IsEnabledChanged )
    {
        $UI.IO.ServiceLabel.Content      = $UI.IO.ServiceProfile.SelectedItem.Content
    }

    ForEach ( $I in 0..( $Services.Output.Count - 1 ) )
    {
        $DataGrid.Add([Int32]1)
        $DataGrid[$I]                      = $Services.Output[$I]
    }

    $UI.IO.DataGrid.ItemsSource          = $DataGrid

    $UI.IO.ShowDialog()
    # SetProfile([Int32]$Index)
    # {
    #     $UI.IO.DataGrid.IsEnabled            = 1
    #     $UI.IO.Search.Content                = $Null

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
