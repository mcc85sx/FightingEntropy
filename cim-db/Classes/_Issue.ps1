    Class _Issue
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time

        [UInt32]          $Rank
        [Object]   $DisplayName

        [Object]        $Status
        [String[]] $Description

        [Object]        $Client
        [Object]        $Device
        [Object[]]    $Purchase
        [Object[]]     $Service
        [Object[]]     $Invoice

        _Issue([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 3
            $This.Type = "Issue"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Issue"
        }
    }
