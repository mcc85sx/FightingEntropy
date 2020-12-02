Class _Role
{
    [UInt32] $Type
    [String] $Name
    [Object] $Role

    [Int32] GetVersion()
    {
        Return @( Get-Item Variable:\PSVersionTable | % Value | % PSVersion | % Major )
    }
    
    [Int32] GetWinType()
    {
        Return @( Invoke-Expression "Get-CimInstance -ClassName Win32_OperatingSystem | % Caption" | % { 
        
            If ( $_ -match "Windows 10"     ) { 0 } 
            If ( $_ -match "Windows Server" ) { 1 }
        })
    }
    
    [Int32] GetOSType()
    {
        Return @( If ( $This.GetVersion() -gt 5 )
        {
            If ( Get-Item Variable:\IsLinux | % Value )
            {
                2
            }
            
            Else
            {
                $This.GetWinType()
            }
        }
        
        Else
        {
            $This.GetWinType()
        })
    }   

    _Role()
    {
        $This.Type = $This.GetOSType()
        $This.Name = ("{0}Client {0}Server UnixBSD RHELCentOS" -f "Win32_" -Split " ")[$This.Type]
        $This.Role = Switch($This.Name)
        {
            Win32_Client { [_Win32_Client]::New() } Win32_Server { [_Win32_Server]::New() } 
            UnixBSD      { [_UnixBSD]::New()      } RHELCentOS   { [_RHELCentOS]::New()   }
        }
    }
}
