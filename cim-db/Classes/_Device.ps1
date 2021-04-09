Class _Device
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
    [String]          $Rank

    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Owner

    _Device([Object]$UID) 
    { 
        $This.UID  = $UID.UID
        $This.Slot = 2
        $This.Type = $UID.Type
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
