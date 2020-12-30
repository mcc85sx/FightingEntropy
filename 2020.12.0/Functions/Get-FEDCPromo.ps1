Function Get-FEDCPromo
{
    Write-Theme "Loading Network [:] Domain Controller Initialization"

    $Time = [System.Diagnostics.Stopwatch]::StartNew()
    $UI   = [_FEDCPromo]::New((Get-XamlWindow -Type FEDCPromo),0)
    $Time.Stop()

    Write-Theme @("Scan [:] Complete";("-"*17 -join '');@{ 
    
        "Time Elapsed"    = $Time.Elapsed 
        "Detected Hosts"  = $UI.HostMap.Count
        "Not On Domain"   = ($UI.HostMap | ? NBT -eq $Null).Count
        "On Domain"       = ($UI.HostMap | ? NBT -ne $Null).Count
    })

    $UI.IO.Forest.Add_Click({$UI.SetMode(0)})
    $UI.IO.Tree.Add_Click({$UI.SetMode(1)})
    $UI.IO.Child.Add_Click({$UI.SetMode(2)})
    $UI.IO.Clone.Add_Click({$UI.SetMode(3)})
    $UI.IO.Cancel.Add_Click({$UI.IO.DialogResult = $False})

    $UI.IO.CredentialButton.Add_Click({

        $UI.Connection.Target           = $Null
        $DC                             = Get-XAMLWindow -Type FEDCFound
        $DC.IO.DataGrid.ItemsSource     = $UI.Connection.Output
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

        $DC.IO.ShowDialog()

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

            $DC.IO.ShowDialog()
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

    $UI.IO.Invoke()
    $UI
}
