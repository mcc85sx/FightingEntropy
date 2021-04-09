Class _UID
{
    [Object] $UID
    [UInt32] $Index
    [Object] $Slot
    [Object] $Type
    [Object] $Date
    [Object] $Time
    [Object] $Record

    _UID([Object]$UID,[UInt32]$Slot)
    {
        $This.UID    = $UID
        $This.Slot   = $Slot
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Slot]
        $This.Date   = Get-Date -UFormat "%m/%d/%Y"
        $This.Time   = Get-Date -UFormat "%H:%M:%S"
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
    [Object]        $Time
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

    [String] GetName([String]$First,[String]$Last)
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
        $This.Type = $UID.Type
        $This.Date = $UID.Date
        $This.Time = $UID.Time

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
    [Object]          $Time
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

    SetName([String]$Name)
    {
        If ( $Name -notin $This.Service.Name )
        {
            $This.Name = $Name
        }
    }

    SetDescription([String[]]$Description)
    {
        $This.Description = $Description
    }

    SetCost([Object]$Cost)
    {
        $This.Cost        = $Cost
    }
}

Class _Device
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
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
        $This.Time = $UID.Time
    }
}

Class _Issue
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
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
        $This.Time = $UID.Time
    }
}

Class _Inventory
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
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
        $This.Time = $UID.Time
    }
}

Class _Purchase
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
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
        $This.Time = $UID.Time
    }
}

Class _Expense
{
    [Object]           $UID
    [UInt32]         $Index
    [Object]          $Slot
    [Object]          $Type
    [Object]          $Date
    [Object]          $Time
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
        $This.Time = $UID.Time
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

        $Object.Index             = $This.GetIndex()
        $Object.Rank              = $This.GetRank($Slot)

        $This.UID                += $Object
        Switch($Slot)
        {
            0 { $This.Client     += $Object }
            1 { $This.Service    += $Object }
            2 { $This.Device     += $Object }
            3 { $This.Issue      += $Object }
            4 { $This.Inventory  += $Object }
            5 { $This.Purchase   += $Object }
            6 { $This.Expense    += $Object }
        }
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
