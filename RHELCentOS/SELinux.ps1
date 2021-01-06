Class SELinux
{
    [String]      $Path = "/etc/sysconfig/selinux"
    [String[]] $Content

    SELinux()
    {
        $This.Content = Get-Content -Path $This.Path
        $This.Content = $This.Content -Replace "SELINUX=enforcing","SELINUX=disabled"
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Content -Verbose
    }
}
