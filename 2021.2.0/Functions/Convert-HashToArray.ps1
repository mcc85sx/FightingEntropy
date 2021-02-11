Function Convert-HashToArray
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][Hashtable]$Table)
    
    ForEach ( $Item in $Table.GetEnumerator() )
    {     
        If ( $Item.Value.GetType().Name -eq "Hashtable" )
        {
            "[$($Item.Name)]"
            $Table.$($Item.Name).GetEnumerator() | % { "$($_.Name)=$($_.Value)" }
            ""
        }
            
        Else
        {
            "$($Item.Name)=$($Item.Value)"
            ""
        }
    }
}
