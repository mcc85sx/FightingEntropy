Function Install-Apache
{
    sudo yum install epel-release httpd httpd-tools -y
    chown apache:apache /var/www/html -R
}
