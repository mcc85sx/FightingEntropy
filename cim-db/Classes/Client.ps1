    Class Client
    {
        [Object]         $UID
        [UInt32]       $Index
        [UInt32]        $Slot
        [Object]        $Type
        [Object]        $Date
        [Object]        $Time
        [UInt32]        $Sort
        [UInt32]        $Rank
        [String] $DisplayName
        [String]       $First
        [String]          $MI
        [String]        $Last
        [Object]     $Address
        [Object]        $City
        [Object]      $Region
        [Object]     $Country
        [Object]      $Postal
        [UInt32]       $Month
        [UInt32]         $Day
        [UInt32]        $Year
        [String]         $DOB
        [String]      $Gender
        [Object]       $Image
        [Object[]]     $Phone
        [Object[]]     $Email
        [Object[]]    $Device
        [Object[]]     $Issue
        [Object[]]   $Invoice
        Client([Object]$UID,[UInt32]$Rank)
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Issue   = @( )
            $This.Invoice = @( )
        }
        [String] ToString()
        {
            Return "Client"
        }
    }
