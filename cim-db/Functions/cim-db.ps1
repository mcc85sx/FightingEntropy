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
            $This.Value = $Value
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
        }
        
        GetStage()
        {
            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Invoice = @( )
        }
        
        AddPhone([Object]$Phone)
        {
            $This.Phone  += $Phone
        }
        
        AddEmail([Object]$Email)
        {
            $This.Email  += $Email
        }

        SetStage([String]$First,[String]$Last,[Object]$DOB,[Object]$Phone,[Object]$Email)
        {
            $This.First   = $First
            $This.Last    = $Last
            $This.DOB     = $DOB
        
            $This.AddPhone($Phone)
            $This.AddEmail($Email)
        }
        
        [String] GetName()
        {
            If (!$This.First -or !$This.Last)
            {
                If (!$This.First) 
                { 
                    Throw "Missing first name" 
                }

                If (!$This.Last) 
                {
                    Throw "Missing last name"  
                }
            }

            Return "{0}, {1}" -f $This.Last, $This.First
        }

        SetName([String]$First,[String]$Last)
        {
            $This.Name = $This.GetName($First,$Last)
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
        [String[]] $Description
        [Float]           $Cost

        _Service([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 1
            $This.Type = "Service"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        
        [Object] GetName([String]$Name)
        {
            If ( $Name -in $This.Service.Name )
            {
                Return @( $This.Service | ? Name -eq $Name )
            }

            Else 
            {
                Return $Null    
            }
        }

        [Object] GetUID([Object]$UID)
        {
            If ( $UID -in $This.Service.UID )
            {
                Return @( $This.Service | ? UID -eq $UID )
            }

            Else 
            {
                Return $Null
            }
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
        [UInt32]          $Cost

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

        [Object]        $Object

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

    Class cimdb
    {
        [Object]  $Window
        [Object]      $IO
        [Object]      $DB

        cimdb([String]$Xaml)
        {
            $This.Window = [_Xaml]::New($Xaml)
            $This.IO     = $This.Window.IO
            $This.DB     = [_DB]::New()
        }

        Refresh()
        {
            $This.DB.Client                          = $This.DB.UID | ? Type -eq Client
            $This.DB.Service                         = $This.DB.UID | ? Type -eq Service
            $This.DB.Device                          = $This.DB.UID | ? Type -eq Device
            $This.DB.Issue                           = $This.DB.UID | ? Type -eq Issue
            $This.DB.Inventory                       = $This.DB.UID | ? Type -eq Inventory
            $This.DB.Purchase                        = $This.DB.UID | ? Type -eq Purchase
            $This.DB.Expense                         = $This.DB.UID | ? Type -eq Expense
            $This.DB.Account                         = $This.DB.UID | ? Type -eq Account
            $This.DB.Invoice                         = $This.DB.UID | ? Type -eq Invoice

            $This.IO._GetUIDResult.ItemsSource       = $This.DB.UID
            $This.IO._GetClientResult.ItemsSource    = $This.DB.Client
            $This.IO._GetServiceResult.ItemsSource   = $This.DB.Service
            $This.IO._GetDeviceResult.ItemsSource    = $This.DB.Device
            $This.IO._GetIssueResult.ItemsSource     = $This.DB.Issue
            $This.IO._GetInventoryResult.ItemsSource = $This.DB.Inventory
            $This.IO._GetPurchaseResult.ItemsSource  = $This.DB.Purchase
            $This.IO._GetExpenseResult.ItemsSource   = $This.DB.Expense
            $This.IO._GetAccountResult.ItemsSource   = $This.DB.Account
            $This.IO._GetInvoiceResult.ItemsSource   = $This.DB.Invoice
        }

        Collapse()
        {
            $This.IO._GetUIDPanel.Visibility        = "Collapsed"
            $This.IO._ViewUIDPanel.Visibility       = "Collapsed"
            $This.IO._GetClientPanel.Visibility     = "Collapsed"
            $This.IO._ViewClientPanel.Visibility    = "Collapsed"
            $This.IO._EditClientPanel.Visibility    = "Collapsed"
            $This.IO._NewClientPanel.Visibility     = "Collapsed"
            $This.IO._GetServicePanel.Visibility    = "Collapsed"
            $This.IO._ViewServicePanel.Visibility   = "Collapsed"
            $This.IO._EditServicePanel.Visibility   = "Collapsed"
            $This.IO._NewServicePanel.Visibility    = "Collapsed"
            $This.IO._GetDevicePanel.Visibility     = "Collapsed"
            $This.IO._ViewDevicePanel.Visibility    = "Collapsed"
            $This.IO._EditDevicePanel.Visibility    = "Collapsed"
            $This.IO._NewDevicePanel.Visibility     = "Collapsed"
            $This.IO._GetIssuePanel.Visibility      = "Collapsed"
            $This.IO._ViewIssuePanel.Visibility     = "Collapsed"
            $This.IO._EditIssuePanel.Visibility     = "Collapsed"
            $This.IO._NewIssuePanel.Visibility      = "Collapsed"
            $This.IO._GetInventoryPanel.Visibility  = "Collapsed"
            $This.IO._ViewInventoryPanel.Visibility = "Collapsed"
            $This.IO._EditInventoryPanel.Visibility = "Collapsed"
            $This.IO._NewInventoryPanel.Visibility  = "Collapsed"
            $This.IO._GetPurchasePanel.Visibility   = "Collapsed"
            $This.IO._ViewPurchasePanel.Visibility  = "Collapsed"
            $This.IO._EditPurchasePanel.Visibility  = "Collapsed"
            $This.IO._NewPurchasePanel.Visibility   = "Collapsed"
            $This.IO._GetExpensePanel.Visibility    = "Collapsed"
            $This.IO._ViewExpensePanel.Visibility   = "Collapsed"
            $This.IO._EditExpensePanel.Visibility   = "Collapsed"
            $This.IO._NewExpensePanel.Visibility    = "Collapsed"
            $This.IO._GetAccountPanel.Visibility    = "Collapsed"
            $This.IO._ViewAccountPanel.Visibility   = "Collapsed"
            $This.IO._EditAccountPanel.Visibility   = "Collapsed"
            $This.IO._NewAccountPanel.Visibility    = "Collapsed"
            $This.IO._GetInvoicePanel.Visibility    = "Collapsed"
            $This.IO._ViewInvoicePanel.Visibility   = "Collapsed"
            $This.IO._EditInvoicePanel.Visibility   = "Collapsed"
            $This.IO._NewInvoicePanel.Visibility    = "Collapsed"
        }

        [Object] NewUID([UInt32]$Slot)
        {
            Return @( $This.DB.NewUID($Slot) )
        }

        [Object] GetUID([String]$UID)
        {
            Return @( $This.DB.UID | ? UID -match $UID )
        }

        ViewUID([String]$UID)
        {
            $This.IO._ViewUIDUID.Text   = $Null
            $This.IO._ViewUIDIndex.Text = $Null
            $This.IO._ViewUIDSlot.Text  = $Null
            $This.IO._ViewUIDType.Text  = $Null
            $This.IO._ViewUIDDate.Text  = $Null
            $This.IO._ViewUIDTime.Text  = $Null
            $This.IO._ViewUIDRecordBox.ItemsSource = $Null

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

            $This.IO._ViewUIDRecordBox.ItemsSource = $Item.Record | Get-Member | ? MemberType -eq Property | % Name | % { [_DGList]::New($_,$Item.Record.$_) }
        }

        ViewClient([Object]$UID)
        {
            $This.IO._ViewClientFirst.Text          = $Null
            $This.IO._ViewClientMI.Text             = $Null
            $This.IO._ViewClientLast.Text           = $Null
            $This.IO._ViewClientAddress.Text        = $Null
            $This.IO._ViewClientCity.Text           = $Null
            $This.IO._ViewClientRegion.Text         = $Null
            $This.IO._ViewClientCountry.Text        = $Null
            $This.IO._ViewClientPostal.Text         = $Null
            $This.IO._ViewClientMonth.Text          = $Null
            $This.IO._ViewClientDay.Text            = $Null
            $This.IO._ViewClientYear.Text           = $Null
            $This.IO._ViewClientPhone.ItemsSource   = $Null
            $This.IO._ViewClientEmail.ItemsSource   = $Null
            $This.IO._ViewClientDevice.ItemsSource  = $Null
            $This.IO._ViewClientInvoice.ItemsSource = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Client UID"
            }

            $This.IO._ViewClientFirst.Text   = $Item.Record.First.Text
            $This.IO._ViewClientMI.Text      = $Item.Record.MI.Text
            $This.IO._ViewClientLast.Text    = $Item.Record.Last.Text
            $This.IO._ViewClientAddress.Text = $Item.Record.Address.Text
            $This.IO._ViewClientCity.Text    = $Item.Record.City.Text
            $This.IO._ViewClientRegion.Text  = $Item.Record.Region.Text
            $This.IO._ViewClientCountry.Text = $Item.Record.Country.Text
            $This.IO._ViewClientPostal.Text  = $Item.Record.Postal.Text
            $This.IO._ViewClientMonth.Text   = $Item.Record.Month.Text
            $This.IO._ViewClientDay.Text     = $Item.Record.Day.Text
            $This.IO._ViewClientYear.Text    = $Item.Record.Year.Text

            $This.IO._ViewClientPhone.ItemsSource    = $Item.Record.Phone
            $This.IO._ViewClientEmail.ItemsSource    = $Item.Record.Email
            $This.IO._ViewClientDevice.ItemsSource   = $Item.Record.Device
            $This.IO._ViewClientInvoice.ItemsSource  = $Item.Record.Invoice
        }

        ViewService([Object]$UID)
        {
            $This.IO._ViewServiceName.Text           = $Null
            $This.IO._ViewServiceDescription.Text    = $Null
            $This.IO._ViewServiceCost.Text           = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO._ViewServiceName.Text           = $Item.Record.Name
            $This.IO._ViewServiceDescription.Text    = $Item.Record.Description
            $This.IO._ViewServiceCost.Text           = $Item.Record.Cost
        }

        ViewDevice([Object]$UID)
        {
            $This.IO._ViewDeviceChassis.Text         = $Null 
            $This.IO._ViewDeviceVendor.Text          = $Null 
            $This.IO._ViewDeviceModel.Text           = $Null 
            $This.IO._ViewDeviceSpecification.Text   = $Null 
            $This.IO._ViewDeviceSerial.Text          = $Null 
            $This.IO._ViewDeviceTitle.Text           = $Null 
            $This.IO._ViewDeviceClient.Text          = $Null 
            $This.IO._ViewDeviceIssue.Text           = $Null 
            $This.IO._ViewDevicePurchase.Text        = $Null 
            $This.IO._ViewDeviceInvoice.Text         = $Null 

            $Item = $This.GetUID($This.IO._GetDeviceResult.SelectedItem.UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO._ViewDeviceChassis.Text         = $Item.Record.Chassis
            $This.IO._ViewDeviceVendor.Text          = $Item.Record.Vendor
            $This.IO._ViewDeviceModel.Text           = $Item.Record.Model
            $This.IO._ViewDeviceSpecification.Text   = $Item.Record.Specification
            $This.IO._ViewDeviceSerial.Text          = $Item.Record.Serial
            $This.IO._ViewDeviceTitle.Text           = $Item.Record.Title
            $This.IO._ViewDeviceClient.ItemsSource   = $Item.Record.Client
            $This.IO._ViewDeviceIssue.ItemsSource    = $Item.Record.Issue
            $This.IO._ViewDevicePurchase.ItemsSource = $Item.Record.Purchase
            $This.IO._ViewDeviceInvoice.ItemsSource  = $Item.Record.Invoice
        }

        ViewIssue([Object]$UID)
        {
            $This.IO._ViewIssueClient.ItemsSource    = $Null 
            $This.IO._ViewIssueDevice.ItemsSource    = $Null 
            $This.IO._ViewIssueDescription.Text      = $Null 
            $This.IO._ViewIssueStatus.SelectedIndex  = -1
            $This.IO._ViewIssuePurchase.ItemsSource  = $Null 
            $This.IO._ViewIssueService.ItemsSource   = $Null
            $This.IO._ViewIssueInvoice.ItemsSource   = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Service UID"
            }

            $This.IO._ViewIssueClient.ItemsSource    = $Item.Record.Client
            $This.IO._ViewIssueDevice.ItemsSource    = $Item.Record.Device
            $This.IO._ViewIssueDescription.Text      = $Item.Record.Description
            $This.IO._ViewIssueStatus.SelectedIndex  = $Item.Record.Status
            $This.IO._ViewIssuePurchase.ItemsSource  = $Item.Record.Purchase
            $This.IO._ViewIssueService.ItemsSource   = $Item.Record.Service
            $This.IO._ViewIssueInvoice.ItemsSource   = $Item.Record.Invoice
        }

        ViewInventory([Object]$UID)
        {
            $This.IO._ViewInventoryVendor.Text        = $Null 
            $This.IO._ViewInventorySerial.Text        = $Null 
            $This.IO._ViewInventoryModel.Text         = $Null 
            $This.IO._ViewInventoryTitle.Text         = $Null
            $This.IO._ViewInventoryIsDevice.IsChecked = $False
            $This.IO._ViewInventoryDevice.ItemsSource = $Null
            $This.IO._ViewInventoryCost.Text          = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._ViewInventoryVendor.Text        = $Item.Record.Vendor
            $This.IO._ViewInventorySerial.Text        = $Item.Record.Serial
            $This.IO._ViewInventoryModel.Text         = $Item.Record.Model
            $This.IO._ViewInventoryTitle.Text         = $Item.Record.Title
            $This.IO._ViewInventoryIsDevice.IsChecked = $Item.Record.IsDevice
            $This.IO._ViewInventoryDevice.ItemsSource = $Item.Record.Device
            $This.IO._ViewInventoryCost.Text          = $Item.Record.Cost
        }

        ViewPurchase([Object]$UID)
        {
            $This.IO._ViewPurchaseDistributor.Text   = $Null 
            $This.IO._ViewPurchaseDisplayName.Text   = $Null 
            $This.IO._ViewPurchaseVendor.Text        = $Null 
            $This.IO._ViewPurchaseModel.Text         = $Null
            $This.IO._ViewPurchaseSpecification.Text = $Null
            $This.IO._ViewPurchaseSerial.Text        = $Null
            $This.IO._ViewPurchaseIsDevice.IsChecked = $Null
            $This.IO._ViewPurchaseDevice.ItemsSource = $Null
            $This.IO._ViewPurchaseCost.Text          = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Purchase UID"
            }

            $This.IO._ViewPurchaseDistributor.Text   = $Item.Record.Distributor
            $This.IO._ViewPurchaseDisplayName.Text   = $Item.Record.DisplayName
            $This.IO._ViewPurchaseVendor.Text        = $Item.Record.Vendor
            $This.IO._ViewPurchaseModel.Text         = $Item.Record.Model
            $This.IO._ViewPurchaseSpecification.Text = $Item.Record.Specification
            $This.IO._ViewPurchaseSerial.Text        = $Item.Record.Serial
            $This.IO._ViewPurchaseIsDevice.IsChecked = $Item.Record.IsDevice
            $This.IO._ViewPurchaseDevice.ItemsSource = $Item.Record.Device
            $This.IO._ViewPurchaseCost.Text          = $Item.Record.Cost
        }

        ViewExpense([Object]$UID)
        {
            $This.IO._ViewExpenseRecipient.Text       = $Null 
            $This.IO._ViewExpenseDisplayName.Text     = $Null
            $This.IO._ViewExpenseAccount.ItemsSource  = $Null
            $This.IO._ViewExpenseCost.Text            = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Expense UID"
            }

            $This.IO._ViewExpenseRecipient.Text       = $Item.Record.Recipient
            $This.IO._ViewExpenseDisplayName.Text     = $Item.Record.DisplayName
            $This.IO._ViewExpenseAccount.ItemsSource  = $Item.Record.Account
            $This.IO._ViewExpenseCost.Text            = $Item.Record.Cost
        }

        ViewAccount([Object]$UID)
        {
            $This.IO._ViewAccountObject.ItemsSource   = $Null 

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Account UID"
            }

            $This.IO._ViewAccountObject.ItemsSource   = $Item.Record.Object
        }

        ViewInvoice([Object]$UID)
        {
            $This.IO._ViewInvoiceMode.SelectedIndex    = 0 
            $This.IO._ViewInvoiceClient.ItemsSource    = $Null
            $This.IO._ViewInvoiceInventory.ItemsSource = $Null
            $This.IO._ViewInvoiceService.ItemsSource   = $Null
            $This.IO._ViewInvoicePurchase.ItemsSource  = $Null

            $Item = $This.GetUID($UID)
            
            If (!$Item)
            {
                Throw "Invalid Inventory UID"
            }

            $This.IO._ViewExpenseRecipient.Text        = $Item.Record.Recipient
            $This.IO._ViewInvoiceMode.SelectedIndex    = $Item.Record.Mode
            $This.IO._ViewInvoiceClient.ItemsSource    = $Item.Record.Client
            $This.IO._ViewInvoiceInventory.ItemsSource = $Item.Record.Inventory
            $This.IO._ViewInvoiceService.ItemsSource   = $Item.Record.Service
            $This.IO._ViewInvoicePurchase.ItemsSource  = $Item.Record.Purchase
        }
    }

    $GFX  = [_Gfx]::New()
    $Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
            xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
            Title="Company Information Management Database [FightingEntropy]://(cim-db)" 
            Height="660" 
            Width="800"
            Topmost="True" 
            ResizeMode="NoResize" 
            Icon="C:\ProgramData\Secure Digits Plus LLC\Graphics\icon.ico" 
            HorizontalAlignment="Center" 
            WindowStartupLocation="CenterScreen"
            FontFamily="Consolas">
    <Window.Resources>
        <Style TargetType="TabItem">
            <Setter Property="FontSize" Value="15"/>
            <Setter Property="FontWeight" Value="Heavy"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border Name="Border" BorderThickness="2,2,2,2" BorderBrush="Black" CornerRadius="2" Margin="2">
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
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="FontWeight" Value="Heavy"/>
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="BorderThickness" Value="2"/>
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
        </Style>
        <Style TargetType="DataGridColumnHeader">
            <Setter Property="FontSize"   Value="12"/>
            <Setter Property="FontWeight" Value="Normal"/>
        </Style>
        <Style TargetType="TabControl" x:Key="SubTabControl">
            <Setter Property="TabStripPlacement" Value="Top"/>
            <Setter Property="HorizontalContentAlignment" Value="Center"/>
        </Style>
    </Window.Resources>
    <TabControl TabStripPlacement="Left" HorizontalContentAlignment="Right" Name="_MainTabControl">
        <TabControl.Resources>
            <Style TargetType="GroupBox">
                <Setter Property="Foreground" Value="Black"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="FontSize" Value="12"/>
                <Setter Property="FontWeight" Value="Normal"/>
            </Style>
        </TabControl.Resources>
        <TabItem>
            <TabItem.Header>
                <Image Width="80" Source="C:\ProgramData\Secure Digits Plus LLC\Graphics\sdplogo.png"/>
            </TabItem.Header>
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetUIDTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewUIDTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetUIDPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetUIDSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="UID"/>
                            <ComboBoxItem Content="Index"/>
                            <ComboBoxItem Content="Date"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >
                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetUIDSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetUIDResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="UID"    Binding='{Binding UID}'    Width="160"/>
                            <DataGridTextColumn Header="Index"  Binding='{Binding Index}'  Width="60"/>
                            <DataGridTextColumn Header="Slot"   Binding='{Binding Slot}'   Width="40"/>
                            <DataGridTextColumn Header="Date"   Binding='{Binding Date}'   Width="*"/>
                            <DataGridTextColumn Header="Time"   Binding='{Binding Time}'   Width="0.5*"/>
                            <DataGridTextColumn Header="Record" Binding='{Binding Record}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetUIDRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewUIDRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewUIDPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="70"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="200"/>
                            <ColumnDefinition Width="120"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[UID]">
                            <TextBox Name="_ViewUIDUID" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Index]">
                            <TextBox Name="_ViewUIDIndex" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Slot]">
                            <TextBox Name="_ViewUIDSlot" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Type]">
                            <TextBox Name="_ViewUIDType" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="1">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Date]">
                            <TextBox Name="_ViewUIDDate" IsEnabled="False"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Time]">
                            <TextBox Name="_ViewUIDTime" IsEnabled="False"/>
                        </GroupBox>
                    </Grid>
                    <DataGrid Grid.Row="2" Margin="5" Name="_ViewUIDRecordBox">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name" Width="*"/>
                            <DataGridTextColumn Header="Value" Width="2*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Client">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetClientTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewClientTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditClientTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewClientTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetClientPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetClientSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Name"/>
                            <ComboBoxItem Content="Phone Number"/>
                            <ComboBoxItem Content="Email Address"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" Name="_GetClientSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetClientResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name"  Binding='{Binding Name}'  Width="*"/>
                            <DataGridTextColumn Header="Last"  Binding='{Binding Last}'  Width="*"/>
                            <DataGridTextColumn Header="First" Binding='{Binding First}' Width="*"/>
                            <DataGridTextColumn Header="MI"    Binding='{Binding MI}'    Width="0.25*"/>
                            <DataGridTextColumn Header="DOB"   Binding='{Binding DOB}'   Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetClientRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewClientRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewClientPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="3*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="0.5*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Last]">
                                <TextBox Name="_ViewClientLast"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[First]">
                                <TextBox Name="_ViewClientFirst"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[MI]">
                                <TextBox Name="_ViewClientMI"/>
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[Address]">
                            <TextBox Name="_ViewClientAddress"/>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="3*"/>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="1.5*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[City]">
                                <TextBox Name="_ViewClientCity"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Region]">
                                <TextBox Name="_ViewClientRegion"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[Country]">
                                <TextBox Name="_ViewClientCountry"/>
                            </GroupBox>
                            <GroupBox Grid.Column="3" Header="[Postal]">
                                <TextBox Name="_ViewClientPostal"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Row="3">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Column="0" Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2.5*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <TextBox Grid.Column="0" Name="_ViewClientMonth"/>
                                        <TextBox Grid.Column="1" Name="_ViewClientDay"/>
                                        <TextBox Grid.Column="2" Name="_ViewClientYear"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Gender]">
                                    <ComboBox Name="_ViewClientGender" SelectedIndex="2">
                                        <ComboBoxItem Content="Male"/>
                                        <ComboBoxItem Content="Female"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                            </Grid>
                            <GroupBox Header="[Phone Number(s)]" Grid.Column="0" Grid.Row="1">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewClientPhone"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddPhone"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemovePhone"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_ViewClientEmail"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddEmail"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveEmail"/>
                                </Grid>
                            </GroupBox>
                            <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                        </Grid>
                        <Grid Grid.Row="4">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="240"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="4*"/>
                            </Grid.ColumnDefinitions>
                        </Grid>
                        <GroupBox Grid.Row="4" Header="[Device(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewClientDevice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddDevice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewClientInvoice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddInvoice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveInvoice"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditClientRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditClientPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="3*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="0.5*"/>
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
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[Address]">
                            <TextBox Name="_EditClientAddress"/>
                        </GroupBox>
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
                        <Grid Grid.Row="3">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Column="0" Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2.5*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <TextBox Grid.Column="0" Name="_EditClientMonth"/>
                                        <TextBox Grid.Column="1" Name="_EditClientDay"/>
                                        <TextBox Grid.Column="2" Name="_EditClientYear"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Gender]">
                                    <ComboBox Name="_EditClientGender" SelectedIndex="2">
                                        <ComboBoxItem Content="Male"/>
                                        <ComboBoxItem Content="Female"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                            </Grid>
                            <GroupBox Header="[Phone Number(s)]" Grid.Column="0" Grid.Row="1">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditClientPhone"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddPhone"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemovePhone"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_EditClientEmail"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddEmail"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveEmail"/>
                                </Grid>
                            </GroupBox>
                            <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                        </Grid>
                        <Grid Grid.Row="4">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="240"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="4*"/>
                            </Grid.ColumnDefinitions>
                        </Grid>
                        <GroupBox Grid.Row="4" Header="[Device(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditClientDevice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddDevice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditClientInvoice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddInvoice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveInvoice"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateClientRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewClientPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="3*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="0.5*"/>
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
                        </Grid>
                        <GroupBox Grid.Row="1" Header="[Address]">
                            <TextBox Name="_NewClientAddress"/>
                        </GroupBox>
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
                        <Grid Grid.Row="3">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>
                            <Grid Grid.Column="0" Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="2.5*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                    <Grid>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="0.5*"/>
                                            <ColumnDefinition Width="*"/>
                                        </Grid.ColumnDefinitions>
                                        <TextBox Grid.Column="0" Name="_NewClientMonth"/>
                                        <TextBox Grid.Column="1" Name="_NewClientDay"/>
                                        <TextBox Grid.Column="2" Name="_NewClientYear"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Column="3" Header="[Gender]">
                                    <ComboBox Name="_NewClientGender" SelectedIndex="2">
                                        <ComboBoxItem Content="Male"/>
                                        <ComboBoxItem Content="Female"/>
                                        <ComboBoxItem Content="-"/>
                                    </ComboBox>
                                </GroupBox>
                            </Grid>
                            <GroupBox Header="[Phone Number(s)]" Grid.Column="0" Grid.Row="1">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewClientPhone"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddPhone"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemovePhone"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="40"/>
                                        <ColumnDefinition Width="40"/>
                                    </Grid.ColumnDefinitions>
                                    <ComboBox Grid.Column="0" Name="_NewClientEmail"/>
                                    <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddEmail"/>
                                    <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveEmail"/>
                                </Grid>
                            </GroupBox>
                            <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                        </Grid>
                        <Grid Grid.Row="4">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="240"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="60"/>
                                <ColumnDefinition Width="4*"/>
                            </Grid.ColumnDefinitions>
                        </Grid>
                        <GroupBox Grid.Row="4" Header="[Device(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewClientDevice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddDevice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewClientInvoice"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddInvoice"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveInvoice"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveClientRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Service">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetServiceTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewServiceTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditServiceTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewServiceTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetServicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetServiceSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Name"/>
                            <ComboBoxItem Content="Description"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >
                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetServiceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetServiceResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name" Binding='{Binding Name}' Width="*"/>
                            <DataGridTextColumn Header="Description" Binding='{Binding Description}' Width="*"/>
                            <DataGridTextColumn Header="Cost" Binding='{Binding Cost}' Width="0.5*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetServiceRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewServiceRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewServicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Name]">
                            <TextBox Name="_ViewServiceName"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Description]">
                            <TextBox Name="_ViewServiceDescription"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Cost]">
                            <TextBox Name="_ViewServiceCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditServiceRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditServicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
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
                    <Button Grid.Row="1" Name="_UpdateServiceRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewServicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
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
                    <Button Grid.Row="1" Name="_SaveServiceRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Device">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetDeviceTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewDeviceTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditDeviceTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewDeviceTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetDevicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetDeviceSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Vendor"/>
                            <ComboBoxItem Content="Model"/>
                            <ComboBoxItem Content="Specification"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" Name="_GetDeviceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetDeviceResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor"        Binding='{Binding Vendor}'        Width="*"/>
                            <DataGridTextColumn Header="Model"         Binding='{Binding Model}'         Width="*"/>
                            <DataGridTextColumn Header="Specification" Binding='{Binding Specification}' Width="*"/>
                            <DataGridTextColumn Header="Serial"        Binding='{Binding Serial}'        Width="*"/>
                            <DataGridTextColumn Header="Title"         Binding='{Binding Title}'         Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetDeviceRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewDeviceRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewDevicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="1.5*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Chassis]">
                                <ComboBox Name="_ViewDeviceChassis" SelectedIndex="8">
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
                                <TextBox Name="_ViewDeviceVendor"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[Model]">
                                <TextBox Name="_ViewDeviceModel"/>
                            </GroupBox>
                            <GroupBox Grid.Column="3" Header="[Specification]">
                                <TextBox Name="_ViewDeviceSpecification"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Row="1">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Serial]">
                                <TextBox Name="_ViewDeviceSerial"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Title]">
                                <TextBox Name="_ViewDeviceTitle"/>
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row="2" Header="[Client(s)]">
                            <ComboBox Name="_ViewDeviceClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Issue(s)]">
                            <ComboBox Name="_ViewDeviceIssue"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                            <ComboBox Name="_ViewDevicePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <ComboBox Name="_ViewDeviceInvoice"/>
                        </GroupBox>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_EditDevicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
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
                            <ComboBox Name="_EditDeviceClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Issue(s)]">
                            <ComboBox Name="_EditDeviceIssue"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                            <ComboBox Name="_EditDevicePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <ComboBox Name="_EditDeviceInvoice"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateDeviceRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewDevicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
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
                            <ComboBox Name="_NewDeviceClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Issue(s)]">
                            <ComboBox Name="_NewDeviceIssue"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase(s)]">
                            <ComboBox Name="_NewDevicePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                            <ComboBox Name="_NewDeviceInvoice"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveDeviceRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Issue">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetIssueTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewIssueTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditIssueTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewIssueTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetIssuePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetIssueSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Client"/>
                            <ComboBoxItem Content="Device"/>
                        </ComboBox>
                        <TextBox Grid.Column="1"/>
                        <TextBox Grid.Column="1" Name="_GetIssueSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetIssueResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Client"   Binding='{Binding Client}'   Width="*"/>
                            <DataGridTextColumn Header="Device"   Binding='{Binding Device}'   Width="*"/>
                            <DataGridTextColumn Header="Status"   Binding='{Binding Status}'   Width="*"/>
                            <DataGridTextColumn Header="Purchase" Binding='{Binding Purchase}' Width="*"/>
                            <DataGridTextColumn Header="Service"  Binding='{Binding Service}'  Width="*"/>
                            <DataGridTextColumn Header="Invoice"  Binding='{Binding Invoice}'  Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetIssueRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewIssueRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewIssuePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Client]">
                            <ComboBox  Name="_ViewIssueClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Device]">
                            <ComboBox Name="_ViewIssueDevice"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Description]">
                            <TextBox Name="_ViewIssueDescription"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Status]">
                            <ComboBox Name="_ViewIssueStatus"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <ComboBox Name="_ViewIssuePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Service]">
                            <ComboBox Name="_ViewIssueService"/>
                        </GroupBox>
                        <GroupBox Grid.Row="6" Header="[Invoice]">
                            <ComboBox Name="_ViewIssueInvoice"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditIssueRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditIssuePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Client]">
                            <ComboBox  Name="_EditIssueClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Device]">
                            <ComboBox Name="_EditIssueDevice"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Description]">
                            <TextBox Name="_EditIssueDescription"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Status]">
                            <ComboBox Name="_EditIssueStatus"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <ComboBox Name="_EditIssuePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Service]">
                            <ComboBox Name="_EditIssueService"/>
                        </GroupBox>
                        <GroupBox Grid.Row="6" Header="[Invoice]">
                            <ComboBox Name="_EditIssueInvoice"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateIssueRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewIssuePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Client]">
                            <ComboBox  Name="_NewIssueClient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Device]">
                            <ComboBox Name="_NewIssueDevice"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Description]">
                            <TextBox Name="_NewIssueDescription"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Status]">
                            <ComboBox Name="_NewIssueStatus"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <ComboBox Name="_NewIssuePurchase"/>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Service]">
                            <ComboBox Name="_NewIssueService"/>
                        </GroupBox>
                        <GroupBox Grid.Row="6" Header="[Invoice]">
                            <ComboBox Name="_NewIssueInvoice"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveIssueRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Inventory">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetInventoryTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewInventoryTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditInventoryTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewInventoryTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetInventoryPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetInventorySearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Client"/>
                            <ComboBoxItem Content="Device"/>
                        </ComboBox>
                        <TextBox Grid.Column="1"/>
                        <TextBox Grid.Column="1" Name="_GetInventorySearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetInventoryResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor"     Binding='{Binding Vendor}'   Width="*"/>
                            <DataGridTextColumn Header="Serial"     Binding='{Binding Serial}'   Width="*"/>
                            <DataGridTextColumn Header="Model"      Binding='{Binding Model}'    Width="*"/>
                            <DataGridTextColumn Header="Title"      Binding='{Binding Title}'    Width="2*"/>
                            <DataGridTemplateColumn Header="Device" Width="60">
                                <DataGridTemplateColumn.CellTemplate>
                                    <DataTemplate>
                                        <ComboBox SelectedIndex='{Binding IsDevice}'>
                                            <ComboBoxItem Content="N"/>
                                            <ComboBoxItem Content="Y"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </DataTemplate>
                                </DataGridTemplateColumn.CellTemplate>
                            </DataGridTemplateColumn>
                            <DataGridTextColumn Header="Cost"  Binding='{Binding Cost}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetInventoryRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewInventoryRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewInventoryPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Vendor]">
                            <TextBox Name="_ViewInventoryVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Serial]">
                            <TextBox Name="_ViewInventorySerial"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Model]">
                            <TextBox Name="_ViewInventoryModel"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Title]">
                            <TextBox Name="_ViewInventoryTitle"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Device]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_ViewInventoryIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_ViewInventoryDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_ViewInventoryCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditInventoryRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditInventoryPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Vendor]">
                            <TextBox Name="_EditInventoryVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Serial]">
                            <TextBox Name="_EditInventorySerial"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Model]">
                            <TextBox Name="_EditInventoryModel"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Title]">
                            <TextBox Name="_EditInventoryTitle"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Device]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_EditInventoryIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_EditInventoryDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_EditInventoryCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateInventoryRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewInventoryPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Vendor]">
                            <TextBox Name="_NewInventoryVendor"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Serial]">
                            <TextBox Name="_NewInventorySerial"/>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Model]">
                            <TextBox Name="_NewInventoryModel"/>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Title]">
                            <TextBox Name="_NewInventoryTitle"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Device]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_NewInventoryIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_NewInventoryDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_NewInventoryCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveInventoryRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Purchase">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetPurchaseTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewPurchaseTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditPurchaseTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewPurchaseTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetPurchasePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetPurchaseSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Distributor"/>
                            <ComboBoxItem Content="DisplayName"/>
                            <ComboBoxItem Content="Vendor"/>
                            <ComboBoxItem Content="Serial"/>
                            <ComboBoxItem Content="Model"/>
                            <ComboBoxItem Content="Title"/>
                            <ComboBoxItem Content="Invoice"/>
                        </ComboBox>
                        <TextBox Grid.Column="1"/>
                        <TextBox Grid.Column="1" Name="_GetPurchaseSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetPurchaseResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Distributor"  Binding='{Binding Distributor}' Width="*"/>
                            <DataGridTextColumn Header="DisplayName"  Binding='{Binding DisplayName}' Width="*"/>
                            <DataGridTextColumn Header="Vendor"       Binding='{Binding Vendor}'      Width="*"/>
                            <DataGridTextColumn Header="Serial"       Binding='{Binding Serial}'      Width="2*"/>
                            <DataGridTextColumn Header="Model"        Binding='{Binding Model}'       Width="*"/>
                            <DataGridTemplateColumn Header="Device"   Width="60">
                                <DataGridTemplateColumn.CellTemplate>
                                    <DataTemplate>
                                        <ComboBox SelectedIndex='{Binding IsDevice}'>
                                            <ComboBoxItem Content="N"/>
                                            <ComboBoxItem Content="Y"/>
                                            <ComboBoxItem Content="-"/>
                                        </ComboBox>
                                    </DataTemplate>
                                </DataGridTemplateColumn.CellTemplate>
                            </DataGridTemplateColumn>
                            <DataGridTextColumn Header="Cost"  Binding='{Binding Cost}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetPurchaseRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewPurchaseRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewPurchasePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Distributor]">
                            <TextBox Name="_ViewPurchaseDistributor"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Display Name]">
                            <TextBox Name="_ViewPurchaseDisplayName"/>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="2*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Vendor]">
                                <TextBox Name="_ViewPurchaseVendor"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Model]">
                                <TextBox Name="_ViewPurchaseModel"/>
                            </GroupBox>
                            <GroupBox Grid.Column="2" Header="[Specification]">
                                <TextBox Name="_ViewPurchaseSpecification"/>
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row="3" Header="[Serial]">
                            <TextBox Name="_ViewPurchaseSerial"/>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Device]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_ViewPurchaseIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_ViewPurchaseDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_ViewPurchaseCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditPurchaseRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditPurchasePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
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
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_EditPurchaseIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_EditPurchaseDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_EditPurchaseCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdatePurchaseRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewPurchasePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
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
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="3*"/>
                                </Grid.ColumnDefinitions>
                                <CheckBox Grid.Column="0" Content="Is this a Device?" HorizontalAlignment="Center" VerticalAlignment="Center" Name="_NewPurchaseIsDevice"/>
                                <ComboBox Grid.Column="1" Name="_NewPurchaseDevice"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="5" Header="[Cost]">
                            <TextBox Name="_NewPurchaseCost"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SavePurchaseRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Expense">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetExpenseTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewExpenseTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditExpenseTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewExpenseTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetExpensePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetExpenseSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Recipient"/>
                            <ComboBoxItem Content="DisplayName"/>
                            <ComboBoxItem Content="Account"/>
                            <ComboBoxItem Content="Cost"/>
                        </ComboBox>
                        <TextBox Grid.Column="1"/>
                        <TextBox Grid.Column="1" Name="_GetExpenseSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetExpenseResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Recipient"    Binding='{Binding Recipient}'   Width="*"/>
                            <DataGridTextColumn Header="DisplayName"  Binding='{Binding DisplayName}' Width="1.5*"/>
                            <DataGridTextColumn Header="Account"      Binding='{Binding Account}'     Width="*"/>
                            <DataGridTextColumn Header="Cost"         Binding='{Binding Cost}'        Width="0.5*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetExpenseRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewExpenseRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewExpensePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Recipient]">
                            <TextBox Name="_ViewExpenseRecipient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Display Name]">
                            <TextBox Name="_ViewExpenseDisplayName"/>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Account]">
                                <ComboBox Name="_ViewExpenseAccount"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Cost]">
                                <TextBox Name="_ViewExpenseCost"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditExpenseRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditExpensePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Recipient]">
                            <TextBox Name="_EditExpenseRecipient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Display Name]">
                            <TextBox Name="_EditExpenseDisplayName"/>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Account]">
                                <ComboBox Name="_EditExpenseAccount"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Cost]">
                                <TextBox Name="_EditExpenseCost"/>
                            </GroupBox>
                        </Grid>
                        <Button Grid.Row="1" Name="_UpdateExpenseRecord" Content="Update"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_NewExpensePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Recipient]">
                            <TextBox Name="_NewExpenseRecipient"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Display Name]">
                            <TextBox Name="_NewExpenseDisplayName"/>
                        </GroupBox>
                        <Grid Grid.Row="2">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[Account]">
                                <ComboBox Name="_NewExpenseAccount"/>
                            </GroupBox>
                            <GroupBox Grid.Column="1" Header="[Cost]">
                                <TextBox Name="_NewExpenseCost"/>
                            </GroupBox>
                        </Grid>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveExpenseRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Account">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetAccountTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewAccountTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditAccountTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewAccountTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetAccountPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetAccountSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Object"/>
                        </ComboBox>
                        <TextBox Grid.Column="1"/>
                        <TextBox Grid.Column="1" Name="_GetAccountSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetAccountResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Object"  Binding='{Binding Object}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetAccountRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewAccountRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewAccountPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Column="0" Header="[Object]">
                            <ComboBox Name="_ViewAccountObject"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditAccountRecord" Content="Edit"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditAccountPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Column="0" Header="[Object]">
                            <ComboBox Name="_EditAccountObject"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateAccountRecord" Content="Update"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewAccountPanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Column="0" Header="[Object]">
                            <ComboBox Name="_NewAccountObject"/>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveAccountRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
        <TabItem Header="Invoice">
            <Grid>
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
                    <Button Grid.Column="0" Content="Get" Name="_GetInvoiceTab"/>
                    <Button Grid.Column="1" Content="View" Name="_ViewInvoiceTab"/>
                    <Button Grid.Column="2" Content="Edit" Name="_EditInvoiceTab"/>
                    <Button Grid.Column="3" Content="New" Name="_NewInvoiceTab"/>
                </Grid>
                <Grid Grid.Row="1" Name="_GetInvoicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetInvoiceSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Date"/>
                            <ComboBoxItem Content="Name"/>
                            <ComboBoxItem Content="Phone Number"/>
                            <ComboBoxItem Content="Email Address"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >
                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetInvoiceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetInvoiceResult">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="*"/>
                            <DataGridTextColumn Header="Name"  Binding='{Binding Name}'  Width="*"/>
                            <DataGridTextColumn Header="Phone"  Binding='{Binding Last}'  Width="*"/>
                            <DataGridTextColumn Header="Email" Binding='{Binding First}' Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Grid.Column="0" Name="_GetInvoiceRefresh" Content="Refresh"/>
                        <Button Grid.Column="1" Name="_ViewInvoiceRecord" Content="View"/>
                    </Grid>
                </Grid>
                <Grid Grid.Row="1" Name="_ViewInvoicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Mode]">
                            <ComboBox Name="_ViewInvoiceMode"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Client]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceClient"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewInvoiceAddClient"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewInvoiceRemoveClient"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Inventory]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceInventory"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewInvoiceAddInventory"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewInvoiceRemoveInventory"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Service]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoiceService"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewInvoiceAddService"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewInvoiceRemoveService"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_ViewInvoicePurchase"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewInvoiceAddPurchase"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewInvoiceRemovePurchase"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_EditInvoiceRecord" Content="Save"/>
                </Grid>
                <Grid Grid.Row="1" Name="_EditInvoicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Mode]">
                            <ComboBox Name="_EditInvoiceMode"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Client]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditInvoiceClient"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditInvoiceAddClient"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditInvoiceRemoveClient"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Inventory]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditInvoiceInventory"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditInvoiceAddInventory"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditInvoiceRemoveInventory"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Service]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditInvoiceService"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditInvoiceAddService"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditInvoiceRemoveService"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_EditInvoicePurchase"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditInvoiceAddPurchase"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditInvoiceRemovePurchase"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_UpdateInvoiceRecord" Content="Save"/>
                </Grid>
                <Grid Grid.Row="1" Name="_NewInvoicePanel" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                            <RowDefinition Height="70"/>
                        </Grid.RowDefinitions>
                        <GroupBox Grid.Row="0" Header="[Mode]">
                            <ComboBox Name="_NewInvoiceMode"/>
                        </GroupBox>
                        <GroupBox Grid.Row="1" Header="[Client]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewInvoiceClient"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewInvoiceAddClient"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewInvoiceRemoveClient"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="2" Header="[Inventory]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewInvoiceInventory"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewInvoiceAddInventory"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewInvoiceRemoveInventory"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="3" Header="[Service]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewInvoiceService"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewInvoiceAddService"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewInvoiceRemoveService"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row="4" Header="[Purchase]">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Name="_NewInvoicePurchase"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewInvoiceAddPurchase"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewInvoiceRemovePurchase"/>
                            </Grid>
                        </GroupBox>
                    </Grid>
                    <Button Grid.Row="1" Name="_SaveInvoiceRecord" Content="Save"/>
                </Grid>
            </Grid>
        </TabItem>
    </TabControl>
