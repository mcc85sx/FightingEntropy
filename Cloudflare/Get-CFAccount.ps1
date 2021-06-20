
Function Get-CFAccount
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Path)

    Class API
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
        API([Object]$Result)
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
            $This.Meta              = $Result.Meta
            $This.Owner             = $Result.Owner
            $This.Account           = $Result.Account
            $This.Permissions       = $Result.Permissions
            $This.Plan              = $Result.Plan
        }
    }

    Class Key
    {
        [String]               $Name
        Hidden [String]      $ZoneID
        Hidden [String]   $AccountID
        Hidden [String]     $OwnerID
        [String]         $ApiZoneUrl
        Hidden [String]     $AuthKey
        [String]          $AuthEmail
        Key([Object]$Key)
        {
            $Item             = $Key -Split " "
            $This.Name        = $Item[0]
            $This.ZoneID      = $Item[1]
            $This.AccountID   = $Item[2]
            $This.OwnerID     = $Item[3]
            $This.ApiZoneUrl  = $Item[4]
            $This.AuthKey     = $Item[5]
            $This.AuthEmail   = $Item[6]
        }

        [Object] Refresh()
        {
            $Item = Invoke-RestMethod "$($This.APIZoneUrl)/$($This.ZoneID)" -Headers @{ 

                "Content-Type" = "application/json"
                "X-Auth-Key"   = $This.AuthKey
                "X-Auth-Email" = $This.AuthEmail
            } 

            Return [API]$Item.Result
        }
    }

    If (!(Test-Path $Path))
    {
        Throw "Invalid path"
    }

    $Key = Get-Content -Path $Path | ConvertTo-SecureString

    If ($Key -eq $Null -or $Key.GetType().Name -ne "SecureString")
    {
        Throw "Invalid key file"
    }

    $Object = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($Key))))

    [Key]::New($Object)
}
