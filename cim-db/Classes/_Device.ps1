Class _Device
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
    [String]          $Rank

    [String]       $Chassis
    [String]        $Vendor
    [String]         $Model
    [String]          $Spec
    [String]        $Serial
    [Object]         $Title  
    [Object]         $Owner

    _Device([Object]$UID) 
    { 
        $This.UID  = $UID.UID
        $This.Slot = 2
        $This.Type = "Device"
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
