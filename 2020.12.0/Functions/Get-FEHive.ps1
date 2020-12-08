Function Get-FEHive ([String]$Type,[String]$Version)
{
    [_Hive]::new($Type,$Version)
}
