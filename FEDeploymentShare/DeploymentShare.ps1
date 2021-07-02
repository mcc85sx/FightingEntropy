Function FEDeploymentShare
{
    Class DSClass
    {
        Static [String]  $Base = "github.com/mcc85sx/FightingEntropy/blob/master/FEDeploymentShare"
        Static [String] $Order = (Invoke-RestMethod "$([DSClass]::Base)/Classes/index.txt?raw=true")
        [Object] $Hash
        DSClass()
        {
            $This.Hash = @{ }
            $This.Hash.Add("Class" , @{} ) 
            $This.Hash.Add("Xaml"  , @{} )

            [DSClass]::Order.Split("`n") | % { $This.Hash.Class.Add($_,(Invoke-RestMethod "$([DSClass]::Base)/Classes/$_.ps1?raw=true")) }

            $This.Hash.Xaml.Add("DS",(Invoke-WebRequest "$([DSClass]::Base)/Xaml/DS.xaml?raw=true" | % Content))
        }
    }   

    Class Main
    {
        Static [String] $Base       = "$Env:ProgramData\Secure Digits Plus LLC"
        Static [String] $GFX        = "$([Main]::Base)\Graphics"
        Static [String] $Icon       = "$([Main]::GFX)\icon.ico"
        Static [String] $Logo       = "$([Main]::GFX)\sdplogo.png"
        Static [String] $Background = "$([Main]::GFX)\background.jpg"
        Static [String] $Tab        = (IWR github.com/mcc85sx/FightingEntropy/blob/master/FEDeploymentShare/Xaml/DS.xaml?raw=true | % Content)
        Main()
        {
        }
    }
    
    $Xaml         = [XamlWindow][Main]::Tab

    # Set list of array declarations here for itemssource objects

    # 1) Domain
    $Xaml.IO.Sitemap.ItemsSource   = @( )
    $Xaml.IO.Sitename.ItemsSource  = @( )

    # 2) Network
    $Xaml.IO.Stack.ItemsSource     = @( )
    $Xaml.IO.Control.ItemsSource   = @( )
    $Xaml.IO.Subject.ItemsSource   = @( )

    # 3) Imaging
    $Xaml.IO.WimIso.ItemsSource    = @( )
    $Xaml.IO.IsoView.ItemsSource   = @( )
    $Xaml.IO.IsoList.ItemsSource   = @( )

    # 5) Configuration
    $Xaml.IO.Services.ItemsSource  = @( )
    # end array declarations 

    # Domain Tab
    $Xaml.IO.GetSitename.Add_Click(
    {
        If (!$Xaml.IO.Organization.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid/null organization entry","Error")
        }

        ElseIf (!$Xaml.IO.CommonName.Text)
        {
            [System.Windows.MessageBox]::Show("Invalid/null common name entry","Error")
        }

        Else
        {
            $SM = [Control]::New($Xaml.IO.Organization.Text,$Xaml.IO.CommonName.Text)
            $SM.Pull()
            $Xaml.IO.Sitemap.ItemsSource   += $SM.Sitemap
            $Xaml.IO.GetSitename.IsEnabled  = 0
        }
    })

    $Xaml.IO.AddSitename.Add_Click(
    {
        If (!$Xaml.IO.AddSitenameZip.Text)
        {
            [System.Windows.MessageBox]::Show("Zipcode text entry error","Error")
        }

        Else
        {
            $Tmp  = $SM.NewCertificate()
            $Item = $SM.ZipStack.ZipTown($Xaml.IO.AddSitenameZip.Text)

                $Tmp[0].Location = $Item.Name
                $Tmp[0].Postal   = $Item.Zip
                $Tmp[0].Region   = [States]::Name($Item.State)

                $Tmp.GetSiteLink()
            }

            $Xaml.IO.Sitemap.ItemsSource += $Tmp
            $Xaml.IO.AddSitenameZip.Text = ""
    })

    $Xaml.IO.SiteMap.Add_MouseDoubleClick(
    {
        $Object = $Xaml.IO.Sitemap.SelectedItem
        $Xaml.IO.Sitename.ItemsSource = $Null
        $Xaml.IO.Sitename.ItemsSource = ForEach ( $Item in "Location Region Country Postal TimeZone SiteLink SiteName" -Split " " )
        {
            [DGList]::New($Item,$Object.$Item)
        }
    })

    # Network Tab
    $Xaml.IO.StackLoad.Add_Click(
    {
        If ($Xaml.IO.StackText.Text -notmatch "((\d+\.+){3}\d+\/\d+)")
        {
            [System.Windows.MessageBox]::Show("Invalid/null network string (Use 'IP/Prefix' notation)","Error")
        }

        Else
        {
            $SM.GetNetwork($Xaml.IO.StackText.Text)
            $Xaml.IO.Stack.ItemsSource   = $Null
            $Xaml.IO.Control.ItemsSource = $Null
            $Xaml.IO.Subject.ItemsSource = $Null
            $Xaml.IO.Stack.ItemsSource   = $SM.Stack
        }
    })

    $Xaml.IO.Stack.Add_MouseDoubleClick(
    {
        If ( $Xaml.IO.Stack.SelectedIndex -ne -1 )
        {
            $Network = $Xaml.IO.Stack.SelectedItem.Network
            $Xaml.IO.Control.ItemsSource = $Null
            $Xaml.IO.Subject.ItemsSource = $Null

            $Xaml.IO.Control.ItemsSource = @( $SM.Stack | ? Network -match $Network )
            $Xaml.IO.Subject.ItemsSource = @( $SM.Stack | ? Network -notmatch $Network )
        }
    })

    # Imaging Tab
    $Xaml.IO.IsoPath.Add_TextChanged(
    {
        If ( $Xaml.IO.IsoPath.Text -ne "" )
        {
            $Xaml.IO.IsoScan.IsEnabled = 1
        }
    
        Else
        {
            $Xaml.IO.IsoScan.IsEnabled = 0
        }
    })
    
    $Xaml.IO.IsoScan.Add_Click(
    {
        If (!(Test-Path $Xaml.IO.IsoPath.Text))
        {
            [System.Windows.MessageBox]::Show("Invalid image root path","Error")
        }
    
        $Tmp = Get-ChildItem $Xaml.IO.IsoPath.Text *.iso
    
        If (!$Tmp)
        {
            [System.Windows.MessageBox]::Show("No images detected","Error")
        }
        
        $Xaml.IO.IsoList.ItemsSource = $Tmp | Select-Object Name, Fullname
    })
    
    $Xaml.IO.IsoList.Add_SelectionChanged(
    {
        If ( $Xaml.IO.IsoList.SelectedIndex -gt -1 )
        {
            $Xaml.IO.IsoMount.IsEnabled = 1
        }
    
        Else
        {
            $Xaml.IO.IsoMount.IsEnabled = 0
        }
    })
    
    $Xaml.IO.IsoMount.Add_Click(
    {
        If ( $Xaml.IO.IsoList.SelectedIndex -eq -1)
        {
            [System.Windows.MessageBox]::Show("No image selected","Error")
        }
    
        $ImagePath  = $Xaml.IO.IsoList.SelectedItem.FullName
        Write-Host "Mounting [~] [$ImagePath]"
    
        Mount-DiskImage -ImagePath $ImagePath -Verbose
    
        $Letter    = Get-DiskImage $ImagePath | Get-Volume | % DriveLetter
        
        If (!$Letter)
        {
            [System.Windows.MessageBox]::Show("Image failed mounting to drive letter","Error")
        }
    
        ElseIf (!(Test-Path "${Letter}:\sources\install.wim"))
        {
            [System.Windows.MessageBox]::Show("Not a valid Windows disc/image","Error")
            Dismount-Diskimage -ImagePath $ImagePath
        }
    
        Else
        {
            $Xaml.IO.IsoView.ItemsSource     = Get-WindowsImage -ImagePath "${Letter}:\sources\install.wim" | % { [WindowsImage]$_ }
            $Xaml.IO.IsoList.IsEnabled       = 0
            $Xaml.IO.IsoDismount.IsEnabled   = 1
            Write-Host "Mounted [+] [$ImagePath]"
        }
    })
    
    $Xaml.IO.IsoDismount.Add_Click(
    {
        $ImagePath                           = $Xaml.IO.IsoList.SelectedItem.FullName
        Dismount-DiskImage -ImagePath $ImagePath
        $Xaml.IO.IsoView.ItemsSource         = $Null
        $Xaml.IO.IsoList.IsEnabled           = 1
    
        Write-Host "Dismounted [+] [$ImagePath]"
        $ImagePath                           = $Null
    
        $Xaml.IO.IsoDismount.IsEnabled       = 0
    })
    
    $Xaml.IO.IsoView.Add_SelectionChanged(
    {
        If ( $Xaml.IO.IsoView.Items.Count -eq 0 )
        {
            $Xaml.IO.WimQueue.IsEnabled     = 0
        }
    
        If ( $Xaml.IO.IsoView.Items.Count -gt 0 )
        {
            $Xaml.IO.WimQueue.IsEnabled     = 1
        }
    })
    
    $Xaml.IO.WimIso.Add_SelectionChanged(
    {
        If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled   = 0
            $Xaml.IO.WimIsoUp.IsEnabled     = 0
            $xaml.IO.WimIsoDown.IsEnabled   = 0
        }
    
        If ( $Xaml.IO.WimIso.Items.Count -gt 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled   = 1
            $Xaml.IO.WimIsoUp.IsEnabled     = 1
            $xaml.IO.WimIsoDown.IsEnabled   = 1
        }
    })
    
    $Xaml.IO.WimQueue.Add_Click(
    {
        If ($Xaml.IO.IsoList.SelectedItem.Fullname -in $Xaml.IO.WimIso.Items.Name)
        {
            [System.Windows.MessageBox]::Show("Image already selected","Error")
        }
    
        Else
        {
            $Indexes      = $Xaml.IO.IsoView.SelectedItems.Index -join ","
            $Descriptions = $Xaml.IO.IsoView.SelectedItems.Description -join ","
            $Xaml.IO.WimIso.ItemsSource += [ImageQueue]::New($Xaml.IO.IsoList.SelectedItem.Fullname,$Indexes,$Descriptions)
        }
    })
    
    $Xaml.IO.WimDequeue.Add_Click(
    {
        $Grid = $Xaml.IO.WimIso.ItemsSource
        $Items = @( )
    
        ForEach ( $Item in $Grid )
        {
            If ( $Item -ne $Xaml.IO.WimIso.SelectedItem )
            {
                $Items += $Item
            }
        }
    
        $Xaml.IO.WimIso.ItemsSource = @( )
        $Xaml.IO.WimIso.ItemsSource = $Items
        $Grid                       = $Null
        $Items                      = $Null
    
        If ( $Xaml.IO.WimIso.Items.Count -eq 0 )
        {
            $Xaml.IO.WimDequeue.IsEnabled = 0
        }
    })
    
    $Xaml.IO.WimIsoUp.Add_Click(
    {
        If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
        {
            $Rank  = $Xaml.IO.WimIso.SelectedIndex
            $Grid  = $Xaml.IO.WimIso.ItemsSource
            $Items = 0..($Grid.Count-1)
    
            If ($Rank -ne 0)
            {
                ForEach ($I in 0..($Grid.Count-1))
                {
                    If ( $I -eq $Rank - 1 )
                    {
                        $Items[$I] = $Grid[$I+1]
                    }
    
                    ElseIf ( $I -eq $Rank )
                    {
                        $Items[$I] = $Grid[$I-1]   
                    }
    
                    Else
                    {
                        $Items[$I] = $Grid[$I]
                    }
                }
    
                $Xaml.IO.WimIso.ItemsSource = @( )
                $Xaml.IO.WimIso.ItemsSource = $Items
                $Items = $Null
                $Rank  = $Null
                $Grid  = $Null
            }
        }
    })
    
    $Xaml.IO.WimIsoDown.Add_Click(
    {
        If ( $Xaml.IO.WimIso.Items.Count -gt 1 )
        {
            $Rank  = $Xaml.IO.WimIso.SelectedIndex
            $Grid  = $Xaml.IO.WimIso.ItemsSource
            $Items = 0..($Grid.Count - 1)
    
            If ($Rank -ne $Grid.Count - 1)
            {
                ForEach ($I in 0..($Grid.Count-1))
                {
                    If ( $I -eq $Rank )
                    {
                        $Items[$I] = $Grid[$I+1]   
                    }
    
                    ElseIf ( $I -eq $Rank + 1 )
                    {
                        $Items[$I] = $Grid[$I-1]
                    }
    
                    Else
                    {
                        $Items[$I] = $Grid[$I]
                    }
                }
                
                $Xaml.IO.WimIso.ItemsSource = @( )
                $Xaml.IO.WimIso.ItemsSource = $Items
                $Items = $Null
                $Rank  = $Null
                $Grid  = $Null
            }
        }
    })
    
    $Xaml.IO.WimExtract.Add_Click(
    {
        If (Test-Path $Xaml.IO.WimSwap.Text)
        {
            Switch([System.Windows.MessageBox]::Show("Path [!] exists!","The path already exists, delete?","YesNo"))
            {
                Yes 
                { 
                    Write-Host "Removing path... [$($Xaml.IO.WimSwap.Text)]"
                    Remove-Item -Path $Xaml.IO.WimSwap.Text -Recurse -Force -Verbose
                }
                
                No
                { 
                    Write-Host "No action taken"
                    Break
                }
            }
        }
    
        $Images = [ImageStore]::New($Xaml.IO.IsoPath.Text,$Xaml.IO.WimSwap.Text)
    
        $X      = 0
        ForEach ( $Item in $Xaml.IO.WimIso.Items )
        {
            $Type = Switch -Regex ($Item.Description)
            {
                Server { "Server" } Default { "Client" }
            }
    
            $Images.AddImage($Type,$Item.Name)
            $Images.Store[$X].AddMap($Item.Index.Split(","))
            $X ++
        }
    
        $Images.GetSwap()
        $Images.GetOutput()
        Write-Theme "Complete [+] Images Collected"
    })
    
    $Xaml.IO.WimSwap.Add_TextChanged(
    {
        If ( $Xaml.IO.WimSwap.Text -ne "" )
        {
            $Xaml.IO.WimExtract.IsEnabled = 1
        }
    
        If ( $Xaml.IO.WimSwap.Text -eq "" )
        {
            $Xaml.IO.WimExtract.IsEnabled = 0
        }
    })

    # Branding Tab
    $Xaml.IO.AddLogo.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.OpenFileDialog
        $Item.InitialDirectory = $This.Graphics | Select-Object -Unique | % Directory | % FullName
        $Item.ShowDialog()
        
        If (!$Item.Filename)
        {
            $Item.Filename     = [Main]::Logo
        }

        $Xaml.IO.LogoText.Text = $Item.FileName
    })
    
    $Xaml.IO.AddBackground.Add_Click(
    {
        $Item                  = New-Object System.Windows.Forms.OpenFileDialog
        $Item.InitialDirectory = $This.Graphics | Select-Object -Unique | % Directory | % FullName
        $Item.ShowDialog()
        
        If (!$Item.Filename)
        {
            $Item.Filename     = [Main]::Background
        }

        $Xaml.IO.BackgroundText.Text = $Item.FileName
    })

    # Configuration Tab
    $Xaml.IO.Services.ItemsSource = @( 
        
        $Win     = Get-WindowsFeature
        $Reg     = "","\WOW6432Node" | % { "HKLM:\Software$_\Microsoft\Windows\CurrentVersion\Uninstall\*" }
    
        ForEach ( $Item in "DHCP","DNS","AD-Domain-Services","WDS","Web-WebServer")
        {
            [DGList]::New($Item,($Win | ? Name -eq $Item | % Installed))
        }
    
        ForEach ( $Item in "MDT","WinADK","WinPE")
        {
            Switch($Item)
            {
                MDT
                {
                    $Base = $Reg[0]
                    $Tag  = "Microsoft Deployment Toolkit"
                    $Ver  = "6.3.8456.1000"
                }
                
                WinADK 
                { 
                    $Base  = $Reg[1]
                    $Tag   = "Windows Assessment and Deployment Kit - Windows 10"
                    $Ver   = "10.1.17763.1"
                }
                
                WinPE  
                {   
                    $Base  = $Reg[1]
                    $Tag   = "Preinstallation Environment Add-ons - Windows 10" 
                    $Ver   = "10.1.17763.1"
                }
            }
            
            [DGList]::New($Item,[Bool](Get-ItemProperty $Base | ? DisplayName -match $Tag | ? DisplayVersion -ge $Ver))
        }
    )

    # Final

    # $Xaml.IO.PhoneText
    # $Xaml.IO.HoursText
    # $Xaml.IO.WebsiteText
    # $Xaml.IO.LogoText
    # $Xaml.IO.BackgroundText
    # $Xaml.IO.LMUsernameText
    # $Xaml.IO.LMPasswordText
    # $Xaml.IO.LMConfirmText

    $Xaml.Invoke()
}