Class _UISwitch
{
    [String]     $Title
    [String]    $Prompt
    [System.Management.Automation.Host.ChoiceDescription[]] $Options
    [Int32]    $Default
    [Object]    $Output

    _UISwitch([String]$Title,[String]$Prompt,[String[]]$Options,[Int32]$Default)
    {
        $This.Title     = $Title
        $This.Prompt    = $Prompt
        $This.Options   = $Options
        $This.Default   = $Default
        $This.Output    = (Get-Host).UI.PromptForChoice($This.Title,$This.Prompt,$This.Options,$This.Default)
    }
}
