    Class Service
    {
        [Object]           $UID
        [UInt32]         $Index
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]          $Name
        [String]   $Description
        [Float]           $Cost
        Service([Object]$UID,[UInt32]$Rank) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
        }
        [String] ToString()
        {
            Return "Service"
        }
    }
