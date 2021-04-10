Class _Service
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
    [UInt32]          $Rank
    [String]          $Name
    [String[]] $Description
    [Float]           $Cost

    _Service([Object]$UID) 
    { 
        $This.UID  = $UID.UID
        $This.Slot = 1
        $This.Type = "Service"
        $This.Date = $UID.Date
        $This.Time = $UID.Time
    }
    
    [Object] GetName([String]$Name)
    {
        If ( $Name -in $This.Service.Name )
        {
            Return @( $This.Service | ? Name -eq $Name )
        }

        Else 
        {
            Return $Null    
        }
    }

    [Object] GetUID([Object]$UID)
    {
        If ( $UID -in $This.Service.UID )
        {
            Return @( $This.Service | ? UID -eq $UID )
        }

        Else 
        {
            Return $Null
        }
    }
}
