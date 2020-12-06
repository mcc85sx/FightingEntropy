Class _Module
{
    [Object]             $Module
    Hidden [Object]         $Env
    Hidden [Object]         $Var
    [String]               $Name = "FightingEntropy"
    [String]            $Version = "2020.12.0"
    [String]           $Provider = "Secure Digits Plus LLC"
    [String]               $Date
    [String]             $Status
    [String]               $Type
    [String]           $Resource = "https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.12.0"

    [String]           $Registry
    [String]               $Path
    [Object]               $File 
    [Object]           $Manifest 
    [Object]               $Base

    [Object]               $Host
    [Object]               $Info
    [Object]               $Role
    
    [Object[]]          $Classes
    [Object[]]          $Control
    [Object[]]        $Functions
    [Object[]]         $Graphics

    [String] Root([String]$Root)
    {
        Return @( $Root, $This.Provider, $This.Name, $This.Version -join '\' )
    }
    
    [Object] GetItem([String]$Object)
    {
        $Return = @{ }

        Foreach ( $Item in ( Get-Item -Path $Object | % GetEnumerator ) ) 
        { 
            $Return.Add($Item.Name,$Item.Value) 
        }
            
        Return $Return
    }

    [Object[]] Content([String]$Folder)
    {
        Return @( $This.Base | ? Name -eq $Folder | Get-ChildItem | % FullName )
    }

    [String[]] GetClasses()
    {
        Return @( $This.Module.Classes | % { "{0}\Classes\$_.ps1" -f $This.Path } )
    }

    LoadClassLibrary()
    {
        Invoke-Expression ( @( $This.GetClasses() | % { Get-Content $_ } ) -join "`n" )
    }

    [String[]] GetFunctions()
    {
        Return @( $This.Module.Functions | % { "{0}\Functions\$_.ps1" -f $This.Path } )
    }

    LoadFunctionLibrary()
    {
        Invoke-Expression ( @( $This.GetClasses() | % { Get-Content $_ } ) -join "`n" )
    }
    
    _Module()
    {
        $This.Module             = [_Manifest]::New()
        $This.Env                = $This.GetItem("Env:\")
        $This.Var                = $This.GetItem("Variable:\")
        $This.Registry           = $This.Root("HKLM:\SOFTWARE\Policies")

        Get-ItemProperty -Path $This.Registry | % { 

            $This.Name           = $_.Name
            $This.Version        = $_.Version
            $This.Provider       = $_.Provider
            $This.Date           = $_.Date
            $This.Status         = $_.Status
            $This.Type           = $_.Type
            $This.Path           = $_.Path
        }

        $This.Path               = $This.Root($Env:ProgramData)
        $This.File               = "{0}\FightingEntropy.psm1" -f $This.Path
        $This.Manifest           = "{0}\FightingEntropy.psd1" -f $This.Path
        $This.Base               = Get-ChildItem -Path $This.Path
        $This.Host               = [_Host]::New()
        $This.Info               = [_Info]::New()
        $This.Role               = [_Role]::New()
        $This.Classes            = $This.Content("Classes")
        $This.Control            = $This.Content("Control")
        $This.Functions          = $This.Content("Functions")
        $This.Graphics           = $This.Content("Graphics")
    }
}
