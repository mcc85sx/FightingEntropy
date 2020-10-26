
If ( [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() | % IsInRole Administrators )
{
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
}

Else
{
    Throw "Run As Administrator"
}
