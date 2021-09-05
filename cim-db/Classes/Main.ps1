    Class Main
    {
        [String[]]       $Slot = ("UID Client Service Device Issue Purchase Inventory Expense Account Invoice" -Split " ")
        [UInt32]            $X
        [UInt32]            $Y
        [String]      $Current
        [Object]           $DB
        [Object]         $Xaml
        [Object[]]      $Names
        [Object]     $Selected
        Main([Object]$Xaml)
        {
            $This.DB       = [DB]::New()
            $This.Xaml     = $Xaml
            $This.Names    = $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % { [DGList]::New($_,$This.Xaml.IO.$_.GetType().Name) }
        }
        Select()
        {
            $This.Selected = $This.Xaml.IO."Get_$($This.Current)_Result".Items[$This.Xaml.IO."Get_$($This.Current)_Result".SelectedIndex]
        }
        Menu([UInt32]$X)
        {
            $This.X                       = $X
            $This.Y                       = 0
            $This.Current                 = $This.Slot[$X]
            $Cx                           = $This.Current

            ForEach ( $Item in $This.Names | ? Value -match Grid | % Name )
            {
                $This.Xaml.IO.$Item.Visibility = @("Collapsed","Visible")[$Item -match "Get_$Cx"]
            }

            $Dg                           = "Get_{0}_Result" -f $Cx
            $This.Xaml.IO.$Dg.ItemsSource = @( )
            $This.Xaml.IO.$Dg.ItemsSource = @( $This.DB.$Cx )

            If ($X -eq 0)
            {
                $This.Xaml.IO.View.IsEnabled    = 0
                $This.Xaml.IO.New.IsEnabled     = 0
                $This.Xaml.IO.Edit.IsEnabled    = 0
                $This.Xaml.IO.Save.IsEnabled    = 0
                $This.Xaml.IO.Delete.IsEnabled  = 0
            }

            If ($X -ne 0)
            {
                $This.Xaml.IO.View.IsEnabled    = 0
                $This.Xaml.IO.New.IsEnabled     = 1
                $This.Xaml.IO.Edit.IsEnabled    = 0
                $This.Xaml.IO.Save.IsEnabled    = 0
                $This.Xaml.IO.Delete.IsEnabled  = 0
            }

            ForEach ( $I in 0..9 )
            {
                $Tx = "{0}_Tab" -f $This.Slot[$I]

                If ( $This.Slot[$I] -eq $This.Current )
                {
                    $This.Xaml.IO.$Tx.Background   = "#4444FF"
                    $This.Xaml.IO.$Tx.Foreground   = "#FFFFFF"
                    $This.Xaml.IO.$Tx.BorderBrush  = "#111111"
                }

                Else
                {
                    $This.Xaml.IO.$Tx.Background  = "#DFFFBA"
                    $This.Xaml.IO.$Tx.Foreground  = "#000000"
                    $This.Xaml.IO.$Tx.BorderBrush = "#000000"
                }
            }
        }
        Mode([UInt32]$Y)
        {
            $This.Y                       = $Y
            $This.Current                 = $This.Slot[$This.X]
            $Cx                           = $This.Current

            $This.Xaml.IO."Get_$Cx".Visibility = "Collapsed"
            $This.Xaml.IO."Mod_$Cx".Visibility = "Visible"

            Switch($Y)
            {
                0 # View
                {
                    $This.Names | ? Name -match "Mod_$($This.Current)" | % { 
                        
                        $Xaml.IO.$($_.Name).IsEnabled = 0 
                    }
                    $This.Xaml.IO.View.IsEnabled   = 0
                    $This.Xaml.IO.New.IsEnabled    = 1
                    $This.Xaml.IO.Edit.IsEnabled   = 1
                    $This.Xaml.IO.Save.IsEnabled   = 0
                    $This.Xaml.IO.Delete.IsEnabled = 1
                }

                1 # New
                {
                    $This.Names | ? Name -match "Mod_$($This.Current)" | % { 
                        
                        $This.Xaml.IO.$($_.Name).IsEnabled = 1
                        If ($_.Value -match "TextBox" )
                        {
                            $This.Xaml.IO.$($_.Name).Text  = ""
                        }
                    }
                    $This.Xaml.IO.View.IsEnabled   = 0
                    $This.Xaml.IO.New.IsEnabled    = 0
                    $This.Xaml.IO.Edit.IsEnabled   = 0
                    $This.Xaml.IO.Save.IsEnabled   = 1
                    $This.Xaml.IO.Delete.IsEnabled = 0
                }

                2 # Edit
                {
                    $This.Names | ? Name -match "Mod_$($This.Current)" | % { 
                        
                        $This.Xaml.IO.$($_.Name).IsEnabled = 1
                    }
                    $This.Xaml.IO.View.IsEnabled   = 0
                    $This.Xaml.IO.New.IsEnabled    = 1
                    $This.Xaml.IO.Edit.IsEnabled   = 0
                    $This.Xaml.IO.Save.IsEnabled   = 1
                    $This.Xaml.IO.Delete.IsEnabled = 1
                }

                3 # Save
                {
                    [System.Windows.MessageBox]::Show("This will now save the open record")
                    $This.Xaml.IO.View.IsEnabled   = 0
                    $This.Xaml.IO.New.IsEnabled    = 0
                    $This.Xaml.IO.Edit.IsEnabled   = 0
                    $This.Xaml.IO.Save.IsEnabled   = 1
                    $This.Xaml.IO.Delete.IsEnabled = 0
                    Switch($This.Current)
                    {
                        Client
                        {
                            # Email
                            If ($This.Xaml.IO.Mod_Client_Email_List.Items.Count -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must specify an email address","Error")
                            }

                            If ($This.Xaml.IO.Mod_Client_Email_List.Items.Count -gt 0)
                            {
                                ForEach ($Email in $This.Xaml.IO.Mod_Client_Email_List.Items)
                                {
                                    If ($Email -in $This.DB.Client.Record.Email)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("That email address is already used in another account","Error")
                                    }
                                }
                            }

                            # Phone
                            If ($This.Xaml.IO.Mod_Client_Phone_List.Items.Count -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must specify an email address","Error")
                            }

                            If ($This.Xaml.IO.Mod_Client_Email_List.Items.Count -gt 0)
                            {
                                ForEach ($Phone in $This.Xaml.IO.Mod_Client_Phone_List.Items)
                                {
                                    If ($Email -in $This.DB.Client.Record.Phone)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("That phone number is already used in another account","Error")
                                    }
                                }
                            }

                            # Name
                            If ($This.Xaml.IO.Mod_Client_Last.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Last name missing","Error")
                            }
                            
                            If ($This.Xaml.IO.Mod_Client_First.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("First name missing","Error")
                            }

                            If ($This.Xaml.IO.Mod_Client_MI.Text.Length -ne 0)
                            {
                                $DisplayName = "{0}, {1} {2}." -f @($This.Xaml.IO.Mod_Client_Last.Text,
                                                                    $This.Xaml.IO.Mod_Client_First.Text,
                                                                    $This.Xaml.IO.Mod_Client_MI.Text)
                            }

                            If ($This.Xaml.IO.Mod_Client_MI.Text.Length -eq 0)
                            {
                                $DisplayName = "{0}, {1}" -f @( $This.Xaml.IO.Mod_Client_Last.Text,
                                                                $This.Xaml.IO.Mod_Client_First.Text)
                            }

                            If ( $This.Xaml.IO.Mod_Client_Month.Text -notin 1..12 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid DOB/month","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Day.Text -notin 1..31 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid DOB/day","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Year.Text -notin 1900..[UInt32](Get-Date -UFormat %Y))
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid DOB/year","Error")
                            }

                            $DOB = "{0}/{1}/{2}" -f @($This.Xaml.IO.Mod_Client_Month.Text,
                                                      $This.Xaml.IO.Mod_Client_Day.Text,
                                                      $This.Xaml.IO.Mod_Client_Year.Text)

                            If ($Full -in $This.DB.Client.Record.DisplayName -and $DOB -in $This.DB.Client.Record.DOB )
                            {
                                Throw [System.Windows.MessageBox]::Show("The customer is already in the database","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Gender.SelectedItem.Content -eq "-" )
                            {
                                Throw [System.Windows.MessageBox]::Show("Gender missing","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Address.Text.Length -eq 0 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Address missing","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_City.Text.Length -eq 0 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid town/city","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Region.Text.Length -eq 0 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid region/state","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Country.Text.Length -eq 0 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid country","Error")
                            }

                            If ( $This.Xaml.IO.Mod_Client_Postal.Text.Length -ne 5 )
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid town/city","Error")
                            }

                            $Item                                 = $This.DB.NewUID(0)
                            $Item.Record.DisplayName              = $DisplayName
                            $Item.Record.Last                     = $This.Xaml.IO.Mod_Client_Last.Text 
                            $Item.Record.First                    = $This.Xaml.IO.Mod_Client_First.Text
                            $Item.Record.MI                       = $This.Xaml.IO.Mod_Client_MI.Text
                            $Item.Record.Gender                   = @(0,1)[$This.Xaml.IO.Mod_Client_Gender.SelectedIndex]
                            $Item.Record.Address                  = $This.Xaml.IO.Mod_Client_Address.Text
                            $Item.Record.Month                    = $This.Xaml.IO.Mod_Client_Month.Text
                            $Item.Record.Day                      = $This.Xaml.IO.Mod_Client_Day.Text
                            $Item.Record.Year                     = $This.Xaml.IO.Mod_Client_Year.Text
                            $Item.Record.DOB                      = $DOB
                            $Item.Record.City                     = $This.Xaml.IO.Mod_Client_City.Text 
                            $Item.Record.Region                   = $This.Xaml.IO.Mod_Client_Region.Text
                            $Item.Record.Country                  = $This.Xaml.IO.Mod_Client_Country.Text
                            $Item.Record.Postal                   = $This.Xaml.IO.Mod_Client_Postal.Text
                            $Item.Record.Phone                    = @($This.Xaml.IO.Mod_Client_Phone_List.Items)
                            $Item.Record.Email                    = @($This.Xaml.IO.Mod_Client_Email_List.Items)
                            $Item.Record.Device                   = @($This.Xaml.IO.Mod_Client_Device_List.Items)
                            $Item.Record.Invoice                  = @($This.Xaml.IO.Mod_Client_Invoice_List.Items)

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(1)
                        }
                        Service
                        {
                            If ($This.Xaml.IO.Mod_Service_Name.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No service name listed","Error")
                            }

                            If ($This.Xaml.IO.Mod_Service_Description.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No service description listed","Error")
                            }

                            If ($This.Xaml.IO.Mod_Service_Cost.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No service cost listed","Error")
                            }

                            $DisplayName = "{0}/{1}" -f $This.Xaml.IO.Mod_Service_Name.Text, $This.Xaml.IO.Mod_Service_Cost.Text

                            If ( $DisplayName -in $This.DB.Service.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("That service is already in the database","Error")
                            }

                            $Item                    = $This.DB.NewUID(1)
                            $Item.Record.DisplayName = $DisplayName
                            $Item.Record.Name        = $This.Xaml.IO.Mod_Service_Name.Text
                            $Item.Record.Description = $This.Xaml.IO.Mod_Service_Description.Text
                            $Item.Record.Cost        = [Float]($This.Xaml.IO.Mod_Service_Cost.Text.TrimStart("$"))

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(2)
                        }
                        Device
                        {
                            If ($This.Xaml.IO.Mod_Device_Chassis_List.SelectedIndex -eq 8)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must select a chassis type","Error")
                            }
                            
                            If ($This.Xaml.IO.Mod_Device_Vendor.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Missing a vendor name","Error") 
                            }

                            If ($This.Xaml.IO.Mod_Device_Model.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Missing a model name","Error")
                            }

                            If ($This.Xaml.IO.Mod_Device_Specification.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Missing a specification","Error")
                            }

                            If ($This.Xaml.IO.Mod_Device_Serial.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Missing a serial number","Error")
                            }

                            $DisplayName = "{0}/{1}/{2}/{3}" -f @($This.Xaml.IO.Mod_Device_Vendor.Text,
                                                                $This.Xaml.IO.Mod_Device_Model.Text,
                                                                $This.Xaml.IO.Mod_Device_Specification.Text,
                                                                $This.Xaml.IO.Mod_Device_Serial.Text)
                            
                            If ($DisplayName -in $Mod.DB.Device.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("That device is already registered","Error")
                            }

                            If ($This.Xaml.IO.Mod_Device_Client_List.Items.Count -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No client was attached to the device","Error" )
                            }

                            $Item                      = $This.DB.NewUID(2)
                            $Item.Record.DisplayName   = $DisplayName
                            $Item.Record.Chassis       = $This.Xaml.IO.Mod_Device_Chassis_List.SelectedItem.Content
                            $Item.Record.Vendor        = $This.Xaml.IO.Mod_Device_Vendor.Text
                            $Item.Record.Model         = $This.Xaml.IO.Mod_Device_Model.Text
                            $Item.Record.Specification = $This.Xaml.IO.Mod_Device_Specification.Text
                            $Item.Record.Serial        = $This.Xaml.IO.Mod_Device_Serial.Text

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(3)
                        }
                        Issue
                        {
                            If ($This.Xaml.IO.Mod_Issue_Status_List.SelectedIndex -eq 4)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must select an issue status","Error")
                            }

                            If ($This.Xaml.IO.Mod_Issue_Description.Text -eq "")
                            {
                                Throw [System.Windows.MessageBox]::Show("Must enter in a description","Error")
                            }

                            If ($This.Xaml.IO.Mod_Issue_Client_List.Items.Count -ne 1)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must assign (1) client to the issue","Error")
                            }

                            If ($This.Xaml.IO.Mod_Issue_Device_List.Items.Count -ne 1)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must assign (1) device to the issue","Error")
                            }

                            If ($This.Xaml.IO.Mod_Issue_Service_List.Items.Count -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must assign at least (1) service to the issue","Error")
                            }

                            $DisplayName = "{0}/{1}/{2}" -f @($This.Xaml.IO.Mod_Issue_Status_List.SelectedItem.Content,
                                                            $This.Xaml.IO.Mod_Issue_Client_List.SelectedItem.Content,
                                                            $This.Xaml.IO.Mod_Issue_Device_List.SelectedItem.Content)

                            If ($DisplayName -in $This.DB.Issue.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("That status/client/device is already in the system","Error")
                            }

                            $Item                    = $This.DB.NewUID(3)
                            $Item.Record.DisplayName = $DisplayName
                            $Item.Record.Status      = $This.Xaml.IO.Mod_Issue_Status_List.SelectedItem.Content
                            $Item.Record.Description = $This.Xaml.IO.Mod_Issue_Description.Text
                            $Item.Record.Client      = $This.Xaml.IO.Mod_Issue_Client_List.SelectedItem.Content
                            $Item.Record.Device      = $This.Xaml.IO.Mod_Issue_Device_List.SelectedItem.Content
                            $Item.Record.Service     = @($This.Xaml.IO.Mod_Issue_Service_List.Items)

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(4)
                        }
                        Purchase
                        {
                            If ($This.Xaml.IO.Mod_Purchase_Distributor.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Distributor cannot be left blank","Error")
                            }

                            If ($This.Xaml.IO.Mod_Purchase_URL.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Purchase URL cannot be blank","Error")
                            }

                            If ($This.Xaml.IO.Mod_Purchase_Vendor.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Invalid vendor","Error")
                            }
                            
                            If ($This.Xaml.IO.Mod_Purchase_Model.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Invalid model name","Error")
                            }

                            If ($This.Xaml.IO.Mod_Purchase_Specification.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Invalid specification","Error")
                            }   

                            If ($This.Xaml.IO.Mod_Purchase_Serial.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::New("Serial cannot be blank, use (N/A) if necessary","Error")
                            }

                            If ($This.Xaml.IO.Mod_Purchase_IsDevice.SelectedItem -eq "True")
                            {
                                If ($This.Xaml.IO.Mod_Purchase_Device_List.Items.Count -ne 1)
                                {
                                    Throw [System.Windows.MessageBox]::Show("If this is a device, create the device and select it","Error")
                                }
                            }

                            If ($This.Xaml.IO.Mod_Purchase_Cost.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Cost cannot be left blank","Error")
                            }

                            $DisplayName              = "{0}/{1}/{2}/{3}" -f @($This.Xaml.IO.Mod_Purchase_Distributor.Text
                                                                            $This.Xaml.IO.Mod_Purchase_Vendor.Text,
                                                                            $This.Xaml.IO.Mod_Purchase_Model.Text,
                                                                            $This.Xaml.IO.Mod_Purchase_Specification.Text)
                            If ($DisplayName -in $This.DB.Purchase.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("That item already exists in the database","Error")
                            }

                            $Item                      = $This.DB.NewUID(4)
                            $Item.Record.DisplayName   = $DisplayName
                            $Item.Record.Distributor   = $This.Xaml.IO.Mod_Purchase_Distributor.Text
                            $Item.Record.URL           = $This.Xaml.IO.Mod_Purchase_URL.Text
                            $Item.Record.Vendor        = $This.Xaml.IO.Mod_Purchase_Vendor.Text
                            $Item.Record.Model         = $This.Xaml.IO.Mod_Purcahse_Model.Text
                            $Item.Record.Specification = $This.Xaml.IO.Mod_Purchase_Specification.Text
                            $Item.Record.Serial        = $This.Xaml.IO.Mod_Purchase_Serial.Text
                            $Item.Record.IsDevice      = @(0,1)[$This.Xaml.IO.Mod_Purchase_IsDevice]
                            If ($Item.Record.IsDevice -eq $True)
                            {
                                $Item.Record.Device    = $This.Xaml.IO.Mod_Purchase_Device.SelectedItem.Content
                            }
                            $Item.Record.Cost          = [Float]($This.Xaml.IO.Mod_Purchase_Cost.Text.TrimStart("$"))

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(5)
                        }
                        Inventory
                        {
                            If ($This.Xaml.IO.Mod_Inventory_Vendor.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid vendor specified","Error")
                            }

                            If ($This.Xaml.IO.Mod_Inventory_Model.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid model specified","Error")
                            }

                            If ($This.Xaml.IO.Mod_Inventory_Serial.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Invalid serial specified","Error")
                            }

                            If ($This.Xaml.IO.Mod_Inventory_Title.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Title not listed","Error")
                            }

                            If ($This.Xaml.IO.Mod_Inventory_Cost.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Cost not listed","Error")
                            }

                            If ($This.Xaml.IO.Mod_Inventory_IsDevice.SelectedItem.Content -eq "True" )
                            {
                                If ($This.Xaml.IO.Mod_Inventory_Device_List.Items.Count -ne 1)
                                {
                                    Throw [System.Windows.MessageBox]::Show("If this is a device, must specify (1) device","Error")
                                }
                            }

                            $DisplayName = "{0}/{1}/{2}/{3}" -f @($This.Xaml.IO.Mod_Inventory_Title.Text,
                                                                $This.Xaml.IO.Mod_Inventory_Vendor.Text,
                                                                $This.Xaml.IO.Mod_Inventory_Model.Text,
                                                                $This.Xaml.IO.Mod_Inventory_Serial.Text)
                            
                            If ($DisplayName -in $This.DB.Inventory.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("There is an item already in the inventory with these attributes","Error")
                            }

                            $Item                     = $This.DB.NewUID(5)
                            $Item.Record.DisplayName  = $DisplayName
                            $Item.Record.Vendor       = $This.Xaml.IO.Mod_Inventory_Vendor.Text
                            $Item.Record.Model        = $This.Xaml.IO.Mod_Inventory_Model.Text
                            $Item.Record.Serial       = $This.Xaml.IO.Mod_Inventory_Serial.Text
                            $Item.Record.Title        = $This.Xaml.IO.Mod_Inventory_Title.Text
                            $Item.Record.Cost         = [Float]($This.Xaml.IO.Mod_Inventory_Cost.Text.TrimStart("$"))
                            $Item.Record.IsDevice     = @(0,1)[$This.Xaml.IO.Mod_Inventory_IsDevice.SelectedIndex]
                            If ($Item.Record.IsDevice -eq $True)
                            {
                                $Item.Record.Device   = $This.Xaml.IO.Mod_Inventory_Device.SelectedItem.Content
                            }

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(6)
                        }
                        Expense
                        {
                            If ($This.Xaml.IO.Mod_Expense_DisplayName.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Enter a display name for the expense","Error")
                            }

                            If ($This.Xaml.IO.Mod_Expense_Recipient.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No recipient specified","Error")
                            }

                            If ($This.Xaml.IO.Mod_Expense_IsAccount.SelectedItem.Content -eq "True")
                            {
                                If ($This.Xaml.IO.Mod_Expense_Account_List.Items.Count -ne 1)
                                {
                                    Throw [System.Windows.MessageBox]::Show("If this is an account, specify the account","Error")
                                }
                            }

                            If ($This.Xaml.IO.Mod_Expense_Cost.Text.Length -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("No cost associated with the expense","Error")
                            }

                            If ($This.Xaml.IO.Mod_Expense_DisplayName.Text -in $This.DB.Expense.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("An expense with that name is already in the database","Error")
                            }

                            $Item               = $This.DB.NewUID(6)
                            $Item.Record.DisplayName = $This.Xaml.IO.Mod_Expense_DisplayName.Text
                            $Item.Record.Recipient   = $This.Xaml.IO.Mod_Expense_Recipient.Text
                            $Item.Record.IsAccount   = @(0,1)[$This.Xaml.IO.Mod_Expense_IsAccount.SelectedIndex]
                            If ($Item.Record.IsAccount -eq $True)
                            {
                                $Item.Record.Account = $This.Xaml.IO.Mod_Expense_Account.SelectedItem.Content
                            }
                            $Item.Record.Cost        = [Float]($This.Xaml.IO.Mod_Expense_Cost.Text.TrimStart("$"))

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(7)
                        }
                        Account
                        {
                            If ($This.Xaml.IO.Mod_Account_Object_List.Items.Count -eq 0)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must specify an account object","Error")
                            }

                            If ($This.Xaml.IO.Mod_Account_Object_List.SelectedItem.Content -in $This.DB.Account.Record.Object)
                            {
                                Throw [System.Windows.MessageBox]::Show("That account is already in the database","Error")
                            }

                            $Item                    = $This.DB.NewUID(7)
                            $Item.Record.Account     = $This.Xaml.IO.Mod_Account_List.SelectedItem.Content

                            [System.Windows.MessageBox]::Show("[$($Item.Record.Account)] added to the database")
                            $This.Menu(8)
                        }
                        Invoice
                        {
                            If ($This.Xaml.IO.Mod_Invoice_Client.List.Count -ne 1)
                            {
                                Throw [System.Windows.MessageBox]::Show("Must specify a client","Error")
                            }

                            Switch($This.Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex)
                            {
                                0 # Issue
                                {
                                    If ($This.Xaml.IO.Mod_Invoice_Issue_List.Items.Count -eq 0)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify an issue","Error")
                                    }
                                }
                                1 # Purchase
                                {
                                    If ($This.Xaml.IO.Mod_Invoice_Purchase_List.Items.Count -eq 0)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify a purchase","Error")
                                    }
                                }

                                2 # Inventory
                                {
                                    If ($This.Xaml.IO.Mod_Invoice_Inventory_List.Items.Count -eq 0)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify inventory item","Error")
                                    }
                                }

                                3 # Issue/Purchase
                                {
                                    If ( 0 -in $This.Xaml.IO.Mod_Invoice_Issue_List.Items.Count, $This.Xaml.IO.Mod_Invoice_Purchase_List.Items.Count)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify an issue AND a purchase","Error")
                                    }
                                }

                                4 # Issue/Inventory
                                {
                                    If ( 0 -in $This.Xaml.IO.Mod_Invoice_Issue_List.Items.Count, $This.Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify an issue AND an inventory item","Error")
                                    }
                                }

                                5 # Purchase/Inventory
                                {
                                    If ( 0 -in $This.Xaml.IO.Mod_Invoice_Purchase_List.Items.Count, $This.Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify a purchase AND an inventory item","Error")
                                    }
                                }

                                6 # Issue/Purchase/Inventory
                                {
                                    If ( 0 -in $This.Xaml.IO.Mod_Invoice_Issue.List.Items.Count, $This.Xaml.IO.Mod_Invoice_Purchase_List.Items.Count, $This.Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                                    {
                                        Throw [System.Windows.MessageBox]::Show("Must specify at least (1) issue, (1) purchase, and (1) inventory item","Error")
                                    }
                                }

                                7 # Null
                                {
                                    Throw [System.Windows.MessageBox]::Show("Cannot create a null invoice","Error")
                                }
                            }

                            $DisplayName              = "{0}/{1}/{2}" -f @( Get-Date -UFormat "(%m-%d-%Y)",
                                                                            $This.Xaml.IO.Mod_Invoice_Client_List.SelectedItem.Content,
                                                                            $This.Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex)
                            
                            If ($DisplayName -in $This.DB.Invoice.Record.DisplayName)
                            {
                                Throw [System.Windows.MessageBox]::Show("That item already exists within the database","Error")
                            }
                            $Item                     = $This.DB.NewUID(8)
                            $Item.Record.DisplayName  = $DisplayName
                            $Item.Record.Mode         = $This.Xaml.IO.Mod_Invoice_Mode_List.SelectedItem.Content
                            $Item.Record.Client       = $This.Xaml.IO.Mod_Invoice_Client_List.SelectedItem.Content
                            $Item.Record.Issue        = @($This.Xaml.IO.Mod_Invoice_Issue.Items)
                            $Item.Record.Purchase     = @($This.Xaml.IO.Mod_Invoice_Purchase.Items)
                            $Item.Record.Inventory    = @($This.Xaml.IO.Mod_Invoice_Inventory.Items)

                            [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                            $This.Menu(9)
                        }
                    }
                }

                4 # Delete
                {
                    [System.Windows.MessageBox]::Show("This will now delete the open record")
                }
            }
        }
        View([String]$UID)
        {
            $Item = $This.DB.GetUID($UID)

            Switch($This.Current)
            {
                UID
                {
                    $This.Xaml.IO.Mod_UID_UID.Text                       = $Item.UID
                    $This.Xaml.IO.Mod_UID_Index.Text                     = $Item.Index
                    $This.Xaml.IO.Mod_UID_Slot.Text                      = $Item.Slot
                    $This.Xaml.IO.Mod_UID_Type.Text                      = $Item.Type
                    $This.Xaml.IO.Mod_UID_Date.Text                      = $Item.Date
                    $This.Xaml.IO.Mod_UID_Time.Text                      = $Item.Time
                    $This.Xaml.IO.Mod_UID_Record.ItemsSource             = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
                Client
                {
                    $This.Xaml.IO.Mod_Client_Last.Text                   = $Item.Record.Last
                    $This.Xaml.IO.Mod_Client_First.Text                  = $Item.Record.First
                    $This.Xaml.IO.Mod_Client_MI.Text                     = $Item.Record.MI
                    $This.Xaml.IO.Mod_Client_Gender.SelectedIndex        = @(0,1)[$Item.Record.Gender]
                    $This.Xaml.IO.Mod_Client_Address.Text                = $Item.Record.Address
                    $This.Xaml.IO.Mod_Client_Month.Text                  = $Item.Record.Month
                    $This.Xaml.IO.Mod_Client_Day.Text                    = $Item.Record.Day
                    $This.Xaml.IO.Mod_Client_Year.Text                   = $Item.Record.Year
                    $This.Xaml.IO.Mod_Client_City.Text                   = $Item.Record.City
                    $This.Xaml.IO.Mod_Client_Region.Text                 = $Item.Record.Region
                    $This.Xaml.IO.Mod_Client_Country.Text                = $Item.Record.Country
                    $This.Xaml.IO.Mod_Client_Postal.Text                 = $Item.Record.Postal
                    $This.Xaml.IO.Mod_Client_Phone_List.ItemsSource      = @($Item.Record.Phone)
                    $This.Xaml.IO.Mod_Client_Email_List.ItemsSource      = @($Item.Record.Email)
                    $This.Xaml.IO.Mod_Client_Device_List.ItemsSource     = @($Item.Record.Device)
                    $This.Xaml.IO.Mod_Client_Issue_List.ItemsSource      = @($Item.Record.Issue)
                    $This.Xaml.IO.Mod_Client_Invoice_List.ItemsSource    = @($Item.Record.Invoice)
                }
                Service
                {
                    $This.Xaml.IO.Mod_Service_Name.Text                  = $Item.Record.Name
                    $This.Xaml.IO.Mod_Service_Description.Text           = $Item.Record.Description
                    $This.Xaml.IO.Mod_Service_Cost.Text                  = $Item.Record.Cost
                }
                Device
                {
                    $This.Xaml.IO.Mod_Device_DisplayName.Text            = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Device_Chassis_List.SelectedIndex  = @{ Desktop = 0; Laptop = 1; Smartphone = 2; Tablet = 3; Console = 4; Server = 5; Network = 6; Other = 7; "-" = 8 }[$Item.Record.Chassis]
                    $This.Xaml.IO.Mod_Device_Vendor.Text                 = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Device_Model.Text                  = $Item.Record.Model
                    $This.Xaml.IO.Mod_Device_Specification.Text          = $Item.Record.Specfication
                    $This.Xaml.IO.Mod_Device_Serial.Text                 = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Device_Client_Result.ItemsSource   = @($Item.Record.Client)
                }
                Issue
                {
                    $This.Xaml.IO.Mod_Issue_Status_List.SelectedIndex    = @{ "-" = 0; New = 1; Diagnosed = 2; Commit = 3; Complete = 4}[$Item.Record.Status]
                    $This.Xaml.IO.Mod_Issue_Description.Text             = $Item.Record.Description
                    $This.Xaml.IO.Mod_Issue_Client_List.ItemsSource      = $Item.Record.Client
                    $This.Xaml.IO.Mod_Issue_Device_List.ItemsSource      = $Item.Record.Device
                    $This.Xaml.IO.Mod_Issue_Service_List.ItemsSource     = @($Item.Record.Service)
                    $This.Xaml.IO.Mod_Issue_Record_List.ItemsSource      = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
                Purchase
                {
                    $This.Xaml.IO.Mod_Purchase_DisplayName.Text          = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Purchase_Distributor.Text          = $Item.Record.Distributor
                    $This.Xaml.IO.Mod_Purchase_URL.Text                  = $Item.Record.URL
                    $This.Xaml.IO.Mod_Purchase_Vendor.Text               = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Purchase_Model.Text                = $Item.Record.Model
                    $This.Xaml.IO.Mod_Purchase_Specification.Text        = $Item.Record.Specification
                    $This.Xaml.IO.Mod_Purchase_Serial.Text               = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Purchase_IsDevice.SelectedIndex    = @(0,1)[$Item.Record.IsDevice]
                    $This.Xaml.IO.Mod_Purchase_Device_List.ItemsSource   = $Item.Record.Device
                    $This.Xaml.IO.Mod_Purchase_Cost.Text                 = $Item.Record.Cost
                }
                Inventory
                {
                    $This.Xaml.IO.Mod_Inventory_Vendor.Text              = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Inventory_Model.Text               = $Item.Record.Model
                    $This.Xaml.IO.Mod_Inventory_Serial.Text              = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Inventory_Title.Text               = $Item.Record.Title
                    $This.Xaml.IO.Mod_Inventory_Cost.Text                = $Item.Record.Cost
                    $This.Xaml.IO.Mod_Inventory_IsDevice.SelectedIndex   = @(0,1)[$Item.Record.IsDevice]
                    $This.Xaml.IO.Mod_Inventory_Device_List.ItemsSource  = $Item.Record.Device
                }
                Expense
                {
                    $This.Xaml.IO.Mod_Expense_DisplayName.Text           = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Expense_Recipient.Text             = $Item.Record.Recipient
                    $This.Xaml.IO.Mod_Expense_IsAccount.SelectedIndex    = @(0,1)[$Item.Record.IsAccount]
                    $This.Xaml.IO.Mod_Expense_Account_List.ItemsSource   = $Item.Record.Account
                    $This.Xaml.IO.Mod_Expense_Cost.Text                  = $Item.Record.Cost
                }
                Account
                {
                    $This.Xaml.IO.Mod_Account_Object_List.ItemsSource    = @($Item.Record.Object)
                }
                Invoice
                {
                    $This.Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex    = @{ Quick = 0 ; Default = 1 }[$Item.Record.Mode]
                    $This.Xaml.IO.Mod_Invoice_Client_List.ItemsSource    = @($Item.Record.Client)
                    $This.Xaml.IO.Mod_Invoice_Issue_List.ItemsSource     = @($Item.Record.Issue)
                    $This.Xaml.IO.Mod_Invoice_Purchase_List.ItemsSource  = @($Item.Record.Purchase)
                    $This.Xaml.IO.Mod_Invoice_Inventory_List.ItemsSource = @($Item.Record.Inventory)

                    $This.Xaml.IO.Mod_Invoice_Record_List.ItemsSource    = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
            }
        }
    }
