Class _Role
{
    [UInt32] $Type
    [String] $Name
    [Object] $Role

    GetWinType()
    {
        $Caption = Invoke-Expression "Get-CimInstance -ClassName Win32_OperatingSystem | % Caption"

        If ( $Caption -match "Windows 10" ) 
        { 
            $This.Type = 0 
        }
        
        If ( $Caption -match "Windows Server" )
        { 
            $This.Type = 1 
        }
    }
    
    _Role()
    {
        If ( ( Get-Item "Variable:\PSVersionTable" | % Value | % PSVersion | % Major ) -gt 5 )
        {
            If ( Get-Item "Variable:\IsLinux" | % Value )
            {
                $This.Type = 2
            }
            
            Else
            {
                $This.GetWinType()
            }
        }
        
        Else
        {
            $This.GetWinType()
        }
        
        $This.Name = ("{0}Client {0}Server UnixBSD RHELCentOS" -f "Win32_" -Split " ")[$This.Type]
        $This.Role = Switch($This.Name)
        {
            Win32_Client { [_Win32_Client]::New() } Win32_Server { [_Win32_Server]::New() } 
            UnixBSD      { [_UnixBSD]::New()      } RHELCentOS   { [_RHELCentOS]::New()   }
        }
    }
}
