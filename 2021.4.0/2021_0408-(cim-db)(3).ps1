Class _UID
{
    [Object] $UID
    [UInt32] $Index
    [Object] $Slot
    [Object] $Type
    [Object] $Date
    [Object] $Record

    _UID([Object]$UID,[UInt32]$Slot)
    {
        $This.UID    = $UID
        $This.Slot   = $Slot
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Slot]
        $This.Date   = Get-Date -UFormat "(%m/%d/%Y @ %H:%M:%S)"
    }

    InsertIndex([UInt32]$Index)
    {
        $This.Index  = $Index
    }

    InsertRecord([Object]$Record)
    {
        $This.Record = $Record
    }
}
 
Class _Client
{
    [Object]         $UID
    [Object]       $Index
    [Object]        $Slot
    [Object]        $Type
    [Object]        $Date

    [UInt32]        $Rank
    [Object]        $Name
    [String]       $First
    [String]        $Last
    [Object]         $DOB
    [Object[]]     $Phone
    [Object[]]     $Email

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
        Return @( "{0}, {1}" -f $This.Last, $This.First )
    }

    _Client([Object]$UID)
    {
        $This.UID  = $UID.UID
        $This.Slot = 0
        $This.Type = $UID.Type
        $This.Date = $UID.Date

        $This.GetStage()
    }
}

Class _Service
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [UInt32]          $Rank

    [String]          $Name
    [String[]] $Description
    [Float]           $Cost

    _Service([Object]$UID) 
    { 
        $This.UID  = $UID.UID
        $This.Slot = 1
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Device
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [String]          $Rank

    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Owner

    _Device([Object]$UID) 
    { 
        $This.UID  = $UID.UID
        $This.Slot = 2
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Issue
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [UInt32]          $Rank

    [String[]] $Description
    [Object]        $Status
    [Object]         $Order
    [Object]       $Service
    [UInt32]         $Price

    _Issue([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 3
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Inventory
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [UInt32]          $Rank

    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]          $Cost

    _Inventory([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 4
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Purchase
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [UInt32]          $Rank

    [Object]   $Distributor
    [Object]   $DisplayName
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]          $Cost

    _Purchase([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 5
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Expense
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date

    [UInt32]          $Rank

    [Object]     $Recipient
    [Object]   $DisplayName
    [Object]       $Account
    [UInt32]          $Cost

    _Expense([Object]$UID) 
    {
        $This.UID  = $UID.UID
        $This.Slot = 6
        $This.Type = $UID.Type
        $This.Date = $UID.Date
    }
}

Class _Database 
{
    [Object[]]         $UID
    [Object[]]      $Client
    [Object[]]     $Service
    [Object[]]      $Device
    [Object[]]       $Issue
    [Object[]]   $Inventory
    [Object[]]    $Purchase
    [Object[]]     $Expense
    [Object[]]     $Account
    
    _Database()
    {
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

    [UInt32] GetIndex()
    {
        Return $This.UID.Count
    }

    [UInt32] GetRank([UInt32]$Slot)
    {
        $X = Switch($Slot)
        {
            0 { $This.Client.Count    }
            1 { $This.Service.Count   }
            2 { $This.Device.Count    }
            3 { $This.Issue.Count     }
            4 { $This.Inventory.Count }
            5 { $This.Purchase.Count  }
            6 { $This.Account.Count   }
        }

        Return $X
    }

    AddUID([Object]$Slot)
    {
        If ($Slot -notin 0..6)
        {
            Throw "Invalid entry"
        } 

        $GUID           = (New-GUID | % GUID)
        $Item           = [_UID]::New($GUID,$Slot)
        $Object         = Switch ($Slot)
        {
            0 { [_Client    ]::New($Item) }
            1 { [_Service   ]::New($Item) }
            2 { [_Device    ]::New($Item) }
            3 { [_Issue     ]::New($Item) }
            4 { [_Inventory ]::New($Item) } 
            5 { [_Purchase  ]::New($Item) }
            6 { [_Expense   ]::New($Item) }
        }

        $Object.Index             = $This.GetIndex() + 1 

        Switch($Slot)
        {
            0 
            {
                $Object.Rank      = $This.GetRank(0) + 1 
                $This.Client     += $Object 
            }

            1 
            { 
                $Object.Rank      = $This.GetRank(1) + 1 
                $This.Service    += $Object 
            }
            
            2 
            { 
                $Object.Rank      = $This.GetRank(2) + 1 
                $This.Device     += $Object 
            }

            3 
            { 
                $Object.Rank      = $This.GetRank(3) + 1 
                $This.Issue      += $Object 
            }

            4 
            { 
                $Object.Rank      = $This.GetRank(4) + 1 
                $This.Inventory  += $Object 
            }

            5 
            { 
                $Object.Rank      = $This.GetRank(5) + 1 
                $This.Purchase   += $Object 
            }

            6 
            { 
                $Object.Rank      = $This.GetRank(6) + 1 
                $This.Expense    += $Object 
            }
        }

        $This.UID                += $Object
    }
}

$DB               = [_Database]::New()

0..1000 | % { 
    
    $DB.AddUID((Get-Random -Minimum 0 -Maximum 6))
    Write-Host ("Added [+] {0}" -f $DB.UID[$_].Type)
}

$DB.AddUID(0) # Adds Client
$DB.AddUID(1) # Adds Service
$DB.AddUID(2) # Adds Device
$DB.AddUID(3) # Adds Issue
$DB.AddUID(4) # Adds Inventory
$DB.AddUID(5) # Adds Purchase
$DB.AddUID(6) # Adds Expense
