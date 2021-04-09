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
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Slot]
        $This.Date   = Get-Date -UFormat "%m/%d/%Y"
        $This.Time   = Get-Date -UFormat "%H:%M:%S"
    }

    InsertIndex([UInt32]$Index)
    {
        $This.Index  = $Index
    }

    InsertRecord([Object]$Record)
    {
        $This.Record = $Record
    }
}
