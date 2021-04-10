Class _Issue
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
    [UInt32]          $Rank

    [Object]        $Client
    [Object]        $Device
    [String[]] $Description
    [Object]        $Status
    [Object]      $Purchase
    [Object]       $Service
    [Object]       $Invoice

    _Issue([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 3
        $This.Type = "Issue"
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
}
