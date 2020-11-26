Class Service
{
    [String]             $Name
    [Object]           $Object
    [String[]]         $Status = ("start enable reload restart status" -Split " ")

    [ValidateSet("Launch","Status","Restart")]
    [String]             $Mode

    [String]            $Title
    [String[]]           $Slot

    Service([String]$Mode,[String]$Name)
    {
        $This.Name             = $Name
        $This.Object           = (systemctl status $Name)
        $This.Mode             = $Mode
        $This.Title            = @{ 
            
            Launch             = "Launching"
            Status             = "Launch w/ Status"
            Restart            = "Restarting" 
        
        }[$Mode]
        
        $This.Slot             = @{ 
            
            Launch             = 0,1,2
            Status             = 0,1,4
            Restart            = 3 
        
        }[$Mode]
        
        $This.Slot             = [Int32[]]$This.Slot | % { $This.Status[$_] }

        ForEach ( $Item in $This.Slot )
        {
            systemctl $Item $This.Name
        }
    }
}
