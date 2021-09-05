    Class Invoice
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
        [UInt32]          $Mode
        [Object]        $Client
        [Object[]]       $Issue
        [Object[]]    $Purchase
        [Object[]]   $Inventory
        Invoice([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Issue     = @( )
            $This.Purchase  = @( )
            $This.Inventory = @( )
        }
        [String] ToString()
        {
            Return "Invoice"
        }
    }
