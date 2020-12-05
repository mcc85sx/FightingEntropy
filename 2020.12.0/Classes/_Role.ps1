Class _Role
{
    [UInt32] $Type
    [String] $Name
    [Object] $Root

    _Role([UInt32]$Slot)
    {
        If ( $Slot -notin 0..3 )
        {
            Throw "Invalid option"
        }

        $This.Type = ("{0}Client {0}Server UnixBSD RHELCentOS" -f "Win32_" -Split " ")[$Slot]
       
        $This.Role = Switch($Slot)
        {
            Win32_Client { [_Win32_Client]::New() } Win32_Server { [_Win32_Server]::New() } 
            UnixBSD      { [_UnixBSD]::New()      } RHELCentOS   { [_RHELCentOS]::New()   }
        }
    }
}
