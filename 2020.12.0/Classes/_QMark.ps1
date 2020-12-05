Class _QMark
{
    [String] $ID
                
    _QMark()
    {
        $This.ID                = (Get-Service *_* -EA 0 | ? ServiceType -eq 224 | Select-Object -First 1).Name.Split('_')[-1]
    }
}
