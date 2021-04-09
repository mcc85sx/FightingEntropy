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
        $This.Slot = 6
        $This.Type = $UID.Type
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
