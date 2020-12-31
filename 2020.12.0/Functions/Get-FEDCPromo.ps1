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

        $DC.Invoke()

        If ( $UI.Connection.Target )
        {
            $DC                         = [_ADLogin]::New((Get-XAMLWindow -Type ADLogin),$UI.Connection.Target)

            $DC.IO.Switch.Add_Click(
            { 
                $DC.IO.Port.IsEnabled   = $True
                $DC.IO.Port.Text        = $DC.Port
            })

            $DC.IO.Cancel.Add_Click(
            {
                $UI.IO.Credential.Text  = ""
                $DC.IO.DialogResult     = $False
            })

            $DC.IO.Ok.Add_Click(
            {
                $DC.Port                = $DC.IO.Port.Text
                
                If (!$DC.IO.Username.Text)
                {
                    [System.Windows.MessageBox]::Show("Invalid Username","Error")
                }

                ElseIf (!$DC.IO.Password.Password)
                {
                    [System.Windows.MessageBox]::Show("Invalid Password","Error")
                }

                ElseIf ($DC.IO.Password.SecurePassword -notmatch $DC.IO.Confirm.SecurePassword)
                {
                    [System.Windows.MessageBox]::Show("Passwords do not match","Error")
                }

                Else
                {
                    $DC.Credential = [System.Management.Automation.PSCredential]::New($DC.IO.Username.Text,$DC.IO.Password.SecurePassword)
                
                    If (!$DC.Credential)
                    {
                        [System.Windows.MessageBox]::New("Invalid Credential","Error") 
                    }

                    Else
                    {
                        $DC.Directory  = "LDAP://{0}:{1}/CN=Partitions,CN=Configuration,DC={2}" -f $DC.DC,$DC.IO.Port.Text,($DC.Domain.Split(".") -join ",DC=")
                        $DC.Test       = [System.DirectoryServices.DirectoryEntry]::New($DC.Directory,$DC.Credential.UserName,$DC.Credential.GetNetworkCredential().Password)
                        $DC.Initialize($DC.Test)
                
                        If (!$DC.Result)
                        {
                            [System.Windows.MessageBox]::Show("Authentication Failure","Error")
                        }

                        Else
                        {
                            $UI.Connection.Return               = $DC | Select-Object IPAddress, DNSName, Domain, NetBIOS, Credential, DC
                            $UI.Connection.Credential           = $DC.Credential
                            $UI.IO.Credential                   | % { 
                
                                $_.Text                         = $DC.Credential.UserName
                                $_.IsEnabled                    = $False
                        }

                        Switch ($UI.Mode)
                        {
                            Default {}

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
                        }
                    }
                }
            })

            $DC.Window.Invoke()
        }

        Else
        {
            [System.Windows.MessageBox]::Show("Exception","No Domain Controllers")
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
