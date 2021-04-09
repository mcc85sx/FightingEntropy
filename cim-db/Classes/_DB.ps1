Class _DB 
{
    [Object]          $Init 
    [Object[]]         $UID
    [Object[]]      $Client
    [Object[]]     $Service
    [Object[]]      $Device
    [Object[]]       $Issue
    [Object[]]   $Inventory
    [Object[]]    $Purchase
    [Object[]]     $Expense
    [Object[]]     $Account
    
    _DB([Object]$Init)
    {
        $This.Init      = $Init
        $This.UID       = @( )
        $This.Client    = @( )
        $This.Service   = @( )
        $This.Device    = @( )
        $This.Issue     = @( )
        $This.Inventory = @( )
        $This.Purchase  = @( )
        $This.Expense   = @( )
        $This.Account   = @( )  
    }

    [UInt32] GetCount([UInt32]$X)
    {
        Return ( $X + 1 )
    }

    [UInt32] GetIndex()
    {
        Return ($This.GetCount($This.UID.Count) - 1)
    }

    [UInt32] GetRank([UInt32]$Slot)
    {
        Return $This.GetCount(
        @(  
            $This.Client.Count    ,
            $This.Service.Count   ,
            $This.Device.Count    ,
            $This.Issue.Count     , 
            $This.Inventory.Count ,
            $This.Purchase.Count  ,
            $This.Account.Count   
        
        )[$Slot]) - 1
    }

    AddUID([Object]$Slot)
    {
        If ($Slot -notin 0..6)
        {
            Throw "Invalid entry"
        }

        $Item                = [_UID]::New($Slot)
        $Item.Index          = $This.GetIndex()
        $Item.Record         = Switch ($Slot)
        {
            0 { [_Client    ]::New($Item) }
            1 { [_Service   ]::New($Item) }
            2 { [_Device    ]::New($Item) }
            3 { [_Issue     ]::New($Item) }
            4 { [_Inventory ]::New($Item) } 
            5 { [_Purchase  ]::New($Item) }
            6 { [_Expense   ]::New($Item) }
        }

        $Item.Record.Index   = $Item.Index
        $Item.Record.Rank    = $This.GetRank($Slot)

        Switch($Slot)
        {
            0 { $This.Client     += $Item }
            1 { $This.Service    += $Item }
            2 { $This.Device     += $Item }
            3 { $This.Issue      += $Item }
            4 { $This.Inventory  += $Item }
            5 { $This.Purchase   += $Item }
            6 { $This.Expense    += $Item }
        }

        $This.UID            += $Item
    }
}
