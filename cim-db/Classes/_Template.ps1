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
            $This.UID          = @("UID","Index","Date","Rank","DisplayName")
            $This.Client       = @($This.UID; "DOB", "Phone", "Email")
            $This.Service      = @($This.UID; "Description")
            $This.Device       = @($This.UID; "Vendor", "Model", "Specification", "Serial", "Title")
            $This.Issue        = @($This.UID; "Status","Description","Client","Device","Purchase","Service","Invoice")
            $This.Inventory    = @($This.UID; "Vendor","Model","Serial","Title","Cost","IsDevice","Device")
            $This.Purchase     = @($This.UID; "Distributor","Vendor","Serial","Model","IsDevice","Device","Cost")
            $This.Expense      = @($This.UID; "Recipient","Account","Cost")
            $This.Account      = @($This.UID; "Object")
            $This.Invoice      = @($This.UID; "Client","Inventory","Service","Purchase")
            $This.UID          = $This.UID[0..3]
        }
    }
