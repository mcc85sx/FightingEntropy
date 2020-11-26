Function Configure-Apache
{
    [String]            $Root = "/etc/httpd/conf/httpd.conf"
    [String]      $ServerName = (hostname)
    [String[]]       $Content = (Get-Content $Root)

    0..( $Content.Count - 1 ) | % { 
        
        If ( $Content[$_] -match "(<Directory />)" )
        {
            $Content[$_+1]    = $Content[$_+1] -Replace "none","all" 
        }
        
        If ( $Content[$_] -match "(#ServerName)" ) 
        { 
            $Content[$_]      = $Content[$_] -Replace "www.example.com", $ServerName -Replace "#Ser","Ser" 
        }
    }

    Set-Content -Path $Root -Value $Content -Verbose

    "http","https" | % { firewall-cmd --zone=public --permanent --add-service=$_ }

    [Service]::New("Launch","httpd")
}
