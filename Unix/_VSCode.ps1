Function Install-VSCode
{
    $Link = "https://packages.microsoft.com"
    $Keys = "$Link/keys/microsoft.asc"
    $Repo = "$Link/yumrepos/vscode"
            
    sudo rpm --import $Keys
    Set-Content "/etc/yum.repos.d/vscode.repo" "[code]|name=Visual Studio Code|baseurl=$Repo|enabled=1|gpgcheck=1|gpgkey=$Keys".Split('|') -VB

    sudo yum install code
    code --install-extension ms-vscode.powershell
}
