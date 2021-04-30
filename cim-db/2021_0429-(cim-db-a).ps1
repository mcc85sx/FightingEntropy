Function cim-db
{
    Add-Type -AssemblyName PresentationFramework

    Class _DGList
    {
        [String] $Name
        [Object] $Value

        _DGList([String]$Name,[Object]$Value)
        {
            $This.Name  = $Name
            $This.Value = $Value -join ", "
        }
    }

    Class _UID
    {
        [Object] $UID
        [UInt32] $Index
        [Object] $Slot
        [Object] $Type
        [Object] $Date
        [Object] $Time
        [Object] $Record

        _UID([UInt32]$Slot)
        {
            $This.UID    = New-GUID | % GUID
            $This.Slot   = $Slot
            $This.Date   = Get-Date -UFormat "%m/%d/%Y"
            $This.Time   = Get-Date -UFormat "%H:%M:%S"
        }

        [String] ToString()
        {
            Return $This.Slot
        }
    }

    Class _Client
    {
        [Object]         $UID
        [Object]       $Index
        [Object]        $Slot
        [Object]        $Type
        [Object]        $Date
        [Object]        $Time
        [UInt32]        $Rank
        [Object]        $Name
        [String]       $First
        [String]          $MI
        [String]        $Last
        [Object]     $Address
        [Object]        $City
        [Object]      $Region
        [Object]     $Country
        [Object]      $Postal
        [UInt32]       $Month
        [UInt32]         $Day
        [UInt32]        $Year
        [String]         $DOB
        [String]      $Gender
        [Object]       $Image
        [Object[]]     $Phone
        [Object[]]     $Email
        [Object[]]    $Device
        [Object[]]   $Invoice

        _Client([Object]$UID)
        {
            $This.UID  = $UID.UID
            $This.Slot = 0
            $This.Type = "Client"
            $This.Date = $UID.Date
            $This.Time = $UID.Time

            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Invoice = @( )
        }

        [String] ToString()
        {
            Return "Client"
        }
    }

    Class _Service
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [String]          $Name
        [String]   $Description
        [Object]          $Cost

        _Service([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 1
            $This.Type = "Service"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Service"
        }
    }

    Class _Device
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [String]          $Rank

        [String]       $Chassis
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Object]         $Title
        [Object]        $Client
        [Object]         $Issue
        [Object]      $Purchase
        [Object]       $Invoice

        _Device([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 2
            $This.Type = "Device"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Device"
        }
    }

    Class _Issue
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]        $Client
        [Object]        $Device
        [String[]] $Description
        [Object]        $Status
        [Object]      $Purchase
        [Object]       $Service
        [Object]       $Invoice

        _Issue([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 3
            $This.Type = "Issue"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Issue"
        }
    }

    Class _Inventory
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
            
        [String]        $Vendor
        [String]        $Serial
        [String]         $Model
        [Object]         $Title
        [Bool]        $IsDevice
        [Object[]]      $Device
        [Object]          $Cost

        _Inventory([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 4
            $This.Type = "Inventory"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Inventory"
        }
    }

    Class _Purchase
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]   $Distributor
        [Object]   $DisplayName
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Bool]        $IsDevice
        [Object]        $Device
        [Object]          $Cost
        
        _Purchase([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 5
            $This.Type = "Purchase"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Purchase"
        }
    }

    Class _Expense
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]     $Recipient
        [Object]   $DisplayName
        [Object]       $Account
        [Object]          $Cost

        _Expense([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 6
            $This.Type = "Expense"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Expense"
        }
    }

    Class _Account
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [Object]        $Object

        _Account([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 7
            $This.Type = "Account"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Account"
        }
    }

    Class _Invoice
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank

        [UInt32]          $Mode
        [Object]        $Client
        [Object]     $Inventory
        [Object]       $Service
        [Object]      $Purchase

        _Invoice([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 8
            $This.Type = "Invoice"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Invoice"
        }
    }

    Class _DB
    {
        [Object[]]         $UID
        [Object[]]      $Client
        [Object[]]     $Service
        [Object[]]      $Device
        [Object[]]       $Issue
        [Object[]]   $Inventory
        [Object[]]    $Purchase
        [Object[]]     $Expense
        [Object[]]     $Account
        [Object[]]     $Invoice
        
        _DB()
        {
            $This.UID       = @( )
            $This.Client    = @( )
            $This.Service   = @( )
            $This.Device    = @( )
            $This.Issue     = @( )
            $This.Inventory = @( )
            $This.Purchase  = @( )
            $This.Expense   = @( )
            $This.Account   = @( )
            $This.Invoice   = @( )  
        }

        [UInt32] GetCount([UInt32]$X)
        {
            Return ( $X + 1 )
        }

        [UInt32] GetIndex()
        {
            Return ($This.GetCount($This.UID.Count) - 1)
        }

        [UInt32] GetRank([UInt32]$Slot)
        {
            Return $This.GetCount(
            @(  
                $This.Client.Count    ,
                $This.Service.Count   ,
                $This.Device.Count    ,
                $This.Issue.Count     , 
                $This.Inventory.Count ,
                $This.Purchase.Count  ,
                $This.Expense.Count   ,
                $This.Account.Count   ,
                $This.Invoice.Count   
            
            )[$Slot]) - 1
        }

        [Object] NewUID([Object]$Slot)
        {
            If ($Slot -notin 0..8)
            {
                Throw "Invalid entry"
            }

            $Item                = [_UID]::New($Slot)
            $Item.Type           = @("Client Service Device Issue Inventory Purchase Expense Account Invoice" -Split " ")[$Slot]
            $Item.Index          = $This.GetIndex()
            $Item.Record         = Switch ($Slot)
            {
                0 { [_Client    ]::New($Item) }
                1 { [_Service   ]::New($Item) }
                2 { [_Device    ]::New($Item) }
                3 { [_Issue     ]::New($Item) }
                4 { [_Inventory ]::New($Item) } 
                5 { [_Purchase  ]::New($Item) }
                6 { [_Expense   ]::New($Item) }
                7 { [_Account   ]::New($Item) }
                8 { [_Invoice   ]::New($Item) }
            }

            $Item.Record.Index   = $Item.Index
            $Item.Record.Rank    = $This.GetRank($Slot)

            Switch($Slot)
            {
                0 { $This.Client     += $Item }
                1 { $This.Service    += $Item }
                2 { $This.Device     += $Item }
                3 { $This.Issue      += $Item }
                4 { $This.Inventory  += $Item }
                5 { $This.Purchase   += $Item }
                6 { $This.Expense    += $Item }
                7 { $This.Account    += $Item }
                8 { $This.Invoice    += $Item }
            }

            $This.UID           += $Item

            Return $Item
        }

        [Object] GetUID([Object]$UID)
        {
            Return $This.UID | ? UID -match $UID
        }
    }

    Class _GFX
    {
        [String] $Base = "https://github.com/mcc85sx/FightingEntropy/blob/master/Graphics"
        [String] $Path = "$Env:ProgramData\Secure Digits Plus LLC\Graphics"
        [String] $Logo 
        [String] $Icon
        [String] $Background

        _GFX()
        {
            $Root            = ""

            ForEach ( $Item in $This.Path.Split("\") )
            {
                $Root       += $Item

                If (!(Test-Path $Root))
                {
                    New-Item $Root -ItemType Directory -Verbose
                }

                $Root        = "$Root\"
            }

            $Root            = $Root.TrimEnd("\")

            $This.Logo       = "$Root\sdplogo.png"
            $This.Icon       = "$Root\icon.ico"
            $This.Background = "$Root\background.jpg"

            If (!(Test-Path $This.Logo))
            {
                Invoke-WebRequest -URI "$($This.Base)/sdplogo.png?raw=true"    -OutFile $This.Logo       -Verbose
            }

            If (!(Test-Path $This.Icon))
            {
                Invoke-WebRequest -URI "$($This.Base)/icon.ico?raw=true"       -OutFile $This.Icon       -Verbose
            }

            If (!(Test-Path $This.Background))
            {
                Invoke-WebRequest -URI "$($This.Base)/background.jpg?raw=true" -OutFile $This.Background -Verbose
            }
        }
    }

    Class _Xaml
    {
        Hidden [Object]        $Xaml
        [String[]]            $Names
        Hidden [Object]         $XML
        [Object]               $Node
        [Object]                 $IO

        [String[]] FindNames()
        {
            $ID   = [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % { $_.Split('"')[1] }

            Return ( $ID | Select-Object -Unique )
        }

        _Xaml([String]$Xaml)
        {           
            [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

            $This.Xaml               = $Xaml
            $This.Names              = $This.FindNames()
            $This.XML                = [XML]$This.Xaml
            $This.Node               = [System.Xml.XmlNodeReader]::New($This.XML)
            $This.IO                 = [System.Windows.Markup.XamlReader]::Load($This.Node)

            $This.Names              | % { 

                $This.IO             | Add-Member -MemberType NoteProperty -Name $_ -Value $This.IO.FindName($_) -Force

            }
        }

        Invoke()
        {
            $This.IO.Dispatcher.InvokeAsync{$This.IO.ShowDialog()}.Wait()
        }
    }

    Class _Template
    {
        [String[]] $UID
        [String[]] $Client
        [String[]] $Service
        [String[]] $Device
        [String[]] $Issue
        [String[]] $Inventory
        [String[]] $Purchase
        [String[]] $Expense
        [String[]] $Account
        [String[]] $Invoice

        _Template()
        {
            $This.UID          = @("UID","Index","Date","Rank")
            $This.Client       = @($This.UID; "Name", "DOB", "Phone", "Email")
            $This.Service      = @($This.UID; "Name", "Description")
            $This.Device       = @($This.UID; "Vendor", "Model", "Specification", "Serial", "Title")
            $This.Issue        = @($This.UID; "Status","Description","Client","Device","Purchase","Service","Invoice")
            $This.Inventory    = @($This.UID; "Vendor","Model","Serial","Title","Cost","IsDevice","Device")
            $This.Purchase     = @($This.UID; "Distributor","DisplayName","Vendor","Serial","Model","IsDevice","Device","Cost")
            $This.Expense      = @($This.UID; "Recipient","DisplayName","Account","Cost")
            $This.Account      = @($This.UID; "Object")
            $This.Invoice      = @($This.UID; "Client","Inventory","Service","Purchase")
        }
    }

    Class _Postal
    {
        Hidden [Object] $Line
        [String] $Postal
        [String] $City
        [String] $County

        _Postal([String]$Line)
        {
            $This.Line  = $Line -Split "\t"
            $This.Postal = $This.Line[0]
            $This.City   = $This.Line[1]
            $This.County = $This.Line[2]
        }
    }

    Class cimdb
    {
        [Object]  $Window
        [Object]      $IO
        [Object]    $Temp
        [Object]     $Tab = ("UID Client Service Device Issue Inventory Purchase Expense Account Invoice" -Split " ")
        [String[]] $Names
        [Object]    $Date = (Get-Date -uformat %m/%d/%Y)
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
            }

            $Control.SelectedIndex = -1
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
                    "p7_x1_Device____",
                    "p7_x2_Device____",
                    "p7_x3_Device____",
                "p8_x0_Account___",
                    "p8_x1_Account___",
                    "p8_x2_Account___",
                    "p8_x3_Account___",
                "p9_x0_Invoice___",
                    "p9_x1_Client____","p9_x1_Inventory_","p9_x1_Service___","p9_x1_Purchase__",
                    "p9_x2_Client____","p9_x2_Inventory_","p9_x2_Service___","p9_x2_Purchase__",
                    "p9_x3_Client____","p9_x3_Inventory_","p9_x3_Service___","p9_x3_Purchase__")
        }

        [String[]] GetControlNames()
        {
            Return @(
                "p0_x1_UID_______TB","p0_x1_Index_____TB","p0_x1_Slot______TB",
            "p0_x1_Type______TB","p0_x1_Date______TB",
            "p0_x1_Time______TB",
			"p1_x1_Address___TB",
            "p1_x1_City______TB",
            "p1_x1_Country___TB",
            "p1_x1_Day_______TB",
            "p1_x1_Email_____TB",
            "p1_x1_First_____TB",
            "p1_x1_Last______TB",
            "p1_x1_MI________TB",
            "p1_x1_Month_____TB",
            "p1_x1_Phone_____TB",
            "p1_x1_Postal____TB",
            "p1_x1_Region____TB",
            "p1_x1_Year______TB",
			"p1_x2_Address___TB",
            "p1_x2_City______TB",
            "p1_x2_Country___TB",
            "p1_x2_Day_______TB",
            "p1_x2_Email_____TB",
            "p1_x2_First_____TB",
            "p1_x2_Last______TB",
            "p1_x2_MI________TB",
            "p1_x2_Month_____TB",
            "p1_x2_Phone_____TB",
            "p1_x2_Postal____TB",
            "p1_x2_Region____TB",
            "p1_x2_Year______TB",
			"p1_x3_Address___TB",
            "p1_x3_City______TB",
            "p1_x3_Country___TB",
            "p1_x3_Day_______TB",
            "p1_x3_Email_____TB",
            "p1_x3_First_____TB",
            "p1_x3_Last______TB",
            "p1_x3_MI________TB",
            "p1_x3_Month_____TB",
            "p1_x3_Phone_____TB",
            "p1_x3_Postal____TB",
            "p1_x3_Region____TB",
            "p1_x3_Year______TB",
			"p2_x1_Name______TB",
            "p2_x1_Descript__TB",
            "p2_x1_Cost______TB",
			"p2_x2_Name______TB",
            "p2_x2_Descript__TB",
            "p2_x2_Cost______TB",
			"p2_x3_Name______TB",
            "p2_x3_Descript__TB",
            "p2_x3_Cost______TB",
            "p3_x1_Model_____TB",
            "p3_x1_Serial____TB",
            "p3_x1_Spec______TB",
            "p3_x1_Title_____TB",
            "p3_x1_Vendor____TB",
            "p3_x2_Model_____TB",
            "p3_x2_Serial____TB",
            "p3_x2_Spec______TB",
            "p3_x2_Title_____TB",
            "p3_x2_Vendor____TB",
            "p3_x3_Model_____TB",
            "p3_x3_Serial____TB",
            "p3_x3_Spec______TB",
            "p3_x3_Title_____TB",
            "p3_x3_Vendor____TB",
			"p4_x1_Status____TB",
            "p4_x1_Descript__TB",
			"p4_x2_Status____TB",
            "p4_x2_Descript__TB",
			"p4_x3_Status____TB",
            "p4_x3_Descript__TB",
			"p5_x1_Cost______TB",
            "p5_x1_Model_____TB",
            "p5_x1_Serial____TB",
            "p5_x1_Title_____TB",
            "p5_x1_Vendor____TB",
			"p5_x2_Cost______TB",
            "p5_x2_Model_____TB",
            "p5_x2_Serial____TB",
            "p5_x2_Title_____TB",
            "p5_x2_Vendor____TB",
			"p5_x3_Cost______TB",
            "p5_x3_Model_____TB",
            "p5_x3_Serial____TB",
            "p5_x3_Title_____TB",
            "p5_x3_Vendor____TB",
			"p6_x1_Cost______TB",
            "p6_x1_Display___TB",
            "p6_x1_Dist______TB",
            "p6_x1_Model_____TB",
            "p6_x1_Serial____TB",
            "p6_x1_Spec______TB",
            "p6_x1_Vendor____TB",
			"p6_x1_Cost______TB",
            "p6_x1_Display___TB",
            "p6_x1_Dist______TB",
            "p6_x1_Model_____TB",
            "p6_x1_Serial____TB",
            "p6_x1_Spec______TB",
            "p6_x1_Vendor____TB",
			"p6_x1_Cost______TB",
            "p6_x1_Display___TB",
            "p6_x1_Dist______TB",
            "p6_x1_Model_____TB",
            "p6_x1_Serial____TB",
            "p6_x1_Spec______TB",
            "p6_x1_Vendor____TB",
			"p7_x1_Cost______TB",
            "p7_x1_Display___TB",
            "p7_x1_Dist______TB",
			"p7_x2_Cost______TB",
            "p7_x2_Display___TB",
            "p7_x2_Dist______TB",
			"p7_x3_Cost______TB",
            "p7_x3_Display___TB",
            "p7_x3_Dist______TB", 
			"p9_x1_Client____LI",
            "p9_x1_Inventory_LI",
            "p9_x1_Service___LI",
            "p9_x1_Purchase__LI",
			"p9_x2_Client____LI",
            "p9_x2_Inventory_LI",
            "p9_x2_Service___LI",
            "p9_x2_Purchase__LI",
			"p9_x3_Client____LI",
            "p9_x3_Inventory_LI",
            "p9_x3_Service___LI",
            "p9_x3_Purchase__LI"
			"p7_x1_IsDevice__CB",
			"p7_x2_IsDevice__CB",
			"p7_x3_IsDevice__CB"
            "p0_x1_Record____LI",
			"p1_x1_Phone_____LI",
            "p1_x1_Email_____LI",
            "p1_x1_Device____LI",
            "p1_x1_Invoice___LI",
			"p1_x2_Phone_____LI",
            "p1_x2_Email_____LI",
            "p1_x2_Device____LI",
            "p1_x2_Invoice___LI",
			"p1_x3_Phone_____LI",
            "p1_x3_Email_____LI",
            "p1_x3_Device____LI",
            "p1_x3_Invoice___LI"
			"p3_x1_Client____LI",
            "p3_x1_Issue_____LI",
            "p3_x1_Purchase__LI",
            "p3_x1_Invoice___LI",
			"p3_x2_Client____LI",
            "p3_x2_Issue_____LI",
            "p3_x2_Purchase__LI",
            "p3_x2_Invoice___LI",
			"p3_x3_Client____LI",
            "p3_x3_Issue_____LI",
            "p3_x3_Purchase__LI",
            "p3_x3_Invoice___LI",
			"p4_x1_Model_____LI",
            "p4_x1_Serial____LI",
            "p4_x1_Spec______LI",
            "p4_x1_Title_____LI",
            "p4_x1_Vendor____LI",
			"p4_x2_Model_____LI",
            "p4_x2_Serial____LI",
            "p4_x2_Spec______LI",
            "p4_x2_Title_____LI",
            "p4_x2_Vendor____LI",
			"p4_x3_Model_____LI",
            "p4_x3_Serial____LI",
            "p4_x3_Spec______LI",
            "p4_x3_Title_____LI",
            "p4_x3_Vendor____LI",
			"p5_x1_Device____LI",
			"p5_x2_Device____LI",
			"p5_x3_Device____LI",
			"p6_x1_Device____LI",
			"p6_x2_Device____LI",
			"p6_x3_Device____LI",
			"p7_x1_Device____LI",
            "p7_x2_Device____LI",
            "p7_x3_Device____LI",
			"p8_x1_Account___LI",
			"p8_x2_Account___LI",
			"p8_x3_Account___LI")

        }

        [Void] SetDefaults()
        {
            $Output = ForEach ( $Name in $This.GetSearchNames() )
            {
                $Type   = Switch -Regex ($Name)
                {
                    UID       {       "UID" }
                    Client    {    "Client" }
                    Service   {   "Service" }
                    Device    {    "Device" }
                    Issue     {     "Issue" }
                    Inventory { "Inventory" }
                    Purchase  {  "Purchase" }
                    Expense   {   "Expense" }
                    Account   {   "Account" }
                    Invoice   {   "Invoice" }
                    Object    {    "Object" }
                }

                "$("# {0} {1}" -f $Name, ("-"*(60-$Type.Length)))

                `$This.IO.$Name`SP.ItemsSource   = `$This.Temp.$Type
                `$This.IO.$Name`SP.SelectedIndex = 2
                `$This.IO.$Name`SR.ItemsSource   = New-Object System.Collections.ObjectModel.Collection[Object]
                `$This.IO.$Name`SF.Text          = @(`$Null,`$This.Date)[(`$This.IO.$Name`SP.SelectedItem -eq 'Date')]
                
                `$This.IO.$Name`SF.Add_TextChanged(
                {
                    If ( `$This.IO.$Name`SF.Text -ne `"`" )
                    {
                        `$This.IO.$Name`SR.ItemsSource = `$Null
                
                        `$This.DG = `$This.DB.$Type | ? `$This.IO.$Name`SP.SelectedItem -match `$This.IO.$Name`SF.Text
                
                        If ( `$This.DG.Count -gt 0 )
                        {
                            `$This.IO.$Name`SR.ItemsSource = @( `$This.DG )
                        }
                    }
                
                    Else
                    {
                        `$This.IO.$Name`SR.ItemsSource = `$This.DB.$Type
                    }
                            
                    Start-Sleep -Milliseconds 50
                })
                
                `$Cim.IO.$Name`SP.Add_SelectionChanged(
                {
                    If ( `$Cim.IO.$Name`SP.SelectedItem -eq `"Date`" )
                    {
                        `$Cim.IO.$Name`SF.Text = `$Cim.Date
                    }

                    Else
                    {
                        `$Cim.IO.$Name`SF.Text = `"`"
                    }
                })

            # _____________________________________________________________________ "
            }

            Invoke-Expression $Output
        }

        [Void] Collapse()
        {
            $This.IO.p0_x0.Visibility = "Collapsed"
            $This.IO.p0_x1.Visibility = "Collapsed"
            $This.IO.p0_x2.Visibility = "Collapsed"
            $This.IO.p0_x3.Visibility = "Collapsed"
            $This.IO.p1_x0.Visibility = "Collapsed"
            $This.IO.p1_x1.Visibility = "Collapsed"
            $This.IO.p1_x2.Visibility = "Collapsed"
            $This.IO.p1_x3.Visibility = "Collapsed"
            $This.IO.p2_x0.Visibility = "Collapsed"
            $This.IO.p2_x1.Visibility = "Collapsed"
            $This.IO.p2_x2.Visibility = "Collapsed"
            $This.IO.p2_x3.Visibility = "Collapsed"
            $This.IO.p3_x0.Visibility = "Collapsed"
            $This.IO.p3_x1.Visibility = "Collapsed"
            $This.IO.p3_x2.Visibility = "Collapsed"
            $This.IO.p3_x3.Visibility = "Collapsed"
            $This.IO.p4_x0.Visibility = "Collapsed"
            $This.IO.p4_x1.Visibility = "Collapsed"
            $This.IO.p4_x2.Visibility = "Collapsed"
            $This.IO.p4_x3.Visibility = "Collapsed"
            $This.IO.p5_x0.Visibility = "Collapsed"
            $This.IO.p5_x1.Visibility = "Collapsed"
            $This.IO.p5_x2.Visibility = "Collapsed"
            $This.IO.p5_x3.Visibility = "Collapsed"
            $This.IO.p6_x0.Visibility = "Collapsed"
            $This.IO.p6_x1.Visibility = "Collapsed"
            $This.IO.p6_x2.Visibility = "Collapsed"
            $This.IO.p6_x3.Visibility = "Collapsed"
            $This.IO.p7_x0.Visibility = "Collapsed"
            $This.IO.p7_x1.Visibility = "Collapsed"
            $This.IO.p7_x2.Visibility = "Collapsed"
            $This.IO.p7_x3.Visibility = "Collapsed"
            $This.IO.p8_x0.Visibility = "Collapsed"
            $This.IO.p8_x1.Visibility = "Collapsed"
            $This.IO.p8_x2.Visibility = "Collapsed"
            $This.IO.p8_x3.Visibility = "Collapsed"
            $This.IO.p9_x0.Visibility = "Collapsed"
            $This.IO.p9_x1.Visibility = "Collapsed"
            $This.IO.p9_x2.Visibility = "Collapsed"
            $This.IO.p9_x3.Visibility = "Collapsed"
        }

        cimdb([String]$Xaml)
        {
            $This.Window                                    = [_Xaml]::New($Xaml)
            $This.IO                                        = $This.Window.IO
            $This.Temp                                      = [_Template]::New()
            $This.DB                                        = [_DB]::New()

            $This.SetDefaults()
            $This.Collapse()
            $This.Stage()
            $This.Refresh()
        }

        _ViewUID()
        {
            # "p0_x1_UID_______TB"
            # "p0_x1_Index_____TB"
            # "p0_x1_Slot______TB"
            # "p0_x1_Type______TB"
            # "p0_x1_Date______TB"
            # "p0_x1_Time______TB"
 
            $This.IO._ViewUIDUID.Text                       = $Null
            $This.IO._ViewUIDIndex.Text                     = $Null
            $This.IO._ViewUIDSlot.Text                      = $Null
            $This.IO._ViewUIDType.Text                      = $Null
            $This.IO._ViewUIDDate.Text                      = $Null
            $This.IO._ViewUIDTime.Text                      = $Null

            # "p0_x1_Record____LI"

            $This.IO._ViewUIDRecordResult.ItemsSource       = $Null
        }

        _ViewClient()
        {
            # "p1_x1_Address___TB"
            # "p1_x1_City______TB"
            # "p1_x1_Country___TB"
            # "p1_x1_Day_______TB"
            # "p1_x1_Email_____TB"
            # "p1_x1_First_____TB"
            # "p1_x1_Last______TB"
            # "p1_x1_MI________TB"
            # "p1_x1_Month_____TB"
            # "p1_x1_Phone_____TB"
            # "p1_x1_Postal____TB"
            # "p1_x1_Region____TB"
            # "p1_x1_Year______TB"

            $This.IO._ViewClientAddress.Text                = $Null
            $This.IO._ViewClientCity.Text                   = $Null
            $This.IO._ViewClientCountry.Text                = $Null
            $This.IO._ViewClientDay.Text                    = $Null
            $This.IO._ViewClientEmailText.Text              = $Null
            $This.IO._ViewClientFirst.Text                  = $Null
            $This.IO._ViewClientLast.Text                   = $Null
            $This.IO._ViewClientMI.Text                     = $Null
            $This.IO._ViewClientMonth.Text                  = $Null
            $This.IO._ViewClientPhoneText.Text              = $Null
            $This.IO._ViewClientPostal.Text                 = $Null
            $This.IO._ViewClientRegion.Text                 = $Null
            $This.IO._ViewClientYear.Text                   = $Null

            # "p1_x1_Phone_____LI"
            # "p1_x1_Email_____LI"
            # "p1_x1_Device____LI"
            # "p1_x1_Invoice___LI"

            $This.IO._ViewClientPhoneList.ItemsSource       = $Null
            $This.IO._ViewClientEmailList.ItemsSource       = $Null
            $This.IO._ViewClientDeviceList.ItemsSource      = $Null
            $This.IO._ViewClientInvoiceList.ItemsSource     = $Null
        }

        _EditClient()
        {
            # "p1_x2_Address___TB"
            # "p1_x2_City______TB"
            # "p1_x2_Country___TB"
            # "p1_x2_Day_______TB"
            # "p1_x2_Email_____TB"
            # "p1_x2_First_____TB"
            # "p1_x2_Last______TB"
            # "p1_x2_MI________TB"
            # "p1_x2_Month_____TB"
            # "p1_x2_Phone_____TB"
            # "p1_x2_Postal____TB"
            # "p1_x2_Region____TB"
            # "p1_x2_Year______TB"

            $This.IO._EditClientAddress.Text                = $Null
            $This.IO._EditClientCity.Text                   = $Null
            $This.IO._EditClientCountry.Text                = $Null
            $This.IO._EditClientDay.Text                    = $Null
            $This.IO._EditClientEmailText.Text              = $Null
            $This.IO._EditClientFirst.Text                  = $Null
            $This.IO._EditClientLast.Text                   = $Null
            $This.IO._EditClientMI.Text                     = $Null
            $This.IO._EditClientMonth.Text                  = $Null
            $This.IO._EditClientPhoneText.Text              = $Null
            $This.IO._EditClientPostal.Text                 = $Null
            $This.IO._EditClientRegion.Text                 = $Null
            $This.IO._EditClientYear.Text                   = $Null

            # "p1_x2_Phone_____LI"
            # "p1_x2_Email_____LI"
            # "p1_x2_Device____LI"
            # "p1_x2_Invoice___LI"

            $This.IO._EditClientPhoneList.ItemsSource       = $Null
            $This.IO._EditClientEmailList.ItemsSource       = $Null
            $This.IO._EditClientDeviceList.ItemsSource      = $Null
            $This.IO._EditClientInvoiceList.ItemsSource     = $Null
        }

        _NewClient()
        {
            # "p1_x3_Address___TB"
            # "p1_x3_City______TB"
            # "p1_x3_Country___TB"
            # "p1_x3_Day_______TB"
            # "p1_x3_Email_____TB"
            # "p1_x3_First_____TB"
            # "p1_x3_Last______TB"
            # "p1_x3_MI________TB"
            # "p1_x3_Month_____TB"
            # "p1_x3_Phone_____TB"
            # "p1_x3_Postal____TB"
            # "p1_x3_Region____TB"
            # "p1_x3_Year______TB"

            $This.IO._NewClientAddress.Text                 = $Null
            $This.IO._NewClientCity.Text                    = $Null
            $This.IO._NewClientCountry.Text                 = $Null
            $This.IO._NewClientDay.Text                     = $Null
            $This.IO._NewClientEmailText.Text               = $Null
            $This.IO._NewClientFirst.Text                   = $Null
            $This.IO._NewClientLast.Text                    = $Null
            $This.IO._NewClientMI.Text                      = $Null
            $This.IO._NewClientMonth.Text                   = $Null
            $This.IO._NewClientPhoneText.Text               = $Null
            $This.IO._NewClientPostal.Text                  = $Null
            $This.IO._NewClientRegion.Text                  = $Null
            $This.IO._NewClientYear.Text                    = $Null

            # "p1_x3_Phone_____LI"
            # "p1_x3_Email_____LI"
            # "p1_x3_Device____LI"
            # "p1_x3_Invoice___LI"

            $This.IO._NewClientPhoneList.ItemsSource        = $Null
            $This.IO._NewClientEmailList.ItemsSource        = $Null
            $This.IO._NewClientDeviceList.ItemsSource       = $Null
            $This.IO._NewClientInvoiceList.ItemsSource      = $Null
        }

        _ViewService()
        {
            # "p2_x1_Name______TB"
            # "p2_x1_Descript__TB"
            # "p2_x1_Cost______TB"

            $This.IO._ViewServiceName.Text                             = $Null
            $This.IO._ViewServiceDescription.Text                      = $Null
            $This.IO._ViewServiceCost.Text                             = $Null
        }

        _EditService()
        {
            # "p2_x2_Name______TB"
            # "p2_x2_Descript__TB"
            # "p2_x2_Cost______TB"

            $This.IO._EditServiceName.Text                             = $Null
            $This.IO._EditServiceDescription.Text                      = $Null
            $This.IO._EditServiceCost.Text                             = $Null
        }

        _NewService()
        {
            # "p2_x3_Name______TB"
            # "p2_x3_Descript__TB"
            # "p2_x3_Cost______TB"

            $This.IO._NewServiceName.Text                              = $Null
            $This.IO._NewServiceDescription.Text                       = $Null
            $This.IO._NewServiceCost.Text                              = $Null
        }

        _ViewDevice()
        {
            # "p3_x1_Model_____TB"
            # "p3_x1_Serial____TB"
            # "p3_x1_Spec______TB"
            # "p3_x1_Title_____TB"
            # "p3_x1_Vendor____TB"

            $This.IO._ViewDeviceModel.Text                             = $Null
            $This.IO._ViewDeviceSerial.Text                            = $Null
            $This.IO._ViewDeviceSpecification.Text                     = $Null
            $This.IO._ViewDeviceTitle.Text                             = $Null
            $This.IO._ViewDeviceVendor.Text                            = $Null

            # "p3_x1_Client____LI"
            # "p3_x1_Issue_____LI"
            # "p3_x1_Purchase__LI"
            # "p3_x1_Invoice___LI"

            $This.IO._ViewDeviceClientList.ItemsSource       = $Null
            $This.IO._ViewDeviceIssueList.ItemsSource        = $Null
            $This.IO._ViewDevicePurchaseList.ItemsSource     = $Null
            $This.IO._ViewDeviceInvoiceList.ItemsSource      = $Null
        }

        _EditDevice()
        {
            # "p3_x2_Model_____TB"
            # "p3_x2_Serial____TB"
            # "p3_x2_Spec______TB"
            # "p3_x2_Title_____TB"
            # "p3_x2_Vendor____TB"

            $This.IO._EditDeviceModel.Text                             = $Null
            $This.IO._EditDeviceSerial.Text                            = $Null
            $This.IO._EditDeviceSpecification.Text                     = $Null
            $This.IO._EditDeviceTitle.Text                             = $Null
            $This.IO._EditDeviceVendor.Text                            = $Null

            # "p3_x2_Client____LI"
            # "p3_x2_Issue_____LI"
            # "p3_x2_Purchase__LI"
            # "p3_x2_Invoice___LI"

            $This.IO._EditDeviceClientList.ItemsSource       = $Null
            $This.IO._EditDeviceIssueList.ItemsSource        = $Null
            $This.IO._EditDevicePurchaseList.ItemsSource     = $Null
            $This.IO._EditDeviceInvoiceList.ItemsSource      = $Null
        }
    
        _NewDevice()
        {
            # "p3_x3_Model_____TB"
            # "p3_x3_Serial____TB"
            # "p3_x3_Spec______TB"
            # "p3_x3_Title_____TB"
            # "p3_x3_Vendor____TB"

            $This.IO._NewDeviceModel.Text                              = $Null
            $This.IO._NewDeviceSerial.Text                             = $Null
            $This.IO._NewDeviceSpecification.Text                      = $Null
            $This.IO._NewDeviceTitle.Text                              = $Null
            $This.IO._NewDeviceVendor.Text                             = $Null

            # "p3_x3_Client____LI"
            # "p3_x3_Issue_____LI"
            # "p3_x3_Purchase__LI"
            # "p3_x3_Invoice___LI"

            $This.IO._NewDeviceClientList.ItemsSource        = $Null
            $This.IO._NewDeviceIssueList.ItemsSource         = $Null
            $This.IO._NewDevicePurchaseList.ItemsSource      = $Null
            $This.IO._NewDeviceInvoiceList.ItemsSource       = $Null
        }

        _ViewIssue()
        {
            # "p4_x1_Status____TB"
            # "p4_x1_Descript__TB"

            $This.IO._ViewIssueStatus.SelectedItem           = -1
            $This.IO._ViewIssueDescription.Text              = $Null

            # "p4_x1_Model_____LI"
            # "p4_x1_Serial____LI"
            # "p4_x1_Spec______LI"
            # "p4_x1_Title_____LI"
            # "p4_x1_Vendor____LI"

            $This.IO._ViewIssueClientList.ItemsSource        = $Null
            $This.IO._ViewIssueDeviceList.ItemsSource        = $Null
            $This.IO._ViewIssuePurchaseList.ItemsSource      = $Null
            $This.IO._ViewIssueServiceList.ItemsSource       = $Null
            $This.IO._ViewIssueInvoiceList.ItemsSource       = $Null
        }

        _EditIssue()
        {
            # "p4_x2_Status____TB"
            # "p4_x2_Descript__TB"

            $This.IO._EditIssueStatus.SelectedItem           = -1
            $This.IO._EditIssueDescription.Text              = $Null

            # "p4_x2_Model_____LI"
            # "p4_x2_Serial____LI"
            # "p4_x2_Spec______LI"
            # "p4_x2_Title_____LI"
            # "p4_x2_Vendor____LI"

            $This.IO._EditIssueClientList.ItemsSource        = $Null
            $This.IO._EditIssueDeviceList.ItemsSource        = $Null
            $This.IO._EditIssuePurchaseList.ItemsSource      = $Null
            $This.IO._EditIssueServiceList.ItemsSource       = $Null
            $This.IO._EditIssueInvoiceList.ItemsSource       = $Null
        }

        _NewIssue()
        {
            # "p4_x3_Status____TB"
            # "p4_x3_Descript__TB"

            $This.IO._NewIssueStatus.SelectedItem            = -1
            $This.IO._NewIssueDescription.Text               = $Null

            # "p4_x3_Model_____LI"
            # "p4_x3_Serial____LI"
            # "p4_x3_Spec______LI"
            # "p4_x3_Title_____LI"
            # "p4_x3_Vendor____LI"

            $This.IO._NewIssueClientList.ItemsSource         = $Null
            $This.IO._NewIssueDeviceList.ItemsSource         = $Null
            $This.IO._NewIssuePurchaseList.ItemsSource       = $Null
            $This.IO._NewIssueServiceList.ItemsSource        = $Null
            $This.IO._NewIssueInvoiceList.ItemsSource        = $Null
        }

        _ViewInventory()
        {
            # "p5_x1_Cost______TB"
            # "p5_x1_Model_____TB"
            # "p5_x1_Serial____TB"
            # "p5_x1_Title_____TB"
            # "p5_x1_Vendor____TB"

            $This.IO._ViewInventoryCost.Text                           = $Null
            $This.IO._ViewInventoryModel.Text                          = $Null
            $This.IO._ViewInventorySerial.Text                         = $Null
            $This.IO._ViewInventoryTitle.Text                          = $Null
            $This.IO._ViewInventoryVendor.Text                         = $Null

            # "p5_x1_Device____LI"

            $This.IO._ViewInventoryDeviceList.ItemsSource              = $Null
        }

        _EditInventory()
        {
            # "p5_x2_Cost______TB"
            # "p5_x2_Model_____TB"
            # "p5_x2_Serial____TB"
            # "p5_x2_Title_____TB"
            # "p5_x2_Vendor____TB"

            $This.IO._EditInventoryCost.Text                           = $Null
            $This.IO._EditInventoryModel.Text                          = $Null
            $This.IO._EditInventorySerial.Text                         = $Null
            $This.IO._EditInventoryTitle.Text                          = $Null
            $This.IO._EditInventoryVendor.Text                         = $Null

            # "p5_x2_Device____LI"

            $This.IO._EditInventoryDeviceList.ItemsSource              = $Null
        }
        
        _NewInventory()
        {
            # "p5_x3_Cost______TB"
            # "p5_x3_Model_____TB"
            # "p5_x3_Serial____TB"
            # "p5_x3_Title_____TB"
            # "p5_x3_Vendor____TB"

            $This.IO._NewInventoryCost.Text                            = $Null
            $This.IO._NewInventoryModel.Text                           = $Null
            $This.IO._NewInventorySerial.Text                          = $Null
            $This.IO._NewInventoryTitle.Text                           = $Null
            $This.IO._NewInventoryVendor.Text                          = $Null

            # "p5_x3_Device____LI"

            $This.IO._NewInventoryDeviceList.ItemsSource               = $Null
        }

        _ViewPurchase()
        {
            # "p6_x1_Cost______TB"
            # "p6_x1_Display___TB"
            # "p6_x1_Dist______TB"
            # "p6_x1_Model_____TB"
            # "p6_x1_Serial____TB"
            # "p6_x1_Spec______TB"
            # "p6_x1_Vendor____TB"

            $This.IO._ViewPurchaseCost.Text                            = $Null
            $This.IO._ViewPurchaseDisplayName.Text                     = $Null
            $This.IO._ViewPurchaseDistributor.Text                     = $Null
            $This.IO._ViewPurchaseModel.Text                           = $Null
            $This.IO._ViewPurchaseSerial.Text                          = $Null
            $This.IO._ViewPurchaseSpecification.Text                   = $Null
            $This.IO._ViewPurchaseVendor.Text                          = $Null

            # "p6_x1_Device____LI"

            $This.IO._ViewPurchaseDeviceList.ItemsSource               = $Null
        }

        _EditPurchase()
        {
            # "p6_x2_Cost______TB"
            # "p6_x2_Display___TB"
            # "p6_x2_Dist______TB"
            # "p6_x2_Model_____TB"
            # "p6_x2_Serial____TB"
            # "p6_x2_Spec______TB"
            # "p6_x2_Vendor____TB"

            $This.IO._EditPurchaseCost.Text                            = $Null
            $This.IO._EditPurchaseDisplayName.Text                     = $Null
            $This.IO._EditPurchaseDistributor.Text                     = $Null
            $This.IO._EditPurchaseModel.Text                           = $Null
            $This.IO._EditPurchaseSerial.Text                          = $Null
            $This.IO._EditPurchaseSpecification.Text                   = $Null
            $This.IO._EditPurchaseVendor.Text                          = $Null

            # "p6_x2_Device____LI"

            $This.IO._EditPurchaseDeviceList.ItemsSource               = $Null
        }

        _NewPurchase()
        {
            # "p6_x3_Cost______TB"
            # "p6_x3_Display___TB"
            # "p6_x3_Dist______TB"
            # "p6_x3_Model_____TB"
            # "p6_x3_Serial____TB"
            # "p6_x3_Spec______TB"
            # "p6_x3_Vendor____TB"

            $This.IO._NewPurchaseCost.Text                             = $Null
            $This.IO._NewPurchaseDisplayName.Text                      = $Null
            $This.IO._NewPurchaseDistributor.Text                      = $Null
            $This.IO._NewPurchaseModel.Text                            = $Null
            $This.IO._NewPurchaseSerial.Text                           = $Null
            $This.IO._NewPurchaseSpecification.Text                    = $Null
            $This.IO._NewPurchaseVendor.Text                           = $Null

            # "p6_x3_Device____LI"

            $This.IO._NewPurchaseDeviceList.ItemsSource                = $Null
        }

        _ViewExpense()
        {
            # "p7_x1_Cost______TB"
            # "p7_x1_Display___TB"
            # "p7_x1_Dist______TB"

            $This.IO._ViewExpenseCost.Text                             = $Null
            $This.IO._ViewExpenseDisplayName.Text                      = $Null
            $This.IO._ViewExpenseRecipient.Text                        = $Null

            # "p7_x1_IsDevice__CB"
            # "p7_x1_Device____LI"

            $This.IO._ViewExpenseIsDevice.IsChecked           = $False
            $This.IO._ViewExpenseDeviceList.ItemsSource      = $Null
        }

        _EditExpense()
        {
            # "p7_x2_Cost______TB"
            # "p7_x2_Display___TB"
            # "p7_x2_Dist______TB"

            $This.IO._EditExpenseCost.Text                             = $Null
            $This.IO._EditExpenseDisplayName.Text                      = $Null
            $This.IO._EditExpenseRecipient.Text                        = $Null

            # "p7_x2_IsDevice__CB"
            # "p7_x2_Device____LI"

            $This.IO._EditExpenseIsDevice.IsChecked           = $False
            $This.IO._EditExpenseDeviceList.ItemsSource      = $Null
        }   
        
        _NewExpense()
        {
            # "p7_x3_Cost______TB"
            # "p7_x3_Display___TB"
            # "p7_x3_Dist______TB"

            $This.IO._NewExpenseCost.Text                              = $Null
            $This.IO._NewExpenseDisplayName.Text                       = $Null
            $This.IO._NewExpenseRecipient.Text                         = $Null

            # "p7_x3_IsDevice__CB"
            # "p7_x3_Device____LI"

            $This.IO._NewExpenseIsDevice.IsChecked           = $False
            $This.IO._NewExpenseDeviceList.ItemsSource       = $Null
        }

        _ViewAccount()
        {
            # "p8_x1_Account___LI"

            $This.IO._ViewAccountObjectList.ItemsSource      = $Null
        }

        _EditAccount()
        {
            # "p8_x2_Account___LI"
            
            $This.IO._EditAccountObjectList.ItemsSource      = $Null
        }
        
        _NewAccount()
        {
            # "p8_x3_Account___LI"
            
            $This.IO._NewAccountObjectList.ItemsSource       = $Null
        }

        _ViewInvoice()
        {
            # "p9_x1_Client_____LI"
            # "p9_x1_Inventory__LI"
            # "p9_x1_Service____LI"
            # "p9_x1_Purchase___LI"

            $This.IO._ViewInvoiceClientList.ItemsSource      = $Null
            $This.IO._ViewInvoiceInventoryList.ItemsSource   = $Null
            $This.IO._ViewInvoiceServiceList.ItemsSource     = $Null
            $This.IO._ViewInvoicePurchaseList.ItemsSource    = $Null
        }

        _EditInvoice()
        {
            # "p9_x2_Client_____LI"
            # "p9_x2_Inventory__LI"
            # "p9_x2_Service____LI"
            # "p9_x2_Purchase___LI"

            $This.IO._EditInvoiceClientList.ItemsSource      = $Null
            $This.IO._EditInvoiceInventoryList.ItemsSource   = $Null
            $This.IO._EditInvoiceServiceList.ItemsSource     = $Null
            $This.IO._EditInvoicePurchaseList.ItemsSource    = $Null
        }

        _NewInvoice()
        {
            # "p9_x3_Client_____LI"
            # "p9_x3_Inventory__LI"
            # "p9_x3_Service____LI"
            # "p9_x3_Purchase___LI"

            $This.IO._NewInvoiceClientList.ItemsSource       = $Null
            $This.IO._NewInvoiceInventoryList.ItemsSource    = $Null
            $This.IO._NewInvoiceServiceList.ItemsSource      = $Null
            $This.IO._NewInvoicePurchaseList.ItemsSource     = $Null
        }

        Stage()
        {
            $This._ViewUID()
            $This._EditUID()
            $This._NewUID()
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
            $This.DB.Client                                 = $This.DB.UID | ? Type -eq Client
            $This.DB.Service                                = $This.DB.UID | ? Type -eq Service
            $This.DB.Device                                 = $This.DB.UID | ? Type -eq Device
            $This.DB.Issue                                  = $This.DB.UID | ? Type -eq Issue
            $This.DB.Inventory                              = $This.DB.UID | ? Type -eq Inventory
            $This.DB.Purchase                               = $This.DB.UID | ? Type -eq Purchase
            $This.DB.Expense                                = $This.DB.UID | ? Type -eq Expense
            $This.DB.Account                                = $This.DB.UID | ? Type -eq Account
            $This.DB.Invoice                                = $This.DB.UID | ? Type -eq Invoice

            # "p0_x0_UID_______SR"
            # "p1_x0_Client____SR"
            # "p2_x0_Service___SR"
            # "p3_x0_Device____SR"
            # "p4_x0_Issue_____SR"
            # "p5_x0_Inventory_SR"
            # "p6_x0_Purchase__SR"
            # "p7_x0_Expense___SR"
            # "p8_x0_Account___SR"
            # "p9_x0_Invoice___SR"

            $This.IO._GetUIDSearchResult.ItemsSource        = $This.DB.UID
            $This.IO._GetClientSearchResult.ItemsSource     = $This.DB.Client
            $This.IO._GetServiceSearchResult.ItemsSource    = $This.DB.Service
            $This.IO._GetDeviceSearchResult.ItemsSource     = $This.DB.Device
            $This.IO._GetIssueSearchResult.ItemsSource      = $This.DB.Issue
            $This.IO._GetInventorySearchResult.ItemsSource  = $This.DB.Inventory
            $This.IO._GetPurchaseSearchResult.ItemsSource   = $This.DB.Purchase
            $This.IO._GetExpenseSearchResult.ItemsSource    = $This.DB.Expense
            $This.IO._GetAccountSearchResult.ItemsSource    = $This.DB.Account
            $This.IO._GetInvoiceSearchResult.ItemsSource    = $This.DB.Invoice
        }

        GetTab([UInt32]$Slot)
        {
            $This.Collapse()
            $This.Stage()
            
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

            ForEach ( $Item in $This.Tab | % { "_$_`Tab" } )
            {
                $This.IO.$Item.Background                                = "#DFFFBA"
                $This.IO.$Item.Foreground                                = "#000000"
                $This.IO.$Item.BorderBrush                               = "#000000"
            }

            Write-Host $This.Tab[$Slot]

            $This.IO."_$($This.Tab[$Slot])Panel".Visibility           = "Visible"
            $This.IO."_Get$($This.Tab[$Slot])Panel".Visibility        = "Visible"

            $This.IO."_$($This.Tab[$Slot])Tab".Background             = "#4444FF"
            $This.IO."_$($This.Tab[$Slot])Tab".Foreground             = "#FFFFFF"
            $This.IO."_$($This.Tab[$Slot])Tab".BorderBrush            = "#000000"

            If ( $Slot -ne 0 )
            {
                $This.IO."_Edit$($This.Tab[$Slot])Panel".Visibility   = "Collapsed"
                $This.IO."_New$($This.Tab[$Slot])Panel".Visibility    = "Collapsed"
                $This.IO."_New$($This.Tab[$Slot])Tab".IsEnabled       = 1
            }

            $This.Refresh()
        }

        ViewTab([UInt32]$Slot)
        {
            $This.CollapsePanel()

            $This.IO."_View$($This.Tab[$Slot])Panel".Visibility       = "Visible"
        }

        EditTab([UInt32]$Slot)
        {
            $This.CollapsePanel()

            $This.IO."_Edit$($This.Tab[$Slot])Panel".Visibility       = "Visible"
        }

        NewTab([UInt32]$Slot)
        {
            $This.CollapsePanel()
            $This.ClearTextBox()

            $This.IO."_New$($This.Tab[$Slot])Panel".Visibility         = "Visible"
            $This.IO."_Get$($This.Tab[$Slot])SearchResult".ItemsSource = $Null
            $This.IO."_Save$($This.Tab[$Slot])Tab".IsEnabled           = 1
        }

        ViewUID([String]$UID)
        {
            $This.ClearTextBox()

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid UID"
            }

            $This.IO._ViewUIDUID.Text   = $Item.UID
            $This.IO._ViewUIDIndex.Text = $Item.Index
            $This.IO._ViewUIDSlot.Text  = $Item.Slot
            $This.IO._ViewUIDType.Text  = $Item.Type
            $This.IO._ViewUIDDate.Text  = $Item.Date
            $This.IO._ViewUIDTime.Text  = $Item.Time
 
            $Collect = @( )

            ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name )
            {
                
                $Collect += [_DGList]::New($Object,$Item.Record.$Object)
            }

            $This.IO._ViewUIDRecordResult.ItemsSource    = $Collect
        }

        ViewClient([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._ViewClientGender.SelectedItem      = 2
            $This.IO._ViewClientPhoneList.ItemsSource    = $Null
            $This.IO._ViewClientEmailList.ItemsSource    = $Null
            $This.IO._ViewClientDeviceList.ItemsSource   = $Null
            $This.IO._ViewClientInvoiceList.ItemsSource  = $Null

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Client UID"
            }

            $This.IO._ViewClientFirst.Text               = $Item.Record.First
            $This.IO._ViewClientMI.Text                  = $Item.Record.MI
            $This.IO._ViewClientLast.Text                = $Item.Record.Last
            $This.IO._ViewClientAddress.Text             = $Item.Record.Address
            $This.IO._ViewClientCity.Text                = $Item.Record.City
            $This.IO._ViewClientRegion.Text              = $Item.Record.Region
            $This.IO._ViewClientCountry.Text             = $Item.Record.Country
            $This.IO._ViewClientPostal.Text              = $Item.Record.Postal
            $This.IO._ViewClientMonth.Text               = $Item.Record.Month
            $This.IO._ViewClientDay.Text                 = $Item.Record.Day
            $This.IO._ViewClientYear.Text                = $Item.Record.Year

            $This.IO._ViewClientGender.SelectedIndex     = Switch ($Item.Record.Gender)
            {
                Male {0} Female {1} - {2}
            }

            $This.Populate( $Item.Record.Phone           , $This.IO._ViewClientPhoneList   )
            $This.Populate( $Item.Record.Email           , $This.IO._ViewClientEmailList   )
            $This.Populate( $Item.Record.Device          , $This.IO._ViewClientDeviceList  )
            $This.Populate( $Item.Record.Invoice         , $This.IO._ViewClientInvoiceList )
        }

        EditClient([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Client UID"
            }

            $This.IO._EditClientFirst.Text               = $Item.Record.First
            $This.IO._EditClientMI.Text                  = $Item.Record.MI
            $This.IO._EditClientLast.Text                = $Item.Record.Last
            $This.IO._EditClientAddress.Text             = $Item.Record.Address
            $This.IO._EditClientCity.Text                = $Item.Record.City
            $This.IO._EditClientRegion.Text              = $Item.Record.Region
            $This.IO._EditClientCountry.Text             = $Item.Record.Country
            $This.IO._EditClientPostal.Text              = $Item.Record.Postal
            $This.IO._EditClientMonth.Text               = $Item.Record.Month
            $This.IO._EditClientDay.Text                 = $Item.Record.Day
            $This.IO._EditClientYear.Text                = $Item.Record.Year

            $This.IO._EditClientGender.SelectedIndex     = Switch ($Item.Record.Gender)
            {
                Male {0} Female {1} - {2}
            }

            $This.Populate( $Item.Record.Phone           , $This.IO._EditClientPhoneList   )
            $This.Populate( $Item.Record.Email           , $This.IO._EditClientEmailList   )
            $This.Populate( $Item.Record.Device          , $This.IO._EditClientDeviceList  )
            $This.Populate( $Item.Record.Invoice         , $This.IO._EditClientInvoiceList )
        }

        ViewService([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO._ViewServiceName.Text               = $Item.Record.Name
            $This.IO._ViewServiceDescription.Text        = $Item.Record.Description
            $This.IO._ViewServiceCost.Text               = $Item.Record.Cost
        }

        EditService([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO._EditServiceName.Text               = $Item.Record.Name
            $This.IO._EditServiceDescription.Text        = $Item.Record.Description
            $This.IO._EditServiceCost.Text               = $Item.Record.Cost
        }

        ViewDevice([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                        = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Device UID"
            }

            $This.IO._ViewDeviceChassis.SelectedIndex    = Switch($Item.Record.Chassis)
            {
                Desktop    {0} Laptop     {1} Smartphone {2} Tablet     {3} Console    {4} 
                Server     {5} Network    {6} Other      {7} -          {8}
            }

            $This.IO._ViewDeviceVendor.Text              = $Item.Record.Vendor
            $This.IO._ViewDeviceModel.Text               = $Item.Record.Model
            $This.IO._ViewDeviceSpecification.Text       = $Item.Record.Specification
            $This.IO._ViewDeviceSerial.Text              = $Item.Record.Serial
            $This.IO._ViewDeviceTitle.Text               = $Item.Record.Title

            $This.Populate( $Item.Record.Client          , $This.IO._ViewDeviceClientList   )
            $This.Populate( $Item.Record.Issue           , $This.IO._ViewDeviceIssueList    )
            $This.Populate( $Item.Record.Purchase        , $This.IO._ViewDevicePurchaseList )
            $This.Populate( $Item.Record.Invoice         , $This.IO._ViewDeviceInvoiceList  )
        }

        EditDevice([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                         = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Device UID"
            }

            $This.IO._EditDeviceChassis.SelectedIndex     = Switch($Item.Record.Chassis)
            {
                Desktop    {0} Laptop     {1} Smartphone {2} Tablet     {3} Console    {4} 
                Server     {5} Network    {6} Other      {7} -          {8}
            }

            $This.IO._EditDeviceVendor.Text               = $Item.Record.Vendor
            $This.IO._EditDeviceModel.Text                = $Item.Record.Model
            $This.IO._EditDeviceSpecification.Text        = $Item.Record.Specification
            $This.IO._EditDeviceSerial.Text               = $Item.Record.Serial
            $This.IO._EditDeviceTitle.Text                = $Item.Record.Title

            $This.Populate( $Item.Record.Client           , $This.IO._EditDeviceClientList   )
            $This.Populate( $Item.Record.Issue            , $This.IO._EditDeviceIssueList    )
            $This.Populate( $Item.Record.Purchase         , $This.IO._EditDevicePurchaseList )
            $This.Populate( $Item.Record.Invoice          , $This.IO._EditDeviceInvoiceList  )
        }

        ViewIssue([Object]$UID)
        {
            $This.ClearTextBox()
            $This.IO._ViewIssueStatus.SelectedIndex       = 0

            $Item                                         = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Issue UID"
            }

            $This.IO._ViewIssueDescription.Text           = $Item.Record.Description
            $This.IO._ViewIssueStatus.SelectedIndex       = $Item.Record.Status

            $This.Populate( $Item.Record.Client           , $This.IO._ViewIssueClientList   )
            $This.Populate( $Item.Record.Device           , $This.IO._ViewIssueDeviceList   )
            $This.Populate( $Item.Record.Purchase         , $This.IO._ViewIssuePurchaseList )
            $This.Populate( $Item.Record.Service          , $This.IO._ViewIssueServiceList  )
            $This.Populate( $Item.Record.Invoice          , $This.IO._ViewIssueInvoiceList  )
        }

        ViewInventory([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._ViewInventoryIsDevice.IsChecked     = $False

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._ViewInventoryVendor.Text         = $Item.Record.Vendor
            $This.IO._ViewInventorySerial.Text         = $Item.Record.Serial
            $This.IO._ViewInventoryModel.Text          = $Item.Record.Model
            $This.IO._ViewInventoryTitle.Text          = $Item.Record.Title
            $This.IO._ViewInventoryIsDevice.IsChecked  = $Item.Record.IsDevice

            $This.Populate( $Item.Record.Device        , $This.IO._ViewInventoryDeviceList  )

            $This.IO._ViewInventoryCost.Text           = $Item.Record.Cost
        }

        EditInventory([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._EditInventoryIsDevice.IsChecked  = $False

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._EditInventoryVendor.Text         = $Item.Record.Vendor
            $This.IO._EditInventorySerial.Text         = $Item.Record.Serial
            $This.IO._EditInventoryModel.Text          = $Item.Record.Model
            $This.IO._EditInventoryTitle.Text          = $Item.Record.Title
            $This.IO._EditInventoryIsDevice.IsChecked  = $Item.Record.IsDevice
            $This.IO._EditInventoryCost.Text           = $Item.Record.Cost

            $This.Populate( $Item.Record.Device        , $This.IO._EditInventoryDeviceList  )
        }

        ViewPurchase([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._ViewPurchaseIsDevice.IsChecked   = $Null

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Purchase UID"
            }

            $This.IO._ViewPurchaseDistributor.Text     = $Item.Record.Distributor
            $This.IO._ViewPurchaseDisplayName.Text     = $Item.Record.DisplayName
            $This.IO._ViewPurchaseVendor.Text          = $Item.Record.Vendor
            $This.IO._ViewPurchaseModel.Text           = $Item.Record.Model
            $This.IO._ViewPurchaseSpecification.Text   = $Item.Record.Specification
            $This.IO._ViewPurchaseSerial.Text          = $Item.Record.Serial
            $This.IO._ViewPurchaseIsDevice.IsChecked   = $Item.Record.IsDevice

            $This.Populate( $Item.Record.Device        , $This.IO._ViewPurchaseDeviceList  )

            $This.IO._ViewPurchaseCost.Text            = $Item.Record.Cost
        }

        EditPurchase([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._EditPurchaseIsDevice.IsChecked   = $Null

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Purchase UID"
            }

            $This.IO._EditPurchaseDistributor.Text     = $Item.Record.Distributor
            $This.IO._EditPurchaseDisplayName.Text     = $Item.Record.DisplayName
            $This.IO._EditPurchaseVendor.Text          = $Item.Record.Vendor
            $This.IO._EditPurchaseModel.Text           = $Item.Record.Model
            $This.IO._EditPurchaseSpecification.Text   = $Item.Record.Specification
            $This.IO._EditPurchaseSerial.Text          = $Item.Record.Serial
            $This.IO._EditPurchaseIsDevice.IsChecked   = $Item.Record.IsDevice

            $This.Populate( $Item.Record.Device        , $This.IO._EditPurchaseDeviceList  )

            $This.IO._EditPurchaseCost.Text            = $Item.Record.Cost
        }

        ViewExpense([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Expense UID"
            }

            $This.IO._ViewExpenseRecipient.Text        = $Item.Record.Recipient
            $This.IO._ViewExpenseDisplayName.Text      = $Item.Record.DisplayName

            $This.Populate( $Item.Record.Account       , $This.IO._ViewExpenseAccountList  )

            $This.IO._ViewExpenseCost.Text             = $Item.Record.Cost
        }

        EditExpense([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Expense UID"
            }

            $This.IO._EditExpenseRecipient.Text        = $Item.Record.Recipient
            $This.IO._EditExpenseDisplayName.Text      = $Item.Record.DisplayName

            $This.Populate( $Item.Record.Account       , $This.IO._EditExpenseAccountList  )

            $This.IO._EditExpenseCost.Text             = $Item.Record.Cost
        }

        ViewAccount([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Account UID"
            }

            $This.Populate( $Item.Record.Object        , $This.IO._ViewAccountObjectList    )
        }

        EditAccount([Object]$UID)
        {
            $This.ClearTextBox()

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Account UID"
            }

            $This.Populate( $Item.Record.Object        , $This.IO._EditAccountObjectList    )
        }

        ViewInvoice([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._ViewInvoiceMode.SelectedIndex    = 0 

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._ViewInvoiceMode.SelectedIndex    = $Item.Record.Mode

            $This.Populate( $Item.Record.Client        , $This.IO._ViewInvoiceClientList   )
            $This.Populate( $Item.Record.Inventory     , $This.IO._ViewInvoiceDeviceList   )
            $This.Populate( $Item.Record.Service       , $This.IO._ViewInvoiceServiceList  )
            $This.Populate( $Item.Record.Purchase      , $This.IO._ViewInvoicePurchaseList )
        }

        EditInvoice([Object]$UID)
        {
            $This.ClearTextBox()

            $This.IO._EditInvoiceMode.SelectedIndex    = 0 

            $Item                                      = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._EditExpenseRecipient.Text        = $Item.Record.Recipient
            $This.IO._EditInvoiceMode.SelectedIndex    = $Item.Record.Mode

            $This.Populate( $Item.Record.Client        , $This.IO._EditInvoiceClientList   )
            $This.Populate( $Item.Record.Inventory     , $This.IO._EditInvoiceDeviceList   )
            $This.Populate( $Item.Record.Service       , $This.IO._EditInvoiceServiceList  )
            $This.Populate( $Item.Record.Purchase      , $This.IO._EditInvoicePurchaseList )
        }
    }

    $GFX  = [_Gfx]::New()
    $Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="[FightingEntropy]://(Company Information Management Database)" 
    Height="680" 
    Width="800"
    Topmost="True" 
    ResizeMode="NoResize" 
    Icon="C:\ProgramData\Secure Digits Plus LLC\Graphics\icon.ico" 
    HorizontalAlignment="Center" 
    WindowStartupLocation="CenterScreen"
    FontFamily="Consolas"
    Background="LightYellow">
    <Window.Resources>
        <Style TargetType="ToolTip">
            <Setter Property="Background" Value="#000000"/>
            <Setter Property="Foreground" Value="#66D066"/>
        </Style>
        <Style TargetType="TabItem">
            <Setter Property="FontSize" Value="15"/>
            <Setter Property="FontWeight" Value="Heavy"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border Name="Border" BorderThickness="2" BorderBrush="Black" CornerRadius="2" Margin="2">
                            <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Right" ContentSource="Header" Margin="5"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#4444FF"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                            <Trigger Property="IsSelected" Value="False">
                                <Setter TargetName="Border" Property="Background" Value="#DFFFBA"/>
                                <Setter Property="Foreground" Value="#000000"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="5"/>
            <Setter Property="FontSize" Value="15"/>
            <Setter Property="FontWeight" Value="Heavy"/>
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="Background" Value="#DFFFBA"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Style.Resources>
                <Style TargetType="Border">
                    <Setter Property="CornerRadius" Value="2"/>
                </Style>
            </Style.Resources>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Height" Value="24"/>
            <Setter Property="Margin" Value="4"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="BorderThickness" Value="2"/>
            <Setter Property="Foreground" Value="#000000"/>
            <Style.Resources>
                <Style TargetType="Border">
                    <Setter Property="CornerRadius" Value="2"/>
                </Style>
            </Style.Resources>
        </Style>
        <Style TargetType="ComboBox">
            <Setter Property="Height" Value="24"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="Normal"/>
        </Style>
        <Style TargetType="DataGrid">
            <Setter Property="AutoGenerateColumns" Value="False"/>
            <Setter Property="AlternationCount" Value="2"/>
            <Setter Property="HeadersVisibility" Value="Column"/>
            <Setter Property="CanUserResizeRows" Value="False"/>
            <Setter Property="CanUserAddRows" Value="False"/>
            <Setter Property="IsTabStop" Value="True" />
            <Setter Property="IsTextSearchEnabled" Value="True"/>
            <Setter Property="IsReadOnly" Value="True"/>
        </Style>
        <Style TargetType="DataGridRow">
            <Style.Triggers>
                <Trigger Property="AlternationIndex" Value="0">
                    <Setter Property="Background" Value="White"/>
                </Trigger>
                <Trigger Property="AlternationIndex" Value="1">
                    <Setter Property="Background" Value="#FFD6FFFB"/>
                </Trigger>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="ToolTip">
                        <Setter.Value>
                            <TextBlock TextWrapping="Wrap" Width="400" Background="#000000" Foreground="#00FF00"/>
                        </Setter.Value>
                    </Setter>
                    <Setter Property="ToolTipService.ShowDuration" Value="360000000"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="DataGridColumnHeader">
            <Setter Property="FontSize"   Value="12"/>
            <Setter Property="FontWeight" Value="Normal"/>
        </Style>
        <Style TargetType="TabControl">
            <Setter Property="TabStripPlacement" Value="Top"/>
            <Setter Property="HorizontalContentAlignment" Value="Center"/>
            <Setter Property="Background" Value="LightYellow"/>
        </Style>
        <Style TargetType="GroupBox">
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="Normal"/>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="120"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        <Grid Grid.Column="0">
            <Grid.RowDefinitions>
                <RowDefinition Height="120"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
                <RowDefinition Height="40"/>
            </Grid.RowDefinitions>
            <Button Grid.Row="0" Name="t0">
                <Image Source="C:\ProgramData\Secure Digits Plus LLC\Graphics\sdplogo.png"/>
            </Button>
            <Button Grid.Row="1" Name="t1" HorizontalContentAlignment="Right" Content="Client"/>
            <Button Grid.Row="2" Name="t2" HorizontalContentAlignment="Right" Content="Service"/>
            <Button Grid.Row="3" Name="t3" HorizontalContentAlignment="Right" Content="Device"/>
            <Button Grid.Row="4" Name="t4" HorizontalContentAlignment="Right" Content="Issue"/>
            <Button Grid.Row="5" Name="t5" HorizontalContentAlignment="Right" Content="Inventory"/>
            <Button Grid.Row="6" Name="t6" HorizontalContentAlignment="Right" Content="Purchase"/>
            <Button Grid.Row="7" Name="t7" HorizontalContentAlignment="Right" Content="Expense"/>
            <Button Grid.Row="8" Name="t8" HorizontalContentAlignment="Right" Content="Account"/>
            <Button Grid.Row="9" Name="t9" HorizontalContentAlignment="Right" Content="Invoice"/>
        </Grid>
        <Grid Grid.Column="1">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Name="New" Content="New"/>
                <Button Grid.Column="1" Name="View" Content="View"/>
                <Button Grid.Column="2" Name="Edit" Content="Edit"/>
                <Button Grid.Column="3" Name="Save" Content="Save"/>
            </Grid>
            <Grid Grid.Row="1" Name="p0" Visibility="Collapsed">
                <Grid Name="p0_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="p0_x0_UID_______SP"/>
                        <TextBox Grid.Column="1" Name="p0_x0_UID_______SF"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="p0_x0_UID_______SR">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="UID"    Binding='{Binding UID}'    Width="200"/>
                            <DataGridTextColumn Header="Index"  Binding='{Binding Index}'  Width="50"/>
                            <DataGridTextColumn Header="Slot"   Binding='{Binding Slot}'   Width="50"/>
                            <DataGridTextColumn Header="Date"   Binding='{Binding Date}'   Width="100"/>
                            <DataGridTextColumn Header="Time"   Binding='{Binding Time}'   Width="100"/>
                            <DataGridTextColumn Header="Record" Binding='{Binding Record}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p0_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="200"/>
                            <ColumnDefinition Width="120"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[UID]">
                            <TextBox Name="p0_x1_UID_______TB" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Index]">
                            <TextBox Name="p0_x1_Index_____TB" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Slot]">
                            <TextBox Name="p0_x1_Slot______TB" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Type]">
                            <TextBox Name="p0_x1_Type______TB" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Date]">
                            <TextBox Name="p0_x1_Date______TB" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Time]">
                            <TextBox Name="p0_x1_Time______TB" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <DataGrid Grid.Row="2" Margin="5" Name="p0_x1_Record____LI">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="2*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p1" Visibility="Collapsed">
                <Grid Name="p1_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="p1_x0_Client____SP"/>
                        <TextBox Grid.Column="1" Name="p1_x0_Client____SF"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="p1_x0_Client____SR">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                            <DataGridTextColumn Header="Last"  Binding='{Binding Record.Last}'  Width="*"/>
                            <DataGridTextColumn Header="First" Binding='{Binding Record.First}' Width="*"/>
                            <DataGridTextColumn Header="MI"    Binding='{Binding Record.MI}'    Width="0.25*"/>
                            <DataGridTextColumn Header="DOB"   Binding='{Binding Record.DOB}'   Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p1_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                            <ColumnDefinition Width="120"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_ViewClientLast" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_ViewClientFirst" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_ViewClientMI" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Gender]">
                            <ComboBox Name="_ViewClientGender" SelectedIndex="2" IsEnabled="False">
                                <ComboBoxItem Content="Male"/>
                                <ComboBoxItem Content="Female"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Address]">
                            <TextBox Name="_ViewClientAddress" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[DOB(MM/DD/YYYY)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="_ViewClientMonth" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewClientDay" IsEnabled="False"/>
                                <TextBox Grid.Column="2" Name="_ViewClientYear" IsEnabled="False"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_ViewClientCity" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_ViewClientRegion" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_ViewClientCountry" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_ViewClientPostal" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Header="[Phone Number(s)]" Grid.Row="3">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_ViewClientPhoneText" IsEnabled="False"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddPhone" IsEnabled="False"/>
                            <ComboBox Grid.Column="2" Name="_ViewClientPhoneList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_ViewClientRemovePhone" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Header="[Email Address(es)]" Grid.Row="4">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_ViewClientEmailText" IsEnabled="False"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddEmail" IsEnabled="False"/>
                            <ComboBox Grid.Column="2" Name="_ViewClientEmailList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_ViewClientRemoveEmail" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Device(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_ViewClientDeviceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewClientDeviceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewClientDeviceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewClientAddDevice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewClientDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewClientRemoveDevice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_ViewClientInvoiceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewClientInvoiceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewClientInvoiceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewClientAddInvoice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewClientInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewClientRemoveInvoice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p1_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                            <ColumnDefinition Width="120"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_EditClientLast"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_EditClientFirst"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_EditClientMI"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Gender]">
                            <ComboBox Name="_EditClientGender" SelectedIndex="2">
                                <ComboBoxItem Content="Male"/>
                                <ComboBoxItem Content="Female"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Address]">
                            <TextBox Name="_EditClientAddress"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[DOB(MM/DD/YYYY)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="_EditClientMonth"/>
                                <TextBox Grid.Column="1" Name="_EditClientDay"/>
                                <TextBox Grid.Column="2" Name="_EditClientYear"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_EditClientCity"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_EditClientRegion"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_EditClientCountry"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_EditClientPostal"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Header="[Phone Number(s)]" Grid.Row="3">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_EditClientPhoneText"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddPhone"/>
                            <ComboBox Grid.Column="2" Name="_EditClientPhoneList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_EditClientRemovePhone"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Header="[Email Address(es)]" Grid.Row="4">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_EditClientEmailText"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddEmail"/>
                            <ComboBox Grid.Column="2" Name="_EditClientEmailList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_EditClientRemoveEmail"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Device(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_EditClientDeviceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditClientDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditClientDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditClientAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_EditClientDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditClientRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_EditClientInvoiceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditClientInvoiceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditClientInvoiceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditClientAddInvoice"/>
                                <ComboBox Grid.Column="2" Name="_EditClientInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditClientRemoveInvoice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p1_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                            <ColumnDefinition Width="120"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_NewClientLast"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_NewClientFirst"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_NewClientMI"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Gender]">
                            <ComboBox Name="_NewClientGender" SelectedIndex="2">
                                <ComboBoxItem Content="Male"/>
                                <ComboBoxItem Content="Female"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Address]">
                            <TextBox Name="_NewClientAddress"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[DOB(MM/DD/YYYY)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="0.6*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="_NewClientMonth"/>
                                <TextBox Grid.Column="1" Name="_NewClientDay"/>
                                <TextBox Grid.Column="2" Name="_NewClientYear"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_NewClientCity"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_NewClientRegion"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_NewClientCountry"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_NewClientPostal"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Header="[Phone Number(s)]" Grid.Row="3">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_NewClientPhoneText"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddPhone"/>
                            <ComboBox Grid.Column="2" Name="_NewClientPhoneList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_NewClientRemovePhone"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Header="[Email Address(es)]" Grid.Row="4">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <TextBox Grid.Column="0" Name="_NewClientEmailText"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddEmail"/>
                            <ComboBox Grid.Column="2" Name="_NewClientEmailList"/>
                            <Button Grid.Column="3" Margin="5" Content="-" Name="_NewClientRemoveEmail"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Device(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_NewClientDeviceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewClientDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewClientDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewClientAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_NewClientDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewClientRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_NewClientInvoiceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewClientInvoiceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewClientInvoiceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewClientAddInvoice"/>
                                <ComboBox Grid.Column="2" Name="_NewClientInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewClientRemoveInvoice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p2" Visibility="Collapsed">
                <Grid Name="p2_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetServiceSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetServiceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetServiceSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name"        Binding='{Binding Record.Name}' Width="*"/>
                            <DataGridTextColumn Header="Description" Binding='{Binding Record.Description}' Width="*"/>
                            <DataGridTextColumn Header="Cost"        Binding='{Binding Record.Cost}' Width="0.5*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p2_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_ViewServiceName" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_ViewServiceDescription" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_ViewServiceCost" IsEnabled="False"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p2_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_EditServiceName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_EditServiceDescription"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_EditServiceCost"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p2_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_NewServiceName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_NewServiceDescription"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_NewServiceCost"/>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p3" Visibility="Collapsed">
                <Grid Name="p3_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetDeviceSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetDeviceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetDeviceSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor"        Binding='{Binding Record.Vendor}'        Width="*"/>
                            <DataGridTextColumn Header="Model"         Binding='{Binding Record.Model}'         Width="*"/>
                            <DataGridTextColumn Header="Specification" Binding='{Binding Record.Specification}' Width="*"/>
                            <DataGridTextColumn Header="Serial"        Binding='{Binding Record.Serial}'        Width="*"/>
                            <DataGridTextColumn Header="Title"         Binding='{Binding Record.Title}'         Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p3_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Chassis]">
                            <ComboBox Name="_ViewDeviceChassis" SelectedIndex="8" IsEnabled="False">
                                <ComboBoxItem Content="Desktop"/>
                                <ComboBoxItem Content="Laptop"/>
                                <ComboBoxItem Content="Smartphone"/>
                                <ComboBoxItem Content="Tablet"/>
                                <ComboBoxItem Content="Console"/>
                                <ComboBoxItem Content="Server"/>
                                <ComboBoxItem Content="Network"/>
                                <ComboBoxItem Content="Other"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Vendor]">
                            <TextBox Name="_ViewDeviceVendor" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Model]">
                            <TextBox Name="_ViewDeviceModel" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Specification]">
                            <TextBox Name="_ViewDeviceSpecification" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Serial]">
                            <TextBox Name="_ViewDeviceSerial" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Title]">
                            <TextBox Name="_ViewDeviceTitle" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Client(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceClientSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewDeviceClientSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceClientSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewDeviceAddClient" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewDeviceClientList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewDeviceRemoveClient" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Issue(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceIssueSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewDeviceIssueSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceIssueSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewDeviceAddIssue" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewDeviceIssueList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewDeviceRemoveIssue" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDevicePurchaseSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewDevicePurchaseSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDevicePurchaseSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewDeviceAddPurchase" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewDevicePurchaseList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewDeviceRemovePurchase" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceInvoiceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewDeviceInvoiceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewDeviceInvoiceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewDeviceAddInvoice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewDeviceInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewDeviceRemoveInvoice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p3_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Chassis]">
                            <ComboBox Name="_EditDeviceChassis" SelectedIndex="8">
                                <ComboBoxItem Content="Desktop"/>
                                <ComboBoxItem Content="Laptop"/>
                                <ComboBoxItem Content="Smartphone"/>
                                <ComboBoxItem Content="Tablet"/>
                                <ComboBoxItem Content="Console"/>
                                <ComboBoxItem Content="Server"/>
                                <ComboBoxItem Content="Network"/>
                                <ComboBoxItem Content="Other"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Vendor]">
                            <TextBox Name="_EditDeviceVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Model]">
                            <TextBox Name="_EditDeviceModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Specification]">
                            <TextBox Name="_EditDeviceSpecification"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Serial]">
                            <TextBox Name="_EditDeviceSerial"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Title]">
                            <TextBox Name="_EditDeviceTitle"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Client(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceClientSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditDeviceClientSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceClientSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditDeviceAddClient"/>
                                <ComboBox Grid.Column="2" Name="_EditDeviceClientList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditDeviceRemoveClient"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Issue(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceIssueSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditDeviceIssueSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceIssueSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditDeviceAddIssue"/>
                                <ComboBox Grid.Column="2" Name="_EditDeviceIssueList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditDeviceRemoveIssue"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDevicePurchaseSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditDevicePurchaseSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDevicePurchaseSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditDeviceAddPurchase"/>
                                <ComboBox Grid.Column="2" Name="_EditDevicePurchaseList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditDeviceRemovePurchase"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceInvoiceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditDeviceInvoiceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditDeviceInvoiceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditDeviceAddInvoice"/>
                                <ComboBox Grid.Column="2" Name="_EditDeviceInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditDeviceRemoveInvoice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p3_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Chassis]">
                            <ComboBox Name="_NewDeviceChassis" SelectedIndex="8">
                                <ComboBoxItem Content="Desktop"/>
                                <ComboBoxItem Content="Laptop"/>
                                <ComboBoxItem Content="Smartphone"/>
                                <ComboBoxItem Content="Tablet"/>
                                <ComboBoxItem Content="Console"/>
                                <ComboBoxItem Content="Server"/>
                                <ComboBoxItem Content="Network"/>
                                <ComboBoxItem Content="Other"/>
                                <ComboBoxItem Content="-"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Vendor]">
                            <TextBox Name="_NewDeviceVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Model]">
                            <TextBox Name="_NewDeviceModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Specification]">
                            <TextBox Name="_NewDeviceSpecification"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Serial]">
                            <TextBox Name="_NewDeviceSerial"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Title]">
                            <TextBox Name="_NewDeviceTitle"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Client(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceClientSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewDeviceClientSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceClientSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewDeviceAddClient"/>
                                <ComboBox Grid.Column="2" Name="_NewDeviceClientList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewDeviceRemoveClient"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Issue(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceIssueSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewDeviceIssueSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceIssueSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewDeviceAddIssue"/>
                                <ComboBox Grid.Column="2" Name="_NewDeviceIssueList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewDeviceRemoveIssue"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDevicePurchaseSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewDevicePurchaseSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDevicePurchaseSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewDeviceAddPurchase"/>
                                <ComboBox Grid.Column="2" Name="_NewDevicePurchaseList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewDeviceRemovePurchase"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceInvoiceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewDeviceInvoiceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewDeviceInvoiceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewDeviceAddInvoice"/>
                                <ComboBox Grid.Column="2" Name="_NewDeviceInvoiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewDeviceRemoveInvoice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p4" Visibility="Collapsed">
                <Grid Name="p4_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetIssueSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetIssueSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetIssueSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Client"   Binding='{Binding Record.Client}'   Width="*"/>
                            <DataGridTextColumn Header="Device"   Binding='{Binding Record.Device}'   Width="*"/>
                            <DataGridTextColumn Header="Status"   Binding='{Binding Record.Status}'   Width="*"/>
                            <DataGridTextColumn Header="Purchase" Binding='{Binding Record.Purchase}' Width="*"/>
                            <DataGridTextColumn Header="Service"  Binding='{Binding Record.Service}'  Width="*"/>
                            <DataGridTextColumn Header="Invoice"  Binding='{Binding Record.Invoice}'  Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p4_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="200"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Status]">
                            <ComboBox Name="_ViewIssueStatus"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Description]">
                            <TextBox Name="_ViewIssueDescription"/>
                        </GroupBox>
                    </Grid>
                    <TabControl Grid.Row="1" Name="_ViewIssueTabControl" IsEnabled="False">
                        <TabItem Header="Client">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewIssueClientSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_ViewIssueClientSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_ViewIssueClientSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Last"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="First" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="MI"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="DOB"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Device">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewIssueDeviceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_ViewIssueDeviceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_ViewIssueDeviceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.Vendor}'  Width="*"/>
                                        <DataGridTextColumn Header="Model"  Binding='{Binding Record.Model}'  Width="*"/>
                                        <DataGridTextColumn Header="Spec."  Binding='{Binding Record.Specification}' Width="*"/>
                                        <DataGridTextColumn Header="Serial" Binding='{Binding Record.Serial}'    Width="*"/>
                                        <DataGridTextColumn Header="Title"  Binding='{Binding Record.Title}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Purchase">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewIssuePurchaseSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_ViewIssuePurchaseSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_ViewIssuePurchaseSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Distributor"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="DisplayName"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="Serial"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                        <DataGridTextColumn Header="Device" Binding='{Binding Record.IsDevice}' Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Service">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewIssueServiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_ViewIssueServiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_ViewIssueServiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Description"  Binding='{Binding Record.Description}'  Width="*"/>
                                        <DataGridTextColumn Header="Cost" Binding='{Binding Record.Cost}' Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Invoice">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewIssueInvoiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_ViewIssueInvoiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_ViewIssueInvoiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="UID"   Binding="{Binding Record.UID}" Width="*"/>
                                        <DataGridTextColumn Header="Date"  Binding='{Binding Record.Date}'  Width="*"/>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Phone" Binding='{Binding Record.Phone}' Width="*"/>
                                        <DataGridTextColumn Header="Email"  Binding='{Binding Record.Email}'  Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                    </TabControl>
                    <GroupBox Grid.Row="2" Header="[Client]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_ViewIssueAddClient" IsEnabled="False"/>
                            <ComboBox Grid.Column="1" Name="_ViewIssueClientList"/>
                            <Button Grid.Column="2" Content="-" Name="_ViewIssueRemoveClient" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Device]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_ViewIssueAddDevice" IsEnabled="False"/>
                            <ComboBox Grid.Column="1" Name="_ViewIssueDeviceList"/>
                            <Button Grid.Column="2" Content="-" Name="_ViewIssueRemoveDevice" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_ViewIssueAddPurchase" IsEnabled="False"/>
                            <ComboBox Grid.Column="1" Name="_ViewIssuePurchaseList"/>
                            <Button Grid.Column="2" Content="-" Name="_ViewIssueRemovePurchase" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Service]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_ViewIssueAddService" IsEnabled="False"/>
                            <ComboBox Grid.Column="1" Name="_ViewIssueServiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_ViewIssueRemoveService" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_ViewIssueAddInvoice" IsEnabled="False"/>
                            <ComboBox Grid.Column="1" Name="_ViewIssueInvoiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_ViewIssueRemoveInvoice" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p4_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="200"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Status]">
                            <ComboBox Name="_EditIssueStatus"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Description]">
                            <TextBox Name="_EditIssueDescription"/>
                        </GroupBox>
                    </Grid>
                    <TabControl Grid.Row="1" Name="_EditIssueTabControl">
                        <TabItem Header="Client">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditIssueClientSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditIssueClientSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_EditIssueClientSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Last"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="First" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="MI"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="DOB"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Device">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditIssueDeviceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditIssueDeviceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_EditIssueDeviceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.Vendor}'  Width="*"/>
                                        <DataGridTextColumn Header="Model"  Binding='{Binding Record.Model}'  Width="*"/>
                                        <DataGridTextColumn Header="Spec."  Binding='{Binding Record.Specification}' Width="*"/>
                                        <DataGridTextColumn Header="Serial" Binding='{Binding Record.Serial}'    Width="*"/>
                                        <DataGridTextColumn Header="Title"  Binding='{Binding Record.Title}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Purchase">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditIssuePurchaseSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditIssuePurchaseSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_EditIssuePurchaseSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Distributor"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="DisplayName"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="Serial"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                        <DataGridTextColumn Header="Device" Binding='{Binding Record.IsDevice}' Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Service">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditIssueServiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditIssueServiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_EditIssueServiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Description"  Binding='{Binding Record.Description}'  Width="*"/>
                                        <DataGridTextColumn Header="Cost" Binding='{Binding Record.Cost}' Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Invoice">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditIssueInvoiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditIssueInvoiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_EditIssueInvoiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="UID"   Binding="{Binding Record.UID}" Width="*"/>
                                        <DataGridTextColumn Header="Date"  Binding='{Binding Record.Date}'  Width="*"/>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Phone" Binding='{Binding Record.Phone}' Width="*"/>
                                        <DataGridTextColumn Header="Email"  Binding='{Binding Record.Email}'  Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                    </TabControl>
                    <GroupBox Grid.Row="2" Header="[Client]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_EditIssueAddClient"/>
                            <ComboBox Grid.Column="1" Name="_EditIssueClientList"/>
                            <Button Grid.Column="2" Content="-" Name="_EditIssueRemoveClient"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Device]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_EditIssueAddDevice"/>
                            <ComboBox Grid.Column="1" Name="_EditIssueDeviceList"/>
                            <Button Grid.Column="2" Content="-" Name="_EditIssueRemoveDevice"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_EditIssueAddPurchase"/>
                            <ComboBox Grid.Column="1" Name="_EditIssuePurchaseList"/>
                            <Button Grid.Column="2" Content="-" Name="_EditIssueRemovePurchase"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Service]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_EditIssueAddService"/>
                            <ComboBox Grid.Column="1" Name="_EditIssueServiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_EditIssueRemoveService"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_EditIssueAddInvoice"/>
                            <ComboBox Grid.Column="1" Name="_EditIssueInvoiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_EditIssueRemoveInvoice"/>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p4_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="200"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Status]">
                            <ComboBox Name="_NewIssueStatus" SelectedIndex="0">
                                <ComboBoxItem Content="New"/>
                                <ComboBoxItem Content="Diagnosed"/>
                                <ComboBoxItem Content="Commit"/>
                                <ComboBoxItem Content="Complete"/>
                            </ComboBox>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Description]">
                            <TextBox Name="_NewIssueDescription"/>
                        </GroupBox>
                    </Grid>
                    <TabControl Grid.Row="1" Name="_NewIssueTabControl">
                        <TabItem Header="Client">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewIssueClientSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewIssueClientSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_NewIssueClientSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Last"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="First" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="MI"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="DOB"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Device">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewIssueDeviceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewIssueDeviceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_NewIssueDeviceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.Vendor}'  Width="*"/>
                                        <DataGridTextColumn Header="Model"  Binding='{Binding Record.Model}'  Width="*"/>
                                        <DataGridTextColumn Header="Spec."  Binding='{Binding Record.Specification}' Width="*"/>
                                        <DataGridTextColumn Header="Serial" Binding='{Binding Record.Serial}'    Width="*"/>
                                        <DataGridTextColumn Header="Title"  Binding='{Binding Record.Title}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Purchase">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewIssuePurchaseSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewIssuePurchaseSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_NewIssuePurchaseSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Distributor"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="DisplayName"  Binding='{Binding Record.Last}'  Width="*"/>
                                        <DataGridTextColumn Header="Vendor" Binding='{Binding Record.First}' Width="*"/>
                                        <DataGridTextColumn Header="Serial"    Binding='{Binding Record.MI}'    Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                        <DataGridTextColumn Header="Device" Binding='{Binding Record.IsDevice}' Width="*"/>
                                        <DataGridTextColumn Header="Model"   Binding='{Binding Record.DOB}'   Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Service">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewIssueServiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewIssueServiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_NewIssueServiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Description"  Binding='{Binding Record.Description}'  Width="*"/>
                                        <DataGridTextColumn Header="Cost" Binding='{Binding Record.Cost}' Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                        <TabItem Header="Invoice">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="50"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0" Margin="5">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="150"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewIssueInvoiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewIssueInvoiceSearchFilter"/>
                                </Grid>
                                <DataGrid Grid.Row="1" Name="_NewIssueInvoiceSearchResult">
                                    <DataGrid.Columns>
                                        <DataGridTextColumn Header="UID"   Binding="{Binding Record.UID}" Width="*"/>
                                        <DataGridTextColumn Header="Date"  Binding='{Binding Record.Date}'  Width="*"/>
                                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                                        <DataGridTextColumn Header="Phone" Binding='{Binding Record.Phone}' Width="*"/>
                                        <DataGridTextColumn Header="Email"  Binding='{Binding Record.Email}'  Width="*"/>
                                    </DataGrid.Columns>
                                </DataGrid>
                            </Grid>
                        </TabItem>
                    </TabControl>
                    <GroupBox Grid.Row="2" Header="[Client]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_NewIssueAddClient"/>
                            <ComboBox Grid.Column="1" Name="_NewIssueClientList"/>
                            <Button Grid.Column="2" Content="-" Name="_NewIssueRemoveClient"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Device]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_NewIssueAddDevice"/>
                            <ComboBox Grid.Column="1" Name="_NewIssueDeviceList"/>
                            <Button Grid.Column="2" Content="-" Name="_NewIssueRemoveDevice"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_NewIssueAddPurchase"/>
                            <ComboBox Grid.Column="1" Name="_NewIssuePurchaseList"/>
                            <Button Grid.Column="2" Content="-" Name="_NewIssueRemovePurchase"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Service]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_NewIssueAddService"/>
                            <ComboBox Grid.Column="1" Name="_NewIssueServiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_NewIssueRemoveService"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="6" Header="[Invoice]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <Button Grid.Column="0" Content="+" Name="_NewIssueAddInvoice"/>
                            <ComboBox Grid.Column="1" Name="_NewIssueInvoiceList"/>
                            <Button Grid.Column="2" Content="-" Name="_NewIssueRemoveInvoice"/>
                        </Grid>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p5" Visibility="Collapsed">
                <Grid Name="p5_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetInventorySearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetInventorySearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetInventorySearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor"     Binding='{Binding Record.Vendor}'   Width="*"/>
                            <DataGridTextColumn Header="Serial"     Binding='{Binding Record.Serial}'   Width="*"/>
                            <DataGridTextColumn Header="Model"      Binding='{Binding Record.Model}'    Width="*"/>
                            <DataGridTextColumn Header="Title"      Binding='{Binding Record.Title}'    Width="2*"/>
                            <DataGridTemplateColumn Header="Device" Width="60">
                                <DataGridTemplateColumn.CellTemplate>
                                    <DataTemplate>
                                        <ComboBox SelectedIndex='{Binding Record.IsDevice}'>
                                            <ComboBoxItem Content="N"/>
                                            <ComboBoxItem Content="Y"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </DataTemplate>
                                </DataGridTemplateColumn.CellTemplate>
                            </DataGridTemplateColumn>
                            <DataGridTextColumn Header="Cost"  Binding='{Binding Record.Cost}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p5_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_ViewInventoryVendor" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_ViewInventoryModel" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Serial]">
                            <TextBox Name="_ViewInventorySerial" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Title]">
                            <TextBox Name="_ViewInventoryTitle" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Cost]">
                            <TextBox Name="_ViewInventoryCost" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="1" Name="_ViewInventoryIsDevice" IsEnabled="False">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_ViewInventoryDeviceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="2" Name="_ViewInventoryDeviceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInventoryDeviceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewInventoryAddDevice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewInventoryDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewInventoryRemoveDevice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p5_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_EditInventoryVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_EditInventoryModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Serial]">
                            <TextBox Name="_EditInventorySerial"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Title]">
                            <TextBox Name="_EditInventoryTitle"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Cost]">
                            <TextBox Name="_EditInventoryCost"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="1" Name="_EditInventoryIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_EditInventoryDeviceSearchProperty"/>
                                <TextBox Grid.Column="2" Name="_EditInventoryDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditInventoryDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditInventoryAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_EditInventoryDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditInventoryRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p5_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_NewInventoryVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_NewInventoryModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Serial]">
                            <TextBox Name="_NewInventorySerial"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Title]">
                            <TextBox Name="_NewInventoryTitle"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Cost]">
                            <TextBox Name="_NewInventoryCost"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="2" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="1" Name="_NewInventoryIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_NewInventoryDeviceSearchProperty"/>
                                <TextBox Grid.Column="2" Name="_NewInventoryDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewInventoryDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewInventoryAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_NewInventoryDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewInventoryRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p6" Visibility="Collapsed">
                <Grid Name="p6_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetPurchaseSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetPurchaseSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetPurchaseSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Distributor"  Binding='{Binding Record.Distributor}' Width="*"/>
                            <DataGridTextColumn Header="DisplayName"  Binding='{Binding Record.DisplayName}' Width="*"/>
                            <DataGridTextColumn Header="Vendor"       Binding='{Binding Record.Vendor}'      Width="*"/>
                            <DataGridTextColumn Header="Serial"       Binding='{Binding Record.Serial}'      Width="2*"/>
                            <DataGridTextColumn Header="Model"        Binding='{Binding Record.Model}'       Width="*"/>
                            <DataGridTemplateColumn Header="Device"   Width="60">
                                <DataGridTemplateColumn.CellTemplate>
                                    <DataTemplate>
                                        <ComboBox SelectedIndex='{Binding Record.IsDevice}'>
                                            <ComboBoxItem Content="N"/>
                                            <ComboBoxItem Content="Y"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </DataTemplate>
                                </DataGridTemplateColumn.CellTemplate>
                            </DataGridTemplateColumn>
                            <DataGridTextColumn Header="Cost"  Binding='{Binding Record.Cost}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p6_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Distributor]">
                        <TextBox Name="_ViewPurchaseDistributor" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_ViewPurchaseDisplayName" IsEnabled="False"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_ViewPurchaseVendor" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_ViewPurchaseModel" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Specification]">
                            <TextBox Name="_ViewPurchaseSpecification" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="3" Header="[Serial]">
                        <TextBox Name="_ViewPurchaseSerial" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="1" Name="_ViewPurchaseIsDevice" IsEnabled="False">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_ViewPurchaseDeviceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="2" Name="_ViewPurchaseDeviceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewPurchaseDeviceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewPurchaseAddDevice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewPurchaseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewPurchaseRemoveDevice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Cost]">
                        <TextBox Name="_ViewPurchaseCost" IsEnabled="False"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p6_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Distributor]">
                        <TextBox Name="_EditPurchaseDistributor"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_EditPurchaseDisplayName"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_EditPurchaseVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_EditPurchaseModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Specification]">
                            <TextBox Name="_EditPurchaseSpecification"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="3" Header="[Serial]">
                        <TextBox Name="_EditPurchaseSerial"/>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="1" Name="_EditPurchaseIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_EditPurchaseDeviceSearchProperty"/>
                                <TextBox Grid.Column="2" Name="_EditPurchaseDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditPurchaseDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditPurchaseAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_EditPurchaseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditPurchaseRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Cost]">
                        <TextBox Name="_EditPurchaseCost"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p6_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Distributor]">
                        <TextBox Name="_NewPurchaseDistributor"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_NewPurchaseDisplayName"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="2*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Vendor]">
                            <TextBox Name="_NewPurchaseVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Model]">
                            <TextBox Name="_NewPurchaseModel"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Specification]">
                            <TextBox Name="_NewPurchaseSpecification"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="3" Header="[Serial]">
                        <TextBox Name="_NewPurchaseSerial"/>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Device]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="60"/>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_NewPurchaseIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="1" Name="_NewPurchaseDeviceSearchProperty"/>
                                <TextBox Grid.Column="2" Name="_NewPurchaseDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewPurchaseDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewPurchaseAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_NewPurchaseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewPurchaseRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Cost]">
                        <TextBox Name="_NewPurchaseCost"/>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p7" Visibility="Collapsed">
                <Grid Name="p7_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetExpenseSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetExpenseSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetExpenseSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Recipient"    Binding='{Binding Record.Recipient}'   Width="*"/>
                            <DataGridTextColumn Header="DisplayName"  Binding='{Binding Record.DisplayName}' Width="1.5*"/>
                            <DataGridTextColumn Header="Account"      Binding='{Binding Record.Account}'     Width="*"/>
                            <DataGridTextColumn Header="Cost"         Binding='{Binding Record.Cost}'        Width="0.5*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p7_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Recipient]">
                        <TextBox Name="_ViewExpenseRecipient" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_ViewExpenseDisplayName" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Account]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_ViewExpenseIsDevice" IsEnabled="False">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="0" Name="_ViewExpenseDeviceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewExpenseDeviceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewExpenseDeviceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewExpenseAddDevice" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewExpenseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewExpenseRemoveDevice" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Cost]">
                        <TextBox Name="_ViewExpenseCost" IsEnabled="False"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p7_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Recipient]">
                        <TextBox Name="_EditExpenseRecipient"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_EditExpenseDisplayName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Account]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_EditExpenseIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_EditExpenseDeviceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditExpenseDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditExpenseDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditExpenseAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_EditExpenseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditExpenseRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Cost]">
                        <TextBox Name="_EditExpenseCost"/>
                    </GroupBox>
                </Grid>
                <Grid Name="p7_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="70"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Recipient]">
                        <TextBox Name="_NewExpenseRecipient"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Display Name]">
                        <TextBox Name="_NewExpenseDisplayName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Account]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_NewExpenseIsDevice">
                                    <ComboBoxItem Content="No"/>
                                    <ComboBoxItem Content="Yes"/>
                                </ComboBox>
                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="_NewExpenseDeviceSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewExpenseDeviceSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewExpenseDeviceSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewExpenseAddDevice"/>
                                <ComboBox Grid.Column="2" Name="_NewExpenseDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewExpenseRemoveDevice"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Cost]">
                        <TextBox Name="_NewExpenseCost"/>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p8" Visibility="Collapsed">
                <Grid Name="p8_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetAccountSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetAccountSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetAccountSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Object"  Binding='{Binding Record.Object}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p8_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Column="0" Header="[Object]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewAccountObjectSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewAccountObjectSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewAccountObjectSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewAccountAddObject" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewAccountDeviceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewAccountRemoveObject" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p8_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Column="0" Header="[Object]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditAccountObjectSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_EditAccountObjectSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditAccountObjectSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_EditAccountAddObject"/>
                                <ComboBox Grid.Column="2" Name="_EditAccountObjectList"/>
                                <Button Grid.Column="3" Content="-" Name="_EditAccountRemoveObject"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p8_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Column="0" Header="[Object]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewAccountObjectSearchProperty"/>
                                <TextBox Grid.Column="1" Name="_NewAccountObjectSearchFilter"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewAccountObjectSearchResult"/>
                                <Button Grid.Column="1" Content="+" Name="_NewAccountAddObject"/>
                                <ComboBox Grid.Column="2" Name="_NewAccountObjectList"/>
                                <Button Grid.Column="3" Content="-" Name="_NewAccountRemoveObject"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
            </Grid>
            <Grid Grid.Row="1" Name="p9" Visibility="Collapsed">
                <Grid Name="p9_x0" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetInvoiceSearchProperty"/>
                        <TextBox Grid.Column="1" Name="_GetInvoiceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetInvoiceSearchResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Date" Binding="{Binding Record.Date}" Width="*"/>
                            <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                            <DataGridTextColumn Header="Phone"  Binding='{Binding Record.Last}'  Width="*"/>
                            <DataGridTextColumn Header="Email" Binding='{Binding Record.First}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
                <Grid Name="p9_x1" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                        <RowDefinition Height="105"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Mode]">
                        <ComboBox Name="_ViewInvoiceMode" IsEnabled="False"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Client]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceClientSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewInvoiceClientSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceClientSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewInvoiceAddClient" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewInvoiceClientList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewInvoiceRemoveClient" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Inventory]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceInventorySearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewInvoiceInventorySearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceInventorySearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewInvoiceAddInventory" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewInvoiceInventoryList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewInvoiceRemoveInventory" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Service]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceServiceSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewInvoiceServiceSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceServiceSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewInvoiceAddService" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewInvoiceServiceList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewInvoiceRemoveService" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="4" Header="[Purchase]">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoicePurchaseSearchProperty" IsEnabled="False"/>
                                <TextBox Grid.Column="1" Name="_ViewInvoicePurchaseSearchFilter" IsEnabled="False"/>
                            </Grid>
                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoicePurchaseSearchResult" IsEnabled="False"/>
                                <Button Grid.Column="1" Content="+" Name="_ViewInvoiceAddPurchase" IsEnabled="False"/>
                                <ComboBox Grid.Column="2" Name="_ViewInvoicePurchaseList"/>
                                <Button Grid.Column="3" Content="-" Name="_ViewInvoiceRemovePurchase" IsEnabled="False"/>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                <Grid Name="p9_x2" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Mode]">
                            <ComboBox Name="_EditInvoiceMode"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Client]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceClientSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditInvoiceClientSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceClientSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_EditInvoiceAddClient"/>
                                    <ComboBox Grid.Column="2" Name="_EditInvoiceClientList"/>
                                    <Button Grid.Column="3" Content="-" Name="_EditInvoiceRemoveClient"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Inventory]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceInventorySearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditInvoiceInventorySearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceInventorySearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_EditInvoiceAddInventory"/>
                                    <ComboBox Grid.Column="2" Name="_EditInvoiceInventoryList"/>
                                    <Button Grid.Column="3" Content="-" Name="_EditInvoiceRemoveInventory"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Service]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceServiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditInvoiceServiceSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoiceServiceSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_EditInvoiceAddService"/>
                                    <ComboBox Grid.Column="2" Name="_EditInvoiceServiceList"/>
                                    <Button Grid.Column="3" Content="-" Name="_EditInvoiceRemoveService"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoicePurchaseSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_EditInvoicePurchaseSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditInvoicePurchaseSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_EditInvoiceAddPurchase"/>
                                    <ComboBox Grid.Column="2" Name="_EditInvoicePurchaseList"/>
                                    <Button Grid.Column="3" Content="-" Name="_EditInvoiceRemovePurchase"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateInvoiceRecord" Content="Save"/>
                </Grid>
                <Grid Name="p9_x3" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="40"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                            <RowDefinition Height="105"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Mode]">
                            <ComboBox Name="_NewInvoiceMode"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Client]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceClientSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewInvoiceClientSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceClientSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_NewInvoiceAddClient"/>
                                    <ComboBox Grid.Column="2" Name="_NewInvoiceClientList"/>
                                    <Button Grid.Column="3" Content="-" Name="_NewInvoiceRemoveClient"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Inventory]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceInventorySearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewInvoiceInventorySearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceInventorySearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_NewInvoiceAddInventory"/>
                                    <ComboBox Grid.Column="2" Name="_NewInvoiceInventoryList"/>
                                    <Button Grid.Column="3" Content="-" Name="_NewInvoiceRemoveInventory"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Service]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceServiceSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewInvoiceServiceSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoiceServiceSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_NewInvoiceAddService"/>
                                    <ComboBox Grid.Column="2" Name="_NewInvoiceServiceList"/>
                                    <Button Grid.Column="3" Content="-" Name="_NewInvoiceRemoveService"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="*"/>
                                    <RowDefinition Height="*"/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row="0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="120"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoicePurchaseSearchProperty"/>
                                    <TextBox Grid.Column="1" Name="_NewInvoicePurchaseSearchFilter"/>
                                </Grid>
                                <Grid Grid.Row="1">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewInvoicePurchaseSearchResult"/>
                                    <Button Grid.Column="1" Content="+" Name="_NewInvoiceAddPurchase"/>
                                    <ComboBox Grid.Column="2" Name="_NewInvoicePurchaseList"/>
                                    <Button Grid.Column="3" Content="-" Name="_NewInvoiceRemovePurchase"/>
                                </Grid>
                            </Grid>
                        </GroupBox>
                    </Grid>
                </Grid>
            </Grid>
        </Grid>
    </Grid>
