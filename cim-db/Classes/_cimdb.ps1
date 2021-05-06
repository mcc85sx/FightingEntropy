    Class _cimdb
    {
        [Object]  $Window
        [Object]      $IO
        [Object]    $Temp
        [Object]     $Tab = ("UID Client Service Device Issue Inventory Purchase Expense Account Invoice" -Split " ")
        [Object]    $Date = (Get-Date -uformat %m/%d/%Y)
        [UInt32]    $Slot
        [UInt32]     $New
        [Object]      $DB
        [Object]      $DG

        [Object] NewUID([UInt32]$Slot)
        {
            Return @( $This.DB.NewUID($Slot) )
        }

        [Object] GetUID([String]$UID)
        {
            Return @( $This.DB.UID | ? UID -match $UID )
        }

        [Void] Populate([Object]$Record,[Object]$Control)
        {
            $Control.ItemsSource = $Null

            If ( $Record.Count -ne 0 )
            {
                ForEach ( $Item in $Record )
                {
                    $Control.Items.Add($Item)
                }
            }

            $Control.SelectedIndex = $Control.Items.Count - 1
        }

        [Void] Relinquish([Object]$Control)
        {
            If ( $Control.ItemsSource.Count -ne 0 )
            {
                ForEach ( $Item in $Control.ItemsSource )
                {
                    $Control.Items.Remove($Item)
                }

                $Control.SelectedIndex = -1
            }
        }

        [String[]] GetSearchNames()
        {
            Return @(
                "p0_x0_UID_______",
                "p1_x0_Client____",
                    "p1_x1_Device____","p1_x1_Invoice___",
                    "p1_x2_Device____","p1_x2_Invoice___",
                    "p1_x3_Device____","p1_x3_Invoice___",
                "p2_x0_Service___",
                "p3_x0_Device____",
                    "p3_x1_Client____","p3_x1_Issue_____","p3_x1_Purchase__","p3_x1_Invoice___",
                    "p3_x2_Client____","p3_x2_Issue_____","p3_x2_Purchase__","p3_x2_Invoice___",
                    "p3_x3_Client____","p3_x3_Issue_____","p3_x3_Purchase__","p3_x3_Invoice___",
                "p4_x0_Issue_____",
                    "p4_x1_Client____","p4_x1_Device____","p4_x1_Purchase__","p4_x1_Service___","p4_x1_Invoice___",
                     "p4_x2_Client____","p4_x2_Device____","p4_x2_Purchase__","p4_x2_Service___","p4_x2_Invoice___",
                     "p4_x3_Client____","p4_x3_Device____","p4_x3_Purchase__","p4_x3_Service___","p4_x3_Invoice___",
                "p5_x0_Inventory_",
                    "p5_x1_Device____",
                    "p5_x2_Device____",
                    "p5_x3_Device____",
                "p6_x0_Purchase__",
                    "p6_x1_Device____",
                    "p6_x2_Device____",
                    "p6_x3_Device____",
                "p7_x0_Expense___",
                    "p7_x1_Account___",
                    "p7_x2_Account___",
                    "p7_x3_Account___",
                "p8_x0_Account___",
                    "p8_x1_AcctObj___",
                    "p8_x2_AcctObj___",
                    "p8_x3_AcctObj___",
                "p9_x0_Invoice___",
                    "p9_x1_Client____","p9_x1_Inventory_","p9_x1_Service___","p9_x1_Purchase__",
                    "p9_x2_Client____","p9_x2_Inventory_","p9_x2_Service___","p9_x2_Purchase__",
                    "p9_x3_Client____","p9_x3_Inventory_","p9_x3_Service___","p9_x3_Purchase__")
        }

        [String[]] GetControlNames()
        {
            Return @(
            "p0_x1_UID_______TB",
            "p0_x1_Index_____TB",
            "p0_x1_Slot______TB",
            "p0_x1_Type______TB",
            "p0_x1_Date______TB",
            "p0_x1_Time______TB",
            "p1_x1_Last______TB",
            "p1_x1_First_____TB",
            "p1_x1_MI________TB",
            "p1_x1_Gender____LI",
            "p1_x1_Address___TB",
            "p1_x1_Month_____TB",
            "p1_x1_Day_______TB",
            "p1_x1_Year______TB",
            "p1_x1_City______TB",
            "p1_x1_Region____TB",
            "p1_x1_Country___TB",
            "p1_x1_Postal____TB",
            "p1_x1_Phone_____TB",
            "p1_x1_Phone_____AB",
            "p1_x1_Phone_____LI",
            "p1_x1_Phone_____RB",
            "p1_x1_Email_____TB",
            "p1_x1_Email_____AB",
            "p1_x1_Email_____LI",
            "p1_x1_Email_____RB",
            "p1_x1_Device____SP",
            "p1_x1_Device____SF",
            "p1_x1_Device____SR",
            "p1_x1_Device____AB",
            "p1_x1_Device____LI",
            "p1_x1_Device____RB",
            "p1_x1_Invoice___SP",
            "p1_x1_Invoice___SF",
            "p1_x1_Invoice___SR",
            "p1_x1_Invoice___AB",
            "p1_x1_Invoice___LI",
            "p1_x1_Invoice___RB",
            "p1_x2_Last______TB",
            "p1_x2_First_____TB",
            "p1_x2_MI________TB",
            "p1_x2_Gender____LI",
            "p1_x2_Address___TB",
            "p1_x2_Month_____TB",
            "p1_x2_Day_______TB",
            "p1_x2_Year______TB",
            "p1_x2_City______TB",
            "p1_x2_Region____TB",
            "p1_x2_Country___TB",
            "p1_x2_Postal____TB",
            "p1_x2_Phone_____TB",
            "p1_x2_Phone_____AB",
            "p1_x2_Phone_____LI",
            "p1_x2_Phone_____RB",
            "p1_x2_Email_____TB",
            "p1_x2_Email_____AB",
            "p1_x2_Email_____LI",
            "p1_x2_Email_____RB",
            "p1_x2_Device____SP",
            "p1_x2_Device____SF",
            "p1_x2_Device____SR",
            "p1_x2_Device____AB",
            "p1_x2_Device____LI",
            "p1_x2_Device____RB",
            "p1_x2_Invoice___SP",
            "p1_x2_Invoice___SF",
            "p1_x2_Invoice___SR",
            "p1_x2_Invoice___AB",
            "p1_x2_Invoice___LI",
            "p1_x2_Invoice___RB",
            "p1_x3_Last______TB",
            "p1_x3_First_____TB",
            "p1_x3_MI________TB",
            "p1_x3_Gender____LI",
            "p1_x3_Address___TB",
            "p1_x3_Month_____TB",
            "p1_x3_Day_______TB",
            "p1_x3_Year______TB",
            "p1_x3_City______TB",
            "p1_x3_Region____TB",
            "p1_x3_Country___TB",
            "p1_x3_Postal____TB",
            "p1_x3_Phone_____TB",
            "p1_x3_Phone_____AB",
            "p1_x3_Phone_____LI",
            "p1_x3_Phone_____RB",
            "p1_x3_Email_____TB",
            "p1_x3_Email_____AB",
            "p1_x3_Email_____LI",
            "p1_x3_Email_____RB",
            "p1_x3_Device____SP",
            "p1_x3_Device____SF",
            "p1_x3_Device____SR",
            "p1_x3_Device____AB",
            "p1_x3_Device____LI",
            "p1_x3_Device____RB",
            "p1_x3_Invoice___SP",
            "p1_x3_Invoice___SF",
            "p1_x3_Invoice___SR",
            "p1_x3_Invoice___AB",
            "p1_x3_Invoice___LI",
            "p1_x3_Invoice___RB",
            "p2_x0_Service___SP",
            "p2_x0_Service___SF",
            "p2_x0_Service___SR",
			"p2_x1_Name______TB",
            "p2_x1_Descript__TB",
            "p2_x1_Cost______TB",
			"p2_x2_Name______TB",
            "p2_x2_Descript__TB",
            "p2_x2_Cost______TB",
			"p2_x3_Name______TB",
            "p2_x3_Descript__TB",
            "p2_x3_Cost______TB",
            "p3_x0_Device____SP",
            "p3_x0_Device____SF",
            "p3_x0_Device____SR",
            "p3_x1_Chassis___LI",
            "p3_x1_Vendor____TB",
            "p3_x1_Model_____TB",
            "p3_x1_Spec______TB",
            "p3_x1_Serial____TB",
            "p3_x1_Title_____TB",
            "p3_x1_Client____SP",
            "p3_x1_Client____SF",
            "p3_x1_Client____SR",
            "p3_x1_Client____AB",
            "p3_x1_Client____LI",
            "p3_x1_Client____RB",
            "p3_x1_Issue_____SP",
            "p3_x1_Issue_____SF",
            "p3_x1_Issue_____SR",
            "p3_x1_Issue_____AB",
            "p3_x1_Issue_____LI",
            "p3_x1_Issue_____RB",
            "p3_x1_Purchase__SP",
            "p3_x1_Purchase__SF",
            "p3_x1_Purchase__SR",
            "p3_x1_Purchase__AB",
            "p3_x1_Purchase__LI",
            "p3_x1_Purchase__RB",
            "p3_x1_Invoice___SP",
            "p3_x1_Invoice___SF",
            "p3_x1_Invoice___SR",
            "p3_x1_Invoice___AB",
            "p3_x1_Invoice___LI",
            "p3_x1_Invoice___RB",
			"p3_x2_Chassis___LI",
            "p3_x2_Vendor____TB",
            "p3_x2_Model_____TB",
            "p3_x2_Spec______TB",
            "p3_x2_Serial____TB",
            "p3_x2_Title_____TB",
            "p3_x2_Client____SP",
            "p3_x2_Client____SF",
            "p3_x2_Client____SR",
            "p3_x2_Client____AB",
            "p3_x2_Client____LI",
            "p3_x2_Client____RB",
            "p3_x2_Issue_____SP",
            "p3_x2_Issue_____SF",
            "p3_x2_Issue_____SR",
            "p3_x2_Issue_____AB",
            "p3_x2_Issue_____LI",
            "p3_x2_Issue_____RB",
            "p3_x2_Purchase__SP",
            "p3_x2_Purchase__SF",
            "p3_x2_Purchase__SR",
            "p3_x2_Purchase__AB",
            "p3_x2_Purchase__LI",
            "p3_x2_Purchase__RB",
            "p3_x2_Invoice___SP",
            "p3_x2_Invoice___SF",
            "p3_x2_Invoice___SR",
            "p3_x2_Invoice___AB",
            "p3_x2_Invoice___LI",
            "p3_x2_Invoice___RB",
			"p3_x3_Chassis___LI",
            "p3_x3_Vendor____TB",
            "p3_x3_Model_____TB",
            "p3_x3_Spec______TB",
            "p3_x3_Serial____TB",
            "p3_x3_Title_____TB",
            "p3_x3_Client____SP",
            "p3_x3_Client____SF",
            "p3_x3_Client____SR",
            "p3_x3_Client____AB",
            "p3_x3_Client____LI",
            "p3_x3_Client____RB",
            "p3_x3_Issue_____SP",
            "p3_x3_Issue_____SF",
            "p3_x3_Issue_____SR",
            "p3_x3_Issue_____AB",
            "p3_x3_Issue_____LI",
            "p3_x3_Issue_____RB",
            "p3_x3_Purchase__SP",
            "p3_x3_Purchase__SF",
            "p3_x3_Purchase__SR",
            "p3_x3_Purchase__AB",
            "p3_x3_Purchase__LI",
            "p3_x3_Purchase__RB",
            "p3_x3_Invoice___SP",
            "p3_x3_Invoice___SF",
            "p3_x3_Invoice___SR",
            "p3_x3_Invoice___AB",
            "p3_x3_Invoice___LI",
            "p3_x3_Invoice___RB",
            "p4_x0_Issue_____SP",
            "p4_x0_Issue_____SF",
            "p4_x0_Issue_____SR",
			"p4_x1_Status____LI",
            "p4_x1_Descript__TB",
            "p4_x1_Issue_____TC",
            "p4_x1_Client____SP",
            "p4_x1_Client____SF",
            "p4_x1_Client____SR",
            "p4_x1_Device____SP",
            "p4_x1_Device____SF",
            "p4_x1_Device____SR",
            "p4_x1_Purchase__SP",
            "p4_x1_Purchase__SF",
            "p4_x1_Purchase__SR",
            "p4_x1_Service___SR",
            "p4_x1_Service___SF",
            "p4_x1_Service___SR",
            "p4_x1_Invoice___SR",
            "p4_x1_Invoice___SF",
            "p4_x1_Invoice___SR",
            "p4_x1_Client____AB",
            "p4_x1_Client____LI",
            "p4_x1_Client____RB",
            "p4_x1_Device____AB",
            "p4_x1_Device____LI",
            "p4_x1_Device____RB",
            "p4_x1_Purchase__AB",
            "p4_x1_Purchase__LI",
            "p4_x1_Purchase__RB",
            "p4_x1_Service___AB",
            "p4_x1_Service___LI",
            "p4_x1_Service___RB",
            "p4_x1_Invoice___AB",
            "p4_x1_Invoice___LI",
            "p4_x1_Invoice___RB",
			"p4_x2_Status____LI",
            "p4_x2_Descript__TB",
            "p4_x2_Issue_____TC",
            "p4_x2_Client____SP",
            "p4_x2_Client____SF",
            "p4_x2_Client____SR",
            "p4_x2_Device____SP",
            "p4_x2_Device____SF",
            "p4_x2_Device____SR",
            "p4_x2_Purchase__SP",
            "p4_x2_Purchase__SF",
            "p4_x2_Purchase__SR",
            "p4_x2_Service___SR",
            "p4_x2_Service___SF",
            "p4_x2_Service___SR",
            "p4_x2_Invoice___SR",
            "p4_x2_Invoice___SF",
            "p4_x2_Invoice___SR",
            "p4_x2_Client____AB",
            "p4_x2_Client____LI",
            "p4_x2_Client____RB",
            "p4_x2_Device____AB",
            "p4_x2_Device____LI",
            "p4_x2_Device____RB",
            "p4_x2_Purchase__AB",
            "p4_x2_Purchase__LI",
            "p4_x2_Purchase__RB",
            "p4_x2_Service___AB",
            "p4_x2_Service___LI",
            "p4_x2_Service___RB",
            "p4_x2_Invoice___AB",
            "p4_x2_Invoice___LI",
            "p4_x2_Invoice___RB",
            "p4_x3_Status____LI",
            "p4_x3_Descript__TB",
            "p4_x3_Issue_____TC",
            "p4_x3_Client____SP",
            "p4_x3_Client____SF",
            "p4_x3_Client____SR",
            "p4_x3_Device____SP",
            "p4_x3_Device____SF",
            "p4_x3_Device____SR",
            "p4_x3_Purchase__SP",
            "p4_x3_Purchase__SF",
            "p4_x3_Purchase__SR",
            "p4_x3_Service___SR",
            "p4_x3_Service___SF",
            "p4_x3_Service___SR",
            "p4_x3_Invoice___SR",
            "p4_x3_Invoice___SF",
            "p4_x3_Invoice___SR",
            "p4_x3_Client____AB",
            "p4_x3_Client____LI",
            "p4_x3_Client____RB",
            "p4_x3_Device____AB",
            "p4_x3_Device____LI",
            "p4_x3_Device____RB",
            "p4_x3_Purchase__AB",
            "p4_x3_Purchase__LI",
            "p4_x3_Purchase__RB",
            "p4_x3_Service___AB",
            "p4_x3_Service___LI",
            "p4_x3_Service___RB",
            "p4_x3_Invoice___AB",
            "p4_x3_Invoice___LI",
            "p4_x3_Invoice___RB",
            "p4_x0_Inventory_SP",
            "p4_x0_Inventory_SF",
            "p4_x0_Inventory_SR",
            "p5_x1_Vendor____TB",
            "p5_x1_Model_____TB",
            "p5_x1_Serial____TB",
            "p5_x1_Title_____TB",
			"p5_x1_Cost______TB",
            "p5_x1_IsDevice__CB",
            "p5_x1_Device____SP",
            "p5_x1_Device____SF",
            "p5_x1_Device____SR",
            "p5_x1_Device____AB",
            "p5_x1_Device____LI",
            "p5_x1_Device____RB",
            "p5_x2_Vendor____TB",
            "p5_x2_Model_____TB",
            "p5_x2_Serial____TB",
            "p5_x2_Title_____TB",
			"p5_x2_Cost______TB",
            "p5_x2_IsDevice__CB",
            "p5_x2_Device____SP",
            "p5_x2_Device____SF",
            "p5_x2_Device____SR",
            "p5_x2_Device____AB",
            "p5_x2_Device____LI",
            "p5_x2_Device____RB",
            "p5_x3_Vendor____TB",
            "p5_x3_Model_____TB",
            "p5_x3_Serial____TB",
            "p5_x3_Title_____TB",
			"p5_x3_Cost______TB",
            "p5_x3_IsDevice__CB",
            "p5_x3_Device____SP",
            "p5_x3_Device____SF",
            "p5_x3_Device____SR",
            "p5_x3_Device____AB",
            "p5_x3_Device____LI",
            "p5_x3_Device____RB",
            "p4_x0_Purchase__SP",
            "p4_x0_Purchase__SF",
            "p4_x0_Purchase__SR",
            "p6_x1_Dist______TB",
            "p6_x1_Display___TB",
            "p6_x1_Vendor____TB",
            "p6_x1_Model_____TB",
            "p6_x1_Spec______TB",
            "p6_x1_Serial____TB",
            "p6_x1_IsDevice__CB",
            "p6_x1_Device____SP",
            "p6_x1_Device____SF",
            "p6_x1_Device____SR",
            "p6_x1_Device____AB",
            "p6_x1_Device____LI",
            "p6_x1_Device____RB",
			"p6_x1_Cost______TB",
            "p6_x2_Dist______TB",
            "p6_x2_Display___TB",
            "p6_x2_Vendor____TB",
            "p6_x2_Model_____TB",
            "p6_x2_Spec______TB",
            "p6_x2_Serial____TB",
            "p6_x2_IsDevice__CB",
            "p6_x2_Device____SP",
            "p6_x2_Device____SF",
            "p6_x2_Device____SR",
            "p6_x2_Device____AB",
            "p6_x2_Device____LI",
            "p6_x2_Device____RB",
			"p6_x2_Cost______TB",
            "p6_x3_Dist______TB",
            "p6_x3_Display___TB",
            "p6_x3_Vendor____TB",
            "p6_x3_Model_____TB",
            "p6_x3_Spec______TB",
            "p6_x3_Serial____TB",
            "p6_x3_IsDevice__CB",
            "p6_x3_Device____SP",
            "p6_x3_Device____SF",
            "p6_x3_Device____SR",
            "p6_x3_Device____AB",
            "p6_x3_Device____LI",
            "p6_x3_Device____RB",
			"p6_x3_Cost______TB",
            "p7_x0_Expense___SP",
            "p7_x0_Expense___SF",
            "p7_x0_Expense___SR",
			"p7_x1_Recipient_TB",
            "p7_x1_Display___TB",
            "p7_x1_IsAccount_LI",
            "p7_x1_Account___SP",
            "p7_x1_Account___SF",
            "p7_x1_Account___SR",
            "p7_x1_Account___AB",
            "p7_x1_Account___LI",
            "p7_x1_Account___RB",
            "p7_x1_Cost______TB",         
			"p7_x2_Recipient_TB",
            "p7_x2_Display___TB",
            "p7_x2_IsAccount_LI",
            "p7_x2_Account___SP",
            "p7_x2_Account___SF",
            "p7_x2_Account___SR",
            "p7_x2_Account___AB",
            "p7_x2_Account___LI",
            "p7_x2_Account___RB",
            "p7_x2_Cost______TB",
			"p7_x3_Recipient_TB",
            "p7_x3_Display___TB",
            "p7_x3_IsAccount_LI",
            "p7_x3_Account___SP",
            "p7_x3_Account___SF",
            "p7_x3_Account___SR",
            "p7_x3_Account___AB",
            "p7_x3_Account___LI",
            "p7_x3_Account___RB",
            "p7_x3_Cost______TB",
            "p8_x0_Account___SP",
            "p8_x0_Account___SF",
            "p8_x0_Account___SR",
            "p8_x1_AcctObj___SP",
            "p8_x1_AcctObj___SF",
            "p8_x1_AcctObj___SR",
            "p8_x1_AcctObj___AB",
            "p8_x1_AcctObj___LI",
            "p8_x1_AcctObj___RB",
            "p8_x2_AcctObj___SP",
            "p8_x2_AcctObj___SF",
            "p8_x2_AcctObj___SR",
            "p8_x2_AcctObj___AB",
            "p8_x2_AcctObj___LI",
            "p8_x2_AcctObj___RB",
            "p8_x3_AcctObj___SP",
            "p8_x3_AcctObj___SF",
            "p8_x3_AcctObj___SR",
            "p8_x3_AcctObj___AB",
            "p8_x3_AcctObj___LI",
            "p8_x3_AcctObj___RB",
            "p9_x0_Invoice___SP",
            "p9_x0_Invoice___SF",
            "p9_x0_Invoice___SR",
            "p9_x1_Mode______LI",
            "p9_x1_Client____SP",
            "p9_x1_Client____SF",
            "p9_x1_Client____SR",
            "p9_x1_Client____AB",
            "p9_x1_Client____LI",
            "p9_x1_Client____RB",
			"p9_x1_Inventory_SP",
            "p9_x1_Inventory_SF",
            "p9_x1_Inventory_SR",
            "p9_x1_Inventory_AB",
            "p9_x1_Inventory_LI",
            "p9_x1_Inventory_RB",
            "p9_x1_Service___SP",
            "p9_x1_Service___SF",
            "p9_x1_Service___SR",
            "p9_x1_Service___AB",
            "p9_x1_Service___LI",
            "p9_x1_Service___RB",
            "p9_x1_Purchase__SP",
            "p9_x1_Purchase__SF",
            "p9_x1_Purchase__SR",
            "p9_x1_Purchase__AB",
            "p9_x1_Purchase__LI",
            "p9_x1_Purchase__RB")

            Return $Names
        }

        SetDefaults()
        {
            ForEach ( $Name in $This.GetSearchNames() )
            {
                $Type   = Switch -Regex ($Name)
                {
                    UID       {       "UID" } Client    {    "Client" } Service   {   "Service" }
                    Device    {    "Device" } Issue     {     "Issue" } Inventory { "Inventory" }
                    Purchase  {  "Purchase" } Expense   {   "Expense" } Account   {   "Account" }
                    Invoice   {   "Invoice" } AcctObj   {   "AcctObj" }
                }

                $This.IO."$Name`SP".ItemsSource   = $This.Temp.$Type
                $This.IO."$Name`SP".SelectedIndex = 2
                $This.IO."$Name`SR".ItemsSource   = New-Object System.Collections.ObjectModel.Collection[Object]
                $This.IO."$Name`SF".Text          = @($Null,$This.Date)[($This.IO."$Name`SP".SelectedItem -eq 'Date')]
                
                $This.IO."$Name`SF".Add_TextChanged(
                {
                    If ( $This.IO."$Name`SF".Text -ne "" )
                    {
                        $This.IO."$Name`SR".ItemsSource = $Null
                
                        $This.DG = $This.DB.$Type | ? $This.IO."$Name`SP".SelectedItem -match $This.IO."$Name`SF".Text
                
                        If ( $This.DG.Count -gt 0 )
                        {
                            $This.IO."$Name`SR".ItemsSource = @( $This.DG )
                        }
                    }
                
                    Else
                    {
                        $This.IO."$Name`SR".ItemsSource = $This.DB.$Type
                    }
                            
                    Start-Sleep -Milliseconds 50
                })
                
                $This.IO."$Name`SP".Add_SelectionChanged(
                {
                    If ( $This.IO."$Name`SP".SelectedItem -eq "Date" )
                    {
                        $This.IO."$Name`SF".Text = $This.Date
                    }

                    Else
                    {
                        $This.IO."$Name`SF".Text = ""
                    }
                })
            }
        }

        [Void] Collapse()
        {   
            $This.IO."p0_x0".Visibility = "Collapsed"
            $This.IO."p0_x1".Visibility = "Collapsed"
            $This.IO."p1_x0".Visibility = "Collapsed"
            $This.IO."p1_x1".Visibility = "Collapsed"
            $This.IO."p1_x2".Visibility = "Collapsed"
            $This.IO."p1_x3".Visibility = "Collapsed"
            $This.IO."p2_x0".Visibility = "Collapsed"
            $This.IO."p2_x1".Visibility = "Collapsed"
            $This.IO."p2_x2".Visibility = "Collapsed"
            $This.IO."p2_x3".Visibility = "Collapsed"
            $This.IO."p3_x0".Visibility = "Collapsed"
            $This.IO."p3_x1".Visibility = "Collapsed"
            $This.IO."p3_x2".Visibility = "Collapsed"
            $This.IO."p3_x3".Visibility = "Collapsed"
            $This.IO."p4_x0".Visibility = "Collapsed"
            $This.IO."p4_x1".Visibility = "Collapsed"
            $This.IO."p4_x2".Visibility = "Collapsed"
            $This.IO."p4_x3".Visibility = "Collapsed"
            $This.IO."p5_x0".Visibility = "Collapsed"
            $This.IO."p5_x1".Visibility = "Collapsed"
            $This.IO."p5_x2".Visibility = "Collapsed"
            $This.IO."p5_x3".Visibility = "Collapsed"
            $This.IO."p6_x0".Visibility = "Collapsed"
            $This.IO."p6_x1".Visibility = "Collapsed"
            $This.IO."p6_x2".Visibility = "Collapsed"
            $This.IO."p6_x3".Visibility = "Collapsed"
            $This.IO."p7_x0".Visibility = "Collapsed"
            $This.IO."p7_x1".Visibility = "Collapsed"
            $This.IO."p7_x2".Visibility = "Collapsed"
            $This.IO."p7_x3".Visibility = "Collapsed"
            $This.IO."p8_x0".Visibility = "Collapsed"
            $This.IO."p8_x1".Visibility = "Collapsed"
            $This.IO."p8_x2".Visibility = "Collapsed"
            $This.IO."p8_x3".Visibility = "Collapsed"
            $This.IO."p9_x0".Visibility = "Collapsed"
            $This.IO."p9_x1".Visibility = "Collapsed"
            $This.IO."p9_x2".Visibility = "Collapsed"
            $This.IO."p9_x3".Visibility = "Collapsed"
        }

        SlotCollapse([UInt32]$Slot)
        {
            $This.IO.p0.Visibility = "Collapsed"
            $This.IO.p1.Visibility = "Collapsed"
            $This.IO.p2.Visibility = "Collapsed"
            $This.IO.p3.Visibility = "Collapsed"
            $This.IO.p4.Visibility = "Collapsed"
            $This.IO.p5.Visibility = "Collapsed"
            $This.IO.p6.Visibility = "Collapsed"
            $This.IO.p7.Visibility = "Collapsed"
            $This.IO.p8.Visibility = "Collapsed"
            $This.IO.p9.Visibility = "Collapsed"

            $This.IO."p$Slot".Visibility = "Visible"
        }

        _ViewUID()
        {
            $This.IO.p0_x1_UID_______TB.Text         = $Null
            $This.IO.p0_x1_Index_____TB.Text         = $Null
            $This.IO.p0_x1_Slot______TB.Text         = $Null
            $This.IO.p0_x1_Type______TB.Text         = $Null
            $This.IO.p0_x1_Date______TB.Text         = $Null
            $This.IO.p0_x1_Time______TB.Text         = $Null

            $This.Relinquish($This.IO.p0_x1_Record____LI)
        }

        ViewUID([String]$UID)
        {
            $This._ViewUID()

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid UID"
            }

            $This.IO.p0_x1_UID_______TB.Text         = $Item.UID
            $This.IO.p0_x1_Index_____TB.Text         = $Item.Index
            $This.IO.p0_x1_Slot______TB.Text         = $Item.Slot
            $This.IO.p0_x1_Type______TB.Text         = $Item.Type
            $This.IO.p0_x1_Date______TB.Text         = $Item.Date
            $This.IO.p0_x1_Time______TB.Text         = $Item.Time
 
            $Collect = @( )

            ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name )
            {
                
                $Collect += [_DGList]::New($Object,$Item.Record.$Object)
            }

            $This.IO.p0_x1_Record____LI.ItemsSource  = $Collect
        }

        _ViewClient()
        {
            $This.IO.p1_x1_Last______TB.Text         = $Null
            $This.IO.p1_x1_First_____TB.Text         = $Null
            $This.IO.p1_x1_MI________TB.Text         = $Null
            $This.IO.p1_x1_Gender____LI.SelectedItem = 2
            $This.IO.p1_x1_Address___TB.Text         = $Null
            $This.IO.p1_x1_Month_____TB.Text         = $Null
            $This.IO.p1_x1_Day_______TB.Text         = $Null
            $This.IO.p1_x1_Year______TB.Text         = $Null
            $This.IO.p1_x1_City______TB.Text         = $Null
            $This.IO.p1_x1_Region____TB.Text         = $Null
            $This.IO.p1_x1_Country___TB.Text         = $Null
            $This.IO.p1_x1_Postal____TB.Text         = $Null

            $This.Relinquish($This.IO.p1_x1_Phone_____LI)
            $This.Relinquish($This.IO.p1_x1_Email_____LI)
            $This.Relinquish($This.IO.p1_x1_Device____LI)
            $This.Relinquish($This.IO.p1_x1_Invoice___LI)
        }

        ViewClient([Object]$UID)
        {
            $This._ViewClient()

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Client UID"
            }

            $This.IO.p1_x1_Last______TB.Text         = $Item.Record.Last
            $This.IO.p1_x1_First_____TB.Text         = $Item.Record.First
            $This.IO.p1_x1_MI________TB.Text         = $Item.Record.MI
            $This.IO.p1_x1_Gender____LI.SelectedItem = @{ Male = 0; Female = 1; "-" = 2 }[$Item.Record.Gender]
            $This.IO.p1_x1_Address___TB.Text         = $Item.Record.Address
            $This.IO.p1_x1_Month_____TB.Text         = $Item.Record.Month
            $This.IO.p1_x1_Day_______TB.Text         = $Item.Record.Day
            $This.IO.p1_x1_Year______TB.Text         = $Item.Record.Year
            $This.IO.p1_x1_City______TB.Text         = $Item.Record.City
            $This.IO.p1_x1_Region____TB.Text         = $Item.Record.Region
            $This.IO.p1_x1_Country___TB.Text         = $Item.Record.Country
            $This.IO.p1_x1_Postal____TB.Text         = $Item.Record.Postal

            $This.Populate( $Item.Record.Phone       , $This.IO.p1_x1_Phone_____LI )
            $This.Populate( $Item.Record.Email       , $This.IO.p1_x1_Email_____LI )
            $This.Populate( $Item.Record.Device      , $This.IO.p1_x1_Device____LI )
            $This.Populate( $Item.Record.Invoice     , $This.IO.p1_x1_Invoice___LI )
        }

        _EditClient()
        {
            $This.IO.p1_x2_Last______TB.Text         = $Null
            $This.IO.p1_x2_First_____TB.Text         = $Null
            $This.IO.p1_x2_MI________TB.Text         = $Null
            $This.IO.p1_x2_Gender____LI.SelectedItem = 2
            $This.IO.p1_x2_Address___TB.Text         = $Null
            $This.IO.p1_x2_Month_____TB.Text         = $Null
            $This.IO.p1_x2_Day_______TB.Text         = $Null
            $This.IO.p1_x2_Year______TB.Text         = $Null
            $This.IO.p1_x2_City______TB.Text         = $Null
            $This.IO.p1_x2_Region____TB.Text         = $Null
            $This.IO.p1_x2_Country___TB.Text         = $Null
            $This.IO.p1_x2_Postal____TB.Text         = $Null

            $This.Relinquish( $This.IO.p1_x2_Phone_____LI )
            $This.Relinquish( $This.IO.p1_x2_Email_____LI )
            $This.Relinquish( $This.IO.p1_x2_Device____LI )
            $This.Relinquish( $This.IO.p1_x2_Invoice___LI )
        }

        EditClient([Object]$UID)
        {
            $This._EditClient()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Client UID"
            }

            $This.IO.p1_x2_Last______TB.Text         = $Item.Record.Last
            $This.IO.p1_x2_First_____TB.Text         = $Item.Record.First
            $This.IO.p1_x2_MI________TB.Text         = $Item.Record.MI
            $This.IO.p1_x2_Gender____LI.SelectedIndex = @{ Male = 0; Female = 1; "-" = 2 }[$Item.Record.Gender]
            $This.IO.p1_x2_Address___TB.Text         = $Item.Record.Address
            $This.IO.p1_x2_Month_____TB.Text         = $Item.Record.Month
            $This.IO.p1_x2_Day_______TB.Text         = $Item.Record.Day
            $This.IO.p1_x2_Year______TB.Text         = $Item.Record.Year
            $This.IO.p1_x2_City______TB.Text         = $Item.Record.City
            $This.IO.p1_x2_Region____TB.Text         = $Item.Record.Region
            $This.IO.p1_x2_Country___TB.Text         = $Item.Record.Country
            $This.IO.p1_x2_Postal____TB.Text         = $Item.Record.Postal

            $This.Populate( $Item.Record.Phone       , $This.IO.p1_x2_Phone_____LI)
            $This.Populate( $Item.Record.Email       , $This.IO.p1_x2_Email_____LI)
            $This.Populate( $Item.Record.Device      , $This.IO.p1_x2_Device____LI)
            $This.Populate( $Item.Record.Invoice     , $This.IO.p1_x2_Invoice___LI)
        }

        _NewClient()
        {
            $This.IO.p1_x3_Last______TB.Text         = $Null
            $This.IO.p1_x3_First_____TB.Text         = $Null
            $This.IO.p1_x3_MI________TB.Text         = $Null
            $This.IO.p1_x3_Gender____LI.SelectedItem = 2
            $This.IO.p1_x3_Address___TB.Text         = $Null
            $This.IO.p1_x3_Month_____TB.Text         = $Null
            $This.IO.p1_x3_Day_______TB.Text         = $Null
            $This.IO.p1_x3_Year______TB.Text         = $Null
            $This.IO.p1_x3_City______TB.Text         = $Null
            $This.IO.p1_x3_Region____TB.Text         = $Null
            $This.IO.p1_x3_Country___TB.Text         = $Null
            $This.IO.p1_x3_Postal____TB.Text         = $Null

            $This.Relinquish( $This.IO.p1_x3_Phone_____LI )
            $This.Relinquish( $This.IO.p1_x3_Email_____LI )
            $This.Relinquish( $This.IO.p1_x3_Device____LI )
            $This.Relinquish( $This.IO.p1_x3_Invoice___LI )
        }

        NewClient()
        {
            $This._NewClient()
            $This.IO.p1_x3.Visibility                = "Visible"
        }

        _ViewService()
        {
            $This.IO.p2_x1_Name______TB.Text         = $Null
            $This.IO.p2_x1_Descript__TB.Text         = $Null
            $This.IO.p2_x1_Cost______TB.Text         = $Null
        }

        ViewService([Object]$UID)
        {
            $This._ViewService()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO.p2_x1_Name______TB.Text         = $Item.Record.Name
            $This.IO.p2_x1_Descript__TB.Text         = $Item.Record.Description
            $This.IO.p2_x1_Cost______TB.Text         = $Item.Record.Cost
        }

        _EditService()
        {
            $This.Collapse()

            $This.IO.p2_x2_Name______TB.Text         = $Null
            $This.IO.p2_x2_Descript__TB.Text         = $Null
            $This.IO.p2_x2_Cost______TB.Text         = $Null
        }

        EditService([Object]$UID)
        {
            $This._EditService()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO.p2_x2_Name______TB.Text         = $Item.Record.Name
            $This.IO.p2_x2_Descript__TB.Text         = $Item.Record.Description
            $This.IO.p2_x2_Cost______TB.Text         = $Item.Record.Cost
        }

        _NewService()
        {
            $This.IO.p2_x3_Name______TB.Text         = $Null
            $This.IO.p2_x3_Descript__TB.Text         = $Null
            $This.IO.p2_x3_Cost______TB.Text         = $Null
        }

        NewService()
        {
            $This._NewService()

            $This.IO.p2_x3.Visibility                = "Visible"
        }

        _ViewDevice()
        {
            $This.IO.p3_x1_Chassis___LI.SelectedIndex = 8
            $This.IO.p3_x1_Vendor____TB.Text         = $Null
            $This.IO.p3_x1_Model_____TB.Text         = $Null
            $This.IO.p3_x1_Spec______TB.Text         = $Null
            $This.IO.p3_x1_Serial____TB.Text         = $Null
            $This.IO.p3_x1_Title_____TB.Text         = $Null

            $This.Relinquish($This.IO.p3_x1_Client____LI)
            $This.Relinquish($This.IO.p3_x1_Issue_____LI)
            $This.Relinquish($This.IO.p3_x1_Purchase__LI)
            $This.Relinquish($This.IO.p3_x1_Invoice___LI)
        }

        ViewDevice([Object]$UID)
        {
            $This._ViewDevice()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Device UID"
            }

            $This.IO.p3_x1_Chassis___LI.SelectedIndex = Switch($Item.Record.Chassis)
            {
                Desktop    {0} Laptop     {1} Smartphone {2} Tablet     {3} Console    {4} 
                Server     {5} Network    {6} Other      {7} "-"        {8}
            }

            $This.IO.p3_x1_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p3_x1_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p3_x1_Spec______TB.Text         = $Item.Record.Specification
            $This.IO.p3_x1_Serial____TB.Text         = $Item.Record.Serial
            $This.IO.p3_x1_Title_____TB.Text         = $Item.Record.Title

            $This.Populate( $Item.Record.Client      , $This.IO.p3_x1_Client____LI )
            $This.Populate( $Item.Record.Issue       , $This.IO.p3_x1_Issue_____LI )
            $This.Populate( $Item.Record.Purchase    , $This.IO.p3_x1_Purchase__LI )
            $This.Populate( $Item.Record.Invoice     , $This.IO.p3_x1_Invoice___LI )
        }

        _EditDevice()
        {
            $This.IO.p3_x2_Chassis___LI.SelectedItem = 8
            $This.IO.p3_x2_Vendor____TB.Text         = $Null
            $This.IO.p3_x2_Model_____TB.Text         = $Null
            $This.IO.p3_x2_Spec______TB.Text         = $Null
            $This.IO.p3_x2_Serial____TB.Text         = $Null
            $This.IO.p3_x2_Title_____TB.Text         = $Null

            $This.Relinquish($This.IO.p3_x2_Client____LI)
            $This.Relinquish($This.IO.p3_x2_Issue_____LI)
            $This.Relinquish($This.IO.p3_x2_Purchase__LI)
            $This.Relinquish($This.IO.p3_x2_Invoice___LI)
        }

        EditDevice([Object]$UID)
        {
            $This._EditDevice()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Device UID"
            }

            $This.IO.p3_x2_Chassis___LI.SelectedIndex = Switch($Item.Record.Chassis)
            {
                Desktop    {0} Laptop     {1} Smartphone {2} Tablet     {3} Console    {4} 
                Server     {5} Network    {6} Other      {7} -          {8}
            }

            $This.IO.p3_x2_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p3_x2_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p3_x2_Spec______TB.Text         = $Item.Record.Specification
            $This.IO.p3_x2_Serial____TB.Text         = $Item.Record.Serial
            $This.IO.p3_x2_Title_____TB.Text         = $Item.Record.Title

            $This.Populate( $Item.Record.Client      , $This.IO.p3_x2_Client____LI )
            $This.Populate( $Item.Record.Issue       , $This.IO.p3_x2_Issue_____LI )
            $This.Populate( $Item.Record.Purchase    , $This.IO.p3_x2_Purchase__LI )
            $This.Populate( $Item.Record.Invoice     , $This.IO.p3_x2_Invoice___LI )
        }
    
        _NewDevice()
        {
            $This.Collapse()

            $This.IO.p3_x3_Chassis___LI.SelectedItem = 8
            $This.IO.p3_x3_Vendor____TB.Text         = $Null
            $This.IO.p3_x3_Model_____TB.Text         = $Null
            $This.IO.p3_x3_Spec______TB.Text         = $Null
            $This.IO.p3_x3_Serial____TB.Text         = $Null
            $This.IO.p3_x3_Title_____TB.Text         = $Null

            $This.Relinquish($This.IO.p3_x3_Client____LI)
            $This.Relinquish($This.IO.p3_x3_Issue_____LI)
            $This.Relinquish($This.IO.p3_x3_Purchase__LI)
            $This.Relinquish($This.IO.p3_x3_Invoice___LI)
        }

        NewDevice()
        {
            $This._NewDevice()

            $This.IO.p3_x3.Visibility                = "Visible"
        }

        _ViewIssue()
        {
            $This.IO.p4_x1_Status____LI.SelectedIndex = $Null
            $This.IO.p4_x1_Descript__TB.Text          = $Null

            $This.Relinquish($This.IO.p4_x1_Client____LI)
            $This.Relinquish($This.IO.p4_x1_Device____LI)
            $This.Relinquish($This.IO.p4_x1_Purchase__LI)
            $This.Relinquish($This.IO.p4_x1_Service___LI)
            $This.Relinquish($This.IO.p4_x1_Invoice___LI)
        }

        ViewIssue([Object]$UID)
        {
            $This._ViewIssue()

            $Item                                         = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Issue UID"
            }

            If ( $Item.Record.Status -notin 0..3 )
            {
                $Item.Record.Status = 0
            }

            $This.IO.p4_x1_Status____LI.SelectedIndex     = Switch($Item.Record.Status)
            {
                0 { "New" } 1 { "Diagnosed" } 2 { "Commit" } 3 { "Complete" }
            }

            $This.IO.p4_x1_Descript__TB.SelectedIndex     = $Item.Record.Description

            $This.Populate( $Item.Record.Client           , $This.IO.p4_x1_Client____LI )
            $This.Populate( $Item.Record.Device           , $This.IO.p4_x1_Device____LI )
            $This.Populate( $Item.Record.Purchase         , $This.IO.p4_x1_Purchase__LI )
            $This.Populate( $Item.Record.Service          , $This.IO.p4_x1_Service___LI )
            $This.Populate( $Item.Record.Invoice          , $This.IO.p4_x1_Invoice___LI )
        }

        _EditIssue()
        {
            $This.IO.p4_x2_Status____LI.SelectedIndex = $Null
            $This.IO.p4_x2_Descript__TB.Text         = $Null

            $This.Relinquish($This.IO.p4_x2_Client____LI)
            $This.Relinquish($This.IO.p4_x2_Device____LI)
            $This.Relinquish($This.IO.p4_x2_Purchase__LI)
            $This.Relinquish($This.IO.p4_x2_Service___LI)
            $This.Relinquish($This.IO.p4_x2_Invoice___LI)
        }

        EditIssue([Object]$UID)
        {
            $This._EditIssue()

            $Item                                         = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Issue UID"
            }

            $This.IO.p4_x2_Status____LI.SelectedIndex     = $Item.Record.Status
            $This.IO.p4_x2_Descript__TB.SelectedIndex     = $Item.Record.Description

            $This.Populate( $Item.Record.Client           , $This.IO.p4_x2_Client____LI )
            $This.Populate( $Item.Record.Device           , $This.IO.p4_x2_Device____LI )
            $This.Populate( $Item.Record.Purchase         , $This.IO.p4_x2_Purchase__LI )
            $This.Populate( $Item.Record.Service          , $This.IO.p4_x2_Service___LI )
            $This.Populate( $Item.Record.Invoice          , $This.IO.p4_x2_Invoice___LI )
        }

        _NewIssue()
        {
            $This.IO.p4_x3_Status____LI.SelectedItem = -1
            $This.IO.p4_x3_Descript__TB.Text         = $Null

            $This.Relinquish($This.IO.p4_x3_Client____LI)
            $This.Relinquish($This.IO.p4_x3_Device____LI)
            $This.Relinquish($This.IO.p4_x3_Purchase__LI)
            $This.Relinquish($This.IO.p4_x3_Service___LI)
            $This.Relinquish($This.IO.p4_x3_Invoice___LI)
        }

        NewIssue()
        {
            $This._NewDevice()

            $This.IO.p4_x3.Visibility                = "Visible"
        }

        _ViewInventory()
        {
            $This.IO.p5_x1_Vendor____TB.Text         = $Null
            $This.IO.p5_x1_Model_____TB.Text         = $Null
            $This.IO.p5_x1_Serial____TB.Text         = $Null
            $This.IO.p5_x1_Title_____TB.Text         = $Null
            $This.IO.p5_x1_Cost______TB.Text         = $Null
            $This.IO.p5_x2_IsDevice__LI.SelectedIndex = 0

            $This.Relinquish($This.IO.p5_x1_Device____LI)
        }

        ViewInventory([Object]$UID)
        {
            $This._ViewInventory()

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO.p5_x1_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p5_x1_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p5_x1_Serial____TB.Text         = $Item.Record.Serial
            $This.IO.p5_x1_Title_____TB.Text         = $Item.Record.Title
            $This.IO.p5_x1_Cost______TB.Text         = $Item.Record.Cost
            $This.IO.p5_x1_IsDevice__LI.SelectedIndex = @(0,1)[$Item.Record.IsDevice]

            $This.Populate( $Item.Record.Device      , $This.IO.p5_x1_Device____LI )
        }

        _EditInventory()
        {
            $This.IO.p5_x2_Vendor____TB.Text         = $Null
            $This.IO.p5_x2_Model_____TB.Text         = $Null
            $This.IO.p5_x2_Serial____TB.Text         = $Null
            $This.IO.p5_x2_Title_____TB.Text         = $Null
            $This.IO.p5_x2_Cost______TB.Text         = $Null
            $This.IO.p5_x2_IsDevice__LI.SelectedIndex = 0

            $This.Relinquish($This.IO.p5_x2_Device____LI)
        }

        EditInventory([Object]$UID)
        {
            $This._EditInventory()

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO.p5_x2_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p5_x2_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p5_x2_Serial____TB.Text         = $Item.Record.Serial
            $This.IO.p5_x2_Title_____TB.Text         = $Item.Record.Title
            $This.IO.p5_x2_Cost______TB.Text         = $Item.Record.Cost
            $This.IO.p5_x2_IsDevice__LI.SelectedIndex = @(0,1)[$Item.Record.IsDevice]

            $This.Populate( $Item.Record.Device      , $This.IO.p5_x2_Device____LI )
        }
        
        _NewInventory()
        {
            $This.IO.p5_x3_Vendor____TB.Text         = $Null
            $This.IO.p5_x3_Model_____TB.Text         = $Null
            $This.IO.p5_x3_Serial____TB.Text         = $Null
            $This.IO.p5_x3_Title_____TB.Text         = $Null
            $This.IO.p5_x3_Cost______TB.Text         = $Null
            $This.IO.p5_x3_IsDevice__LI.SelectedIndex = 0

            $This.Relinquish($This.IO.p5_x3_Device____LI)
        }

        NewInventory()
        {
            $This._NewInventory()

            $This.IO.p5_x3.Visibility                = "Visible"
        }

        _ViewPurchase()
        {
            $This.IO.p6_x1_Dist______TB.Text         = $Null
            $This.IO.p6_x1_Display___TB.Text         = $Null
            $This.IO.p6_x1_Vendor____TB.Text         = $Null
            $This.IO.p6_x1_Model_____TB.Text         = $Null
            $This.IO.p6_x1_Spec______TB.Text         = $Null
            $This.IO.p6_x1_Serial____TB.Text         = $Null

            $This.IO.p6_x1_IsDevice__LI.SelectedItem = 0
            $This.Relinquish($This.IO.p6_x1_Device____LI)

            $This.IO.p6_x1_Cost______TB.Text         = $Null
        }

        ViewPurchase([Object]$UID)
        {
            $This._ViewPurchase()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Purchase UID"
            }

            $This.IO.p6_x1_Dist______TB.Text         = $Item.Record.Distributor
            $This.IO.p6_x1_Display___TB.Text         = $Item.Record.DisplayName
            $This.IO.p6_x1_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p6_x1_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p6_x1_Spec______TB.Text         = $Item.Record.Specification
            $This.IO.p6_x1_Serial____TB.Text         = $Item.Record.Serial

            $This.IO.p6_x1_IsDevice__LI.SelectedIndex = @(0,1)[$Item.Record.IsDevice]
            $This.Populate( $Item.Record.Device      , $This.IO.p6_x1_Device____LI )

            $This.IO.p6_x1_Cost______TB.Text         = $Item.Record.Cost
        }

        _EditPurchase()
        {
            $This.IO.p6_x2_Display___TB.Text         = $Null
            $This.IO.p6_x2_Dist______TB.Text         = $Null
            $This.IO.p6_x2_Model_____TB.Text         = $Null
            $This.IO.p6_x2_Serial____TB.Text         = $Null
            $This.IO.p6_x2_Spec______TB.Text         = $Null
            $This.IO.p6_x2_Vendor____TB.Text         = $Null

            $This.IO.p6_x2_IsDevice__LI.ItemsSource  = $Null
            $This.Relinquish($This.IO.p6_x2_Device____LI)

            $This.IO.p6_x2_Cost______TB.Text         = $Null
        }

        EditPurchase([Object]$UID)
        {
            $This._EditPurchase()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Purchase UID"
            }

            $This.IO.p6_x2_Dist______TB.Text         = $Item.Record.Distributor
            $This.IO.p6_x2_Display___TB.Text         = $Item.Record.DisplayName
            $This.IO.p6_x2_Vendor____TB.Text         = $Item.Record.Vendor
            $This.IO.p6_x2_Model_____TB.Text         = $Item.Record.Model
            $This.IO.p6_x2_Spec______TB.Text         = $Item.Record.Specification
            $This.IO.p6_x2_Serial____TB.Text         = $Item.Record.Serial

            $This.IO.p6_x2_IsDevice__LI.SelectedIndex = @(0,1)[$Item.Record.IsDevice]

            $This.Populate( $Item.Record.Device      , $This.IO.p6_x2_Device____LI )

            $This.IO.p6_x2_Cost______TB.Text         = $Item.Record.Cost
        }

        _NewPurchase()
        {
            $This.IO.p6_x3_Display___TB.Text         = $Null
            $This.IO.p6_x3_Dist______TB.Text         = $Null
            $This.IO.p6_x3_Model_____TB.Text         = $Null
            $This.IO.p6_x3_Serial____TB.Text         = $Null
            $This.IO.p6_x3_Spec______TB.Text         = $Null
            $This.IO.p6_x3_Vendor____TB.Text         = $Null

            $This.IO.p6_x3_IsDevice__LI.ItemsSource  = $Null
            $This.Relinquish($This.IO.p6_x3_Device____LI)

            $This.IO.p6_x3_Cost______TB.Text         = $Null
        }

        NewPurchase()
        {
            $This._NewPurchase()

            $This.IO.p6_x3.Visibility                = "Visible"
        }

        _ViewExpense()
        {
            $This.IO.p7_x1_Display___TB.Text         = $Null
            $This.IO.p7_x1_Recipient_TB.Text         = $Null

            $This.IO.p7_x1_IsAccount_LI.SelectedIndex = 0
            $This.Relinquish($This.IO.p7_x1_Account___LI)

            $This.IO.p7_x1_Cost______TB.Text         = $Null
        }

        ViewExpense([Object]$UID)
        {
            $This._ViewExpense()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Expense UID"
            }

            $This.IO.p7_x1_Display___TB.Text         = $Item.Record.Recipient
            $This.IO.p7_x1_Recipient_TB.Text         = $Item.Record.DisplayName
            $This.IO.p7_x1_IsAccount_LI.SelectedIndex = @(0,1)[$Item.Record.IsAccount]

            $This.Populate( $Item.Record.Account     , $This.IO._ViewExpenseAccountList  )

            $This.IO._ViewExpenseCost.Text           = $Item.Record.Cost
        }

        _EditExpense()
        {
            $This.IO.p7_x2_Display___TB.Text         = $Null
            $This.IO.p7_x2_Recipient_TB.Text         = $Null

            $This.IO.p7_x2_IsAccount_LI.SelectedIndex = 0
            $This.Relinquish($This.IO.p7_x2_Account___LI)

            $This.IO.p7_x2_Cost______TB.Text         = $Null
        }

        EditExpense([Object]$UID)
        {
            $This._EditExpense()

            $Item                                    = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Expense UID"
            }

            $This.IO.p7_x2_Display___TB.Text         = $Item.Record.Recipient
            $This.IO.p7_x2_Recipient_TB.Text         = $Item.Record.DisplayName

            $This.IO.p7_x2_IsAccount_LI.IsChecked    = $False
            $This.Populate( $Item.Record.Account     , $This.IO.p7_x2_Account___LI)

            $This.IO.p7_x2_Cost______TB.Text           = $Item.Record.Cost
        }
        
        _NewExpense()
        {
            $This.IO.p7_x3_Display___TB.Text         = $Null
            $This.IO.p7_x3_Recipient_TB.Text         = $Null

            $This.IO.p7_x3_IsAccount_LI.SelectedIndex = 0
            $This.Relinquish($This.IO.p7_x3_Account___LI)

            $This.IO.p7_x3_Cost______TB.Text         = $Null
        }

        NewExpense()
        {
            $This._NewExpense()

            $This.IO.p7_x3.Visibility                = "Visible"
        }

        _ViewAccount()
        {
            $This.Relinquish($This.IO.p8_x1_AcctObj___LI)
        }

        ViewAccount([Object]$UID)
        {
            $This._ViewAccount()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Account UID"
            }

            $This.Populate( $Item.Record.Object        , $This.IO.p8_x1_AcctObj___LI )
        }

        _EditAccount()
        {

            $This.Relinquish($This.IO.p8_x2_AcctObj___LI)
        }

        EditAccount([Object]$UID)
        {
            $This._EditAccount()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Account UID"
            }

            $This.Populate( $Item.Record.Object        , $This.IO.p8_x2_AcctObj___LI    )
        }
        
        _NewAccount()
        {
            $This.Relinquish($This.IO.p8_x3_AcctObj___LI)
        }

        NewAccount()
        {
            $This._NewAccount()

            $This.IO.p8_x3.Visibility                = "Visible"
        }

        _ViewInvoice()
        {
            $This.Collapse()

            $This.IO.p9_x1_Mode______LI.SelectedIndex = 0

            $This.Relinquish($This.IO.p9_x1_Client_____LI)
            $This.Relinquish($This.IO.p9_x1_Inventory__LI)
            $This.Relinquish($This.IO.p9_x1_Service____LI)
            $This.Relinquish($This.IO.p9_x1_Purchase___LI)
        }

        ViewInvoice([Object]$UID)
        {
            $This._ViewInvoice()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO.p9_x1_Mode______LI.SelectedIndex  = $Item.Record.Mode

            $This.Populate( $Item.Record.Client        , $This.IO.p9_x1_Client_____LI )
            $This.Populate( $Item.Record.Inventory     , $This.IO.p9_x1_Inventory__LI )
            $This.Populate( $Item.Record.Service       , $This.IO.p9_x1_Service____LI )
            $This.Populate( $Item.Record.Purchase      , $This.IO.p9_x1_Purchase___LI )
        }

        _EditInvoice()
        {
            $This.IO.p9_x2_Mode______LI.SelectedIndex = 0

            $This.Relinquish($This.IO.p9_x2_Client_____LI)
            $This.Relinquish($This.IO.p9_x2_Inventory__LI)
            $This.Relinquish($This.IO.p9_x2_Service____LI)
            $This.Relinquish($This.IO.p9_x2_Purchase___LI)
        }

        EditInvoice([Object]$UID)
        {
            $This._EditInvoice()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._EditInvoiceMode.SelectedIndex    = $Item.Record.Mode

            $This.Populate( $Item.Record.Client        , $This.IO.p9_x2_Client_____LI )
            $This.Populate( $Item.Record.Inventory     , $This.IO.p9_x2_Inventory__LI )
            $This.Populate( $Item.Record.Service       , $This.IO.p9_x2_Service____LI )
            $This.Populate( $Item.Record.Purchase      , $This.IO.p9_x2_Purchase___LI )
        }

        _NewInvoice()
        {
            $This.IO.p9_x2_Mode______LI.SelectedIndex  = 0

            $This.Relinquish($This.IO.p9_x3_Client_____LI)
            $This.Relinquish($This.IO.p9_x3_Inventory__LI)
            $This.Relinquish($This.IO.p9_x3_Service____LI)
            $This.Relinquish($This.IO.p9_x3_Purchase___LI)
        }

        NewInvoice()
        {
            $This._NewInvoice()

            $This.IO.p9_x3.Visibility                = "Visible"
        }

        Stage()
        {
            $This._ViewUID()
            $This._ViewClient()
            $This._EditClient()
            $This._NewClient()
            $This._ViewService()
            $This._EditService()
            $This._NewService()
            $This._ViewDevice()
            $This._EditDevice()
            $This._NewDevice()
            $This._ViewIssue()
            $This._EditIssue()
            $This._NewIssue()
            $This._ViewInventory()
            $This._EditInventory()
            $This._NewInventory()
            $This._ViewPurchase()
            $This._EditPurchase()
            $This._NewPurchase()
            $This._ViewExpense()
            $This._EditExpense()
            $This._NewExpense()
            $This._ViewAccount()
            $This._EditAccount()
            $This._NewAccount()
            $This._ViewInvoice()
            $This._EditInvoice()
            $This._NewInvoice()
        }

        Refresh()
        {
            $This.DB.Client                         = $This.DB.UID | ? Type -eq Client
            $This.DB.Service                        = $This.DB.UID | ? Type -eq Service
            $This.DB.Device                         = $This.DB.UID | ? Type -eq Device
            $This.DB.Issue                          = $This.DB.UID | ? Type -eq Issue
            $This.DB.Inventory                      = $This.DB.UID | ? Type -eq Inventory
            $This.DB.Purchase                       = $This.DB.UID | ? Type -eq Purchase
            $This.DB.Expense                        = $This.DB.UID | ? Type -eq Expense
            $This.DB.Account                        = $This.DB.UID | ? Type -eq Account
            $This.DB.Invoice                        = $This.DB.UID | ? Type -eq Invoice

            $This.IO.p0_x0_UID_______SR.ItemsSource = $This.DB.UID
            $This.IO.p1_x0_Client____SR.ItemsSource = $This.DB.Client
            $This.IO.p2_x0_Service___SR.ItemsSource = $This.DB.Service
            $This.IO.p3_x0_Device____SR.ItemsSource = $This.DB.Device
            $This.IO.p4_x0_Issue_____SR.ItemsSource = $This.DB.Issue
            $This.IO.p5_x0_Inventory_SR.ItemsSource = $This.DB.Inventory
            $This.IO.p6_x0_Purchase__SR.ItemsSource = $This.DB.Purchase
            $This.IO.p7_x0_Expense___SR.ItemsSource = $This.DB.Expense
            $This.IO.p8_x0_Account___SR.ItemsSource = $This.DB.Account
            $This.IO.p9_x0_Invoice___SR.ItemsSource = $This.DB.Invoice
        }

        _cimdb([String]$Xaml)
        {
            $This.Window                                    = [_Xaml]::New($Xaml)
            $This.IO                                        = $This.Window.IO
            $This.Temp                                      = [_Template]::New()
            $This.DB                                        = [_DB]::New()

            $This.SetDefaults()
            $This.Collapse()
            $This.SlotCollapse(0)
            $This.Stage()
            $This.Refresh()

            $This.IO.New.Visibility                         = "Hidden"
            $This.IO.Edit.Visibility                        = "Hidden"
            $This.IO.Save.Visibility                        = "Hidden"

            # UID
            # Client
            # Service
            # Device
            # Issue
            # Inventory
            # Purchase
            # Expense
            # Account
            # Invoice
        }

        GetTab([UInt32]$Slot)
        {
            $This.Slot = $Slot

            $This.Collapse()
            $This.SlotCollapse($Slot)
            $This.Stage()
           
            If ( $Slot -eq 0 )
            {
                $This.IO.New.Visibility                = "Hidden"
                $This.IO.New.IsEnabled                 = 0
            }

            If ( $Slot -ne 0 )
            {
                $This.IO.New.Visibility                = "Visible"
                $This.IO.New.IsEnabled                 = 1
            }

            $This.IO.Edit.Visibility                   = "Hidden"
            $This.IO.Edit.IsEnabled                    = 0

            $This.IO.Save.Visibility                   = "Hidden"
            $This.IO.Save.IsEnabled                    = 0
            
            ForEach ( $X in 0..9 )
            {
                $Tab__                                 = "t$X"
                $Panel                                 = "p$X"

                If ( $X -ne $This.Slot )
                {
                    $This.IO.$Tab__.Background         = "#DFFFBA"
                    $This.IO.$Tab__.Foreground         = "#000000"
                    $This.IO.$Tab__.BorderBrush        = "#000000"
                    $This.IO.$Panel.Visibility         = "Collapsed"
                }

                If ( $X -eq $This.Slot )
                {
                    $This.IO.$Tab__.Background         = "#4444FF"
                    $This.IO.$Tab__.Foreground         = "#FFFFFF"
                    $This.IO.$Tab__.BorderBrush        = "#111111"

                    $This.IO.$Panel.Visibility         = "Visible"
                    $This.IO."$($Panel)_x0".Visibility = "Visible"
                    $This.IO."$($Panel)_x1".Visibility = "Collapsed"

                    If ( $Slot -ne 0 )
                    {
                        $This.IO."$($Panel)_x2".Visibility = "Collapsed"
                        $This.IO."$($Panel)_x3".Visibility = "Collapsed"
                    }
                }
            }

            Write-Host $This.Tab[$Slot]

            $This.Refresh()
        }

        ViewTab([UInt32]$Slot)
        {
            $This.Slot = $Slot
            $This.Collapse()
            $This.SlotCollapse($This.Slot)

            $This.IO."p$Slot".Visibility               = "Visible"
            $This.IO."p$Slot`_x1".Visibility           = "Visible"

            $This.IO.New.IsEnabled                     = 1
            $This.IO.Edit.IsEnabled                    = 1
            $This.IO.Save.IsEnabled                    = 0

            $This.IO.New.Visibility                    = "Visible"
            $This.IO.Edit.Visibility                   = "Visible"
            $This.IO.Save.Visibility                   = "Visible"
        }

        EditTab([UInt32]$Slot)
        {
            $This.Slot = $Slot
            $This.Collapse()
            $This.SlotCollapse($This.Slot)

            $This.IO."p$Slot".Visibility               = "Visible"
            $This.IO."p$Slot`_x2".Visibility           = "Visible"

            $This.IO.New.IsEnabled                     = 1
            $This.IO.Edit.IsEnabled                    = 0
            $This.IO.Save.IsEnabled                    = 1

            $This.IO.New.Visibility                    = "Visible"
            $This.IO.Edit.Visibility                   = "Visible"
            $This.IO.Save.Visibility                   = "Visible"
        }

        NewTab([UInt32]$Slot)
        {
            $This.Slot = $Slot
            $This.Collapse()
            $This.SlotCollapse($This.Slot)

            $This.IO."p$Slot".Visibility               = "Visible"
            $This.IO."p$Slot`_x3".Visibility           = "Visible"

            $This.IO.New.IsEnabled                     = 1
            $This.IO.Edit.IsEnabled                    = 0
            $This.IO.Save.IsEnabled                    = 1

            $This.IO.New.Visibility                    = "Visible"
            $This.IO.Edit.Visibility                   = "Visible"
            $This.IO.Save.Visibility                   = "Visible"
            
            Switch([UInt32]$This.Slot)
            {
                0 
                {
                    $Null               
                }

                1 
                { 
                    $This.NewClient()
                }

                2 
                { 
                    $This.NewService()
                }

                3 
                { 
                    $This.NewDevice()
                }

                4 
                { 
                    $This.NewIssue()
                }

                5 
                { 
                    $This.NewInventory()
                }

                6 
                { 
                    $This.NewPurchase()
                }

                7 
                { 
                    $This.NewExpense()
                }

                8 
                { 
                    $This.NewAccount()
                }

                9 
                { 
                    $This.NewInvoice()
                }
            }
        }
    }
