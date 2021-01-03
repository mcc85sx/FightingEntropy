Class _OS
{
    [Object[]] $Environment
    [Object[]] $Variable
    [Object]   $PSVersionTable
    [Object]   $PSVersion
    [Object]   $Major
    [Object]   $Type

    [Object] GetItem([String]$Item)
    {
        $Return = @{ }

        ForEach ( $X in ( Get-Item -Path $Item | % GetEnumerator ) )
        { 
            $Return.Add($X.Name,$X.Value)
        }

        Return $Return
    }

    [String] GetWinType()
    {
        Return @( Switch -Regex ( Invoke-Expression "[wmiclass]'\\.\ROOT\CIMV2:Win32_OperatingSystem' | % GetInstances | % Caption" )
        {
            "Windows 10" { "Win32_Client" } "Windows Server" { "Win32_Server" }
        })
    }

    [String] GetOSType()
    {
        Return @( If ( $This.Major -gt 5 )
        {
            If ( Get-Item Variable:\IsLinux | % Value )
            {
                "RHELCentOS"
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

    _OS()
    {
        $This.Environment    = $This.GetItem("Env:\")
        $This.Variable       = $This.GetItem("Variable:\")
        $This.PSVersionTable = $This.Variable.PSVersionTable
        $This.PSVersion      = $This.PSVersionTable.PSVersion
        $This.Major          = $This.PSVersion.Major
        $This.Type           = $This.GetOSType()
    }
}
