Class _UID
{
    [Object] $UID
    [Object] $Slot
    [Object] $Date
    [Object] $Time
    [Object] $Type

    _UID([Object]$UID,[UInt32]$Slot)
    {
        $This.UID    = $UID
        $This.Slot   = $Slot
        $This.Date   = Get-Date -UFormat "%m/%d/%y"
        $This.Time   = Get-Date -UFormat "%H:%M:%S"
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Slot]
    }
}
 
Class _Client : _UID
{
    Hidden [UInt32]   $Rank
    [String]   $First
    [String]   $Last
    [Object]   $DOB
    [Object[]] $Phone
    [Object[]] $Email

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

    _Client([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot)
    { 
        $This.GetStage()
    }
}

Class _Service : _UID
{
    Hidden [UInt32]   $Rank
    [String[]] $Description
    [UInt32]         $Price

    _Service([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) { }
}

Class _Device : _UID
{
    Hidden [String]   $Rank
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Owner

    _Device([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) { }
}

Class _Issue : _UID
{
    [UInt32]          $Rank
    [String[]] $Description
    [Object]        $Status
    [Object]         $Order
    [Object]       $Service
    [UInt32]         $Price

    _Issue([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) {}
}

Class _Inventory : _UID 
{
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Price

    _Inventory([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) {}
}

Class _Purchase : _UID 
{
    [Object]   $Distributor
    [Object]   $DisplayName
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Price

    _Purchase([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) {}
}

Class _Expense : _UID 
{
    [Object]     $Recipient
    [Object]          $Type
    [Object]   $DisplayName
    [Object]       $Account
    [UInt32]         $Total

    _Expense([Object]$UID,[UInt32]$Slot) : base([Object]$UID,[UInt32]$Slot) {}
}

Class _Database 
{
    [Object[]]       $UID
    [Object]      $Client
    [Object]     $Service
    [Object]      $Device
    [Object]       $Issue
    [Object]   $Inventory
    [Object]    $Purchase
    [Object]     $Expense
    [Object]     $Account
    
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

    [Object] GetObject([UInt32]$Slot)
    {
        Return @( Switch ($Slot)
        {
            0 { $This.Client     += [_Client    ]::New($This.UID,0) }
            1 { $This.Service    += [_Service   ]::New($This.UID,1) }
            2 { $This.Device     += [_Device    ]::New($This.UID,2) }
            3 { $This.Issue      += [_Issue     ]::New($This.UID,3) }
            4 { $This.Inventory  += [_Inventory ]::New($This.UID,4) } 
            5 { $This.Purchase   += [_Purchase  ]::New($This.UID,5) }
            6 { $This.Expense    += [_Expense   ]::New($This.UID,6) }
        })
    }

    AddUID([Object]$Slot)
    {
        If ($Slot -notin 0..6)
        {
            Throw "Invalid entry"
        } 

        $GUID           = New-GUID
        $Item           = [_UID]::New($GUID,$Slot)
        $Item.Object    = $Item.GetObject($Slot)
    }
}

$DB               = [_Database]::New()
$DB.AddUID(0) # Adds Client
$DB.AddUID(1) # Adds Service
$DB.AddUID(2) # Adds Device
$DB.AddUID(3) # Adds Issue
$DB.AddUID(4) # Adds Inventory
$DB.AddUID(5) # Adds Purchase
$DB.AddUID(6) # Adds Expense
