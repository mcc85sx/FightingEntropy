    Class Purchase
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [Object]          $Sort
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]   $Distributor
        [Object]           $URL
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Bool]        $IsDevice
        [Object]        $Device
        [Object]          $Cost
        Purchase([Object]$UID,[UInt32]$Rank) 
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
            Return "Purchase"
        }
    }
