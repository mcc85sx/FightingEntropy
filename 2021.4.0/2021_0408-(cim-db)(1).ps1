Class _ID
{
    Hidden [UInt32] $Rank
    [Object] $ID
    [Object] $Date
    [Object] $Time
    [Object] $Type
    [Object] $Object

    _ID([UInt32]$Slot)
    {
        $This.ID     = New-GUID
        $This.Date   = Get-Date -UFormat "%m/%d/%y"
        $This.Time   = Get-Date -UFormat "%H:%M:%S%p"
        $This.Type   = @("Client","Service","Device","Issue","Inventory","Purchase","Expense")[$Slot]
        $This.Object = Switch($This.Type) 
        {
             Client    { [ _Client    ]::New($This.ID) }
             Service   { [ _Service   ]::New($This.ID) }
             Device    { [ _Device    ]::New($This.ID) }
             Issue     { [ _Issue     ]::New($This.ID) }
             Inventory { [ _Inventory ]::New($This.ID) }
             Purchase  { [ _Purchase  ]::New($This.ID) }
             Expense   { [ _Expense   ]::New($This.ID) }
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

    _Client([Object]$ID,[UInt32]$Type) : base($ID,"Client") 
    { 
        $This.GetStage()
    }
}

Class _Service : _ID
{
    Hidden [UInt32]   $Rank
    [String[]] $Description
    [UInt32]         $Price

    _Service([Object]$ID,[UInt32]$Type) : base($ID,"Service") 
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

    _Device([Object]$ID,[UInt32]$Type) : base($ID,"Device") 
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

    _Issue([Object]$ID,[UInt32]$Type) : base($ID,"Issue") 
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

    _Inventory([Object]$ID,[UInt32]$Type) : base($ID,"Inventory")
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

    _Purchase([Object]$ID,[UInt32]$Type) : base($ID,"Purchase")
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

    _Expense([Object]$ID,[UInt32]$Type) : base($ID,"Expense")
    {

    }
}

Class _Database 
{
    [String[]] $Table = ("Client Service Device Issue Inventory Purchase Expense" -Split " ")
    [Object[]] $UID
    
    _Database()
    {
        $This.UID = @( )
    }

    [UInt32] GetUID()
    {
        Return $This.CID.Count
    }

    AddUID([Object]$Type)
    {
        If ($Type -notin $This.Table)
        {
            Throw "Invalid entry"
        }

        $This.UID += [_ID]::New($Type)
    }
}

$DB               = [_Database]::New()
