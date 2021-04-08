Class DB 
{
    [Object[]] $UID
    
    DB()
    {
        $This.UID = @( )
    }

    [UInt32] GetCID()
    {
        Return $This.CID.Count + 1
    }
}

Class _ID
{
    Hidden [UInt32] $Rank
    [Object] $ID
    [Object] $Date
    [Object] $Time
    [Object] $Type
    [Object] $Object

    _ID([Object]$ID,[Object]$Type)
    {
        $This.ID     = $ID
        $This.Date   = Get-Date -UFormat 
        $This.Time   = Get-Date -UFormat "%H:%M:%S%p"
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Type]
        $This.Object = Switch($Type) 
        {
             Client    { [ _Client    ]::New() }
             Service   { [ _Service   ]::New() }
             Device    { [ _Device    ]::New() }
             Issue     { [ _Issue     ]::New() }
             Inventory { [ _Inventory ]::New() }
             Purchase  { [ _Purchase  ]::New() }
             Expense   { [ _Expense   ]::New() }
        }
    }
}

Class _Client : _ID
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
    
    SetStage([Object]$Client)
    {
        $This.First   = $Client.First
        $This.Last    = $Client.Last
        $This.DOB     = $Client.DOB
    
        $This.AddPhone($Client.Phone)
        $This.AddEmail($Client.Email)
    }

    _Client([Object]$ID,[UInt32]$Type) : base($ID,$Type) 
    { 
        $This.GetStage()
    }
}

Class _Service : _ID
{
    Hidden [UInt32]   $Rank
    [String[]] $Description
    [UInt32]         $Price

    _Service([Object]$ID,[UInt32]$Type) : base($ID,$Type) 
    { 

    }
}

Class _Device : _ID
{
    Hidden [String]   $Rank
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Owner

    _Device([Object]$ID,[UInt32]$Type) : base($ID,$Type) 
    { 

    }
}

Class _Issue : _ID
{
    [UInt32]          $Rank
    [String[]] $Description
    [Object]        $Status
    [Object]         $Order
    [Object]       $Service
    [UInt32]         $Price

    _Issue([Object]$ID,[UInt32]$Type) : base($ID,$Type) 
    { 

    }
}

Class _Inventory : _ID 
{
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Price

    _Inventory([Object]$ID,[UInt32]$Type) : base($ID,$Type)
    {

    }
}

Class _Purchase : _ID 
{
    [Object]   $Distributor
    [Object]   $DisplayName
    [String]        $Vendor
    [String]        $Serial
    [String]         $Model
    [Object]         $Title  
    [Object]         $Price

    _Purchase([Object]$ID,[UInt32]$Type) : base($ID,$Type)
    {

    }
}

Class _Expense : _ID 
{
    [Object]     $Recipient
    [Object]          $Type
    [Object]   $DisplayName
    [Object]       $Account
    [UInt32]         $Total

    _Expense([Object]$ID,[UInt32]$Type) : base($ID,$Type)
    {

    }
}
