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
