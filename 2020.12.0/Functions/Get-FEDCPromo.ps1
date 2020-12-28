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

        $UI.Connection.Target              = $Null
        $Popup                             = Get-XAMLWindow -Type FEDCFound
        $Popup.Host.DataGrid.ItemsSource   = $UI.Connection.Output
        $Popup.Host.DataGrid.SelectedIndex = 0
        [Void]$Popup.Host.DataGrid.Focus()

        $Popup.Host.Cancel.Add_Click(
        {
            Write-Host "Canceled"
            $Popup.Host.DialogResult       = $False
        })

        $Popup.Host.Ok.Add_Click(
        {
            $UI.Connection.Target          = $UI.Connection.Output[$Popup.Host.DataGrid.SelectedIndex]
            $Popup.Host.DialogResult       = $True
        })

        $Popup.Invoke()

        If ( !$UI.Connection.Target )
        {
            Throw "Unsuccessful"
        }

        $Popup                             = [_ADLogin]::New((Get-XAMLWindow -Type ADLogin),$UI.Connection.Target)

        $Popup.IO.Cancel.Add_Click(
        {
            $Popup.Window.Host.DialogResult = $False
        })

        $Popup.IO.Ok.Add_Click(
        {
            If ( ! $Popup.IO.Username.Text )
            {
                [Void][System.Windows.MessageBox]::Show("Invalid Username","Error")
            }

            ElseIf ( ! $Popup.IO.Password.Password )
            {
                [Void][System.Windows.MessageBox]::Show("Invalid Password","Error")
            }

            ElseIf ( $Popup.IO.Password.Password -notmatch $Popup.IO.Confirm.Password )
            {
                [Void][System.Windows.MessageBox]::Show("Passwords do not match","Error")
            }

            Else
            {
                $Popup.Credential               = [System.Management.Automation.PSCredential]::New($Popup.IO.Username.Text,$Popup.IO.Confirm.SecurePassword)
                $Popup.Window.Host.DialogResult = $True
            }
        })

        $Popup.Window.Invoke()
    }
     
    # SafeModeAdministratorPassword : System.Windows.Controls.PasswordBox
    # Confirm                       : System.Windows.Controls.PasswordBox
    # Start                         : System.Windows.Controls.Button: Start

    $UI.Window.Invoke()
}
