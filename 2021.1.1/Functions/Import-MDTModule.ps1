Function Import-MDTModule
{
    [String]   $Path = "HKLM:\Software\Microsoft\Deployment 4"
        
    If (!(Test-Path $Path))
    {
        Throw "MDT Not Installed"
    }

    [Object]   $Item = Get-ItemProperty $Path
        
    If (!($Item))
    {
        Throw "Error, can't locate MDT Installation Path"
    }

    [String]    $Dir = $Item.Install_Dir
    [String] $Output = Get-ChildItem -Path $Dir -Filter *Toolkit.psd1 -Recurse | % FullName

    If (!($Output))
    {
        Throw "MDT Module not found"
    }

    $Output | Import-Module -Verbose -Force
}
