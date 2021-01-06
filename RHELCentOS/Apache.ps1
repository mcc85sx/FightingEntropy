Class Apache
{
    [String]   $Path = "/etc/httpd/conf/httpd.conf"
    [String[]] $Value

    Apache()
    {
        If (!(Test-Path $This.Path))
        {
            sudo yum install epel-release httpd httpd-tools -y
            sudo chown apache:apache /var/www/html -R
        }
        
        $This.Value = Get-Content -Path $This.Path
    }

    [Void] Config()
    {
        ForEach ($I in 0..( $This.Value.Length - 1 ))
        {
            If ( $This.Value[$I] -match "(<Directory />)")
            {
                $This.Value[$I+1] = "    AllowOverride All"
            }
        }
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Value -Verbose -force
    }

    Firewall()
    {
        sudo firewall-cmd --zone=public --permanent --add-service=http
        sudo firewall-cmd --zone=public --permanent --add-service=https
    }

    Service()
    {
        sudo systemctl start httpd
        sudo systemctl enable httpd 
        sudo systemctl reload httpd
    }
}
