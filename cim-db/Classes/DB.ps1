    Class DB
    {
        [Object[]]         $UID
        [Object[]]      $Client
        [Object[]]     $Service
        [Object[]]      $Device
        [Object[]]       $Issue
        [Object[]]    $Purchase
        [Object[]]   $Inventory
        [Object[]]     $Expense
        [Object[]]     $Account
        [Object[]]     $Invoice
        [Object[]]      $Sorted
        DB()
        {
            $This.UID       = @( )
            $This.Client    = @( )
            $This.Service   = @( )
            $This.Device    = @( )
            $This.Issue     = @( )
            $This.Purchase  = @( )
            $This.Inventory = @( )
            $This.Expense   = @( )
            $This.Account   = @( )
            $This.Invoice   = @( )  
            $This.Sorted    = @( )
        }
        [Object] NewUID([Object]$Slot)
        {
            If ($Slot -notin 0..8)
            {
                Throw "Invalid entry"
            }

            $Item                = [UID]::New($This.UID.Count,$Slot)
            $Type                = $Item.Type
            $X                   = $This.$Type.Count
            $Item.Record         = Switch ($Slot)
            {
                0 { [Client]::New($Item,$X)    } 1 { [Service]::New($Item,$X)   } 2 { [Device]::New($Item,$X)    }
                3 { [Issue]::New($Item,$X)     } 4 { [Purchase]::New($Item,$X)  } 5 { [Inventory]::New($Item,$X) } 
                6 { [Expense]::New($Item,$X)   } 7 { [Account]::New($Item,$X)   } 8 { [Invoice]::New($Item,$X)   }
            }

            $Item.Record.Index   = $This.UID.Count
            $Item.Record.Rank    = $X

            Switch($Slot)
            {
                0 { $This.Client     += $Item } 1 { $This.Service    += $Item } 2 { $This.Device     += $Item }
                3 { $This.Issue      += $Item } 4 { $This.Purchase   += $Item } 5 { $This.Inventory  += $Item }
                6 { $This.Expense    += $Item } 7 { $This.Account    += $Item } 8 { $This.Invoice    += $Item }
            }

            $This.UID           += $Item

            Return $Item
        }
        [Object] GetUID([Object]$UID)
        {
            Return $This.UID | ? UID -match $UID
        }
        [Void] SortUID([Object]$UID)
        {
            $Item             = $This.GetUID($UID)
            $Type             = $Item.Type
            $Item.Slot        = 9
            $Item.Type        = "Sorted"
            $Item.Record.Rank = $This.Sorted.Count
            $Item.Sort        = 1
            $This.Sorted     += $Item

            $This.$Type       = @( $This.$Type | ? Type -ne "Sorted" )
            $X                = 0
            ForEach ( $Object in $This.$Type )
            {
                $Object.Record.Rank = $X
                $X ++
            }
        }
    }
