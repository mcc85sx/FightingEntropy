Class SELinux
{
    [String]      $Path = "/etc/sysconfig/selinux"
    [String[]] $Content
    [String[]]  $Output

    SELinux()
    {
        Write-Host "Get-Content [:] $($This.Path)"
        $This.Content = Get-Content -Path $This.Path
        $This.Output  = ($This.Content -join "`n").Replace("SELINUX=enforcing","SELINUX=disabled")
    }

    Save()
    {
        Set-Content -Path $This.Path -Value $This.Output -Verbose -Force
    }
}
