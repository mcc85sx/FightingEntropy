Function _Apache
{
    [CmdLetBinding()]Param([Parameter(Mandatory,Position=0)][String]$Path = "/var/www/html")

    chown apache:apache $Path -R

    $Conf    = "/etc/httpd/conf/httpd.conf" 
    $Content = Get-Content $Conf
    
    ForEach ( $X in 0..($Content.Count - 1))
    {
        If ( $Content[$X] -match "(<Directory />)" )
        { 
            $Content[$X+1] = "    AllowOverride All" 
        }
    }

    Set-Content $Conf $Content

    "http","https" | % { sudo firewall-cmd --zone=public --permanent --add-service=$_ }

    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl reload httpd 
}
