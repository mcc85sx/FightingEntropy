Function Get-FEDCPromo
{
    Write-Theme "Loading Network [:] Domain Controller Initialization"

    $UI = [_FEPromo]::New((Get-XamlWindow -Type FEDCPromo),0)

    $UI.IO.Forest.Add_Click{ $UI.SetMode(0) }
    $UI.IO.Tree.Add_Click{   $UI.SetMode(1) }
    $UI.IO.Child.Add_Click{  $UI.SetMode(2) }
    $UI.IO.Clone.Add_Click{  $UI.SetMode(3) }
    $UI.IO.Cancel.Add_Click{ $UI.IO.DialogResult = $False }

    $UI.IO.Credential.Add_Click{

        $Popup                             = Get-XAMLWindow -Type Test
        $Popup.Host.DataGrid.ItemsSource   = $UI.Connection.Output
        $Popup.Host.DataGrid.SelectedIndex = 0
        $Popup.Host.DataGrid.Focus()

        $Popup.Host.Cancel.Add_Click(
        {
            $Popup.Host.DialogResult       = $False
        })

        $Popup.Host.Ok.Add_Click(
        {
            $UI.Connection.Return          = $UI.Connection.Output[$Popup.Host.DataGrid.SelectedIndex]
            $Popup.Host.DialogResult       = $True
        })

        $Popup.Invoke()
        
    }
     
    # SafeModeAdministratorPassword : System.Windows.Controls.PasswordBox
    # Confirm                       : System.Windows.Controls.PasswordBox
    # Start                         : System.Windows.Controls.Button: Start

    $UI.Window.Invoke()
}
