    Class Issue
    {
        [Object]           $UID
        [UInt32]         $Index
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]        $Status
        [String]   $Description
        [Object]        $Client
        [Object]        $Device
        [Object[]]     $Service
        Issue([Object]$UID,[UInt32]$Rank)
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Service  = @( )
        }
        [String] ToString()
        {
            Return "Issue"
        }
    }
