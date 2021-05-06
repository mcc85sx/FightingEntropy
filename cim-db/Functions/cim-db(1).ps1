#Function cim-db
#{
    Add-Type -AssemblyName PresentationFramework

	$Base = "https://github.com/mcc85sx/FightingEntropy/blob/master/cim-db"
	$Xaml = Invoke-WebRequest $Base/Xaml/cim-db.xaml?raw=true | % Content
	$Slot = "UID Client Service Device Issue Inventory Purchase Expense Account Invoice"
	$List = "DGList $Slot DB GFX Xaml Template Postal cimdb" -Split " "
	$Slot = $Slot -Split " "
	$Bind = @( )
	ForEach ( $I in 0..( $List.Count - 1 ) )
	{ 
	    $Item = $List[$I]
	    $Link = "$Base/Classes/_$Item.ps1?raw=true" 
	    "[~] $Link" 
	    $Bind += Invoke-RestMethod $Link
	}

	$Grid = @{ }
	ForEach ( $I in 0..( $Slot.Count - 1 ) ) 
	{
	    $Item = $Slot[$I]
	    $Link = "$Base/Xaml/p$I-$Item.xaml?raw=true"
	    "[~] $Link"
	    $Grid.Add($I, (Invoke-WebRequest $Link | % Content))
	}

	Invoke-Expression ($Bind -join "`n")

    $GFX  = [_Gfx]::New()
    $Cim  = [Cimdb]::New($Xaml)

    # ---- #
    # Menu #
    # ---- #
    
    $Cim.IO.t0.Add_Click{ $Cim.GetTab(0) }
    $Cim.IO.t1.Add_Click{ $Cim.GetTab(1) }
    $Cim.IO.t2.Add_Click{ $Cim.GetTab(2) }
    $Cim.IO.t3.Add_Click{ $Cim.GetTab(3) }
    $Cim.IO.t4.Add_Click{ $Cim.GetTab(4) }
    $Cim.IO.t5.Add_Click{ $Cim.GetTab(5) }
    $Cim.IO.t6.Add_Click{ $Cim.GetTab(6) }
    $Cim.IO.t7.Add_Click{ $Cim.GetTab(7) }
    $Cim.IO.t8.Add_Click{ $Cim.GetTab(8) }
    $Cim.IO.t9.Add_Click{ $Cim.GetTab(9) }

    # --- #
    # UID #
    # --- #

    $Cim.IO.p0_x0_UID_______SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(0)
        $Cim.ViewUID($Cim.IO.p0_x0_UID_______SR.SelectedItem.UID)
    })

    # ------ #
    # Client #
    # ------ #

    $Cim.IO.p1_x0_Client____SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(1)
        $Cim.ViewClient($Cim.IO.p1_x0_Client____SR.SelectedItem.UID)
    })

    # Edit
    $Cim.IO.p1_x2_Device____TC.Add_Click(
    {
        $Cim.IO.p1_x2_Device____TI.Visibility = "Visible"
        $Cim.IO.p1_x2_Invoice___TI.Visibility = "Collapsed"
    })

    $Cim.IO.p1_x2_Invoice___TC.Add_Click(
    {
        $Cim.IO.p1_x2_Device____TI.Visibility = "Collapsed"
        $Cim.IO.p1_x2_Invoice___TI.Visibility = "Visible"
    })

    # New
    $Cim.IO.p1_x3_Device____TC.Add_Click(
    {
        $Cim.IO.p1_x3_Device____TI.Visibility = "Visible"
        $Cim.IO.p1_x3_Invoice___TI.Visibility = "Collapsed"

        $Cim.Populate($Cim.DB.Device,$Cim.IO.p1_x3_Device____SR)
    })

    $Cim.IO.p1_x3_Invoice___TC.Add_Click(
    {
        $Cim.IO.p1_x3_Device____TI.Visibility = "Collapsed"
        $Cim.IO.p1_x3_Invoice___TI.Visibility = "Visible"
        
        $Cim.Populate($Cim.DB.Device,$Cim.IO.p1_x3_Invoice___SR)
    })


    # Service #
    
    $Cim.IO.p2_x0_Service___SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(2)
        $Cim.ViewService($Cim.IO.p2_x0_Service___SR.SelectedItem.UID)
    })

    # ------ #
    # Device #
    # ------ #

    # View # 

    $Cim.IO.p3_x0_Device____SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(3)
        $Cim.ViewDevice($Cim.IO.p3_x0_Device____SR.SelectedItem.UID)
    })

    # Edit #

    $Cim.IO.p3_x2_Client____TC.Add_Click(
    {
        $Cim.IO.p3_x2_Client____TI.Visibility = "Visible"
        $Cim.IO.p3_x2_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x2_Client____SR.ItemsSource = $Cim.DB.Client
    })

    $Cim.IO.p3_x2_Issue_____TC.Add_Click(
    {
        $Cim.IO.p3_x2_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Issue_____TI.Visibility = "Visible"
        $Cim.IO.p3_x2_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x2_Issue_____SR.ItemsSource = $Cim.DB.Issue
    })

    $Cim.IO.p3_x2_Purchase__TC.Add_Click(
    {
        $Cim.IO.p3_x2_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Purchase__TI.Visibility = "Visible"
        $Cim.IO.p3_x2_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x2_Purchase___SR.ItemsSource = $Cim.DB.Purchase
    })

    $Cim.IO.p3_x2_Invoice___TC.Add_Click(
    {
        $Cim.IO.p3_x2_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x2_Invoice___TI.Visibility = "Visible"

        $Cim.IO.p3_x2_Invoice___SR.ItemsSource = $Cim.DB.Invoice
    })

    # Client Add/Remove

    $Cim.IO.p3_x2_Client____AB.Add_Click(
    {
        If ( $Cim.IO.p3_x2_Client____SR.SelectedItem.UID -in $Cim.IO.p3_x2_Client____LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ($Cim.IO.p3_x2_Client____SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Client____LI.Items.Add($Cim.IO.p3_x2_Client____SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Client____RB.Add_Click(
    {
        If ( $Cim.IO.p3_x2_Client____LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No client to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Client____LI.Items.Remove($Cim.IO.p3_x2_Client____LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Issue_____AB.Add_Click(
    {
        If ($Cim.IO.p3_x2_Issue_____SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x2_Issue_____SR.SelectedItem.UID -in $Cim.IO.p3_x2_Issue_____LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Issue_____LI.Items.Add($Cim.IO.p3_x2_Issue_____SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Issue_____RB.Add_Click(
    {
        If ( $Cim.IO.p3_x2_Issue_____LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Issue_____LI.Items.Remove($Cim.IO.p3_x2_Issue_____LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Purchase__AB.Add_Click(
    {
        If ($Cim.IO.p3_x2_Purchase__SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x2_Purchase__SR.SelectedItem.UID -in $Cim.IO.p3_x2_Purchase__LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Purchase__LI.Items.Add($Cim.IO.p3_x2_Purchase__SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Purchase__RB.Add_Click(
    {
        If ( $Cim.IO.p3_x2_Purchase__LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Purchase__LI.Items.Remove($Cim.IO.p3_x2_Purchase__LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Invoice___AB.Add_Click(
    {
        If ($Cim.IO.p3_x2_Invoice___SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x2_Invoice___SR.SelectedItem.UID -in $Cim.IO.p3_x2_Invoice___LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Invoice___LI.Items.Add($Cim.IO.p3_x2_Invoice___SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x2_Invoice___RB.Add_Click(
    {
        If ( $Cim.IO.p3_x2_Invoice___LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x2_Invoice___LI.Items.Remove($Cim.IO.p3_x2_Invoice___LI.SelectedItem)
        }
    })

    

    # New #

    $Cim.IO.p3_x3_Client____TC.Add_Click(
    {
        $Cim.IO.p3_x3_Client____TI.Visibility = "Visible"
        $Cim.IO.p3_x3_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x3_Client____SR.ItemsSource = $Cim.DB.Client
    })

    $Cim.IO.p3_x3_Issue_____TC.Add_Click(
    {
        $Cim.IO.p3_x3_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Issue_____TI.Visibility = "Visible"
        $Cim.IO.p3_x3_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x3_Issue_____SR.ItemsSource = $Cim.DB.Issue
    })

    $Cim.IO.p3_x3_Purchase__TC.Add_Click(
    {
        $Cim.IO.p3_x3_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Purchase__TI.Visibility = "Visible"
        $Cim.IO.p3_x3_Invoice___TI.Visibility = "Collapsed"

        $Cim.IO.p3_x3_Purchase__SR.ItemsSource = $Cim.DB.Purchase
    })

    $Cim.IO.p3_x3_Invoice___TC.Add_Click(
    {
        $Cim.IO.p3_x3_Client____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Issue_____TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Purchase__TI.Visibility = "Collapsed"
        $Cim.IO.p3_x3_Invoice___TI.Visibility = "Visible"

        $Cim.IO.p3_x3_Invoice___SR.ItemsSource = $Cim.DB.Invoice
    })

    # Client Add/Remove
    $Cim.IO.p3_x3_Client____AB.Add_Click(
    {
        If ( $Cim.IO.p3_x3_Client____SR.SelectedItem -in $Cim.IO.p3_x3_Client____LI.Items)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ($Cim.IO.p3_x3_Client____SR.Items.Count -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Client____LI.Items.Add($Cim.IO.p3_x3_Client____SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Client____RB.Add_Click(
    {
        If ( $Cim.IO.p3_x3_Client____LI.Items.Count -le 0)
        {
            [System.Windows.MessageBox]::Show("No client to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Client____LI.Items.Remove($Cim.IO.p3_x3_Client____LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Issue_____AB.Add_Click(
    {
        If ($Cim.IO.p3_x3_Issue_____SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x3_Issue_____SR.SelectedItem.UID -in $Cim.IO.p3_x3_Issue_____LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Issue_____LI.Items.Add($Cim.IO.p3_x3_Issue_____SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Issue_____RB.Add_Click(
    {
        If ( $Cim.IO.p3_x3_Issue_____LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Issue_____LI.Items.Remove($Cim.IO.p3_x3_Issue_____LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Purchase__AB.Add_Click(
    {
        If ($Cim.IO.p3_x3_Purchase__SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x3_Purchase__SR.SelectedItem.UID -in $Cim.IO.p3_x3_Purchase__LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Purchase__LI.Items.Add($Cim.IO.p3_x3_Purchase__SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Purchase__RB.Add_Click(
    {
        If ( $Cim.IO.p3_x3_Purchase__LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Purchase__LI.Items.Remove($Cim.IO.p3_x3_Purchase__LI.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Invoice___AB.Add_Click(
    {
        If ($Cim.IO.p3_x3_Invoice___SR.SelectedItem -le 0)
        {
            [System.Windows.MessageBox]::Show("Invalid entry selected","Error")
        }

        ElseIf ( $Cim.IO.p3_x3_Invoice___SR.SelectedItem.UID -in $Cim.IO.p3_x3_Invoice___LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Entry is already selected","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Invoice___LI.Items.Add($Cim.IO.p3_x3_Invoice___SR.SelectedItem)
        }
    })

    $Cim.IO.p3_x3_Invoice___RB.Add_Click(
    {
        If ( $Cim.IO.p3_x3_Invoice___LI.Items.Count -le 0 )
        {
            [System.Windows.MessageBox]::Show("No issue to remove","Error")
        }

        Else
        {
            $Cim.IO.p3_x3_Invoice___LI.Items.Remove($Cim.IO.p3_x3_Invoice___LI.SelectedItem)
        }
    })

    # ----- #
    # Issue #
    # ----- #

    $Cim.IO.p4_x0_Issue_____SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(4)
        $Cim.ViewIssue($Cim.IO.p4_x0_Issue_____SR.SelectedItem.UID)
    })

    # --------- #
    # Inventory #
    # --------- #

    $Cim.IO.p5_x0_Inventory_SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(5)
        $Cim.ViewInventory($Cim.IO.p5_x0_Inventory_SR.SelectedItem.UID)
    })

    # -------- #
    # Purchase #
    # -------- #

    $Cim.IO.p6_x0_Purchase__SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(6)
        $Cim.ViewPurchase($Cim.IO.p6_x0_Purchase__SR.SelectedItem.UID)
    })

    # ------- #
    # Expense #
    # ------- #

    $Cim.IO.p7_x0_Expense___SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(7)
        $Cim.ViewExpense($Cim.IO.p7_x0_Expense___SR.SelectedItem.UID)
    })
    
    # Account #

    $Cim.IO.p8_x0_Account___SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(8)
        $Cim.ViewAccount($Cim.IO.p8_x0_Account___SR.SelectedItem.UID)
    })

    # Invoice # 

    $Cim.IO.p9_x0_Invoice___SR.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(9)
        $Cim.ViewInvoice($Cim.IO.p9_x0_Invoice___SR.SelectedItem.UID)
    })

    $Cim.IO.Edit.Add_Click(
    {
        $Cim.Collapse()
        $Cim.SlotCollapse($Cim.Slot)

        $Cim.New  = 0

        $Cim.IO.Edit.IsEnabled = 0
        $Cim.IO.New.IsEnabled  = 1
        $Cim.IO.Save.IsEnabled = 1

        $Cim.IO.New.Visibility                         = "Visible"        
        $Cim.IO.Save.Visibility                        = "Visible"
        $Cim.IO.Edit.Visibility                        = "Visible"

        $Cim.EditTab($Cim.Slot)

        Switch([UInt32]$Cim.Slot)
        {
            0 
            { 
                $Null
            }

            1 
            { 
                $Cim.EditClient($Cim.IO.p1_x0_Client____SR.SelectedItem.UID)
            }

            2 
            { 
                $Cim.EditService($Cim.IO.p2_x0_Service___SR.SelectedItem.UID)
            }
            
            3 
            { 
                $Cim.EditDevice($Cim.IO.p3_x0_Device____SR.SelectedItem.UID)
            }

            4 
            { 
                $Cim.EditIssue($Cim.IO.p4_x0_Issue_____SR.SelectedItem.UID)
            }

            5 
            { 
                $Cim.EditInventory($Cim.IO.p5_x0_Inventory_SR.SelectedItem.UID)
            }

            6 
            { 
                $Cim.EditPurchase($Cim.IO.p6_x0_Purchase__SR.SelectedItem.UID)
            }

            7 
            { 
                $Cim.EditExpense($Cim.IO.p7_x0_Expense___SR.SelectedItem.UID)
            }

            8 
            { 
                $Cim.EditAccount($Cim.IO.p8_x0_Account___SR.SelectedItem.UID)
            }

            9 
            { 
                $Cim.EditInvoice($Cim.IO.p9_x0_Invoice___SR.SelectedItem.UID)
            }
        }
    })

    $Cim.IO.New.Add_Click(
    {
        $Cim.Collapse()
        $Cim.SlotCollapse($Cim.Slot)

        $Cim.New  = 1
        $Cim.IO.Edit.IsEnabled                         = 0
        $Cim.IO.New.IsEnabled                          = 0
        $Cim.IO.Save.IsEnabled                         = 1

        $Cim.IO.New.Visibility                         = "Visible"        
        $Cim.IO.Save.Visibility                        = "Visible"
        $Cim.IO.Edit.Visibility                        = "Visible"

        $Cim.NewTab($Cim.Slot)
    })

    $Cim.IO.Save.Add_Click(
    {
        Switch([UInt32]$Cim.Slot)
        {
            0 
            { 
                $Null 
            }

            1 # Client
            {
                If ( $Cim.New -eq 0 )
                {
                    $Name = "{0}, {1}" -f $Cim.IO.p1_x2_Last______TB.Text, $Cim.IO.p1_x2_First_____TB.Text 
            
                    If ( $Cim.IO.p1_x2_MI________TB.Text -eq "" )
                    {
                        $Full = $Name
                    }

                    If ( $Cim.IO.p1_x2_MI________TB.Text -ne "" )
                    {
                        $Full = "{0} {1}." -f $Name, $Cim.IO.p1_x2_MI________TB.Text.TrimEnd(".")
                    }

                    $DOB  = "{0:d2}/{1:d2}/{2:d4}" -f $Cim.IO.p1_x2_Month_____TB.Text, $Cim.IO.p1_x2_Day_______TB.Text, $Cim.IO.p1_x2_Year______TB.Text

                    If ($Cim.IO.p1_x2_Last______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Last name missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_First_____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("First name missing","Error")
                    }

                    ElseIf ($Full -in $Cim.DB.Client.Record.Name -and $DOB -in $Cim.DB.Client.Record.DOB)
                    {
                        [System.Windows.MessageBox]::Show("Client account exists","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Address___TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Address missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_City______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("City missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Postal____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Zip code missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Month_____TB.Text -notin 1..12)
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Month","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Day_______TB.Text -notin 1..31)
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Day","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Year______TB.Text.Length -lt 4 )
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Year","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Gender____LI.SelectedIndex -notin 0..1)
                    {
                        [System.Windows.MessageBox]::Show("Invalid Gender","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Phone_____LI.Items.Count -eq 0)
                    {
                        [System.Windows.MessageBox]::Show("No phone number","Error")
                    }

                    ElseIf ($Cim.IO.p1_x2_Email_____LI.Items.Count -eq 0)
                    {
                        [System.Windows.MessageBox]::Show("No email","Error")
                    }

                    Else
                    {
                        $Item                 = $Cim.NewUID(0)
                        $Cim.Refresh()
                        $Item.Record.Last     = $Cim.IO.p1_x2_Last______TB.Text.ToUpper()
                        $Item.Record.First    = $Cim.IO.p1_x2_First_____TB.Text.ToUpper()
                        $Item.Record.MI       = $Cim.IO.p1_x2_MI________TB.Text.ToUpper()
                        $Item.Record.Name     = $Full.ToUpper()
                        $Item.Record.Address  = $Cim.IO.p1_x2_Address___TB.Text.ToUpper()
                        $Item.Record.City     = $Cim.IO.p1_x2_City______TB.Text.ToUpper()
                        $Item.Record.Region   = $Cim.IO.p1_x2_Region____TB.Text.ToUpper()
                        $Item.Record.Country  = $Cim.IO.p1_x2_Country___TB.Text.ToUpper()
                        $Item.Record.Postal   = $Cim.IO.p1_x2_Postal____TB.Text
                        $Item.Record.Month    = $Cim.IO.p1_x2_Month_____TB.Text
                        $Item.Record.Day      = $Cim.IO.p1_x2_Day_______TB.Text
                        $Item.Record.Year     = $Cim.IO.p1_x2_Year______TB.Text
                        $Item.Record.DOB      = $DOB
                        $Item.Record.Gender   = $Cim.IO.p1_x2_Gender____LI.SelectedItem.Content
                        $Item.Record.Phone    = $Cim.IO.p1_x2_Phone_____LI.Items
                        $Item.Record.Email    = $Cim.IO.p1_x2_Email_____LI.Items
                        $Item.Record.Device   = $Cim.IO.p1_x2_Device____LI.Items
                        $Item.Record.Invoice  = $Cim.IO.p1_x2_Invoice___LI.Items

                        [System.Windows.MessageBox]::Show("Client [$($Item.Record.Name)] added to database","Success")

                        $Cim.GetTab(1)
                    }
                }

                If ( $Cim.New -eq 1 )
                {
                    $Name = "{0}, {1}" -f $Cim.IO.p1_x3_Last______TB.Text, $Cim.IO.p1_x3_First_____TB.Text 
            
                    If ( $Cim.IO.p1_x3_MI________TB.Text -eq "" )
                    {
                        $Full = $Name
                    }

                    If ( $Cim.IO.p1_x3_MI________TB.Text -ne "" )
                    {
                        $Full = "{0} {1}." -f $Name, $Cim.IO.p1_x3_MI________TB.Text.TrimEnd(".")
                    }

                    $DOB  = "{0:d2}/{1:d2}/{2:d4}" -f $Cim.IO.p1_x3_Month_____TB.Text, $Cim.IO.p1_x3_Day_______TB.Text, $Cim.IO.p1_x3_Year______TB.Text

                    If ($Cim.IO.p1_x3_Last______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Last name missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_First_____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("First name missing","Error")
                    }

                    ElseIf ($Full -in $Cim.DB.Client.Record.Name -and $DOB -in $Cim.DB.Client.Record.DOB)
                    {
                        [System.Windows.MessageBox]::Show("Client account exists","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Address___TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Address missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_City______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("City missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Postal____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Zip code missing","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Month_____TB.Text -notin 1..12)
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Month","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Day_______TB.Text -notin 1..31)
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Day","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Year______TB.Text.Length -lt 4 )
                    {
                        [System.Windows.MessageBox]::Show("Invalid DOB.Year","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Gender____LI.SelectedIndex -notin 0..1)
                    {
                        [System.Windows.MessageBox]::Show("Invalid Gender","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Phone_____LI.Items.Count -eq 0)
                    {
                        [System.Windows.MessageBox]::Show("No phone number","Error")
                    }

                    ElseIf ($Cim.IO.p1_x3_Email_____LI.Items.Count -eq 0)
                    {
                        [System.Windows.MessageBox]::Show("No email","Error")
                    }

                    Else
                    {
                        $Item                 = $Cim.NewUID(0)
                        $Cim.Refresh()
                        $Item.Record.Last     = $Cim.IO.p1_x3_Last______TB.Text.ToUpper()
                        $Item.Record.First    = $Cim.IO.p1_x3_First_____TB.Text.ToUpper()
                        $Item.Record.MI       = $Cim.IO.p1_x3_MI________TB.Text.ToUpper()
                        $Item.Record.Name     = $Full.ToUpper()
                        $Item.Record.Address  = $Cim.IO.p1_x3_Address___TB.Text.ToUpper()
                        $Item.Record.City     = $Cim.IO.p1_x3_City______TB.Text.ToUpper()
                        $Item.Record.Region   = $Cim.IO.p1_x3_Region____TB.Text.ToUpper()
                        $Item.Record.Country  = $Cim.IO.p1_x3_Country___TB.Text.ToUpper()
                        $Item.Record.Postal   = $Cim.IO.p1_x3_Postal____TB.Text
                        $Item.Record.Month    = $Cim.IO.p1_x3_Month_____TB.Text
                        $Item.Record.Day      = $Cim.IO.p1_x3_Day_______TB.Text
                        $Item.Record.Year     = $Cim.IO.p1_x3_Year______TB.Text
                        $Item.Record.DOB      = $DOB
                        $Item.Record.Gender   = $Cim.IO.p1_x3_Gender____LI.SelectedItem.Content
                        $Item.Record.Phone    = $Cim.IO.p1_x3_Phone_____LI.Items
                        $Item.Record.Email    = $Cim.IO.p1_x3_Email_____LI.Items
                        $Item.Record.Device   = $Cim.IO.p1_x3_Device____LI.Items
                        $Item.Record.Invoice  = $Cim.IO.p1_x3_Invoice___LI.Items

                        [System.Windows.MessageBox]::Show("Client [$($Item.Record.Name)] added to database","Success")

                        $Cim.GetTab(1)
                    }
                }
            }

            2 # Service
            { 
                If ( $Cim.New -eq 0 )
                {
                    If ( $Cim.IO.p2_x2_Name______TB.Text -eq "" )
                    {
                        [System.Windows.MessageBox]::Show("Invalid service name","Error")
                    }

                    ElseIf ( $Cim.IO.p2_x2_Cost______TB.Text -eq "" )
                    {
                        [System.Windows.MessageBox]::Show("Service cost undefined","Error")
                    }

                    ElseIf ( $Cim.IO.p2_x2_Name______TB.Text -in $Cim.DB.Service.Record.Name )
                    {
                        [System.Windows.MessageBox]::Show("Service exists","Error")
                    }

                    Else
                    {
                        $Item                    = $Cim.NewUID(1)
                        $Cim.Refresh()
                        $Item.Record.Name        = $Cim.IO.p2_x2_Name______TB.Text
                        $Item.Record.Description = $Cim.IO.p2_x2_Descript__TB.Text
                        $Item.Record.Cost        = "{0:C}" -f [UInt32]$Cim.IO.p2_x2_Cost______TB.Text

                        [System.Windows.MessageBox]::Show("Service [$($Item.Record.Name)] added to database","Success")

                        $Cim.IO.p2_x2_Name______TB.Text = $Null
                        $Cim.IO.p2_x2_Descript__TB.Text = $Null
                        $Cim.IO.p2_x2_Cost______TB.Text = $Null

                        $Cim.GetTab(2)
                    }
                }

                ElseIf ( $Cim.New -eq 1 )
                {
                    If ( $Cim.IO.p2_x3_Name______TB.Text -eq "" )
                    {
                        [System.Windows.MessageBox]::Show("Invalid service name","Error")
                    }

                    ElseIf ( $Cim.IO.p2_x3_Cost______TB.Text -eq "" )
                    {
                        [System.Windows.MessageBox]::Show("Service cost undefined","Error")
                    }

                    ElseIf ( $Cim.IO.p2_x3_Name______TB.Text -in $Cim.DB.Service.Record.Name )
                    {
                        [System.Windows.MessageBox]::Show("Service exists","Error")
                    }

                    Else
                    {
                        $Item                    = $Cim.NewUID(1)
                        $Cim.Refresh()
                        $Item.Record.Name        = $Cim.IO.p2_x3_Name______TB.Text
                        $Item.Record.Description = $Cim.IO.p2_x3_Descript__TB.Text
                        $Item.Record.Cost        = "{0:C}" -f [UInt32]$Cim.IO.p2_x3_Cost______TB.Text

                        [System.Windows.MessageBox]::Show("Service [$($Item.Record.Name)] added to database","Success")

                        $Cim.IO.p2_x3_Name______TB.Text = $Null
                        $Cim.IO.p2_x3_Descript__TB.Text = $Null
                        $Cim.IO.p2_x3_Cost______TB.Text = $Null

                        $Cim.GetTab(2)
                    }
                }

                Else
                {
                    [System.Windows.MessageBox]::Show("The entry was not saved","Error")
                }
            }

            3 # Device
            {
                If ( $Cim.New -eq 0 )
                {        
                    If ($Cim.IO.p3_x2_Chassis___LI.SelectedIndex -eq 8)
                    {
                        [System.Windows.MessageBox]::Show("Select a valid chassis type","Error")
                    }

                    ElseIf($Cim.IO.p3_x2_Vendor____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a vendor","Error")
                    }

                    ElseIf($Cim.IO.p3_x2_Model_____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a model","Error")
                    }

                    ElseIf($Cim.IO.p3_x2_Spec______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a model specification OR enter N/A","Error")
                    }

                    ElseIf($Cim.IO.p3_x2_Serial____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a serial number","Error")
                    }

                    Else
                    {
                        $Item                          = $Cim.NewUID(2)
                        $Cim.Refresh()
                        $Item.Record.Chassis           = $Cim.IO.p3_x2_Chassis___LI.SelectedIndex
                        $Item.Record.Vendor            = $Cim.IO.p3_x2_Vendor____TB.Text
                        $Item.Record.Specification     = $Cim.IO.p3_x2_Spec______TB.Text
                        $Item.Record.Serial            = $Cim.IO.p3_x2_Serial____TB.Text
                        $Item.Record.Model             = $Cim.IO.p3_x2_Model_____TB.Text
                        $Item.Record.Title             = $Cim.IO.p3_x2_Title_____TB.Text
                        $Item.Record.Client            = $Cim.IO.p3_x2_Client____LI.Items
                        $Item.Record.Issue             = $Cim.IO.p3_x2_Issue_____LI.Items
                        $Item.Record.Purchase          = $Cim.IO.p3_x2_Purchase__LI.Items
                        $Item.Record.Invoice           = $Cim.IO.p3_x2_Invoice___LI.Items

                        [System.Windows.MessageBox]::Show("Device [$($Item.Record.Title)] added to database","Success")

                        $Cim.GetTab(3)
                    }
                }

                If ( $Cim.New -eq 1 )
                {        
                    If ($Cim.IO.p3_x3_Chassis___LI.SelectedIndex -eq 8)
                    {
                        [System.Windows.MessageBox]::Show("Select a valid chassis type","Error")
                    }

                    ElseIf($Cim.IO.p3_x3_Vendor____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a vendor","Error")
                    }

                    ElseIf($Cim.IO.p3_x3_Model_____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a model","Error")
                    }

                    ElseIf($Cim.IO.p3_x3_Spec______TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a model specification OR enter N/A","Error")
                    }

                    ElseIf($Cim.IO.p3_x3_Serial____TB.Text -eq "")
                    {
                        [System.Windows.MessageBox]::Show("Must enter a serial number","Error")
                    }

                    Else
                    {
                        $Item                          = $Cim.NewUID(2)
                        $Cim.Refresh()
                        $Item.Record.Chassis           = $Cim.IO.p3_x3_Chassis___LI.SelectedIndex
                        $Item.Record.Vendor            = $Cim.IO.p3_x3_Vendor____TB.Text
                        $Item.Record.Model             = $Cim.IO.p3_x3_Model_____TB.Text
                        $Item.Record.Specification     = $Cim.IO.p3_x3_Spec______TB.Text
                        
                        $Item.Record.Serial            = $Cim.IO.p3_x3_Serial____TB.Text
                        $Item.Record.DisplayName       = $Cim.IO.p3_x3_Title_____TB.Text
                        $Item.Record.Client            = $Cim.IO.p3_x3_Client____LI.Items
                        $Item.Record.Issue             = $Cim.IO.p3_x3_Issue_____LI.Items
                        $Item.Record.Purchase          = $Cim.IO.p3_x3_Purchase__LI.Items
                        $Item.Record.Invoice           = $Cim.IO.p3_x3_Invoice___LI.Items

                        [System.Windows.MessageBox]::Show("Device [$($Item.Record.DisplayName)] added to database","Success")

                        $Cim.GetTab(3)
                    }
                }
            }

            4 # Issue
            {
                If ( $Cim.New -eq 0 )
                {
                    If ( $Cim.IO.p4_x2_Client____LI.Items.Count -lt 1 )
                    {
                        [System.Windows.MessageBox]::Show("No services specified","Error")
                    }

                    ElseIf ( $Cim.IO.p4_x2_Device____LI.Items.Count -lt 1 )
                    {
                        [System.Windows.MessageBox]::Show("No services specified","Error")
                    }

                    ElseIf ( $Cim.IO.p4_x2_Service___LI.Items.Count -lt 1 )
                    {
                        [System.Windows.MessageBox]::Show("No services specified","Error")
                    }

                    Switch($Cim.IO.p4_x2_Status____LI.SelectedIndex)
                    {
                        0 # New
                        {
                            [System.Windows.MessageBox]::Show("This option should be unreachable","Error")
                        }
                        
                        1 # Diagnosed
                        { 
                            If ( $Cim.IO.p4_x2_Service___LI.Items.Count -lt 1 )
                            {
                                [System.Windows.MessageBox]::Show("No services specified","Error")
                            }
                        } 
                        
                        2 # Commit
                        { 
                            If ( $Cim.IO.p4_x2_Service___LI.Items.Count -lt 1 )
                            {
                                [System.Windows.MessageBox]::Show("No services specified","Error")
                            }
                        } 
                        
                        3 # Complete
                        { 
                            If ( $Cim.IO.p4_x2_Service___LI.Items.Count -lt 1 )
                            {
                                [System.Windows.MessageBox]::Show("No services specified","Error")
                            }
                        }
                    }
                }

                If ( $Cim.New -eq 1 )
                {
                    If ( $Cim.IO.p4_x3_Client____LI.Items.Count -lt 1 )
                    {
                        [System.Windows.MessageBox]::Show("No client listed","Error")
                    }

                    ElseIf ( $Cim.IO.p4_x3_Device____LI.Items.Count -lt 1 )
                    {
                        [System.Windows.MessageBox]::Show("No client listed","Error")
                    }

                    Else
                    {
                        $Item                          = $Cim.NewUID(3)
                        $Cim.Refresh()
                    }
                }
            }
        }  

        $Cim.IO.Edit.IsEnabled = 0
        $Cim.IO.New.IsEnabled  = 1
        $Cim.IO.Save.IsEnabled = 0
        $Cim.GetTab($Cim.Slot)
    })

    # ------ #
    # Client #
    # ------ #

    # Edit
    $Cim.IO.p1_x2_Device____TC.Add_Click(
    {
        $Cim.IO.p1_x2_Device____TI.Visibility = "Visible"
        $Cim.IO.p1_x2_Invoice___TI.Visibility = "Collapsed"
    })

    $Cim.IO.p1_x2_Invoice___TC.Add_Click(
    {
        $Cim.IO.p1_x2_Device____TI.Visibility = "Collapsed"
        $Cim.IO.p1_x2_Invoice___TI.Visibility = "Visible"
    })

    $Cim.IO.p1_x2_Phone_____AB.Add_Click(
    {
        $Item   = $Cim.IO.p1_x2_Phone_____TB.Text.ToString() -Replace "-",""
        $String = "{0}{1}{2}-{3}{4}{5}-{6}{7}{8}{9}" -f $Item[0..9]

        If ( $Item.Length -ne 10 -or $Item -notmatch "(\d{10})" )
        {
            [System.Windows.MessageBox]::Show("Invalid phone number","Error")
        }

        ElseIf ( $String -in $Cim.IO.p1_x2_Phone_____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate phone number","Error")
        }

        ElseIf ($String -in $Cim.DB.Client.Record.Phone)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO.p1_x2_Phone_____LI.Items.Add($String)
            $Cim.IO.p1_x2_Phone_____LI.SelectedIndex = ($Cim.IO.p1_x2_Phone_____LI.Items.Count - 1)
            $Cim.IO.p1_x2_Phone_____TB.Text = $Null
            $Item                           = $Null 
            $String                         = $Null
        }
    })

    $Cim.IO.p1_x2_Phone_____RB.Add_Click(
    {
        If ( $Cim.IO.p1_x2_Phone_____LI.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No phone number to remove","Error")
        }

        ElseIf( $Cim.IO.p1_x2_Phone_____LI.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another phone number before removing","Error")
        }

        Else
        {
            $Cim.IO.p1_x2_Phone_____LI.Items.Remove($Cim.IO.p1_x2_Phone_____LI.SelectedItem)
        }
    })

    $Cim.IO.p1_x2_Email_____AB.Add_Click(
    {
        
        $Item = $Cim.IO.p1_x2_Email_____TB.Text.ToString()

        If ( $Item -notmatch "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        {
            [System.Windows.MessageBox]::Show("Invalid Email Address","Error")
        }

        ElseIf ( $Item -in $Cim.IO.p1_x2_Email_____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate email address","Error")
        }

        ElseIf ($Item -in $Cim.DB.Client.Record.Email)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO.p1_x2_Email_____LI.Items.Add($Item)
            $Cim.IO.p1_x2_Email_____LI.SelectedIndex = ($Cim.IO.p1_x2_Email_____LI.Count - 1)
            $Cim.IO.p1_x2_Email_____TB.Text,$Item = $Null
        }
    })

    $Cim.IO.p1_x2_Email_____RB.Add_Click(
    {    
        If ( $Cim.IO.p1_x2_Email_____LI.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No email address to remove","Error")
        }

        ElseIf( $Cim.IO.p1_x2_Email_____LI.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another email address before removing","Error")
        }

        Else
        {
            $Cim.IO.p1_x2_Email_____LI.Items.Remove($Cim.IO.p1_x2_Email_____LI.SelectedItem)
        }
    })

    $Cim.IO.p1_x2_Device____AB.Add_Click(
    {
        If ( $Cim.IO.p1_x2_Device____SR.Items.Count -eq 0 )
        {
            [System.Windows.MessageBox]::Show("No device listed to add","Error")
        }

        ElseIf( $Cim.IO.p1_x2_Device____SR.SelectedItem.UID -in $Cim.IO.p1_x2_Device____LI.Items)
        {
            [System.Windows.MessageBox]::Show("Device is already selected","Error")
        }

        $Cim.IO.p1_x2_Device____LI.Items.Add($Cim.IO.p1_x2_Device____SR.SelectedItem.UID)
    })

    $Cim.IO.p1_x2_Device____RB.Add_Click(
    {
        If ($Cim.IO.p1_x2_Device____LI.SelectedIndex -eq -1 -or $Cim.IO.p1_x2_Device____LI.Items.Count -eq 0 )
        {
            [System.Windows.MessageBox]::Show("No device listed to remove","Error")
        }

        $Cim.IO.p1_x2_Device____LI.Items.Remove($Cim.IO.p1_x2_Device____SR.SelectedItem.UID)
    })

    # New
    $Cim.IO.p1_x3_Phone_____AB.Add_Click(
    {
        $Item   = $Cim.IO.p1_x3_Phone_____TB.Text.ToString() -Replace "-",""
        $String = "{0}{1}{2}-{3}{4}{5}-{6}{7}{8}{9}" -f $Item[0..9]

        If ( $Item.Length -ne 10 -or $Item -notmatch "(\d{10})" )
        {
            [System.Windows.MessageBox]::Show("Invalid phone number","Error")
        }

        ElseIf ( $String -in $Cim.IO.p1_x3_Phone_____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate phone number","Error")
        }

        ElseIf ($String -in $Cim.DB.Client.Record.Phone)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO.p1_x3_Phone_____LI.Items.Add($String)
            $Cim.IO.p1_x3_Phone_____LI.SelectedIndex = ($Cim.IO.p1_x3_Phone_____LI.Items.Count - 1)
            $Cim.IO.p1_x3_Phone_____TB.Text = $Null
            $Item                           = $Null 
            $String                         = $Null
        }
    })

    $Cim.IO.p1_x3_Phone_____RB.Add_Click(
    {
        If ( $Cim.IO.p1_x3_Phone_____LI.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No phone number to remove","Error")
        }

        ElseIf( $Cim.IO.p1_x3_Phone_____LI.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another phone number before removing","Error")
        }

        Else
        {
            $Cim.IO.p1_x3_Phone_____LI.Items.Remove($Cim.IO.p1_x3_Phone_____LI.SelectedItem)
        }
    })

    $Cim.IO.p1_x3_Email_____AB.Add_Click(
    {
        
        $Item = $Cim.IO.p1_x3_Email_____TB.Text.ToString()

        If ( $Item -notmatch "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        {
            [System.Windows.MessageBox]::Show("Invalid Email Address","Error")
        }

        ElseIf ( $Item -in $Cim.IO.p1_x3_Email_____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate email address","Error")
        }

        ElseIf ($Item -in $Cim.DB.Client.Record.Email)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO.p1_x3_Email_____LI.Items.Add($Item)
            $Cim.IO.p1_x3_Email_____LI.SelectedIndex = ($Cim.IO.p1_x3_Email_____LI.Count - 1)
            $Cim.IO.p1_x3_Email_____TB.Text,$Item = $Null
        }
    })

    $Cim.IO.p1_x3_Email_____RB.Add_Click(
    {    
        If ( $Cim.IO.p1_x3_Email_____LI.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No email address to remove","Error")
        }

        ElseIf( $Cim.IO.p1_x3_Email_____LI.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another email address before removing","Error")
        }

        Else
        {
            $Cim.IO.p1_x3_Email_____LI.Items.Remove($Cim.IO.p1_x3_Email_____LI.SelectedItem)
        }
    })

    $Cim.IO.p1_x3_Device____AB.Add_Click(
    {
        If ( $Cim.IO.p1_x3_Device____SR.Items.Count -eq 0 )
        {
            [System.Windows.MessageBox]::Show("No device listed to add","Error")
        }

        ElseIf( $Cim.IO.p1_x3_Device____SR.SelectedItem.UID -in $Cim.IO.p1_x3_Device____LI.Items.UID)
        {
            [System.Windows.MessageBox]::Show("Device is already selected","Error")
        }

        $Cim.IO.p1_x3_Device____LI.Items.Add($Cim.IO.p1_x3_Device____SR.SelectedItem)
    })

    $Cim.IO.p1_x3_Device____RB.Add_Click(
    {
        If ($Cim.IO.p1_x3_Device____LI.SelectedIndex -eq -1 -or $Cim.IO.p1_x3_Device____LI.Items.Count -eq 0 )
        {
            [System.Windows.MessageBox]::Show("No device listed to remove","Error")
        }

        Else
        {
            $Cim.IO.p1_x3_Device____LI.Items.Remove($Cim.IO.p1_x3_Device____SR.SelectedItem)
        }
    })

    # ----- #
    # Issue #
    # ----- #

    # Edit ----

    $Cim.IO.p4_x2_Client____RB.IsEnabled = 0
    $Cim.IO.p4_x2_Device____RB.IsEnabled = 0
    $Cim.IO.p4_x2_Purchase__RB.IsEnabled = 0
    $Cim.IO.p4_x2_Service___RB.IsEnabled = 0
    $Cim.IO.p4_x2_Invoice___RB.IsEnabled = 0

    $Cim.IO.p4_x2_Client____LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x2_Client____LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x2_Client____AB.IsEnabled = 1
                $Cim.IO.p4_x2_Client____RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x2_Client____AB.IsEnabled = 0 
                $Cim.IO.p4_x2_Client____RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x2_Device____LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x2_Device____LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x2_Device____AB.IsEnabled = 1
                $Cim.IO.p4_x2_Device____RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x2_Device____AB.IsEnabled = 0 
                $Cim.IO.p4_x2_Device____RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x2_Purchase__LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x2_Purchase__LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x2_Purchase__AB.IsEnabled = 1
                $Cim.IO.p4_x2_Purchase__RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x2_Purchase__AB.IsEnabled = 0 
                $Cim.IO.p4_x2_Purchase__RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x2_Client____AB.Add_Click(
    {
        If ( $Cim.IO.p4_x2_Client____SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x2_Client____SR.SelectedItem -in $Cim.IO.p4_x2_Client____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x2_Client____LI.Items.Add($Cim.IO.p4_x2_Client____SR.SelectedItem.UID)
            $Cim.IO.p4_x2_Client____AB.IsEnabled = 0
            $Cim.IO.p4_x2_Client____RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x2_Client____RB.Add_Click(
    {
        $Cim.IO.p4_x2_Client____LI($Cim.IO.p4_x2_Client____SR.SelectedItem.UID)
        $Cim.IO.p4_x2_Client____AB.IsEnabled = 1
        $Cim.IO.p4_x2_Client____RB.IsEnabled = 0
    })

    $Cim.IO.p4_x2_Device____AB.Add_Click(
    {
        If ( $Cim.IO.p4_x2_Device____SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x2_Device____SR.SelectedItem -in $Cim.IO.p4_x2_Device____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x2_Device____LI.Items.Add($Cim.IO.p4_x2_Device____SR.SelectedItem.UID)
            $Cim.IO.p4_x2_Device____AB.IsEnabled = 0
            $Cim.IO.p4_x2_Device____RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x2_Device____RB.Add_Click(
    {
        $Cim.IO.p4_x2_Device____LI($Cim.IO.p4_x2_Device____SR.SelectedItem.UID)
        $Cim.IO.p4_x2_Device____AB.IsEnabled = 1
        $Cim.IO.p4_x2_Device____RB.IsEnabled = 0
    })

    $Cim.IO.p4_x2_Purchase__AB.Add_Click(
    {
        If ( $Cim.IO.p4_x2_Purchase__SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x2_Purchase__SR.SelectedItem -in $Cim.IO.p4_x2_Purchase__LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x2_Purchase__LI.Items.Add($Cim.IO.p4_x2_Purchase__SR.SelectedItem.UID)
            $Cim.IO.p4_x2_Purchase__AB.IsEnabled = 0
            $Cim.IO.p4_x2_Purchase__RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x2_Purchase__RB.Add_Click(
    {
        $Cim.IO.p4_x2_Purchase__LI($Cim.IO.p4_x2_Purchase__SR.SelectedItem.UID)
        $Cim.IO.p4_x2_Purchase__AB.IsEnabled = 1
        $Cim.IO.p4_x2_Purchase__RB.IsEnabled = 0
    })

    $Cim.IO.p4_x2_Service___AB.Add_Click(
    {
        If ( $Cim.IO.p4_x2_Service___SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x2_Service___SR.SelectedItem -in $Cim.IO.p4_x2_Service___LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x2_Service___LI.Items.Add($Cim.IO.p4_x2_Service___SR.SelectedItem.UID)
            $Cim.IO.p4_x2_Service___AB.IsEnabled = 0
            $Cim.IO.p4_x2_Service___RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x2_Service___RB.Add_Click(
    {
        $Cim.IO.p4_x2_Service___LI($Cim.IO.p4_x2_Service___SR.SelectedItem.UID)
        $Cim.IO.p4_x2_Service___AB.IsEnabled = 1
        $Cim.IO.p4_x2_Service___RB.IsEnabled = 0
    })

    $Cim.IO.p4_x2_Invoice___AB.Add_Click(
    {
        If ( $Cim.IO.p4_x2_Invoice___SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x2_Invoice___SR.SelectedItem -in $Cim.IO.p4_x2_Invoice___LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x2_Invoice___LI.Items.Add($Cim.IO.p4_x2_Invoice___SR.SelectedItem.UID)
            $Cim.IO.p4_x2_Invoice___AB.IsEnabled = 0
            $Cim.IO.p4_x2_Invoice___RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x2_Invoice___RB.Add_Click(
    {
        $Cim.IO.p4_x2_Invoice___LI($Cim.IO.p4_x2_Invoice___SR.SelectedItem.UID)
        $Cim.IO.p4_x2_Invoice___AB.IsEnabled = 1
        $Cim.IO.p4_x2_Invoice___RB.IsEnabled = 0
    })

    # New ----

    $Cim.IO.p4_x3_Client____RB.IsEnabled = 0
    $Cim.IO.p4_x3_Device____RB.IsEnabled = 0
    $Cim.IO.p4_x3_Purchase__RB.IsEnabled = 0
    $Cim.IO.p4_x3_Service___RB.IsEnabled = 0
    $Cim.IO.p4_x3_Invoice___RB.IsEnabled = 0

    $Cim.IO.p4_x3_Client____LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x3_Client____LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x3_Client____AB.IsEnabled = 1
                $Cim.IO.p4_x3_Client____RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x3_Client____AB.IsEnabled = 0 
                $Cim.IO.p4_x3_Client____RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x3_Device____LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x3_Device____LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x3_Device____AB.IsEnabled = 1
                $Cim.IO.p4_x3_Device____RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x3_Device____AB.IsEnabled = 0 
                $Cim.IO.p4_x3_Device____RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x3_Purchase__LI.Add_DataContextChanged(
    {
        Switch($Cim.IO.p4_x3_Purchase__LI.Items.Count)
        {
            0 
            { 
                $Cim.IO.p4_x3_Purchase__AB.IsEnabled = 1
                $Cim.IO.p4_x3_Purchase__RB.IsEnabled = 0 
            } 

            1 
            { 
                $Cim.IO.p4_x3_Purchase__AB.IsEnabled = 0 
                $Cim.IO.p4_x3_Purchase__RB.IsEnabled = 1
            }
        }
    })

    $Cim.IO.p4_x3_Client____AB.Add_Click(
    {
        If ( $Cim.IO.p4_x3_Client____SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x3_Client____SR.SelectedItem -in $Cim.IO.p4_x3_Client____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x3_Client____LI.Items.Add($Cim.IO.p4_x3_Client____SR.SelectedItem.UID)
            $Cim.IO.p4_x3_Client____AB.IsEnabled = 0
            $Cim.IO.p4_x3_Client____RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x3_Client____RB.Add_Click(
    {
        $Cim.IO.p4_x3_Client____LI($Cim.IO.p4_x3_Client____SR.SelectedItem.UID)
        $Cim.IO.p4_x3_Client____AB.IsEnabled = 1
        $Cim.IO.p4_x3_Client____RB.IsEnabled = 0
    })

    $Cim.IO.p4_x3_Device____AB.Add_Click(
    {
        If ( $Cim.IO.p4_x3_Device____SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x3_Device____SR.SelectedItem -in $Cim.IO.p4_x3_Device____LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x3_Device____LI.Items.Add($Cim.IO.p4_x3_Device____SR.SelectedItem.UID)
            $Cim.IO.p4_x3_Device____AB.IsEnabled = 0
            $Cim.IO.p4_x3_Device____RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x3_Device____RB.Add_Click(
    {
        $Cim.IO.p4_x3_Device____LI($Cim.IO.p4_x3_Device____SR.SelectedItem.UID)
        $Cim.IO.p4_x3_Device____AB.IsEnabled = 1
        $Cim.IO.p4_x3_Device____RB.IsEnabled = 0
    })

    $Cim.IO.p4_x3_Purchase__AB.Add_Click(
    {
        If ( $Cim.IO.p4_x3_Purchase__SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x3_Purchase__SR.SelectedItem -in $Cim.IO.p4_x3_Purchase__LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x3_Purchase__LI.Items.Add($Cim.IO.p4_x3_Purchase__SR.SelectedItem.UID)
            $Cim.IO.p4_x3_Purchase__AB.IsEnabled = 0
            $Cim.IO.p4_x3_Purchase__RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x3_Purchase__RB.Add_Click(
    {
        $Cim.IO.p4_x3_Purchase__LI($Cim.IO.p4_x3_Purchase__SR.SelectedItem.UID)
        $Cim.IO.p4_x3_Purchase__AB.IsEnabled = 1
        $Cim.IO.p4_x3_Purchase__RB.IsEnabled = 0
    })

    $Cim.IO.p4_x3_Service___AB.Add_Click(
    {
        If ( $Cim.IO.p4_x3_Service___SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x3_Service___SR.SelectedItem -in $Cim.IO.p4_x3_Service___LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x3_Service___LI.Items.Add($Cim.IO.p4_x3_Service___SR.SelectedItem.UID)
            $Cim.IO.p4_x3_Service___AB.IsEnabled = 0
            $Cim.IO.p4_x3_Service___RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x3_Service___RB.Add_Click(
    {
        $Cim.IO.p4_x3_Service___LI($Cim.IO.p4_x3_Service___SR.SelectedItem.UID)
        $Cim.IO.p4_x3_Service___AB.IsEnabled = 1
        $Cim.IO.p4_x3_Service___RB.IsEnabled = 0
    })

    $Cim.IO.p4_x3_Invoice___AB.Add_Click(
    {
        If ( $Cim.IO.p4_x3_Invoice___SR.SelectedIndex -eq -1 )
        {
            [System.Windows.MessageBox]::Show("No client selected","Error")
        }

        ElseIf ( $Cim.IO.p4_x3_Invoice___SR.SelectedItem -in $Cim.IO.p4_x3_Invoice___LI.Items )
        {
            [System.Windows.MessageBox]::Show("Client is already specified","Error")
        }

        Else
        {
            $Cim.IO.p4_x3_Invoice___LI.Items.Add($Cim.IO.p4_x3_Invoice___SR.SelectedItem.UID)
            $Cim.IO.p4_x3_Invoice___AB.IsEnabled = 0
            $Cim.IO.p4_x3_Invoice___RB.IsEnabled = 1
        }
    })

    $Cim.IO.p4_x3_Invoice___RB.Add_Click(
    {
        $Cim.IO.p4_x3_Invoice___LI($Cim.IO.p4_x3_Invoice___SR.SelectedItem.UID)
        $Cim.IO.p4_x3_Invoice___AB.IsEnabled = 1
        $Cim.IO.p4_x3_Invoice___RB.IsEnabled = 0
    })

    Function IssuePanel 
    {
    $Cim.IO._EditIssueTab.Add_Click(
    {
        $Cim.EditTab(4)
        $Cim.EditIssue($Cim.IO._GetIssueSearchResult.SelectedItem.UID)

        $Cim.Populate($Cim.DB.Service.Record,$Cim.IO._EditIssueServiceSearchResult)

        $Cim.IO._EditIssueTab.IsEnabled = 0
        $Cim.IO._NewIssueTab.IsEnabled  = 1
        $Cim.IO._SaveIssueTab.IsEnabled = 1
    })

    $Cim.IO._NewIssueTab.Add_Click(
    { 
        $Cim.NewTab(4)

        $Cim.Relinquish($Cim.IO._NewIssueClientSearchResult)
        $Cim.Relinquish($Cim.IO._NewIssueDeviceSearchResult)
        $Cim.Relinquish($Cim.IO._NewIssuePurchaseSearchResult)
        $Cim.Relinquish($Cim.IO._NewIssueServiceSearchResult)
        $Cim.Relinquish($Cim.IO._NewIssueInvoiceSearchResult)

        $Cim.IO._NewIssueClientList.ItemsSource = $Null
        $Cim.IO._NewIssueDeviceList.ItemsSource = $Null
        $Cim.IO._NewIssuePurchaseList.ItemsSource = $Null
        $Cim.IO._NewIssueServiceList.ItemsSource = $Null
        $Cim.IO._NewIssueInvoiceList.ItemsSource = $Null

        $Cim.Populate($Cim.DB.Client,$Cim.IO._NewIssueClientSearchResult)
        $Cim.Populate($Cim.DB.Device,$Cim.IO._NewIssueDeviceSearchResult)
        $Cim.Populate($Cim.DB.Purchase,$Cim.IO._NewIssuePurchaseSearchResult)
        $Cim.Populate($Cim.DB.Service,$Cim.IO._NewIssueServiceSearchResult)
        $Cim.Populate($Cim.DB.Invoice,$Cim.IO._NewIssueInvoiceSearchResult)

        $Cim.IO._EditIssueTab.IsEnabled = 0
        $Cim.IO._NewIssueTab.IsEnabled  = 0
        $Cim.IO._SaveIssueTab.IsEnabled = 1
    })

    $Cim.IO._NewIssueAddService.Add_Click(
    {
        $Item = $Cim.DB.Service | ? { $_.Record.Name -eq $Cim.IO._NewIssueServiceSearchResult.SelectedItem }
        
        If ( $Item -in $Cim.IO._NewIssueServiceList.Items )
        {
            [System.Windows.MessageBox]::Show("Service is already selected","Error")
        }   
            
        Else
        {
            $Cim.IO._NewIssueServiceList.Items.Add($Item.Record.Name)
        }

    })

    $Cim.IO._NewIssueRemoveService.Add_Click(
    {
        $Item = $Cim.DB.Service | ? { $_.Record.Name -eq $Cim.IO._NewIssueServiceSearchResult.SelectedItem }

        If ( $Item -in $Cim.IO._NewIssueServiceList.Items )
        {
            $Cim.IO._NewIssueServiceList.Items.Remove($Item.Record.Name)
        }
    })
    }

    Function InventoryPanel 
    {

    $Cim.IO._EditInventoryTab.Add_Click(
    {
        $Cim.EditTab(5)
        $Cim.EditInventory($Cim.IO._GetInventorySearchResult.SelectedItem.UID)
        $Cim.IO._EditInventoryTab.IsEnabled = 0
        $Cim.IO._NewInventoryTab.IsEnabled  = 1
        $Cim.IO._SaveInventoryTab.IsEnabled = 1
    })

    $Cim.IO._NewInventoryTab.Add_Click(
    { 
        $Cim.NewTab(5)
        $Cim.IO._EditInventoryTab.IsEnabled = 0
        $Cim.IO._NewInventoryTab.IsEnabled  = 0
        $Cim.IO._SaveInventoryTab.IsEnabled = 1
    })
    }

    Function PurchasePanel 
    {
    $Cim.IO._EditPurchaseTab.Add_Click(
    {
        $Cim.EditTab(6)
        $Cim.EditPurchase($Cim.IO._GetPurchaseSearchResult.SelectedItem.UID)
        $Cim.IO._EditPurchaseTab.IsEnabled = 0
        $Cim.IO._NewPurchaseTab.IsEnabled  = 1
        $Cim.IO._SavePurchaseTab.IsEnabled = 1
    })

    $Cim.IO._NewPurchaseTab.Add_Click(
    { 
        $Cim.NewTab(6)
        $Cim.IO._EditPurchaseTab.IsEnabled = 0
        $Cim.IO._NewPurchaseTab.IsEnabled  = 0
        $Cim.IO._SavePurchaseTab.IsEnabled = 1
    })
    }

    Function ExpensePanel 
    {
    $Cim.IO._EditExpenseTab.Add_Click(
    {
        $Cim.EditTab(7)
        $Cim.EditExpense($Cim.IO._GetExpenseSearchResult.SelectedItem.UID)
        $Cim.IO._EditExpenseTab.IsEnabled = 0
        $Cim.IO._NewExpenseTab.IsEnabled  = 1
        $Cim.IO._SaveExpenseTab.IsEnabled = 1
    })

    $Cim.IO._NewExpenseTab.Add_Click(
    { 
        $Cim.NewTab(7)
        $Cim.IO._EditExpenseTab.IsEnabled = 0
        $Cim.IO._NewExpenseTab.IsEnabled  = 0
        $Cim.IO._SaveExpenseTab.IsEnabled = 1
    })
    }

    Function AccountPanel 
    {
    $Cim.IO._EditAccountTab.Add_Click(
    {
        $Cim.EditTab(8)
        $Cim.EditAccount($Cim.IO._GetAccountSearchResult.SelectedItem.UID)
        $Cim.IO._EditAccountTab.IsEnabled = 0
        $Cim.IO._NewAccountTab.IsEnabled  = 1
        $Cim.IO._SaveAccountTab.IsEnabled = 1
    })

    $Cim.IO._NewAccountTab.Add_Click(
    { 
        $Cim.NewTab(8)
        $Cim.IO._EditAccountTab.IsEnabled = 0
        $Cim.IO._NewAccountTab.IsEnabled  = 0
        $Cim.IO._SaveAccountTab.IsEnabled = 1
    })
    }

    Function InvoicePanel 
    {

    $Cim.IO._EditInvoiceTab.Add_Click(
    {
        $Cim.EditTab(9)
        $Cim.EditInvoice($Cim.IO._GetInvoiceSearchResult.SelectedItem.UID)
        $Cim.IO._EditInvoiceTab.IsEnabled = 0
        $Cim.IO._NewInvoiceTab.IsEnabled  = 1
        $Cim.IO._SaveInvoiceTab.IsEnabled = 1
    })

    $Cim.IO._NewInvoiceTab.Add_Click(
    { 
        $Cim.NewTab(9)
        $Cim.IO._EditInvoiceTab.IsEnabled = 0
        $Cim.IO._NewInvoiceTab.IsEnabled  = 0
        $Cim.IO._SaveInvoiceTab.IsEnabled = 1
    })
    }

    # ------------- #
    # Return Object #
    # ------------- #

    #$Cim
#

#$Cim      = cim-db

$Cim.Window.Invoke()
