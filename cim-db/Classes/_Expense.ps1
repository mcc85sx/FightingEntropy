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
}
