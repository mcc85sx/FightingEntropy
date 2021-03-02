Class Apache
{
    [String]      $Path = "/etc/httpd/conf/httpd.conf"
    [String[]] $Content
    [String[]]  $Output

    Apache()
    {
        If (!(Test-Path $This.Path))
        {
            Write-Host "Checking/Installing [:] EPEL, Apache"
            sudo yum install epel-release httpd httpd-tools -y
    
            Write-Host "File System [:] /var/www/html"
            sudo chown apache:apache /var/www/html -R
        }
        
        $This.Content = Get-Content -Path $This.Path
    }
    
    Configure()
    {
        Write-Host "Configuring [:] Apache"
        $This.Output = $This.Content
        
        0..( $This.Output.Length - 1 ) | % {

            If ( $This.Output[$_] -match "(<Directory />)")
            {
                $This.Output[$_+1] = "    AllowOverride All"
            }
        }
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose -Force
    }

    Firewall()
    {
        Write-Host "Firewall [:] HTTP"
        sudo firewall-cmd --zone=public --permanent --add-service=http
        
        Write-Host "Firewall [:] HTTPS"
        sudo firewall-cmd --zone=public --permanent --add-service=https
    }

    Service()
    {
        Write-Host "System Control [:] Apache/httpd [Start]"
        sudo systemctl start httpd

        Write-Host "System Control [:] Apache/httpd [Enable]"
        sudo systemctl enable httpd 

        Write-Host "System Control [:] Apache/httpd [Reload]"
        sudo systemctl reload httpd
    }
}
