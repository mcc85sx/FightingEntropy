Class _Client
{
    [Object]         $UID
    [Object]       $Index
    [Object]        $Slot
    [Object]        $Type
    [Object]        $Date
    [Object]        $Time
    [UInt32]        $Rank
    [Object]        $Name
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
    [Object]       $Image
    [Object[]]     $Phone
    [Object[]]     $Email
    [Object[]]    $Device
    [Object[]]   $Invoice

    GetStage()
    {
        $This.First   = $Null
        $This.Last    = $Null
        $This.DOB     = $Null
        $This.Phone   = @( )
        $This.Email   = @( )
    }

    AddPhone([Object]$Phone)
    {
        $This.Phone  += $Phone
    }
    
    AddEmail([Object]$Email)
    {
        $This.Email  += $Email
    }

    SetStage([String]$First,[String]$Last,[Object]$DOB,[Object]$Phone,[Object]$Email)
    {
        $This.First   = $First
        $This.Last    = $Last
        $This.DOB     = $DOB
    
        $This.AddPhone($Phone)
        $This.AddEmail($Email)
    }

    [String] GetName()
    {
        If (!$This.First -or !$This.Last)
        {
            If (!$This.First) 
            { 
                Throw "Missing first name" 
            }

            If (!$This.Last) 
            {
                Throw "Missing last name"  
            }
        }

        Return "{0}, {1}" -f $This.Last, $This.First
    }

    SetName([String]$First,[String]$Last)
    {
        $This.Name = $This.GetName($First,$Last)
    }

    _Client([Object]$UID)
    {
        $This.UID  = $UID.UID
        $This.Slot = 0
        $This.Type = "Client"
        $This.Date = $UID.Date
        $This.Time = $UID.Time

        $This.GetStage()
    }
}
