Function Get-FEDCPromo
{
    Write-Theme "Loading Network [:] Domain Controller Initialization"

    $UI = [_FEPromo]::New((Get-XamlWindow -Type FEDCPromo),0)

    $UI.IO.Forest.Add_Click({ $UI.SetMode(0)})
    $UI.IO.Tree.Add_Click({ $UI.SetMode(1)})
    $UI.IO.Child.Add_Click({ $UI.SetMode(2)})
    $UI.IO.Clone.Add_Click({ $UI.SetMode(3)})
    $UI.IO.Cancel.Add_Click({ $UI.IO.DialogResult = $False })

    $UI.IO.CredentialButton.Add_Click({

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

        If ( $UI.Connection.Target )
        {
            $Popup                         = [_ADLogin]::New((Get-XAMLWindow -Type ADLogin),$UI.Connection.Target)

            $Popup.IO.Cancel.Add_Click(
            {
                $UI.IO.Credential.Text                  = ""
                $Popup.Window.Host.DialogResult         = $False
            })

            $Popup.IO.Ok.Add_Click(
            {
                $Popup.TestCredential()
                
                If (!$Popup.Return)
                {
                    [System.Windows.MessageBox]::Show("Exception","Could not connect")
                }

                $UI.Connection.Return                   = $Popup
                $UI.Connection.Credential               = $Popup.Credential
                $UI.IO.Credential                       | % { 
                
                    $_.Text                             = $Popup.Credential.UserName
                    $_.IsEnabled                        = $False
                }

                Switch ($UI.Mode)
                {
                    1
                    {
                        $UI.IO.ParentDomainName.Text    = $Popup.Domain
                        $UI.IO.Sitename.Text            = $Popup.GetSiteName()
                    }

                    2
                    {
                        $UI.IO.ParentDomainName.Text    = $Popup.Domain
                        $UI.IO.Sitename.Text            = $Popup.GetSiteName() 
                    }

                    3
                    {
                        $UI.IO.ParentDomainName.Text    = ""
                        $UI.IO.Sitename.Text            = $Popup.GetSiteName() 
                        $UI.IO.DomainName.Text          = $Popup.Domain
                        $UI.IO.ReplicationSourceDC.Text = $UI.Connection.Target.Hostname
                    }
                }

                $Popup.Window.Host.DialogResult = $True
            })

            $Popup.Window.Invoke()
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
   
   # Test Output
   # Switch($UI.Mode)
   # {
   #     0
   #     {
   #         
   #     }   
   #
   #     1
   #     {
   #         
   #     }
   #     
   #     2
   #     {
   #         
   #     }
   # 
   #     3
   #     {
   #         
   #     }
   # }
   
   $UI
}
