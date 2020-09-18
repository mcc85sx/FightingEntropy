Class Services
{
    Hidden [Object[]] $WMIObject
    [Service[]]         $Service

    Services()
    {
        $This.WMIObject    = @(WMIObject -Class Win32_Service|Select DelayedAutoStart,
                              StartMode,State,Status,DisplayName,Pathname,Description)

        For ( $I = 0; $I -le $This.WMIObject.Count - 1 ;$I ++ )
        {
            $This.Service += [Service]::New($I,$This.WMIObject[$I])
        }
    }
}

Class Service
{
    [Int32]               $Index
    [Object]            $Service 
    [String]               $Name 
    [Bool]                $Scope
    [Int32[]]              $Slot 
    [Int32]    $DelayedAutoStart 
    [String]          $StartMode 
    [String]              $State 
    [String]             $Status 
    [String]        $DisplayName 
    [String]           $PathName 
    [String]        $Description 

    Service([Int32]$Index,[Object]$WMI)
    {
        $This.Index              = $Index
        $This.Service            = $WMI
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
