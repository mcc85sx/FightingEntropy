Class _CFMeta 
{
   [UInt32]             $Step
   [Bool]      $WildcardProxy
   [UInt32]  $CustomCertQuota
   [UInt32]    $PageRuleQuota
   [Bool]        $PhishDetect
   [Bool]     $MultiRailAllow
   _CFMeta([Object]$Meta)
    {
        $This.Step             = $Meta.Step
        $This.WildcardProxy    = $Meta.Wildcard_Proxiable
        $This.CustomCertQuota  = $Meta.Custom_Certificate_Quota
        $This.PageRuleQuota    = $Meta.Page_Rule_Quota
        $This.PhishDetect      = $Meta.Phishing_Detection
        $This.MultiRailAllow   = $Meta.Multiple_Railguns_Allowed
   }
}
    
Class _CFAPI
{
    [String]            $ID
    [String]          $Name
    [String]        $Status
    [String]        $Paused
    [String]          $Type
    [String]       $DevMode
    [String[]]          $Ns
    [String[]]      $OrigNs
    [String]       $OrigReg
    [String]       $OrigDns
    [Object]      $Modified
    [Object]       $Created
    [Object]     $Activated
    [Object]          $Meta
    [Object]         $Owner
    [Object]       $Account
    [Object]   $Permissions
    [Object]          $Plan
    _CFAPI([Object]$Result)
    {
        $This.ID                = $Result.ID
        $This.Name              = $Result.Name
        $This.Status            = $Result.Status
        $This.Paused            = $Result.Paused
        $This.Type              = $Result.Type
        $This.DevMode           = $Result.development_mode
        $This.Ns                = $Result.name_servers
        $This.OrigNs            = $Result.original_name_servers
        $This.OrigReg           = $Result.original_registrar
        $This.OrigDns           = $Result.original_dnshost
        $This.Modified          = $Result.modified_on
        $This.Created           = $Result.created_on
        $This.Activated         = $Result.activated_on
        $This.Meta              = [_CFMeta]$Result.Meta
        $This.Owner             = $Result.Owner
        $This.Account           = $Result.Account
        $This.Permissions       = $Result.Permissions
        $This.Plan              = $Result.Plan
    }
}

Class _CFAccount
{
    [String]        $Name
    [String]      $ZoneID
    [String]   $AccountID
    [String]     $OwnerID
    [String]  $ApiZoneUrl
    [String]     $AuthKey
    [String]   $AuthEmail
    _CFAccount(
    [String]        $Name ,
    [String]      $ZoneID ,
    [String]   $AccountID ,
    [String]     $OwnerID ,
    [String]  $ApiZoneUrl ,
    [String]     $AuthKey ,
    [String]   $AuthEmail )
    {
        $This.Name        = $Name
        $This.ZoneID      = $ZoneID
        $This.AccountID   = $AccountID
        $This.OwnerID     = $OwnerID
        $This.ApiZoneUrl  = $ApiZoneUrl
        $This.AuthKey     = $AuthKey
        $This.AuthEmail   = $AuthEmail
    }

    [Object] Refresh()
    {
        $Item = Invoke-RestMethod "$($This.APIZoneUrl)/$($This.ZoneID)" -Headers @{ 

            "Content-Type" = "application/json"
            "X-Auth-Key"   = $This.AuthKey
            "X-Auth-Email" = $This.AuthEmail
        } 

        Return @([_CFAPI]$Item.Result)
    }
}