</Window>
"@
    $Cim  = [Cimdb]::New($Xaml)

    # Main Tab Control
    $Cim.IO._MainTabControl.Add_SelectionChanged(
    {
        $Cim.Collapse()

        Switch($Cim.IO._MainTabControl.SelectedIndex)
        {
            0 { $Cim.IO._GetUIDPanel.Visibility        = "Visible" }
            1 { $Cim.IO._GetClientPanel.Visibility     = "Visible" }
            2 { $Cim.IO._GetServicePanel.Visibility    = "Visible" }
            3 { $Cim.IO._GetDevicePanel.Visibility     = "Visible" }
            4 { $Cim.IO._GetIssuePanel.Visibility      = "Visible" }
            5 { $Cim.IO._GetInventoryPanel.Visibility  = "Visible" }
            6 { $Cim.IO._GetPurchasePanel.Visibility   = "Visible" }
            7 { $Cim.IO._GetExpensePanel.Visibility    = "Visible" }
            8 { $Cim.IO._GetAccountPanel.Visibility    = "Visible" }
            9 { $Cim.IO._GetInvoicePanel.Visibility    = "Visible" }
        }
    })

    # UID
    #_GetUIDPanel
    #_ViewUIDPanel
    $Cim.IO._GetUIDSearchFilter.Add_TextChanged{

        $Item = $Cim.DB.UID | ? $Cim.IO._GetUIDSearchType.SelectedItem.Content -match $Cim.IO._GetUIDSearchFilter.Text

        If ($Item -eq $Null) 
        {
            $Cim.IO._GetUIDResult.ItemsSource = $Null
        }

        Else
        {
            $Cim.IO._GetUIDResult.ItemsSource = $Item
        }

        Start-Sleep -Milliseconds 50
    }
    
    <#
    # Client
    _GetClientPanel
    _ViewClientPanel
    _EditClientPanel
    _NewClientPanel

    # Service
    _GetServicePanel
    _ViewServicePanel
    _EditServicePanel
    _NewServicePanel

    # Device
    _GetDevicePanel
    _ViewDevicePanel
    _EditDevicePanel
    _NewDevicePanel

    # Issue
    _GetIssuePanel
    _ViewIssuePanel
    _EditIssuePanel
    _NewIssuePanel

    # Inventory
    _GetInventoryPanel
    _ViewInventoryPanel
    _EditInventoryPanel
    _NewInventoryPanel
    
    # Purchase
    _GetPurchasePanel
    _ViewPurchasePanel
    _EditPurchasePanel
    _NewPurchasePanel

    # Expense
    _GetExpensePanel
    _ViewExpensePanel
    _EditExpensePanel
    _NewExpensePanel

    # Account
    _GetAccountPanel
    _ViewAccountPanel
    _EditAccountPanel
    _NewAccountPanel

    # Invoice
    _GetInvoicePanel
    _ViewInvoicePanel
    _EditInvoicePanel
    _NewInvoicePanel
    #>

    $Cim.IO._GetUIDRefresh.Add_Click{$Cim.Refresh()}
    $Cim.IO._ViewUIDRecord.Add_Click{$Cim.ViewUID($Cim.IO._GetUIDResult.SelectedItem.UID)}

    $Cim.IO._GetClientRefresh.    Add_Click{$Cim.Refresh()}
    $Cim.IO._GetServiceRefresh.   Add_Click{$Cim.Refresh()}
    $Cim.IO._GetDeviceRefresh.    Add_Click{$Cim.Refresh()}
    $Cim.IO._GetIssueRefresh.     Add_Click{$Cim.Refresh()}
    $Cim.IO._GetInventoryRefresh. Add_Click{$Cim.Refresh()}
    $Cim.IO._GetPurchaseRefresh.  Add_Click{$Cim.Refresh()}
    $Cim.IO._GetExpenseRefresh.   Add_Click{$Cim.Refresh()}
    $Cim.IO._GetAccountRefresh.   Add_Click{$Cim.Refresh()}
    $Cim.IO._GetInvoiceRefresh.   Add_Click{$Cim.Refresh()}

    $Cim
}