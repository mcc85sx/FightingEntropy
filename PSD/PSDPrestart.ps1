# PSDPrestart.ps1

$Path = "X:\Deploy\Prestart\PSDPrestart.xml"
If (Test-Path $Path)
{
    [Xml]$XML = Get-Content $Path
    ForEach ($Item in ($XML.Commands.Command))
    {
        Start-Process -FilePath $Item.Executable -ArgumentList $Item.Argument -Wait -NoNewWindow -PassThru
    }
}
