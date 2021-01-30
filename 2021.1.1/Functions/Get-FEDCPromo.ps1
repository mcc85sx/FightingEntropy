Function Get-FEDCPromo
{
    Write-Theme "Loading Network [:] Domain Controller Initialization"

    $UI                   = [_FEDCPromo]::New((Get-FEModule))

    $UI.IO.Forest.Add_Click({$UI.SetMode(0)})
    $UI.IO.Tree.Add_Click({$UI.SetMode(1)})
    $UI.IO.Child.Add_Click({$UI.SetMode(2)})
    $UI.IO.Clone.Add_Click({$UI.SetMode(3)})
    $UI.IO.Cancel.Add_Click({$UI.IO.DialogResult = $False})

    $Max                  = Switch -Regex ([WMIClass]"Win32_OperatingSystem" | % GetInstances | % Caption)
    {
        "(2000)"         { 0 }
        "(2003)"         { 1 }
        "(2008)+(R2){0}" { 2 }
        "(2008 R2){1}"   { 3 }
        "(2012)+(R2){0}" { 4 }
        "(2012 R2){1}"   { 5 }
        "(2016|2019)"    { 6 }
    
    }

    $UI.IO.ForestMode.SelectedIndex = $Max
    $UI.IO.DomainMode.SelectedIndex = $Max

    $UI.GetADConnection()
    $UI.IO.CredentialButton.Add_Click({

        $UI.Connection.Target           = $Null
        $DC                             = [_DCFound]::New($UI.Connection)
        $DC.IO.DataGrid.ItemsSource     = $DC.Control
        $DC.IO.DataGrid.SelectedIndex   = 0
        [Void]$DC.IO.DataGrid.Focus()

        $DC.IO.Cancel.Add_Click(
        {
            $DC.IO.DialogResult         = $False
        })

        $DC.IO.Ok.Add_Click(
        {
            $UI.Connection.Target       = $UI.Connection.Output[$DC.IO.DataGrid.SelectedIndex]
            $DC.IO.DialogResult         = $True
        })

        $DC.Window.Invoke()

        If ( $UI.Connection.Target )
        {
            $DC                         = [_ADLogin]::New((Get-XAMLWindow -Type ADLogin),$UI.Connection.Target)

            $DC.IO.Cancel.Add_Click(
            {
                $UI.IO.Credential.Text  = ""
                $DC.IO.DialogResult     = $False
            })

            $DC.IO.Ok.Add_Click(
            {
                $DC.TestCredential()
                
                If (!$DC.Return)
                {
                    [System.Windows.MessageBox]::Show("Exception","Could not connect")
                }

                $UI.Connection.Return                   = $DC
                $UI.Connection.Credential               = $DC.Credential
                $UI.IO.Credential                       | % { 
                
                    $_.Text                             = $DC.Credential.UserName
                    $_.IsEnabled                        = $False
                }

                Switch ($UI.Mode)
                {
                    1
                    {
                        $UI.IO.ParentDomainName.Text    = $DC.Domain
                        $UI.IO.Sitename.Text            = $DC.GetSiteName()
                    }

                    2
                    {
                        $UI.IO.ParentDomainName.Text    = $DC.Domain
                        $UI.IO.Sitename.Text            = $DC.GetSiteName()
                    }

                    3
                    {
                        $UI.IO.ParentDomainName.Text    = ""
                        $UI.IO.Sitename.Text            = $DC.GetSiteName()
                        $UI.IO.DomainName.Text          = $DC.Domain
                        $UI.IO.ReplicationSourceDC.Text = $UI.Connection.Target.Hostname
                    }
                }

                $DC.IO.DialogResult = $True
            })

            $DC.Window.Invoke()
        }
    })

    $UI.IO.Start.Add_Click(
    {
        $Password                             = $UI.IO.SafeModeAdministratorPassword
        $Confirm                              = $UI.IO.Confirm

        If (!$Password.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid password")
        }

        ElseIf ($Password.Password -notmatch $Confirm.Password)
        {
            [System.Windows.Messagebox]::Show("Password does not match")
        }

        Else
        {
            $UI.SafeModeAdministratorPassword = $Password.SecurePassword
            $UI.IO.DialogResult               = $True
        }
    })

    $UI.Window.Invoke()
}
