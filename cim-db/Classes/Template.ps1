    Class Template
    {
        [String[]] $UID
        [String[]] $Client
        [String[]] $Service
        [String[]] $Device
        [String[]] $Issue
        [String[]] $Purchase
        [String[]] $Inventory
        [String[]] $Expense
        [String[]] $Account
        [String[]] $Invoice
        Template()
        {
            $This.UID          = "UID","Index","Slot","Date"
            $This.Client       = @($This.UID;"Rank","DisplayName","Email","Phone","Last","First","DOB")
            $This.Service      = @($This.UID;"Rank","DisplayName","Name","Cost","Description")
            $This.Device       = @($This.UID;"Rank","DisplayName","Chassis","Vendor","Model","Specification","Serial","Client")
            $This.Issue        = @($This.UID;"Rank","Status","Description","Client","Device")
            $This.Purchase     = @($This.UID;"Rank","Distributor","Vendor","Serial","Model","IsDevice","Device","Cost")
            $This.Inventory    = @($This.UID;"Rank","Vendor","Model","Serial","Title","Cost","IsDevice","Device")
            $This.Expense      = @($This.UID;"Rank","Recipient","Account","Cost")
            $This.Account      = @($This.UID;"Rank","Object")
            $This.Invoice      = @($This.UID;"DisplayName","Mode","Phone","Email")
        }
    }
