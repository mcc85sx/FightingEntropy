Function Install-VSCodeBossMode
{
    [CmdLetBinding()]Param([Parameter()][String]$Path = $Env:UserProfile)
    {
        [String]   $Base = "https://github.com/mcc85sx/FightingEntropy/blob/master/bossmode"
        [String[]] $Tree = ".vscode",
                           "themes",
                           "CHANGELOG.md",
                           "index.txt",
                           "package.json",
                           "README.md",
                           "vsc-extension-quickstart.md",
                           ".vscode\launch.json",
                           "themes\BossMode-color-theme.json"
        [Object[]] $Files

        $Temp = "$Path\.vscode"
        If (!(Test-Path $Temp))
        {
            New-Item $Temp -ItemType Directory -Verbose
        }

        $Temp = "$Temp\extensions"
        If (!(Test-Path $Temp))
        {
            New-Item $Temp -ItemType Directory -Verbose
        }

        $Temp = "$Temp\bossmode"
        If (!(Test-Path $Temp))
        {
            New-Item $Temp -ItemType Directory -Verbose
        }
        ForEach ( $File in $Tree )
        {
            If ($File -match "\\")
            {
                $Folder = "{0}\{1}" -f $Temp, ($File | Split-Path -Parent)
                If (!(Test-Path $Folder))
                {
                    New-Item $Folder -ItemType Directory -Verbose
                }
            }
            
            Invoke-RestMethod "$Base/$File`?raw=true" -Outfile "$Temp/$File" -Verbose
        }
    }
}
