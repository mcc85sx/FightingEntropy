Class _TLSVersions
{
    [String[]] $Path = ("" , "\WOW6432NODE" | % { "HKLM:\SOFTWARE$_\Microsoft\.NETFramework" })
                        
    _TLSVersions()
    {
        ForEach ( $Item in $This.Path )
        {
            ForEach ( $Version in "v2.0.50727" , "v4.0.30319" )
            {
                If ( ! ( Test-Path "$Item\$Version" ) )
                { 
                    New-Item -Path $Item -Name $Version -Verbose
                }
                
                Set-ItemProperty -Path $Item\$Version -Name SystemDefaultTlsVersions -Value 1 -Verbose
            }
        }
    }
}
