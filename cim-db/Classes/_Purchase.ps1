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
    [String]        $Serial
    [String]         $Model
    [Object]         $Title
    [Object]          $Cost

    _Purchase([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 5
        $This.Type = "Purchase"
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
