    Class _Invoice
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time

        [UInt32]          $Rank
        [String]   $DisplayName

        [UInt32]          $Mode
        [Object]        $Client
        [Object]     $Inventory
        [Object]       $Service
        [Object]      $Purchase

        _Invoice([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 8
            $This.Type = "Invoice"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }

        [String] ToString()
        {
            Return "Invoice"
        }
    }