</Window>
"@
    $Cim  = [Cimdb]::New($Xaml)

   
    $Cim.SetDefaults()

    # --------- #
    # UID Panel #
    # --------- #
    
    $Cim.IO.T0.Add_Click{ $Cim.GetTab(0) }
    $Cim.IO.T1.Add_Click{ $Cim.GetTab(1) }
    $Cim.IO.T2.Add_Click{ $Cim.GetTab(2) }
    $Cim.IO.T3.Add_Click{ $Cim.GetTab(3) }
    $Cim.IO.T4.Add_Click{ $Cim.GetTab(4) }
    $Cim.IO.T5.Add_Click{ $Cim.GetTab(5) }
    $Cim.IO.T6.Add_Click{ $Cim.GetTab(6) }
    $Cim.IO.T7.Add_Click{ $Cim.GetTab(7) }
    $Cim.IO.T8.Add_Click{ $Cim.GetTab(8) }
    $Cim.IO.T9.Add_Click{ $Cim.GetTab(9) }


    # --------- #
    # UID Panel #
    # --------- #

    $Cim.IO._GetUIDSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(0)
        $Cim.ViewUID($Cim.IO._GetUIDSearchResult.SelectedItem.UID)
    })

    # ------------ #
    # Client Panel #
    # ------------ #

    $Cim.IO._GetClientSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(1)
        $Cim.ViewClient($Cim.IO._GetClientSearchResult.SelectedItem.UID)
        $Cim.IO._EditClientTab.IsEnabled = 1
        $Cim.IO._NewClientTab.IsEnabled  = 1
        $Cim.IO._SaveClientTab.IsEnabled = 0
    })

    $Cim.IO._EditClientTab.Add_Click(
    {
        $Cim.EditTab(1)
        $Cim.IO._EditClientPhoneList.ItemsSource = $Null
        $Cim.IO._EditClientEmailList.ItemsSource = $Null
        $Cim.IO._EditClientDeviceList.ItemsSource = $Null
        $Cim.IO._EditClientInvoiceList.ItemsSource = $Null

        $Cim.EditClient($Cim.IO._GetClientSearchResult.SelectedItem.UID)
        $Cim.IO._EditClientTab.IsEnabled = 0
        $Cim.IO._NewClientTab.IsEnabled  = 1
        $Cim.IO._SaveClientTab.IsEnabled = 1
    })

    $Cim.IO._NewClientTab.Add_Click(
    { 
        $Cim.NewTab(1)
        $Cim.IO._NewClientPhoneList.ItemsSource = $Null
        $Cim.IO._NewClientEmailList.ItemsSource = $Null
        $Cim.IO._NewClientDeviceList.ItemsSource = $Null
        $Cim.IO._NewClientInvoiceList.ItemsSource = $Null

        $Cim.IO._EditClientTab.IsEnabled = 0
        $Cim.IO._NewClientTab.IsEnabled  = 0
        $Cim.IO._SaveClientTab.IsEnabled = 1
    })

    # -------------------------

    $Cim.IO._EditClientAddPhone.Add_Click(
    {
        $Item   = $Cim.IO._EditClientPhoneText.Text.ToString() -Replace "-",""
        $String = "{0}{1}{2}-{3}{4}{5}-{6}{7}{8}{9}" -f $Item[0..9]

        If ( $Item.Length -ne 10 -or $Item -notmatch "(\d{10})" )
        {
            [System.Windows.MessageBox]::Show("Invalid phone number","Error")
        }

        ElseIf ( $String -in $Cim.IO._EditClientPhoneList.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate phone number","Error")
        }

        ElseIf ($String -in $Cim.DB.Client.Record.Phone)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO._EditClientPhoneList.Items.Add($String)
            $Cim.IO._EditClientPhoneList.SelectedIndex = ($Cim.IO._EditClientPhoneList.Count - 1)
            $Cim.IO._EditClientPhoneText.Text,$Item,$String = $Null
        }
    })

    $Cim.IO._EditClientRemovePhone.Add_Click{

        If ( $Cim.IO._EditClientPhoneList.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No phone number to remove","Error")
        }

        ElseIf( $Cim.IO._EditClientPhoneList.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another phone number before removing","Error")
        }

        Else
        {
            $Cim.IO._EditClientPhoneList.Items.Remove($Cim.IO._EditClientPhoneList.SelectedItem)
        }
    }

    $Cim.IO._EditClientAddEmail.Add_Click{
        
        $Item = $Cim.IO._EditClientEmailText.Text

        If ( $Item -notmatch "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        {
            [System.Windows.MessageBox]::Show("Invalid Email Address","Error")
        }

        ElseIf ( $Item -in $Cim.IO._EditClientEmailList.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate email address","Error")
        }

        ElseIf ($Item -in $Cim.DB.Client.Record.Email)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO._EditClientEmailList.Items.Add($Item)
            $Cim.IO._EditClientEmailList.SelectedIndex = ($Cim.IO._EditClientEmailList.Count - 1)
            $Cim.IO._EditClientEmailText.Text,$Item = $Null
        }
    }

    $Cim.IO._EditClientRemoveEmail.Add_Click{
        
        If ( $Cim.IO._EditClientEmailList.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No email address to remove","Error")
        }

        ElseIf( $Cim.IO._EditClientEmailList.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another email address before removing","Error")
        }

        Else
        {
            $Cim.IO._EditClientEmailList.Items.Remove($Cim.IO._EditClientEmailList.SelectedItem)
        }
    }

    $Cim.IO._NewClientAddPhone.Add_Click{

        $Item   = $Cim.IO._NewClientPhoneText.Text.ToString() -Replace "-",""
        $String = "{0}{1}{2}-{3}{4}{5}-{6}{7}{8}{9}" -f $Item[0..9]

        If ( $Item.Length -ne 10 -or $Item -notmatch "(\d{10})" )
        {
            [System.Windows.MessageBox]::Show("Invalid phone number","Error")
        }

        ElseIf ( $String -in $Cim.IO._NewClientPhoneList.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate phone number","Error")
        }

        ElseIf ($String -in $Cim.DB.Client.Record.Phone)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO._NewClientPhoneList.Items.Add($String)
            $Cim.IO._NewClientPhoneList.SelectedIndex = ($Cim.IO._NewClientPhoneList.Count - 1)
            $Cim.IO._NewClientPhoneText.Text,$Item,$String = $Null
        }
    }

    $Cim.IO._NewClientRemovePhone.Add_Click{

        If ( $Cim.IO._NewClientPhoneList.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No phone number to remove","Error")
        }

        ElseIf( $Cim.IO._NewClientPhoneList.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another phone number before removing","Error")
        }

        Else
        {
            $Cim.IO._NewClientPhoneList.Items.Remove($Cim.IO._NewClientPhoneList.SelectedItem)
        }
    }

    $Cim.IO._NewClientAddEmail.Add_Click{
        
        $Item = $Cim.IO._NewClientEmailText.Text

        If ( $Item -notmatch "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        {
            [System.Windows.MessageBox]::Show("Invalid Email Address","Error")
        }

        ElseIf ( $Item -in $Cim.IO._NewClientEmailList.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate email address","Error")
        }

        ElseIf ($Item -in $Cim.DB.Client.Record.Email)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO._NewClientEmailList.Items.Add($Item)
            $Cim.IO._NewClientEmailList.SelectedIndex = ($Cim.IO._NewClientEmailList.Count - 1)
            $Cim.IO._NewClientEmailText.Text,$Item = $Null
        }
    }

    $Cim.IO._EditClientAddEmail.Add_Click{
        
        $Item = $Cim.IO._EditClientEmailText.Text

        If ( $Item -notmatch "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        {
            [System.Windows.MessageBox]::Show("Invalid Email Address","Error")
        }

        ElseIf ( $Item -in $Cim.IO._EditClientEmailList.Items )
        {
            [System.Windows.MessageBox]::Show("Duplicate email address","Error")
        }

        ElseIf ($Item -in $Cim.DB.Client.Record.Email)
        {
            [System.Windows.MessageBox]::Show("Phone number belongs to another record","Error")
        }

        Else
        {
            $Cim.IO._EditClientEmailList.Items.Add($Item)
            $Cim.IO._EditClientEmailList.SelectedIndex = ($Cim.IO._EditClientEmailList.Count - 1)
            $Cim.IO._EditClientEmailText.Text,$Item = $Null
        }
    }

    $Cim.IO._NewClientRemoveEmail.Add_Click{
        
        If ( $Cim.IO._NewClientEmailList.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No email address to remove","Error")
        }

        ElseIf( $Cim.IO._NewClientEmailList.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another email address before removing","Error")
        }

        Else
        {
            $Cim.IO._NewClientEmailList.Items.Remove($Cim.IO._NewClientEmailList.SelectedItem)
        }
    }

    $Cim.IO._EditClientRemoveEmail.Add_Click{
        
        If ( $Cim.IO._EditClientEmailList.Items.Count -eq 0)
        {
            [System.Windows.MessageBox]::Show("No email address to remove","Error")
        }

        ElseIf( $Cim.IO._EditClientEmailList.Items.Count -eq 1)
        {
            [System.Windows.MessageBox]::Show("Add another email address before removing","Error")
        }

        Else
        {
            $Cim.IO._EditClientEmailList.Items.Remove($Cim.IO._EditClientEmailList.SelectedItem)
        }
    }

    $Cim.IO._NewClientAddDevice.Add_Click(
    {
        If ( $Cim.IO._NewClientDeviceSearchResult.Items.Count -eq 0 )
        {
            [System.Windows.MessageBox]::Show("No device listed to add","Error")
        }
    })

    $Cim.IO._SaveClientTab.Add_Click(
    {
        If ( $Cim.IO._GetClientSearchResult.SelectedIndex -eq -1 )
        {
            $Name = "{0}, {1}" -f $Cim.IO._NewClientLast.Text, $Cim.IO._NewClientFirst.Text 
            
            If ( $Cim.IO._NewClientMI.Text -eq "" )
            {
                $Full = $Name
            }

            If ( $Cim.IO._NewClientMI.Text -ne "" )
            {
                $Full = "{0} {1}." -f $Name, $Cim.IO._NewClientMI.Text.TrimEnd(".")
            }

            $DOB  = "{0:d2}/{1:d2}/{2:d4}" -f $Cim.IO._NewClientMonth.Text, $Cim.IO._NewClientDay.Text, $Cim.IO._NewClientYear.Text

            If ($Cim.IO._NewClientLast.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Last name missing","Error")
            }

            ElseIf ($Cim.IO._NewClientFirst.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("First name missing","Error")
            }

            ElseIf ($Full -in $Cim.DB.Client.Record.Name -and $DOB -in $Cim.DB.Client.Record.DOB)
            {
                [System.Windows.MessageBox]::Show("Client account exists","Error")
            }

            ElseIf ($Cim.IO._NewClientAddress.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Address missing","Error")
            }

            ElseIf ($Cim.IO._NewClientCity.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("City missing","Error")
            }

            ElseIf ($Cim.IO._NewClientPostal.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Zip code missing","Error")
            }

            ElseIf ($Cim.IO._NewClientMonth.Text -notin 1..12)
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Month","Error")
            }

            ElseIf ($Cim.IO._NewClientDay.Text -notin 1..31)
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Day","Error")
            }

            ElseIf ($Cim.IO._NewClientYear.Text.Length -lt 4 )
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Year","Error")
            }

            ElseIf ($Cim.IO._NewClientGender.SelectedIndex -notin 0..1)
            {
                [System.Windows.MessageBox]::Show("Invalid Gender","Error")
            }

            ElseIf ($Cim.IO._NewClientPhoneList.Items[0] -eq $Null)
            {
                [System.Windows.MessageBox]::Show("No phone number","Error")
            }

            ElseIf ($Cim.IO._NewClientEmailList.Items[0] -eq $Null)
            {
                [System.Windows.MessageBox]::Show("No email","Error")
            }

            Else
            {
                $Item                 = $Cim.NewUID(0)
                $Cim.Refresh()
                $Item.Record.First    = $Cim.IO._NewClientFirst.Text.ToUpper()
                $Item.Record.MI       = $Cim.IO._NewClientMI.Text.ToUpper()
                $Item.Record.Last     = $Cim.IO._NewClientLast.Text.ToUpper()
                $Item.Record.Name     = $Full.ToUpper()
                $Item.Record.Address  = $Cim.IO._NewClientAddress.Text.ToUpper()
                $Item.Record.City     = $Cim.IO._NewClientCity.Text.ToUpper()
                $Item.Record.Region   = $Cim.IO._NewClientRegion.Text.ToUpper()
                $Item.Record.Country  = $Cim.IO._NewClientCountry.Text.ToUpper()
                $Item.Record.Postal   = $Cim.IO._NewClientPostal.Text
                $Item.Record.Month    = $Cim.IO._NewClientMonth.Text
                $Item.Record.Day      = $Cim.IO._NewClientDay.Text
                $Item.Record.Year     = $Cim.IO._NewClientYear.Text
                $Item.Record.DOB      = $DOB
                $Item.Record.Gender   = $Cim.IO._NewClientGender.SelectedItem.Content
                $Item.Record.Phone    = $Cim.IO._NewClientPhoneList.Items
                $Item.Record.Email    = $Cim.IO._NewClientEmailList.Items
                $Item.Record.Device   = $Cim.IO._NewClientDeviceList.Items
                $Item.Record.Invoice  = $Cim.IO._NewClientInvoiceList.Items

                [System.Windows.MessageBox]::Show("Client [$($Item.Record.Name)] added to database","Success")

                $Cim.GetTab(1)
            }
        }

        If ( $Cim.IO._GetClientSearchResult.SelectedIndex -ne -1 )
        {
            $Name = "{0}, {1}" -f $Cim.IO._EditClientLast.Text, $Cim.IO._EditClientLast.Text

            If ( $Cim.IO._EditClientMI.Text -eq "")
            {
                $Full = $Name
            }

            If ( $Cim.IO._EditClientMI.Text -ne "" )
            {
                $Full = "{0} {1}." -f $Name, $Cim.IO._EditClientMI.Text.TrimEnd(".")
            }

            $DOB  = "{0:d2}/{1:d2}/{2:d4}" -f $Cim.IO._EditClientMonth.Text, $Cim.IO._EditClientDay.Text, $Cim.IO._EditClientYear.Text

            If ($Cim.IO._EditClientLast.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Last name missing","Error")
            }

            ElseIf ($Cim.IO._EditClientFirst.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("First name missing","Error")
            }

            ElseIf ($Full -in $Cim.DB.Client.Record.Name -and $DOB -in $Cim.DB.Client.Record.DOB)
            {
                [System.Windows.MessageBox]::Show("Client account exists","Error")
            }

            ElseIf ($Cim.IO._EditClientAddress.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Address missing","Error")
            }

            ElseIf ($Cim.IO._EditClientCity.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("City missing","Error")
            }

            ElseIf ($Cim.IO._EditClientPostal.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Zip code missing","Error")
            }

            ElseIf ($Cim.IO._EditClientMonth.Text -notin 1..12)
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Month","Error")
            }

            ElseIf ($Cim.IO._EditClientDay.Text -notin 1..31)
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Day","Error")
            }

            ElseIf ($Cim.IO._EditClientYear.Text.Length -lt 4 )
            {
                [System.Windows.MessageBox]::Show("Invalid DOB.Year","Error")
            }

            ElseIf ($Cim.IO._EditClientGender.SelectedIndex -notin 0..1)
            {
                [System.Windows.MessageBox]::Show("Invalid Gender","Error")
            }

            ElseIf ($Cim.IO._EditClientPhoneList.Items[0] -eq $Null)
            {
                [System.Windows.MessageBox]::Show("No phone number","Error")
            }

            ElseIf ($Cim.IO._EditClientEmailList.Items[0] -eq $Null)
            {
                [System.Windows.MessageBox]::Show("No email","Error")
            }

            Else
            {
                $Item                 = $Cim.NewUID(0)
                $Cim.Refresh()
                $Item.Record.First    = $Cim.IO._EditClientFirst.Text.ToUpper()
                $Item.Record.MI       = $Cim.IO._EditClientMI.Text.ToUpper()
                $Item.Record.Last     = $Cim.IO._EditClientLast.Text.ToUpper()
                $Item.Record.Name     = $Full.ToUpper()
                $Item.Record.Address  = $Cim.IO._EditClientAddress.Text.ToUpper()
                $Item.Record.City     = $Cim.IO._EditClientCity.Text.ToUpper()
                $Item.Record.Region   = $Cim.IO._EditClientRegion.Text.ToUpper()
                $Item.Record.Country  = $Cim.IO._EditClientCountry.Text.ToUpper()
                $Item.Record.Postal   = $Cim.IO._EditClientPostal.Text
                $Item.Record.Month    = $Cim.IO._EditClientMonth.Text
                $Item.Record.Day      = $Cim.IO._EditClientDay.Text
                $Item.Record.Year     = $Cim.IO._EditClientYear.Text
                $Item.Record.DOB      = $DOB
                $Item.Record.Gender   = $Cim.IO._EditClientGender.SelectedItem.Content
                $Item.Record.Phone    = $Cim.IO._EditClientPhoneList.Items
                $Item.Record.Email    = $Cim.IO._EditClientEmailList.Items
                $Item.Record.Device   = $Cim.IO._EditClientDeviceList.Items
                $Item.Record.Invoice  = $Cim.IO._EditClientInvoiceList.Items

                [System.Windows.MessageBox]::Show("Client [$($Item.Record.Name)] added to database","Success")

                $Cim.GetTab(1)
            }
        }
    })

    # ------------- #
    # Service Panel #
    # ------------- #

    $Cim.IO._GetServiceSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(2)
        $Cim.ViewService($Cim.IO._GetServiceSearchResult.SelectedItem.UID)
        $Cim.IO._EditServiceTab.IsEnabled = 1
        $Cim.IO._NewServiceTab.IsEnabled  = 1
        $Cim.IO._SaveServiceTab.IsEnabled = 0
    })

    $Cim.IO._EditServiceTab.Add_Click(
    {
        $Cim.EditTab(2)
        $Cim.EditService($Cim.IO._GetServiceSearchResult.SelectedItem.UID)
        $Cim.IO._EditServiceTab.IsEnabled = 0
        $Cim.IO._NewServiceTab.IsEnabled  = 1
        $Cim.IO._SaveServiceTab.IsEnabled = 1
    })

    $Cim.IO._NewServiceTab.Add_Click(
    { 
        $Cim.NewTab(2)
        $Cim.IO._EditServiceTab.IsEnabled = 0
        $Cim.IO._NewServiceTab.IsEnabled  = 0
        $Cim.IO._SaveServiceTab.IsEnabled = 1
    })

    # --------------------

    $Cim.IO._SaveServiceTab.Add_Click(
    {    
        If ( $Cim.IO._GetServiceSearchResult.SelectedIndex -eq -1)
        {
            If ( $Cim.IO._NewServiceName.Text -eq "" )
            {
                [System.Windows.MessageBox]::Show("Invalid service name","Error")
            }

            ElseIf ( $Cim.IO._NewServiceCost.Text -eq "" )
            {
                [System.Windows.MessageBox]::Show("Service cost undefined","Error")
            }

            ElseIf ( $Cim.IO._NewServiceName.Text -in $Cim.DB.Service.Record.Name )
            {
                [System.Windows.MessageBox]::Show("Service exists","Error")
            }

            Else
            {
                $Item                    = $Cim.NewUID(1)
                $Cim.Refresh()
                $Item.Record.Name        = $Cim.IO._NewServiceName.Text
                $Item.Record.Description = $Cim.IO._NewServiceDescription.Text
                $Item.Record.Cost        = "{0:C}" -f [UInt32]$Cim.IO._NewServiceCost.Text

                [System.Windows.MessageBox]::Show("Service [$($Item.Record.Name)] added to database","Success")

                $Cim.IO._NewServiceName.Text        = $Null
                $Cim.IO._NewServiceDescription.Text = $Null
                $Cim.IO._NewServiceCost.Text        = $Null

                $Cim.GetTab(2)
            }
        }

        If ( $Cim.IO._GetServiceSearchResult.SelectedIndex -ne -1)
        {
            If ( $Cim.IO._EditServiceName.Text -eq "" )
            {
                [System.Windows.MessageBox]::Show("Invalid service name","Error")
            }

            ElseIf ( $Cim.IO._EditServiceCost.Text -eq "" )
            {
                [System.Windows.MessageBox]::Show("Service cost undefined","Error")
            }

            ElseIf ( $Cim.IO._EditServiceName.Text -in $Cim.DB.Service.Record.Name )
            {
                [System.Windows.MessageBox]::Show("Service exists","Error")
            }

            Else
            {
                $Item                    = $Cim.NewUID(1)
                $Cim.Refresh()
                $Item.Record.Name        = $Cim.IO._EditServiceName.Text
                $Item.Record.Description = $Cim.IO._EditServiceDescription.Text
                $Item.Record.Cost        = "{0:C}" -f [UInt32]$Cim.IO._EditServiceCost.Text

                [System.Windows.MessageBox]::Show("Service [$($Item.Record.Name)] added to database","Success")

                $Cim.IO._EditServiceName.Text        = $Null
                $Cim.IO._EditServiceDescription.Text = $Null
                $Cim.IO._EditServiceCost.Text        = $Null

                $Cim.GetTab(2)
            }
        }
    })

    # ------------ #
    # Device Panel #
    # ------------ #
    
    $Cim.IO._GetDeviceSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(3)
        $Cim.ViewDevice($Cim.IO._GetDeviceSearchResult.SelectedItem.UID)
        $Cim.IO._EditDeviceTab.IsEnabled = 1
        $Cim.IO._NewDeviceTab.IsEnabled  = 1
        $Cim.IO._SaveDeviceTab.IsEnabled = 0
    })

    $Cim.IO._EditDeviceTab.Add_Click(
    {
        $Cim.EditTab(3)
        $Cim.EditDevice($Cim.IO._GetDeviceSearchResult.SelectedItem.UID)
        $Cim.IO._EditDeviceTab.IsEnabled = 0
        $Cim.IO._NewDeviceTab.IsEnabled  = 1
        $Cim.IO._SaveDeviceTab.IsEnabled = 1
    })

    $Cim.IO._NewDeviceTab.Add_Click(
    { 
        $Cim.NewTab(3)
        $Cim.IO._EditDeviceTab.IsEnabled = 0
        $Cim.IO._NewDeviceTab.IsEnabled  = 0
        $Cim.IO._SaveDeviceTab.IsEnabled = 1
    })

    # -------------------

    $Cim.IO._SaveDeviceTab.Add_Click(
    {    
        If ($Cim.IO._GetDeviceSearchResult.SelectedIndex -eq -1)
        {
            If ($Cim.IO._NewDeviceChassis.SelectedIndex -eq 8)
            {
                [System.Windows.MessageBox]::Show("Select a valid chassis type","Error")
            }

            ElseIf($Cim.IO._NewDeviceVendor.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a vendor","Error")
            }

            ElseIf($Cim.IO._NewDeviceModel.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a model","Error")
            }

            ElseIf($Cim.IO._NewDeviceSpecification.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a model specification OR enter N/A","Error")
            }

            ElseIf($Cim.IO._NewDeviceSerial.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a serial number","Error")
            }

            Else
            {
                $Item                          = $Cim.NewUID(2)
                $Cim.Refresh()
                $Item.Record.Chassis           = $Cim.IO._NewDeviceChassis.SelectedIndex
                $Item.Record.Vendor            = $Cim.IO._NewDeviceVendor.Text
                $Item.Record.Specification     = $Cim.IO._NewDeviceSpecification.Text
                $Item.Record.Serial            = $Cim.IO._NewDeviceSerial.Text
                $Item.Record.Model             = $Cim.IO._NewDeviceModel.Text
                $Item.Record.Title             = $Cim.IO._NewDeviceTitle.Text
                $Item.Record.Client            = $Cim.IO._NewDeviceClientList.Items
                $Item.Record.Issue             = $Cim.IO._NewDeviceIssueList.Items
                $Item.Record.Purchase          = $Cim.IO._NewDevicePurchaseList.Items
                $Item.Record.Invoice           = $Cim.IO._NewDeviceInvoiceList.Items

                [System.Windows.MessageBox]::Show("Device [$($Item.Record.Title)] added to database","Success")

                $Cim.GetTab(3)
            }
        }

        If ($Cim.IO._GetDeviceSearchResult.SelectedIndex -ne -1)
        {        
            If ($Cim.IO._EditDeviceChassis.SelectedIndex -eq 8)
            {
                [System.Windows.MessageBox]::Show("Select a valid chassis type","Error")
            }

            ElseIf($Cim.IO._EditDeviceVendor.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a vendor","Error")
            }

            ElseIf($Cim.IO._EditDeviceModel.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a model","Error")
            }

            ElseIf($Cim.IO._EditDeviceSpecification.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a model specification OR enter N/A","Error")
            }

            ElseIf($Cim.IO._EditDeviceSerial.Text -eq "")
            {
                [System.Windows.MessageBox]::Show("Must enter a serial number","Error")
            }

            Else
            {
                $Item                          = $Cim.NewUID(2)
                $Cim.Refresh()
                $Item.Record.Chassis           = $Cim.IO._EditDeviceChassis.SelectedIndex
                $Item.Record.Vendor            = $Cim.IO._EditDeviceVendor.Text
                $Item.Record.Specification     = $Cim.IO._EditDeviceSpecification.Text
                $Item.Record.Serial            = $Cim.IO._EditDeviceSerial.Text
                $Item.Record.Model             = $Cim.IO._EditDeviceModel.Text
                $Item.Record.Title             = $Cim.IO._EditDeviceTitle.Text
                $Item.Record.Client            = $Cim.IO._EditDeviceClientList.Items
                $Item.Record.Issue             = $Cim.IO._EditDeviceIssueList.Items
                $Item.Record.Purchase          = $Cim.IO._EditDevicePurchaseList.Items
                $Item.Record.Invoice           = $Cim.IO._EditDeviceInvoiceList.Items

                [System.Windows.MessageBox]::Show("Device [$($Item.Record.Title)] added to database","Success")

                $Cim.GetTab(3)
            }
        }
    })

    # ----------- #
    # Issue Panel #
    # ----------- #
    
    $Cim.IO._GetIssueSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(4)
        $Cim.ViewIssue($Cim.IO._GetIssueSearchResult.SelectedItem.UID)

        $Cim.IO._EditIssueTab.IsEnabled = 1
        $Cim.IO._NewIssueTab.IsEnabled  = 1
        $Cim.IO._SaveIssueTab.IsEnabled = 0
    })

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

    # --------------- #
    # Inventory Panel #
    # --------------- #
    
    $Cim.IO._GetInventorySearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(5)
        $Cim.ViewInventory($Cim.IO._GetInventorySearchResult.SelectedItem.UID)
        $Cim.IO._EditInventoryTab.IsEnabled = 1
        $Cim.IO._NewInventoryTab.IsEnabled  = 1
        $Cim.IO._SaveInventoryTab.IsEnabled = 0
    })

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

    # -------------- #
    # Purchase Panel #
    # -------------- #

    $Cim.IO._GetPurchaseSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(6)
        $Cim.ViewPurchase($Cim.IO._GetPurchaseSearchResult.SelectedItem.UID)
        $Cim.IO._EditPurchaseTab.IsEnabled = 1
        $Cim.IO._NewPurchaseTab.IsEnabled  = 1
        $Cim.IO._SavePurchaseTab.IsEnabled = 0
    })

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

    # ------------- #
    # Expense Panel #
    # ------------- #
    
    $Cim.IO._GetExpenseSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(7)
        $Cim.ViewExpense($Cim.IO._GetExpenseSearchResult.SelectedItem.UID)
        $Cim.IO._EditExpenseTab.IsEnabled = 1
        $Cim.IO._NewExpenseTab.IsEnabled  = 1
        $Cim.IO._SaveExpenseTab.IsEnabled = 0
    })

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

    # ------------- #
    # Account Panel #
    # ------------- #

    $Cim.IO._GetAccountSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(8)
        $Cim.ViewAccount($Cim.IO._GetAccountSearchResult.SelectedItem.UID)
        $Cim.IO._EditAccountTab.IsEnabled = 1
        $Cim.IO._NewAccountTab.IsEnabled  = 1
        $Cim.IO._SaveAccountTab.IsEnabled = 0
    })

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

    # ------------- #
    # Invoice Panel #
    # ------------- #

    $Cim.IO._GetInvoiceSearchResult.Add_MouseDoubleClick(
    {    
        $Cim.ViewTab(9)
        $Cim.ViewInvoice($Cim.IO._GetInvoiceSearchResult.SelectedItem.UID)
        $Cim.IO._EditInvoiceTab.IsEnabled = 1
        $Cim.IO._NewInvoiceTab.IsEnabled  = 1
        $Cim.IO._SaveInvoiceTab.IsEnabled = 0
    })

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

    # ------------- #
    # Return Object #
    # ------------- #

    $Cim
}

$Cim      = cim-db

$Cim.Window.Invoke()
