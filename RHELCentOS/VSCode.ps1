Class VSCode # To install VSCode on CentOS
{
    [String]       $Path = "/etc/yum.repos.d/vscode.repo" 
    Hidden [String] $URL = "https://packages.microsoft.com"
    [String]        $Key
    [String]       $Repo
    [Object]        $GPG

    VSCode()
    {
        $This.Key  = "{0}/keys/microsoft.asc" -f $This.URL
        $This.Repo = "{0}/yumrepos/vscode" -f $This.URL
        $This.GPG = ("[code];name=Visual Studio Code;baseurl={0};enabled=1;gpgcheck=1;gpgkey={1}" -f  $This.Repo, $This.Key -Split ';')
    }

    Install()
    {
        sudo rpm --import $This.Key
        Set-Content -Path $This.Path -Value $This.GPG -Verbose -Force
        sudo yum install code
    }
}
