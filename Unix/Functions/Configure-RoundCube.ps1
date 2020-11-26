Function Configure-RoundCube 
{
    [String]   $Path = (Get-ChildItem -Path "/var/www/roundcube" | ? Name -match "roundcube" | % FullName)
    [String]   $Name = [Network]::New().Host.Hostname
    [Int32]    $Port = 80
    [String]   $Root = "/var/www/html/"
    [String]   $Logs = "/var/log/httpd"

    If ( !$Path )
    {
        Throw "Roundcube not installed/found"
    }

    Set-Content -Path $Path -Value ((";<{0} *:$Port>;  ServerName $Name;  DocumentRoot $Root;;  ErrorLog $Logs`_error.log;"+
    "  CustomLog $Logs`_access.log combined;;  <{1} />;    {2};    {3};  </{1}>;;  <{1} $Root>;    {2} MultiViews;    {3};"+
    "    Order allow,deny;    allow from all;  </{1}>;;</{0}>" ) -f  "VirtualHost" , "Directory" , "Options FollowSymLinks",
    "AllowOverride All").Split(';') -Verbose
}
