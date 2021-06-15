Function _Install
{
    [CmdLetBinding()]Param(   
    [Parameter(Mandatory,Position=0)]
    [ValidateNotNullOrEmpty()][String]$List)

    Invoke-Expression "sudo yum install $($List -Split " ") -y" 
}
