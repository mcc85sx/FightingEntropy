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

        DefaultSearchProperty()
        { 
            $This.IO._GetUIDSearchProperty.ItemsSource                  = $This.Temp.UID
            $This.IO._GetClientSearchProperty.ItemsSource               = $This.Temp.Client
            $This.IO._ViewClientDeviceSearchProperty.ItemsSource        = $This.Temp.Device
            $This.IO._ViewClientInvoiceSearchProperty.ItemsSource       = $This.Temp.Invoice
            $This.IO._EditClientDeviceSearchProperty.ItemsSource        = $This.Temp.Device
            $This.IO._EditClientInvoiceSearchProperty.ItemsSource       = $This.Temp.Invoice
            $This.IO._NewClientDeviceSearchProperty.ItemsSource         = $This.Temp.Device
            $This.IO._NewClientInvoiceSearchProperty.ItemsSource        = $This.Temp.Invoice
            $This.IO._GetServiceSearchProperty.ItemsSource              = $This.Temp.Service
            $This.IO._GetDeviceSearchProperty.ItemsSource               = $This.Temp.Device
            $This.IO._ViewDeviceClientSearchProperty.ItemsSource        = $This.Temp.Client
            $This.IO._ViewDeviceIssueSearchProperty.ItemsSource         = $This.Temp.Issue
            $This.IO._ViewDevicePurchaseSearchProperty.ItemsSource      = $This.Temp.Purchase
            $This.IO._ViewDeviceInvoiceSearchProperty.ItemsSource       = $This.Temp.Invoice
            $This.IO._EditDeviceClientSearchProperty.ItemsSource        = $This.Temp.Client
            $This.IO._EditDeviceIssueSearchProperty.ItemsSource         = $This.Temp.Issue
            $This.IO._EditDevicePurchaseSearchProperty.ItemsSource      = $This.Temp.Purchase
            $This.IO._EditDeviceInvoiceSearchProperty.ItemsSource       = $This.Temp.Invoice
            $This.IO._NewDeviceClientSearchProperty.ItemsSource         = $This.Temp.Client
            $This.IO._NewDeviceIssueSearchProperty.ItemsSource          = $This.Temp.Issue
            $This.IO._NewDevicePurchaseSearchProperty.ItemsSource       = $This.Temp.Purchase
            $This.IO._NewDeviceInvoiceSearchProperty.ItemsSource        = $This.Temp.Invoice
            $This.IO._GetIssueSearchProperty.ItemsSource                = $This.Temp.Issue
            $This.IO._ViewIssueClientSearchProperty.ItemsSource         = $This.Temp.Client
            $This.IO._ViewIssueDeviceSearchProperty.ItemsSource         = $This.Temp.Device
            $This.IO._ViewIssuePurchaseSearchProperty.ItemsSource       = $This.Temp.Purchase
            $This.IO._ViewIssueInvoiceSearchProperty.ItemsSource        = $This.Temp.Invoice
            $This.IO._EditIssueClientSearchProperty.ItemsSource         = $This.Temp.Client
            $This.IO._EditIssueDeviceSearchProperty.ItemsSource         = $This.Temp.Device
            $This.IO._EditIssuePurchaseSearchProperty.ItemsSource       = $This.Temp.Purchase
            $This.IO._EditIssueInvoiceSearchProperty.ItemsSource        = $This.Temp.Invoice
            $This.IO._NewIssueClientSearchProperty.ItemsSource          = $This.Temp.Client
            $This.IO._NewIssueDeviceSearchProperty.ItemsSource          = $This.Temp.Device
            $This.IO._NewIssuePurchaseSearchProperty.ItemsSource        = $This.Temp.Purchase
            $This.IO._NewIssueInvoiceSearchProperty.ItemsSource         = $This.Temp.Invoice
            $This.IO._GetInventorySearchProperty.ItemsSource            = $This.Temp.Inventory
            $This.IO._ViewInventoryDeviceSearchProperty.ItemsSource     = $This.Temp.Device
            $This.IO._EditInventoryDeviceSearchProperty.ItemsSource     = $This.Temp.Device
            $This.IO._NewInventoryDeviceSearchProperty.ItemsSource      = $This.Temp.Device
            $This.IO._GetPurchaseSearchProperty.ItemsSource             = $This.Temp.Purchase
            $This.IO._ViewPurchaseDeviceSearchProperty.ItemsSource      = $This.Temp.Device
            $This.IO._EditPurchaseDeviceSearchProperty.ItemsSource      = $This.Temp.Device
            $This.IO._NewPurchaseDeviceSearchProperty.ItemsSource       = $This.Temp.Device
            $This.IO._GetExpenseSearchProperty.ItemsSource              = $This.Temp.Expense
            $This.IO._ViewExpenseDeviceSearchProperty.ItemsSource       = $This.Temp.Device
            $This.IO._EditExpenseDeviceSearchProperty.ItemsSource       = $This.Temp.Device
            $This.IO._NewExpenseDeviceSearchProperty.ItemsSource        = $This.Temp.Device
            $This.IO._GetAccountSearchProperty.ItemsSource              = $This.Temp.Account
            $This.IO._ViewAccountObjectSearchProperty.ItemsSource       = $This.Temp.Object
            $This.IO._EditAccountObjectSearchProperty.ItemsSource       = $This.Temp.Object
            $This.IO._NewAccountObjectSearchProperty.ItemsSource        = $This.Temp.Object
            $This.IO._GetInvoiceSearchProperty.ItemsSource              = $This.Temp.Invoice
            $This.IO._ViewInvoiceClientSearchProperty.ItemsSource       = $This.Temp.Client
            $This.IO._ViewInvoiceInventorySearchProperty.ItemsSource    = $This.Temp.Inventory
            $This.IO._ViewInvoiceServiceSearchProperty.ItemsSource      = $This.Temp.Service
            $This.IO._ViewInvoicePurchaseSearchProperty.ItemsSource     = $This.Temp.Purchase
            $This.IO._EditInvoiceClientSearchProperty.ItemsSource       = $This.Temp.Client
            $This.IO._EditInvoiceInventorySearchProperty.ItemsSource    = $This.Temp.Inventory
            $This.IO._EditInvoiceServiceSearchProperty.ItemsSource      = $This.Temp.Service
            $This.IO._EditInvoicePurchaseSearchProperty.ItemsSource     = $This.Temp.Purchase
            $This.IO._NewInvoiceClientSearchProperty.ItemsSource        = $This.Temp.Client
            $This.IO._NewInvoiceInventorySearchProperty.ItemsSource     = $This.Temp.Inventory
            $This.IO._NewInvoiceServiceSearchProperty.ItemsSource       = $This.Temp.Service
            $This.IO._NewInvoicePurchaseSearchProperty.ItemsSource      = $This.Temp.Purchase

            $This.IO._GetUIDSearchProperty.SelectedIndex                = 2
            $This.IO._GetClientSearchProperty.SelectedIndex             = 2
            $This.IO._ViewClientDeviceSearchProperty.SelectedIndex      = 2
            $This.IO._ViewClientInvoiceSearchProperty.SelectedIndex     = 2
            $This.IO._EditClientDeviceSearchProperty.SelectedIndex      = 2
            $This.IO._EditClientInvoiceSearchProperty.SelectedIndex     = 2
            $This.IO._NewClientDeviceSearchProperty.SelectedIndex       = 2
            $This.IO._NewClientInvoiceSearchProperty.SelectedIndex      = 2
            $This.IO._GetServiceSearchProperty.SelectedIndex            = 2
            $This.IO._GetDeviceSearchProperty.SelectedIndex             = 2
            $This.IO._ViewDeviceClientSearchProperty.SelectedIndex      = 2
            $This.IO._ViewDeviceIssueSearchProperty.SelectedIndex       = 2
            $This.IO._ViewDevicePurchaseSearchProperty.SelectedIndex    = 2
            $This.IO._ViewDeviceInvoiceSearchProperty.SelectedIndex     = 2
            $This.IO._EditDeviceClientSearchProperty.SelectedIndex      = 2
            $This.IO._EditDeviceIssueSearchProperty.SelectedIndex       = 2
            $This.IO._EditDevicePurchaseSearchProperty.SelectedIndex    = 2
            $This.IO._EditDeviceInvoiceSearchProperty.SelectedIndex     = 2
            $This.IO._NewDeviceClientSearchProperty.SelectedIndex       = 2
            $This.IO._NewDeviceIssueSearchProperty.SelectedIndex        = 2
            $This.IO._NewDevicePurchaseSearchProperty.SelectedIndex     = 2
            $This.IO._NewDeviceInvoiceSearchProperty.SelectedIndex      = 2
            $This.IO._GetIssueSearchProperty.SelectedIndex              = 2
            $This.IO._ViewIssueClientSearchProperty.SelectedIndex       = 2
            $This.IO._ViewIssueDeviceSearchProperty.SelectedIndex       = 2
            $This.IO._ViewIssuePurchaseSearchProperty.SelectedIndex     = 2
            $This.IO._ViewIssueInvoiceSearchProperty.SelectedIndex      = 2
            $This.IO._EditIssueClientSearchProperty.SelectedIndex       = 2
            $This.IO._EditIssueDeviceSearchProperty.SelectedIndex       = 2
            $This.IO._EditIssuePurchaseSearchProperty.SelectedIndex     = 2
            $This.IO._EditIssueInvoiceSearchProperty.SelectedIndex      = 2
            $This.IO._NewIssueClientSearchProperty.SelectedIndex        = 2
            $This.IO._NewIssueDeviceSearchProperty.SelectedIndex        = 2
            $This.IO._NewIssuePurchaseSearchProperty.SelectedIndex      = 2
            $This.IO._NewIssueInvoiceSearchProperty.SelectedIndex       = 2
            $This.IO._GetInventorySearchProperty.SelectedIndex          = 2
            $This.IO._ViewInventoryDeviceSearchProperty.SelectedIndex   = 2
            $This.IO._EditInventoryDeviceSearchProperty.SelectedIndex   = 2
            $This.IO._NewInventoryDeviceSearchProperty.SelectedIndex    = 2
            $This.IO._GetPurchaseSearchProperty.SelectedIndex           = 2
            $This.IO._ViewPurchaseDeviceSearchProperty.SelectedIndex    = 2
            $This.IO._EditPurchaseDeviceSearchProperty.SelectedIndex    = 2
            $This.IO._NewPurchaseDeviceSearchProperty.SelectedIndex     = 2
            $This.IO._GetExpenseSearchProperty.SelectedIndex            = 2
            $This.IO._ViewExpenseDeviceSearchProperty.SelectedIndex     = 2
            $This.IO._EditExpenseDeviceSearchProperty.SelectedIndex     = 2
            $This.IO._NewExpenseDeviceSearchProperty.SelectedIndex      = 2
            $This.IO._GetAccountSearchProperty.SelectedIndex            = 2
            $This.IO._ViewAccountObjectSearchProperty.SelectedIndex     = 2
            $This.IO._EditAccountObjectSearchProperty.SelectedIndex     = 2
            $This.IO._NewAccountObjectSearchProperty.SelectedIndex      = 2
            $This.IO._GetInvoiceSearchProperty.SelectedIndex            = 2
            $This.IO._ViewInvoiceClientSearchProperty.SelectedIndex     = 2
            $This.IO._ViewInvoiceInventorySearchProperty.SelectedIndex  = 2
            $This.IO._ViewInvoiceServiceSearchProperty.SelectedIndex    = 2
            $This.IO._ViewInvoicePurchaseSearchProperty.SelectedIndex   = 2
            $This.IO._EditInvoiceClientSearchProperty.SelectedIndex     = 2
            $This.IO._EditInvoiceInventorySearchProperty.SelectedIndex  = 2
            $This.IO._EditInvoiceServiceSearchProperty.SelectedIndex    = 2
            $This.IO._EditInvoicePurchaseSearchProperty.SelectedIndex   = 2
            $This.IO._NewInvoiceClientSearchProperty.SelectedIndex      = 2
            $This.IO._NewInvoiceInventorySearchProperty.SelectedIndex   = 2
            $This.IO._NewInvoiceServiceSearchProperty.SelectedIndex     = 2
            $This.IO._NewInvoicePurchaseSearchProperty.SelectedIndex    = 2
        }

        DefaultSearchResult()
        {
            $This.IO._GetUIDSearchResult.ItemsSource                    = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetClientSearchResult.ItemsSource                 = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewClientDeviceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewClientInvoiceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditClientDeviceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditClientInvoiceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewClientDeviceSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewClientInvoiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetServiceSearchResult.ItemsSource                = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetDeviceSearchResult.ItemsSource                 = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewDeviceClientSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewDeviceIssueSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewDevicePurchaseSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewDeviceInvoiceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditDeviceClientSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditDeviceIssueSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditDevicePurchaseSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditDeviceInvoiceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewDeviceClientSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewDeviceIssueSearchResult.ItemsSource            = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewDevicePurchaseSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewDeviceInvoiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetIssueSearchResult.ItemsSource                  = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewIssueClientSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewIssueDeviceSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewIssuePurchaseSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewIssueServiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewIssueInvoiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditIssueClientSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditIssueDeviceSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditIssuePurchaseSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditIssueServiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditIssueInvoiceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewIssueClientSearchResult.ItemsSource            = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewIssueDeviceSearchResult.ItemsSource            = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewIssuePurchaseSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewIssueServiceSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewIssueInvoiceSearchResult.ItemsSource           = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetInventorySearchResult.ItemsSource              = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewInventoryDeviceSearchResult.ItemsSource       = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditInventoryDeviceSearchResult.ItemsSource       = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewInventoryDeviceSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetPurchaseSearchResult.ItemsSource               = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewPurchaseDeviceSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditPurchaseDeviceSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewPurchaseDeviceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetExpenseSearchResult.ItemsSource                = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewExpenseDeviceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditExpenseDeviceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewExpenseDeviceSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetAccountSearchResult.ItemsSource                = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewAccountObjectSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditAccountObjectSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewAccountObjectSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._GetInvoiceSearchResult.ItemsSource                = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewInvoiceClientSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewInvoiceInventorySearchResult.ItemsSource      = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewInvoiceServiceSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._ViewInvoicePurchaseSearchResult.ItemsSource       = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditInvoiceClientSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditInvoiceInventorySearchResult.ItemsSource      = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditInvoiceServiceSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._EditInvoicePurchaseSearchResult.ItemsSource       = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewInvoiceClientSearchResult.ItemsSource          = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewInvoiceInventorySearchResult.ItemsSource       = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewInvoiceServiceSearchResult.ItemsSource         = New-Object System.Collections.ObjectModel.Collection[Object]
            $This.IO._NewInvoicePurchaseSearchResult.ItemsSource        = New-Object System.Collections.ObjectModel.Collection[Object]
        }

        DefaultSearchFilter()
        {
            $This.IO._GetUIDSearchFilter.Text                           = $This.Date
            $This.IO._GetClientSearchFilter.Text                        = $This.Date
            $This.IO._ViewClientDeviceSearchFilter.Text                 = $This.Date
            $This.IO._ViewClientInvoiceSearchFilter.Text                = $This.Date
            $This.IO._EditClientDeviceSearchFilter.Text                 = $This.Date
            $This.IO._EditClientInvoiceSearchFilter.Text                = $This.Date
            $This.IO._NewClientDeviceSearchFilter.Text                  = $This.Date
            $This.IO._NewClientInvoiceSearchFilter.Text                 = $This.Date
            $This.IO._GetServiceSearchFilter.Text                       = $This.Date
            $This.IO._GetDeviceSearchFilter.Text                        = $This.Date
            $This.IO._ViewDeviceClientSearchFilter.Text                 = $This.Date
            $This.IO._ViewDeviceIssueSearchFilter.Text                  = $This.Date
            $This.IO._ViewDevicePurchaseSearchFilter.Text               = $This.Date
            $This.IO._ViewDeviceInvoiceSearchFilter.Text                = $This.Date
            $This.IO._EditDeviceClientSearchFilter.Text                 = $This.Date
            $This.IO._EditDeviceIssueSearchFilter.Text                  = $This.Date
            $This.IO._EditDevicePurchaseSearchFilter.Text               = $This.Date
            $This.IO._EditDeviceInvoiceSearchFilter.Text                = $This.Date
            $This.IO._NewDeviceClientSearchFilter.Text                  = $This.Date
            $This.IO._NewDeviceIssueSearchFilter.Text                   = $This.Date
            $This.IO._NewDevicePurchaseSearchFilter.Text                = $This.Date
            $This.IO._NewDeviceInvoiceSearchFilter.Text                 = $This.Date
            $This.IO._GetIssueSearchFilter.Text                         = $This.Date
            $This.IO._ViewIssueClientSearchFilter.Text                  = $This.Date
            $This.IO._ViewIssueDeviceSearchFilter.Text                  = $This.Date
            $This.IO._ViewIssuePurchaseSearchFilter.Text                = $This.Date
            $This.IO._ViewIssueInvoiceSearchFilter.Text                 = $This.Date
            $This.IO._EditIssueClientSearchFilter.Text                  = $This.Date
            $This.IO._EditIssueDeviceSearchFilter.Text                  = $This.Date
            $This.IO._EditIssuePurchaseSearchFilter.Text                = $This.Date
            $This.IO._EditIssueInvoiceSearchFilter.Text                 = $This.Date
            $This.IO._NewIssueClientSearchFilter.Text                   = $This.Date
            $This.IO._NewIssueDeviceSearchFilter.Text                   = $This.Date
            $This.IO._NewIssuePurchaseSearchFilter.Text                 = $This.Date
            $This.IO._NewIssueInvoiceSearchFilter.Text                  = $This.Date
            $This.IO._GetInventorySearchFilter.Text                     = $This.Date
            $This.IO._ViewInventoryDeviceSearchFilter.Text              = $This.Date
            $This.IO._EditInventoryDeviceSearchFilter.Text              = $This.Date
            $This.IO._NewInventoryDeviceSearchFilter.Text               = $This.Date
            $This.IO._GetPurchaseSearchFilter.Text                      = $This.Date
            $This.IO._ViewPurchaseDeviceSearchFilter.Text               = $This.Date
            $This.IO._EditPurchaseDeviceSearchFilter.Text               = $This.Date
            $This.IO._NewPurchaseDeviceSearchFilter.Text                = $This.Date
            $This.IO._GetExpenseSearchFilter.Text                       = $This.Date
            $This.IO._ViewExpenseDeviceSearchFilter.Text                = $This.Date
            $This.IO._EditExpenseDeviceSearchFilter.Text                = $This.Date
            $This.IO._NewExpenseDeviceSearchFilter.Text                 = $This.Date
            $This.IO._GetAccountSearchFilter.Text                       = $This.Date
            $This.IO._ViewAccountObjectSearchFilter.Text                = $This.Date
            $This.IO._EditAccountObjectSearchFilter.Text                = $This.Date
            $This.IO._NewAccountObjectSearchFilter.Text                 = $This.Date
            $This.IO._GetInvoiceSearchFilter.Text                       = $This.Date
            $This.IO._ViewInvoiceClientSearchFilter.Text                = $This.Date
            $This.IO._ViewInvoiceInventorySearchFilter.Text             = $This.Date
            $This.IO._ViewInvoiceServiceSearchFilter.Text               = $This.Date
            $This.IO._ViewInvoicePurchaseSearchFilter.Text              = $This.Date
            $This.IO._EditInvoiceClientSearchFilter.Text                = $This.Date
            $This.IO._EditInvoiceInventorySearchFilter.Text             = $This.Date
            $This.IO._EditInvoiceServiceSearchFilter.Text               = $This.Date
            $This.IO._EditInvoicePurchaseSearchFilter.Text              = $This.Date
            $This.IO._NewInvoiceClientSearchFilter.Text                 = $This.Date
            $This.IO._NewInvoiceInventorySearchFilter.Text              = $This.Date
            $This.IO._NewInvoiceServiceSearchFilter.Text                = $This.Date
            $This.IO._NewInvoicePurchaseSearchFilter.Text               = $This.Date
        }

        cimdb([String]$Xaml)
        {
            $This.Window                                    = [_Xaml]::New($Xaml)
            $This.IO                                        = $This.Window.IO
            $This.Temp                                      = [_Template]::New()
            $This.DB                                        = [_DB]::New()

            $This.DefaultSearchProperty()
            $This.DefaultSearchResult()
            $This.DefaultSearchFilter()
        }

        SetDefaults()
        {
            $This.CollapsePanel()
            $This.ClearTextBox()
            $This.SetSearchFilter()
            $This.ClearComboBoxItemsSource()
            $This.Refresh()
        }

        CollapsePanel()
        {
            $This.IO._GetUIDPanel.Visibility                = "Collapsed"
            $This.IO._ViewUIDPanel.Visibility               = "Collapsed"
            $This.IO._GetClientPanel.Visibility             = "Collapsed"
            $This.IO._ViewClientPanel.Visibility            = "Collapsed"
            $This.IO._EditClientPanel.Visibility            = "Collapsed"
            $This.IO._NewClientPanel.Visibility             = "Collapsed"
            $This.IO._GetServicePanel.Visibility            = "Collapsed"
            $This.IO._ViewServicePanel.Visibility           = "Collapsed"
            $This.IO._EditServicePanel.Visibility           = "Collapsed"
            $This.IO._NewServicePanel.Visibility            = "Collapsed"
            $This.IO._GetDevicePanel.Visibility             = "Collapsed"
            $This.IO._ViewDevicePanel.Visibility            = "Collapsed"
            $This.IO._EditDevicePanel.Visibility            = "Collapsed"
            $This.IO._NewDevicePanel.Visibility             = "Collapsed"
            $This.IO._GetIssuePanel.Visibility              = "Collapsed"
            $This.IO._ViewIssuePanel.Visibility             = "Collapsed"
            $This.IO._EditIssuePanel.Visibility             = "Collapsed"
            $This.IO._NewIssuePanel.Visibility              = "Collapsed"
            $This.IO._GetInventoryPanel.Visibility          = "Collapsed"
            $This.IO._ViewInventoryPanel.Visibility         = "Collapsed"
            $This.IO._EditInventoryPanel.Visibility         = "Collapsed"
            $This.IO._NewInventoryPanel.Visibility          = "Collapsed"
            $This.IO._GetPurchasePanel.Visibility           = "Collapsed"
            $This.IO._ViewPurchasePanel.Visibility          = "Collapsed"
            $This.IO._EditPurchasePanel.Visibility          = "Collapsed"
            $This.IO._NewPurchasePanel.Visibility           = "Collapsed"
            $This.IO._GetExpensePanel.Visibility            = "Collapsed"
            $This.IO._ViewExpensePanel.Visibility           = "Collapsed"
            $This.IO._EditExpensePanel.Visibility           = "Collapsed"
            $This.IO._NewExpensePanel.Visibility            = "Collapsed"
            $This.IO._GetAccountPanel.Visibility            = "Collapsed"
            $This.IO._ViewAccountPanel.Visibility           = "Collapsed"
            $This.IO._EditAccountPanel.Visibility           = "Collapsed"
            $This.IO._NewAccountPanel.Visibility            = "Collapsed"
            $This.IO._GetInvoicePanel.Visibility            = "Collapsed"
            $This.IO._ViewInvoicePanel.Visibility           = "Collapsed"
            $This.IO._EditInvoicePanel.Visibility           = "Collapsed"
            $This.IO._NewInvoicePanel.Visibility            = "Collapsed"
        }

        ClearTextBox()
        {
            $This.IO._EditClientAddress.Text                           = $Null
            $This.IO._EditClientCity.Text                              = $Null
            $This.IO._EditClientCountry.Text                           = $Null
            $This.IO._EditClientDay.Text                               = $Null
            $This.IO._EditClientEmailText.Text                         = $Null
            $This.IO._EditClientFirst.Text                             = $Null
            $This.IO._EditClientLast.Text                              = $Null
            $This.IO._EditClientMI.Text                                = $Null
            $This.IO._EditClientMonth.Text                             = $Null
            $This.IO._EditClientPhoneText.Text                         = $Null
            $This.IO._EditClientPostal.Text                            = $Null
            $This.IO._EditClientRegion.Text                            = $Null
            $This.IO._EditClientYear.Text                              = $Null
            $This.IO._EditDeviceModel.Text                             = $Null
            $This.IO._EditDeviceSerial.Text                            = $Null
            $This.IO._EditDeviceSpecification.Text                     = $Null
            $This.IO._EditDeviceTitle.Text                             = $Null
            $This.IO._EditDeviceVendor.Text                            = $Null
            $This.IO._EditExpenseCost.Text                             = $Null
            $This.IO._EditExpenseDisplayName.Text                      = $Null
            $This.IO._EditExpenseRecipient.Text                        = $Null
            $This.IO._EditInventoryCost.Text                           = $Null
            $This.IO._EditInventoryModel.Text                          = $Null
            $This.IO._EditInventorySerial.Text                         = $Null
            $This.IO._EditInventoryTitle.Text                          = $Null
            $This.IO._EditInventoryVendor.Text                         = $Null
            $This.IO._EditIssueDescription.Text                        = $Null
            $This.IO._EditPurchaseCost.Text                            = $Null
            $This.IO._EditPurchaseDisplayName.Text                     = $Null
            $This.IO._EditPurchaseDistributor.Text                     = $Null
            $This.IO._EditPurchaseModel.Text                           = $Null
            $This.IO._EditPurchaseSerial.Text                          = $Null
            $This.IO._EditPurchaseSpecification.Text                   = $Null
            $This.IO._EditPurchaseVendor.Text                          = $Null
            $This.IO._EditServiceCost.Text                             = $Null
            $This.IO._EditServiceDescription.Text                      = $Null
            $This.IO._EditServiceName.Text                             = $Null
            $This.IO._NewClientAddress.Text                            = $Null
            $This.IO._NewClientCity.Text                               = $Null
            $This.IO._NewClientCountry.Text                            = $Null
            $This.IO._NewClientDay.Text                                = $Null
            $This.IO._NewClientEmailText.Text                          = $Null
            $This.IO._NewClientFirst.Text                              = $Null
            $This.IO._NewClientLast.Text                               = $Null
            $This.IO._NewClientMI.Text                                 = $Null
            $This.IO._NewClientMonth.Text                              = $Null
            $This.IO._NewClientPhoneText.Text                          = $Null
            $This.IO._NewClientPostal.Text                             = $Null
            $This.IO._NewClientRegion.Text                             = $Null
            $This.IO._NewClientYear.Text                               = $Null
            $This.IO._NewDeviceModel.Text                              = $Null
            $This.IO._NewDeviceSerial.Text                             = $Null
            $This.IO._NewDeviceSpecification.Text                      = $Null
            $This.IO._NewDeviceTitle.Text                              = $Null
            $This.IO._NewDeviceVendor.Text                             = $Null
            $This.IO._NewExpenseCost.Text                              = $Null
            $This.IO._NewExpenseDisplayName.Text                       = $Null
            $This.IO._NewExpenseRecipient.Text                         = $Null
            $This.IO._NewInventoryCost.Text                            = $Null
            $This.IO._NewInventoryModel.Text                           = $Null
            $This.IO._NewInventorySerial.Text                          = $Null
            $This.IO._NewInventoryTitle.Text                           = $Null
            $This.IO._NewInventoryVendor.Text                          = $Null
            $This.IO._NewIssueDescription.Text                         = $Null
            $This.IO._NewPurchaseCost.Text                             = $Null
            $This.IO._NewPurchaseDisplayName.Text                      = $Null
            $This.IO._NewPurchaseDistributor.Text                      = $Null
            $This.IO._NewPurchaseModel.Text                            = $Null
            $This.IO._NewPurchaseSerial.Text                           = $Null
            $This.IO._NewPurchaseSpecification.Text                    = $Null
            $This.IO._NewPurchaseVendor.Text                           = $Null
            $This.IO._NewServiceCost.Text                              = $Null
            $This.IO._NewServiceDescription.Text                       = $Null
            $This.IO._NewServiceName.Text                              = $Null
            $This.IO._ViewClientAddress.Text                           = $Null
            $This.IO._ViewClientCity.Text                              = $Null
            $This.IO._ViewClientCountry.Text                           = $Null
            $This.IO._ViewClientDay.Text                               = $Null
            $This.IO._ViewClientEmailText.Text                         = $Null
            $This.IO._ViewClientFirst.Text                             = $Null
            $This.IO._ViewClientLast.Text                              = $Null
            $This.IO._ViewClientMI.Text                                = $Null
            $This.IO._ViewClientMonth.Text                             = $Null
            $This.IO._ViewClientPhoneText.Text                         = $Null
            $This.IO._ViewClientPostal.Text                            = $Null
            $This.IO._ViewClientRegion.Text                            = $Null
            $This.IO._ViewClientYear.Text                              = $Null
            $This.IO._ViewDeviceModel.Text                             = $Null
            $This.IO._ViewDeviceSerial.Text                            = $Null
            $This.IO._ViewDeviceSpecification.Text                     = $Null
            $This.IO._ViewDeviceTitle.Text                             = $Null
            $This.IO._ViewDeviceVendor.Text                            = $Null
            $This.IO._ViewExpenseCost.Text                             = $Null
            $This.IO._ViewExpenseDisplayName.Text                      = $Null
            $This.IO._ViewExpenseRecipient.Text                        = $Null
            $This.IO._ViewInventoryCost.Text                           = $Null
            $This.IO._ViewInventoryModel.Text                          = $Null
            $This.IO._ViewInventorySerial.Text                         = $Null
            $This.IO._ViewInventoryTitle.Text                          = $Null
            $This.IO._ViewInventoryVendor.Text                         = $Null
            $This.IO._ViewIssueDescription.Text                        = $Null
            $This.IO._ViewPurchaseCost.Text                            = $Null
            $This.IO._ViewPurchaseDisplayName.Text                     = $Null
            $This.IO._ViewPurchaseDistributor.Text                     = $Null
            $This.IO._ViewPurchaseModel.Text                           = $Null
            $This.IO._ViewPurchaseSerial.Text                          = $Null
            $This.IO._ViewPurchaseSpecification.Text                   = $Null
            $This.IO._ViewPurchaseVendor.Text                          = $Null
            $This.IO._ViewServiceCost.Text                             = $Null
            $This.IO._ViewServiceDescription.Text                      = $Null
            $This.IO._ViewServiceName.Text                             = $Null
            $This.IO._ViewUIDDate.Text                                 = $Null
            $This.IO._ViewUIDIndex.Text                                = $Null
            $This.IO._ViewUIDSlot.Text                                 = $Null
            $This.IO._ViewUIDTime.Text                                 = $Null
            $This.IO._ViewUIDType.Text                                 = $Null
            $This.IO._ViewUIDUID.Text                                  = $Null
        }

        SetSearchFilter()
        {
            $This.IO._EditAccountObjectSearchFilter.Text               = $This.Date
            $This.IO._EditClientDeviceSearchFilter.Text                = $This.Date
            $This.IO._EditClientInvoiceSearchFilter.Text               = $This.Date
            $This.IO._EditDeviceClientSearchFilter.Text                = $This.Date
            $This.IO._EditDeviceInvoiceSearchFilter.Text               = $This.Date 
            $This.IO._EditDeviceIssueSearchFilter.Text                 = $This.Date 
            $This.IO._EditDevicePurchaseSearchFilter.Text              = $This.Date 
            $This.IO._EditExpenseDeviceSearchFilter.Text               = $This.Date 
            $This.IO._EditInventoryDeviceSearchFilter.Text             = $This.Date 
            $This.IO._EditInvoiceClientSearchFilter.Text               = $This.Date 
            $This.IO._EditInvoiceInventorySearchFilter.Text            = $This.Date 
            $This.IO._EditInvoicePurchaseSearchFilter.Text             = $This.Date 
            $This.IO._EditInvoiceServiceSearchFilter.Text              = $This.Date 
            $This.IO._EditIssueClientSearchFilter.Text                 = $This.Date 
            $This.IO._EditIssueDeviceSearchFilter.Text                 = $This.Date 
            $This.IO._EditIssueInvoiceSearchFilter.Text                = $This.Date 
            $This.IO._EditIssuePurchaseSearchFilter.Text               = $This.Date 
            $This.IO._EditPurchaseDeviceSearchFilter.Text              = $This.Date 
            $This.IO._GetAccountSearchFilter.Text                      = $This.Date 
            $This.IO._GetClientSearchFilter.Text                       = $This.Date 
            $This.IO._GetDeviceSearchFilter.Text                       = $This.Date 
            $This.IO._GetExpenseSearchFilter.Text                      = $This.Date 
            $This.IO._GetInventorySearchFilter.Text                    = $This.Date 
            $This.IO._GetInvoiceSearchFilter.Text                      = $This.Date 
            $This.IO._GetIssueSearchFilter.Text                        = $This.Date 
            $This.IO._GetPurchaseSearchFilter.Text                     = $This.Date 
            $This.IO._GetServiceSearchFilter.Text                      = $This.Date 
            $This.IO._GetUIDSearchFilter.Text                          = $This.Date 
            $This.IO._NewAccountObjectSearchFilter.Text                = $This.Date 
            $This.IO._NewClientDeviceSearchFilter.Text                 = $This.Date 
            $This.IO._NewClientInvoiceSearchFilter.Text                = $This.Date 
            $This.IO._NewDeviceClientSearchFilter.Text                 = $This.Date 
            $This.IO._NewDeviceInvoiceSearchFilter.Text                = $This.Date 
            $This.IO._NewDeviceIssueSearchFilter.Text                  = $This.Date 
            $This.IO._NewDevicePurchaseSearchFilter.Text               = $This.Date 
            $This.IO._NewExpenseDeviceSearchFilter.Text                = $This.Date 
            $This.IO._NewInventoryDeviceSearchFilter.Text              = $This.Date 
            $This.IO._NewInvoiceClientSearchFilter.Text                = $This.Date 
            $This.IO._NewInvoiceInventorySearchFilter.Text             = $This.Date 
            $This.IO._NewInvoicePurchaseSearchFilter.Text              = $This.Date 
            $This.IO._NewInvoiceServiceSearchFilter.Text               = $This.Date 
            $This.IO._NewIssueClientSearchFilter.Text                  = $This.Date 
            $This.IO._NewIssueDeviceSearchFilter.Text                  = $This.Date 
            $This.IO._NewIssueInvoiceSearchFilter.Text                 = $This.Date 
            $This.IO._NewIssuePurchaseSearchFilter.Text                = $This.Date 
            $This.IO._NewPurchaseDeviceSearchFilter.Text               = $This.Date 
            $This.IO._ViewAccountObjectSearchFilter.Text               = $This.Date 
            $This.IO._ViewClientDeviceSearchFilter.Text                = $This.Date 
            $This.IO._ViewClientInvoiceSearchFilter.Text               = $This.Date 
            $This.IO._ViewDeviceClientSearchFilter.Text                = $This.Date
            $This.IO._ViewDeviceInvoiceSearchFilter.Text               = $This.Date
            $This.IO._ViewDeviceIssueSearchFilter.Text                 = $This.Date
            $This.IO._ViewDevicePurchaseSearchFilter.Text              = $This.Date 
            $This.IO._ViewExpenseDeviceSearchFilter.Text               = $This.Date 
            $This.IO._ViewInventoryDeviceSearchFilter.Text             = $This.Date 
            $This.IO._ViewInvoiceClientSearchFilter.Text               = $This.Date 
            $This.IO._ViewInvoiceInventorySearchFilter.Text            = $This.Date 
            $This.IO._ViewInvoicePurchaseSearchFilter.Text             = $This.Date 
            $This.IO._ViewInvoiceServiceSearchFilter.Text              = $This.Date 
            $This.IO._ViewIssueClientSearchFilter.Text                 = $This.Date 
            $This.IO._ViewIssueDeviceSearchFilter.Text                 = $This.Date 
            $This.IO._ViewIssueInvoiceSearchFilter.Text                = $This.Date 
            $This.IO._ViewIssuePurchaseSearchFilter.Text               = $This.Date 
            $This.IO._ViewPurchaseDeviceSearchFilter.Text              = $This.Date 
        }
         
        ClearComboBoxItemsSource()
        {   
            $This.IO._ViewClientPhoneList.ItemsSource        = $Null
            $This.IO._ViewClientEmailList.ItemsSource        = $Null
            $This.IO._ViewClientDeviceList.ItemsSource       = $Null
            $This.IO._ViewClientInvoiceList.ItemsSource      = $Null
            $This.IO._EditClientPhoneList.ItemsSource        = $Null
            $This.IO._EditClientEmailList.ItemsSource        = $Null
            $This.IO._EditClientDeviceList.ItemsSource       = $Null
            $This.IO._EditClientInvoiceList.ItemsSource      = $Null
            $This.IO._NewClientPhoneList.ItemsSource         = $Null
            $This.IO._NewClientEmailList.ItemsSource         = $Null
            $This.IO._NewClientDeviceList.ItemsSource        = $Null
            $This.IO._NewClientInvoiceList.ItemsSource       = $Null
            $This.IO._ViewDeviceClientList.ItemsSource       = $Null
            $This.IO._ViewDeviceIssueList.ItemsSource        = $Null
            $This.IO._ViewDevicePurchaseList.ItemsSource     = $Null
            $This.IO._ViewDeviceInvoiceList.ItemsSource      = $Null
            $This.IO._EditDeviceClientList.ItemsSource       = $Null
            $This.IO._EditDeviceIssueList.ItemsSource        = $Null
            $This.IO._EditDevicePurchaseList.ItemsSource     = $Null
            $This.IO._EditDeviceInvoiceList.ItemsSource      = $Null
            $This.IO._NewDeviceClientList.ItemsSource        = $Null
            $This.IO._NewDeviceIssueList.ItemsSource         = $Null
            $This.IO._NewDevicePurchaseList.ItemsSource      = $Null
            $This.IO._NewDeviceInvoiceList.ItemsSource       = $Null
            $This.IO._ViewIssueClientList.ItemsSource        = $Null
            $This.IO._ViewIssueDeviceList.ItemsSource        = $Null
            $This.IO._ViewIssuePurchaseList.ItemsSource      = $Null
            $This.IO._ViewIssueServiceList.ItemsSource       = $Null
            $This.IO._ViewIssueInvoiceList.ItemsSource       = $Null
            $This.IO._EditIssueClientList.ItemsSource        = $Null
            $This.IO._EditIssueDeviceList.ItemsSource        = $Null
            $This.IO._EditIssuePurchaseList.ItemsSource      = $Null
            $This.IO._EditIssueServiceList.ItemsSource       = $Null
            $This.IO._EditIssueInvoiceList.ItemsSource       = $Null
            $This.IO._NewIssueClientList.ItemsSource         = $Null
            $This.IO._NewIssueDeviceList.ItemsSource         = $Null
            $This.IO._NewIssuePurchaseList.ItemsSource       = $Null
            $This.IO._NewIssueServiceList.ItemsSource        = $Null
            $This.IO._NewIssueInvoiceList.ItemsSource        = $Null
            $This.IO._ViewInventoryDeviceList.ItemsSource    = $Null
            $This.IO._EditInventoryDeviceList.ItemsSource    = $Null
            $This.IO._NewInventoryDeviceList.ItemsSource     = $Null
            $This.IO._ViewPurchaseDeviceList.ItemsSource     = $Null
            $This.IO._EditPurchaseDeviceList.ItemsSource     = $Null
            $This.IO._NewPurchaseDeviceList.ItemsSource      = $Null
            $This.IO._ViewExpenseDeviceList.ItemsSource      = $Null
            $This.IO._EditExpenseDeviceList.ItemsSource      = $Null
            $This.IO._NewExpenseDeviceList.ItemsSource       = $Null
            $This.IO._ViewAccountDeviceList.ItemsSource      = $Null
            $This.IO._EditAccountObjectList.ItemsSource      = $Null
            $This.IO._NewAccountObjectList.ItemsSource       = $Null
            $This.IO._ViewInvoiceClientList.ItemsSource      = $Null
            $This.IO._ViewInvoiceInventoryList.ItemsSource   = $Null
            $This.IO._ViewInvoiceServiceList.ItemsSource     = $Null
            $This.IO._ViewInvoicePurchaseList.ItemsSource    = $Null
            $This.IO._EditInvoiceClientList.ItemsSource      = $Null
            $This.IO._EditInvoiceInventoryList.ItemsSource   = $Null
            $This.IO._EditInvoiceServiceList.ItemsSource     = $Null
            $This.IO._EditInvoicePurchaseList.ItemsSource    = $Null
            $This.IO._NewInvoiceClientList.ItemsSource       = $Null
            $This.IO._NewInvoiceInventoryList.ItemsSource    = $Null
            $This.IO._NewInvoiceServiceList.ItemsSource      = $Null
            $This.IO._NewInvoicePurchaseList.ItemsSource     = $Null
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

        [Void] Populate([Object]$Record,[Object]$Control)
        {
            $Control.ItemsSource = $Null

            If ( $Record.Count -ne 0 )
            {
                ForEach ( $Item in $Record )
                {
                    $Control.Items.Add($Item)
                    $Control.SelectedIndex = $Control.Items.Count - 1
                }
            }
        }

        GetTab([UInt32]$Slot)
        {
            $This.CollapsePanel()
            $This.ClearTextBox()
            
            $This.IO._UIDPanel.Visibility                   = "Collapsed"
            $This.IO._ClientPanel.Visibility                = "Collapsed"
            $This.IO._ServicePanel.Visibility               = "Collapsed"
            $This.IO._DevicePanel.Visibility                = "Collapsed"
            $This.IO._IssuePanel.Visibility                 = "Collapsed"
            $This.IO._InventoryPanel.Visibility             = "Collapsed"
            $This.IO._PurchasePanel.Visibility              = "Collapsed"
            $This.IO._ExpensePanel.Visibility               = "Collapsed"
            $This.IO._AccountPanel.Visibility               = "Collapsed"
            $This.IO._InvoicePanel.Visibility               = "Collapsed"

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
            <Button Grid.Row="0" Name="_UIDTab">
                <Image Source="C:\ProgramData\Secure Digits Plus LLC\Graphics\sdplogo.png"/>
            </Button>
            <Button Grid.Row="1" Name="_ClientTab"    HorizontalContentAlignment="Right" Content="Client"/>
            <Button Grid.Row="2" Name="_ServiceTab"   HorizontalContentAlignment="Right" Content="Service"/>
            <Button Grid.Row="3" Name="_DeviceTab"    HorizontalContentAlignment="Right" Content="Device"/>
            <Button Grid.Row="4" Name="_IssueTab"     HorizontalContentAlignment="Right" Content="Issue"/>
            <Button Grid.Row="5" Name="_InventoryTab" HorizontalContentAlignment="Right" Content="Inventory"/>
            <Button Grid.Row="6" Name="_PurchaseTab"  HorizontalContentAlignment="Right" Content="Purchase"/>
            <Button Grid.Row="7" Name="_ExpenseTab"   HorizontalContentAlignment="Right" Content="Expense"/>
            <Button Grid.Row="8" Name="_AccountTab"   HorizontalContentAlignment="Right" Content="Account"/>
            <Button Grid.Row="9" Name="_InvoiceTab"   HorizontalContentAlignment="Right" Content="Invoice"/>
        </Grid>
        <Grid Grid.Column="1" Name="_UIDPanel" Visibility="Collapsed">
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
            </Grid>
            <Grid Grid.Row="1" Name="_GetUIDPanel" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="40"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Grid Grid.Row="0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="4*"/>
                    </Grid.ColumnDefinitions>
                    <ComboBox Grid.Column="0" Name="_GetUIDSearchProperty"/>
                    <TextBox Grid.Column="1" Name="_GetUIDSearchFilter"/>
                </Grid>
                <DataGrid Grid.Row="1" Margin="5" Name="_GetUIDSearchResult">
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
            <Grid Grid.Row="1" Name="_ViewUIDPanel" Visibility="Collapsed">
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
                <DataGrid Grid.Row="2" Margin="5" Name="_ViewUIDRecordResult">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="2*"/>
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
        </Grid>
        <Grid Grid.Column="1" Name="_ClientPanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditClientTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewClientTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveClientTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetClientPanel" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="40"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Grid Grid.Row="0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="4*"/>
                    </Grid.ColumnDefinitions>
                    <ComboBox Grid.Column="0" Name="_GetClientSearchProperty"/>
                    <TextBox Grid.Column="1" Name="_GetClientSearchFilter"/>
                </Grid>
                <DataGrid Grid.Row="1" Margin="5" Name="_GetClientSearchResult">
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Name"  Binding='{Binding Record.Name}'  Width="*"/>
                        <DataGridTextColumn Header="Last"  Binding='{Binding Record.Last}'  Width="*"/>
                        <DataGridTextColumn Header="First" Binding='{Binding Record.First}' Width="*"/>
                        <DataGridTextColumn Header="MI"    Binding='{Binding Record.MI}'    Width="0.25*"/>
                        <DataGridTextColumn Header="DOB"   Binding='{Binding Record.DOB}'   Width="*"/>
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
            <Grid Grid.Row="1" Name="_ViewClientPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditClientPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewClientPanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_ServicePanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditServiceTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewServiceTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveServiceTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetServicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewServicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditServicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewServicePanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_DevicePanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditDeviceTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewDeviceTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveDeviceTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetDevicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewDevicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditDevicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewDevicePanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_IssuePanel" Visibility="Visible">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditIssueTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewIssueTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveIssueTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetIssuePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewIssuePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditIssuePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewIssuePanel" Visibility="Visible">
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
        <Grid Grid.Column="1" Name="_InventoryPanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditInventoryTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewInventoryTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveInventoryTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetInventoryPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewInventoryPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditInventoryPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewInventoryPanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_PurchasePanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditPurchaseTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewPurchaseTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SavePurchaseTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetPurchasePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewPurchasePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditPurchasePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewPurchasePanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_ExpensePanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditExpenseTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewExpenseTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveExpenseTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetExpensePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewExpensePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditExpensePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewExpensePanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_AccountPanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditAccountTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewAccountTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveAccountTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetAccountPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewAccountPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditAccountPanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewAccountPanel" Visibility="Collapsed">
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
        <Grid Grid.Column="1" Name="_InvoicePanel" Visibility="Collapsed">
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Grid.Row="0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="0" Content="Edit" Name="_EditInvoiceTab"/>
                <Button Grid.Column="1" Content="New" Name="_NewInvoiceTab"/>
                <Button Grid.Column="2" Content="Save" Name="_SaveInvoiceTab"/>
            </Grid>
            <Grid Grid.Row="1" Name="_GetInvoicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_ViewInvoicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_EditInvoicePanel" Visibility="Collapsed">
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
            <Grid Grid.Row="1" Name="_NewInvoicePanel" Visibility="Collapsed">
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
</Window>
"@
    $Cim  = [Cimdb]::New($Xaml)

    $Cim.SetDefaults()

    # --------- #
    # UID Panel #
    # --------- #
    
    $Cim.IO.       _UIDTab.Add_Click{ $Cim.GetTab(0) }
    $Cim.IO.    _ClientTab.Add_Click{ $Cim.GetTab(1) }
    $Cim.IO.   _ServiceTab.Add_Click{ $Cim.GetTab(2) }
    $Cim.IO.    _DeviceTab.Add_Click{ $Cim.GetTab(3) }
    $Cim.IO.     _IssueTab.Add_Click{ $Cim.GetTab(4) }
    $Cim.IO. _InventoryTab.Add_Click{ $Cim.GetTab(5) }
    $Cim.IO.  _PurchaseTab.Add_Click{ $Cim.GetTab(6) }
    $Cim.IO.   _ExpenseTab.Add_Click{ $Cim.GetTab(7) }
    $Cim.IO.   _AccountTab.Add_Click{ $Cim.GetTab(8) }
    $Cim.IO.   _InvoiceTab.Add_Click{ $Cim.GetTab(9) }

    # Defaults
    $Cim.IO._EditClientTab.IsEnabled                  = 0
    $Cim.IO._SaveClientTab.IsEnabled                  = 0

    $Cim.IO._EditServiceTab.IsEnabled                 = 0
    $Cim.IO._SaveServiceTab.IsEnabled                 = 0

    $Cim.IO._EditDeviceTab.IsEnabled                  = 0
    $Cim.IO._SaveDeviceTab.IsEnabled                  = 0

    $Cim.IO._EditIssueTab.IsEnabled                   = 0
    $Cim.IO._SaveIssueTab.IsEnabled                   = 0

    $Cim.IO._EditInventoryTab.IsEnabled               = 0
    $Cim.IO._SaveInventoryTab.IsEnabled               = 0

    $Cim.IO._EditPurchaseTab.IsEnabled                = 0
    $Cim.IO._SavePurchaseTab.IsEnabled                = 0

    $Cim.IO._EditExpenseTab.IsEnabled                 = 0
    $Cim.IO._SaveExpenseTab.IsEnabled                 = 0

    $Cim.IO._EditAccountTab.IsEnabled                 = 0
    $Cim.IO._SaveAccountTab.IsEnabled                 = 0

    $Cim.IO._EditInvoiceTab.IsEnabled                 = 0
    $Cim.IO._SaveInvoiceTab.IsEnabled                 = 0

    # -------------- #
    # Event Triggers #
    # -------------- #


    $Cim.IO._GetUIDSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetUIDSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetUIDSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.UID | ? $Cim.IO._GetUIDSearchProperty.SelectedItem -match $Cim.IO._GetUIDSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetUIDSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetUIDSearchResult.ItemsSource = $Cim.DB.UID
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetUIDSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetUIDSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetUIDSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetUIDSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._GetClientSearchProperty.SelectedItem -match $Cim.IO._GetClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewClientDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewClientDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewClientDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._ViewClientDeviceSearchProperty.SelectedItem -match $Cim.IO._ViewClientDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewClientDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewClientDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewClientDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewClientDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewClientDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewClientDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewClientInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewClientInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewClientInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._ViewClientInvoiceSearchProperty.SelectedItem -match $Cim.IO._ViewClientInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewClientInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewClientInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewClientInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewClientInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewClientInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewClientInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditClientDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditClientDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditClientDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._EditClientDeviceSearchProperty.SelectedItem -match $Cim.IO._EditClientDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditClientDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditClientDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditClientDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditClientDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditClientDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditClientDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditClientInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditClientInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditClientInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._EditClientInvoiceSearchProperty.SelectedItem -match $Cim.IO._EditClientInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditClientInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditClientInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditClientInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditClientInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditClientInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditClientInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewClientDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewClientDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewClientDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._NewClientDeviceSearchProperty.SelectedItem -match $Cim.IO._NewClientDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewClientDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewClientDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewClientDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewClientDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewClientDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewClientDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewClientInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewClientInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewClientInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._NewClientInvoiceSearchProperty.SelectedItem -match $Cim.IO._NewClientInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewClientInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewClientInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewClientInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewClientInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewClientInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewClientInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetServiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetServiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetServiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Service | ? $Cim.IO._GetServiceSearchProperty.SelectedItem -match $Cim.IO._GetServiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetServiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetServiceSearchResult.ItemsSource = $Cim.DB.Service
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetServiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetServiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetServiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetServiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._GetDeviceSearchProperty.SelectedItem -match $Cim.IO._GetDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewDeviceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewDeviceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewDeviceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._ViewDeviceClientSearchProperty.SelectedItem -match $Cim.IO._ViewDeviceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewDeviceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewDeviceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewDeviceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewDeviceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewDeviceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewDeviceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewDeviceIssueSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewDeviceIssueSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewDeviceIssueSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Issue | ? $Cim.IO._ViewDeviceIssueSearchProperty.SelectedItem -match $Cim.IO._ViewDeviceIssueSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewDeviceIssueSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewDeviceIssueSearchResult.ItemsSource = $Cim.DB.Issue
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewDeviceIssueSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewDeviceIssueSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewDeviceIssueSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewDeviceIssueSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewDevicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewDevicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewDevicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._ViewDevicePurchaseSearchProperty.SelectedItem -match $Cim.IO._ViewDevicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewDevicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewDevicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewDevicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewDevicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewDevicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewDevicePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewDeviceInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewDeviceInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewDeviceInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._ViewDeviceInvoiceSearchProperty.SelectedItem -match $Cim.IO._ViewDeviceInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewDeviceInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewDeviceInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewDeviceInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewDeviceInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewDeviceInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewDeviceInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditDeviceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditDeviceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditDeviceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._EditDeviceClientSearchProperty.SelectedItem -match $Cim.IO._EditDeviceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditDeviceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditDeviceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditDeviceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditDeviceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditDeviceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditDeviceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditDeviceIssueSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditDeviceIssueSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditDeviceIssueSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Issue | ? $Cim.IO._EditDeviceIssueSearchProperty.SelectedItem -match $Cim.IO._EditDeviceIssueSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditDeviceIssueSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditDeviceIssueSearchResult.ItemsSource = $Cim.DB.Issue
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditDeviceIssueSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditDeviceIssueSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditDeviceIssueSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditDeviceIssueSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditDevicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditDevicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditDevicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._EditDevicePurchaseSearchProperty.SelectedItem -match $Cim.IO._EditDevicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditDevicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditDevicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditDevicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditDevicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditDevicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditDevicePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditDeviceInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditDeviceInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditDeviceInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._EditDeviceInvoiceSearchProperty.SelectedItem -match $Cim.IO._EditDeviceInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditDeviceInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditDeviceInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditDeviceInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditDeviceInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditDeviceInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditDeviceInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewDeviceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewDeviceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewDeviceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._NewDeviceClientSearchProperty.SelectedItem -match $Cim.IO._NewDeviceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewDeviceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewDeviceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewDeviceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewDeviceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewDeviceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewDeviceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewDeviceIssueSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewDeviceIssueSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewDeviceIssueSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Issue | ? $Cim.IO._NewDeviceIssueSearchProperty.SelectedItem -match $Cim.IO._NewDeviceIssueSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewDeviceIssueSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewDeviceIssueSearchResult.ItemsSource = $Cim.DB.Issue
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewDeviceIssueSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewDeviceIssueSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewDeviceIssueSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewDeviceIssueSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewDevicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewDevicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewDevicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._NewDevicePurchaseSearchProperty.SelectedItem -match $Cim.IO._NewDevicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewDevicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewDevicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewDevicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewDevicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewDevicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewDevicePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewDeviceInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewDeviceInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewDeviceInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._NewDeviceInvoiceSearchProperty.SelectedItem -match $Cim.IO._NewDeviceInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewDeviceInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewDeviceInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewDeviceInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewDeviceInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewDeviceInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewDeviceInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetIssueSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetIssueSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetIssueSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Issue | ? $Cim.IO._GetIssueSearchProperty.SelectedItem -match $Cim.IO._GetIssueSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetIssueSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetIssueSearchResult.ItemsSource = $Cim.DB.Issue
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetIssueSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetIssueSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetIssueSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetIssueSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewIssueClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewIssueClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewIssueClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._ViewIssueClientSearchProperty.SelectedItem -match $Cim.IO._ViewIssueClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewIssueClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewIssueClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewIssueClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewIssueClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewIssueClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewIssueClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewIssueDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewIssueDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewIssueDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._ViewIssueDeviceSearchProperty.SelectedItem -match $Cim.IO._ViewIssueDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewIssueDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewIssueDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewIssueDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewIssueDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewIssueDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewIssueDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewIssuePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewIssuePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewIssuePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._ViewIssuePurchaseSearchProperty.SelectedItem -match $Cim.IO._ViewIssuePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewIssuePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewIssuePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewIssuePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewIssuePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewIssuePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewIssuePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewIssueInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewIssueInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewIssueInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._ViewIssueInvoiceSearchProperty.SelectedItem -match $Cim.IO._ViewIssueInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewIssueInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewIssueInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewIssueInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewIssueInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewIssueInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewIssueInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditIssueClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditIssueClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditIssueClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._EditIssueClientSearchProperty.SelectedItem -match $Cim.IO._EditIssueClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditIssueClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditIssueClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditIssueClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditIssueClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditIssueClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditIssueClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditIssueDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditIssueDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditIssueDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._EditIssueDeviceSearchProperty.SelectedItem -match $Cim.IO._EditIssueDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditIssueDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditIssueDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditIssueDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditIssueDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditIssueDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditIssueDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditIssuePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditIssuePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditIssuePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._EditIssuePurchaseSearchProperty.SelectedItem -match $Cim.IO._EditIssuePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditIssuePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditIssuePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditIssuePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditIssuePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditIssuePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditIssuePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditIssueInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditIssueInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditIssueInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._EditIssueInvoiceSearchProperty.SelectedItem -match $Cim.IO._EditIssueInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditIssueInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditIssueInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditIssueInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditIssueInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditIssueInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditIssueInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewIssueClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewIssueClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewIssueClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._NewIssueClientSearchProperty.SelectedItem -match $Cim.IO._NewIssueClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewIssueClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewIssueClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewIssueClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewIssueClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewIssueClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewIssueClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewIssueDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewIssueDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewIssueDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._NewIssueDeviceSearchProperty.SelectedItem -match $Cim.IO._NewIssueDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewIssueDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewIssueDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewIssueDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewIssueDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewIssueDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewIssueDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewIssuePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewIssuePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewIssuePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._NewIssuePurchaseSearchProperty.SelectedItem -match $Cim.IO._NewIssuePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewIssuePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewIssuePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewIssuePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewIssuePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewIssuePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewIssuePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewIssueInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewIssueInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewIssueInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._NewIssueInvoiceSearchProperty.SelectedItem -match $Cim.IO._NewIssueInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewIssueInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewIssueInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewIssueInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewIssueInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewIssueInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewIssueInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetInventorySearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetInventorySearchFilter.Text -ne "" )
        {
            $Cim.IO._GetInventorySearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Inventory | ? $Cim.IO._GetInventorySearchProperty.SelectedItem -match $Cim.IO._GetInventorySearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetInventorySearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetInventorySearchResult.ItemsSource = $Cim.DB.Inventory
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetInventorySearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetInventorySearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetInventorySearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetInventorySearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewInventoryDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewInventoryDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewInventoryDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._ViewInventoryDeviceSearchProperty.SelectedItem -match $Cim.IO._ViewInventoryDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewInventoryDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewInventoryDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewInventoryDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewInventoryDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewInventoryDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewInventoryDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditInventoryDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditInventoryDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditInventoryDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._EditInventoryDeviceSearchProperty.SelectedItem -match $Cim.IO._EditInventoryDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditInventoryDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditInventoryDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditInventoryDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditInventoryDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditInventoryDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditInventoryDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewInventoryDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewInventoryDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewInventoryDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._NewInventoryDeviceSearchProperty.SelectedItem -match $Cim.IO._NewInventoryDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewInventoryDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewInventoryDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewInventoryDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewInventoryDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewInventoryDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewInventoryDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetPurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetPurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetPurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._GetPurchaseSearchProperty.SelectedItem -match $Cim.IO._GetPurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetPurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetPurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetPurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetPurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetPurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetPurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewPurchaseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewPurchaseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewPurchaseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._ViewPurchaseDeviceSearchProperty.SelectedItem -match $Cim.IO._ViewPurchaseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewPurchaseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewPurchaseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewPurchaseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewPurchaseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewPurchaseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewPurchaseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditPurchaseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditPurchaseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditPurchaseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._EditPurchaseDeviceSearchProperty.SelectedItem -match $Cim.IO._EditPurchaseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditPurchaseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditPurchaseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditPurchaseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditPurchaseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditPurchaseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditPurchaseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewPurchaseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewPurchaseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewPurchaseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._NewPurchaseDeviceSearchProperty.SelectedItem -match $Cim.IO._NewPurchaseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewPurchaseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewPurchaseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewPurchaseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewPurchaseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewPurchaseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewPurchaseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetExpenseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetExpenseSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetExpenseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Expense | ? $Cim.IO._GetExpenseSearchProperty.SelectedItem -match $Cim.IO._GetExpenseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetExpenseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetExpenseSearchResult.ItemsSource = $Cim.DB.Expense
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetExpenseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetExpenseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetExpenseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetExpenseSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewExpenseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewExpenseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewExpenseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._ViewExpenseDeviceSearchProperty.SelectedItem -match $Cim.IO._ViewExpenseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewExpenseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewExpenseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewExpenseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewExpenseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewExpenseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewExpenseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditExpenseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditExpenseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditExpenseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._EditExpenseDeviceSearchProperty.SelectedItem -match $Cim.IO._EditExpenseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditExpenseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditExpenseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditExpenseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditExpenseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditExpenseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditExpenseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewExpenseDeviceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewExpenseDeviceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewExpenseDeviceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Device | ? $Cim.IO._NewExpenseDeviceSearchProperty.SelectedItem -match $Cim.IO._NewExpenseDeviceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewExpenseDeviceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewExpenseDeviceSearchResult.ItemsSource = $Cim.DB.Device
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewExpenseDeviceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewExpenseDeviceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewExpenseDeviceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewExpenseDeviceSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetAccountSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetAccountSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetAccountSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Account | ? $Cim.IO._GetAccountSearchProperty.SelectedItem -match $Cim.IO._GetAccountSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetAccountSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetAccountSearchResult.ItemsSource = $Cim.DB.Account
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetAccountSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetAccountSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetAccountSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetAccountSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewAccountObjectSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewAccountObjectSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewAccountObjectSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Object | ? $Cim.IO._ViewAccountObjectSearchProperty.SelectedItem -match $Cim.IO._ViewAccountObjectSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewAccountObjectSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewAccountObjectSearchResult.ItemsSource = $Cim.DB.Object
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewAccountObjectSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewAccountObjectSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewAccountObjectSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewAccountObjectSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditAccountObjectSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditAccountObjectSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditAccountObjectSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Object | ? $Cim.IO._EditAccountObjectSearchProperty.SelectedItem -match $Cim.IO._EditAccountObjectSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditAccountObjectSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditAccountObjectSearchResult.ItemsSource = $Cim.DB.Object
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditAccountObjectSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditAccountObjectSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditAccountObjectSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditAccountObjectSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewAccountObjectSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewAccountObjectSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewAccountObjectSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Object | ? $Cim.IO._NewAccountObjectSearchProperty.SelectedItem -match $Cim.IO._NewAccountObjectSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewAccountObjectSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewAccountObjectSearchResult.ItemsSource = $Cim.DB.Object
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewAccountObjectSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewAccountObjectSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewAccountObjectSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewAccountObjectSearchFilter.Text = ""
        }
    })

    $Cim.IO._GetInvoiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._GetInvoiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._GetInvoiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Invoice | ? $Cim.IO._GetInvoiceSearchProperty.SelectedItem -match $Cim.IO._GetInvoiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._GetInvoiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._GetInvoiceSearchResult.ItemsSource = $Cim.DB.Invoice
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._GetInvoiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._GetInvoiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._GetInvoiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._GetInvoiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewInvoiceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewInvoiceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewInvoiceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._ViewInvoiceClientSearchProperty.SelectedItem -match $Cim.IO._ViewInvoiceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewInvoiceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewInvoiceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewInvoiceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewInvoiceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewInvoiceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewInvoiceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewInvoiceInventorySearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewInvoiceInventorySearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewInvoiceInventorySearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Inventory | ? $Cim.IO._ViewInvoiceInventorySearchProperty.SelectedItem -match $Cim.IO._ViewInvoiceInventorySearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewInvoiceInventorySearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewInvoiceInventorySearchResult.ItemsSource = $Cim.DB.Inventory
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewInvoiceInventorySearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewInvoiceInventorySearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewInvoiceInventorySearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewInvoiceInventorySearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewInvoiceServiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewInvoiceServiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewInvoiceServiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Service | ? $Cim.IO._ViewInvoiceServiceSearchProperty.SelectedItem -match $Cim.IO._ViewInvoiceServiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewInvoiceServiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewInvoiceServiceSearchResult.ItemsSource = $Cim.DB.Service
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewInvoiceServiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewInvoiceServiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewInvoiceServiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewInvoiceServiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._ViewInvoicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._ViewInvoicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._ViewInvoicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._ViewInvoicePurchaseSearchProperty.SelectedItem -match $Cim.IO._ViewInvoicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._ViewInvoicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._ViewInvoicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._ViewInvoicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._ViewInvoicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._ViewInvoicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._ViewInvoicePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditInvoiceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditInvoiceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditInvoiceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._EditInvoiceClientSearchProperty.SelectedItem -match $Cim.IO._EditInvoiceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditInvoiceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditInvoiceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditInvoiceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditInvoiceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditInvoiceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditInvoiceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditInvoiceInventorySearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditInvoiceInventorySearchFilter.Text -ne "" )
        {
            $Cim.IO._EditInvoiceInventorySearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Inventory | ? $Cim.IO._EditInvoiceInventorySearchProperty.SelectedItem -match $Cim.IO._EditInvoiceInventorySearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditInvoiceInventorySearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditInvoiceInventorySearchResult.ItemsSource = $Cim.DB.Inventory
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditInvoiceInventorySearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditInvoiceInventorySearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditInvoiceInventorySearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditInvoiceInventorySearchFilter.Text = ""
        }
    })

    $Cim.IO._EditInvoiceServiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditInvoiceServiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditInvoiceServiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Service | ? $Cim.IO._EditInvoiceServiceSearchProperty.SelectedItem -match $Cim.IO._EditInvoiceServiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditInvoiceServiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditInvoiceServiceSearchResult.ItemsSource = $Cim.DB.Service
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditInvoiceServiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditInvoiceServiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditInvoiceServiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditInvoiceServiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._EditInvoicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._EditInvoicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._EditInvoicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._EditInvoicePurchaseSearchProperty.SelectedItem -match $Cim.IO._EditInvoicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._EditInvoicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._EditInvoicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._EditInvoicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._EditInvoicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._EditInvoicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._EditInvoicePurchaseSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewInvoiceClientSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewInvoiceClientSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewInvoiceClientSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Client | ? $Cim.IO._NewInvoiceClientSearchProperty.SelectedItem -match $Cim.IO._NewInvoiceClientSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewInvoiceClientSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewInvoiceClientSearchResult.ItemsSource = $Cim.DB.Client
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewInvoiceClientSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewInvoiceClientSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewInvoiceClientSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewInvoiceClientSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewInvoiceInventorySearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewInvoiceInventorySearchFilter.Text -ne "" )
        {
            $Cim.IO._NewInvoiceInventorySearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Inventory | ? $Cim.IO._NewInvoiceInventorySearchProperty.SelectedItem -match $Cim.IO._NewInvoiceInventorySearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewInvoiceInventorySearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewInvoiceInventorySearchResult.ItemsSource = $Cim.DB.Inventory
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewInvoiceInventorySearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewInvoiceInventorySearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewInvoiceInventorySearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewInvoiceInventorySearchFilter.Text = ""
        }
    })

    $Cim.IO._NewInvoiceServiceSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewInvoiceServiceSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewInvoiceServiceSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Service | ? $Cim.IO._NewInvoiceServiceSearchProperty.SelectedItem -match $Cim.IO._NewInvoiceServiceSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewInvoiceServiceSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewInvoiceServiceSearchResult.ItemsSource = $Cim.DB.Service
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewInvoiceServiceSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewInvoiceServiceSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewInvoiceServiceSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewInvoiceServiceSearchFilter.Text = ""
        }
    })

    $Cim.IO._NewInvoicePurchaseSearchFilter.Add_TextChanged(
    {
        If ( $Cim.IO._NewInvoicePurchaseSearchFilter.Text -ne "" )
        {
            $Cim.IO._NewInvoicePurchaseSearchResult.ItemsSource = $Null

            $Cim.DG = $Cim.DB.Purchase | ? $Cim.IO._NewInvoicePurchaseSearchProperty.SelectedItem -match $Cim.IO._NewInvoicePurchaseSearchFilter.Text

            If ( $Cim.DG.Count -gt 0 )
            {
                $Cim.IO._NewInvoicePurchaseSearchResult.ItemsSource = @( $Cim.DG )
            }
        }

        Else
        {
            $Cim.IO._NewInvoicePurchaseSearchResult.ItemsSource = $Cim.DB.Purchase
        }
                
        Start-Sleep -Milliseconds 50
    })
    
    $Cim.IO._NewInvoicePurchaseSearchProperty.Add_SelectionChanged(
    {
        If ( $Cim.IO._NewInvoicePurchaseSearchProperty.SelectedItem -eq "Date" )
        {
            $Cim.IO._NewInvoicePurchaseSearchFilter.Text = $Cim.Date
        }

        Else
        {
            $Cim.IO._NewInvoicePurchaseSearchFilter.Text = ""
        }
    })

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

        $Cim.IO._NewIssueClientSearchResult.Items.Clear()
        $Cim.IO._NewIssueClientList.Items.Clear()
        
        $Cim.IO._NewIssueDeviceSearchResult.Items.Clear()
        $Cim.IO._NewIssueDeviceList.Items.Clear()

        $Cim.IO._NewIssuePurchaseSearchResult.Items.Clear()
        $Cim.IO._NewIssuePurchaseList.Items.Clear()
        
        $Cim.IO._NewIssueServiceSearchResult.Items.Clear()
        $Cim.IO._NewIssueServiceList.Items.Clear()
        
        $Cim.IO._NewIssueInvoiceSearchResult.Items.Clear()
        $Cim.IO._NewIssueInvoiceList.Items.Clear()

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
