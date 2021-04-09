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
}
