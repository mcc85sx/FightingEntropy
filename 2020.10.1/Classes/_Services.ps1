Class _Services
{
    Hidden [Object[]] $WMIObject
    [_Service[]]        $Services

    _Services([Object]$Template)
    {
        $This.WMIObject    = Get-WMIObject -Class Win32_Service | Select-Object Name, DelayedAutoStart, StartMode, State, Status, DisplayName, PathName, Description
        $This.Services     = @( )

        For ( $I = 0 ; $I -le $This.WMIObject.Count - 1 ; $I ++ )
        {
            $Item           = [_Service]::New($I,$This.WMIObject[$I])

            If ( $Template[$Item.Name] -ne $Null )
            {
                $Item.Scope = 1
                $Item.Slot  = $Template[$Item.Name]
            }

            Else
            {
                $Item.Scope = 0
                $Item.Slot  = "-1,-1,-1,-1,-1,-1,-1,-1,-1,-1"
            }

            $This.Services += $Item
        }
    }
}
