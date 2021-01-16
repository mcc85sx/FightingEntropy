Function Import-MDTModule
{
    Class _MSDT
    {
        [String]   $Path = "HKLM:\Software\Microsoft\Deployment 4"
        [Object]   $Item
        [String]    $Dir
        [String] $Output
    
        _MSDT()
        {
            If (!(Test-Path $This.Path))
            {
                Throw "MDT Not Installed"
            }

            $This.Item   = Get-ItemProperty $This.Path
        
            If (!($This.Item))
            {
                Throw "Error, can't locate MDT Installation Path"
            }

            $This.Dir    = $This.Item.Install_Dir
            $This.Output = Get-ChildItem -Path $This.Dir -Filter *Toolkit.psd1 -Recurse | % FullName
        }
    }

    [_MSDT]::New().Output | Import-Module -Verbose -Force
}
