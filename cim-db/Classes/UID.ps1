    Class UID
    {
        [Object] $UID
        [UInt32] $Index
        [UInt32] $Slot
        [Object] $Type
        [Object] $Date
        [Object] $Time
        [UInt32] $Sort
        [Object] $Record
        UID([UInt32]$Index,[UInt32]$Slot)
        {
            $This.UID    = New-GUID | % GUID
            $This.Index  = $Index
            $This.Slot   = $Slot
            $This.Type   = ("Client Service Device Issue Purchase Inventory Expense Account Invoice" -Split " ")[$Slot]
            $This.Date   = Get-Date -UFormat "%m/%d/%Y"
            $This.Time   = Get-Date -UFormat "%H:%M:%S"
            $This.Sort   = 0
        }
        [String] ToString()
        {
            Return $This.Slot
        }
    }
