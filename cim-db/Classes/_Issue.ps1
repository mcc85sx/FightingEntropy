Class _Issue
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
    [UInt32]          $Rank

    [String[]] $Description
    [Object]        $Status
    [Object]         $Order
    [Object]       $Service
    [UInt32]         $Price

    _Issue([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 3
        $This.Type = $UID.Type
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
