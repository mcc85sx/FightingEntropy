Function Get-FEDCPromo
{
    Write-Theme "Loading Network [:] Domain Controller Initialization"

    $UI = [_FEPromo]::New((Get-XamlWindow -Type FEDCPromo),0)

    $UI.IO.Forest.Add_Click{ $UI.SetMode(0) }
    $UI.IO.Tree.Add_Click{   $UI.SetMode(1) }
    $UI.IO.Child.Add_Click{  $UI.SetMode(2) }
    $UI.IO.Clone.Add_Click{  $UI.SetMode(3) }
    $UI.IO.Cancel.Add_Click{ $UI.IO.DialogResult = $False }

    $UI.Window.Invoke()

    # Credential                    : System.Windows.Controls.TextBox
     
    # SafeModeAdministratorPassword : System.Windows.Controls.PasswordBox
    # Confirm                       : System.Windows.Controls.PasswordBox
    # Start                         : System.Windows.Controls.Button: Start
}
