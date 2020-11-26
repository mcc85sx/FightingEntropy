Function Install-MariaDB
{
    sudo yum install mariadb mariadb-server -y
    [Service]::New("Launch","mariadb")
}
