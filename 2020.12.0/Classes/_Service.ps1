Class _Service
{
    [Int32]               $Index
    [String]               $Name 
    [Bool]                $Scope
    [String]               $Slot
    [Int32]    $DelayedAutoStart 
    [String]          $StartMode 
    [String]              $State 
    [String]             $Status 
    [String]        $DisplayName
    [String]           $PathName 
    [String]        $Description 

    _Service([Int32]$Index,[Object]$WMI)
    {
        $This.Index              = $Index
        $This.Name               = $WMI.Name
        $This.DelayedAutoStart   = $WMI.DelayedAutoStart
        $This.StartMode          = $WMI.StartMode
        $This.State              = $WMI.State
        $This.Status             = $WMI.Status
        $This.DisplayName        = $WMI.DisplayName
        $This.PathName           = $WMI.PathName
        $This.Description        = $WMI.Description
    }
}
