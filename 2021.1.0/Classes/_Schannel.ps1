Class _SCHANNEL
{
    [String]   $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

    _SCHANNEL()
    {
        ForEach ( $Type in "SSL 2.0;SSL 3.0;TLS 1.0;TLS 1.1;TLS 1.2".Split(";") )
        {
            $Item = "{0}\{1}" -f $This.Path, $Type

            If ( ! ( Test-Path $Item ) )
            { 
                New-Item -Path $This.Path -Name $Type -Verbose
            }
            
            ForEach ( $Tag in "Client" , "Server" )
            {
                $Slot = "$Item\$Tag"

                If ( ! ( Test-Path $Slot ) )
                {
                    New-Item -Path $Item -Name $Tag -Verbose
                }
                
                ForEach ( $Opt in "DisabledByDefault" , "Enabled" )
                {
                    Set-ItemProperty -Path $Slot -Name $Opt -Value 0 -Verbose
                }

                If ( $Type -eq "TLS 1.2" )
                {
                    Set-ItemProperty -Path $Slot -Name "Enabled" -Value 1 -Verbose
                }
            }
        }
    }
}
