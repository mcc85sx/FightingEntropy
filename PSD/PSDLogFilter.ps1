Class LogItem
{
    Hidden [String]$Line
    Hidden [String]$Message
    [String]$Title
    [String]$Time
    [String]$Date
    [String]$Component
    [UInt32]$Type
    LogItem([String]$Line)
    {
        $This.Line      = $Line
        $Content        = $Line.Replace("><",">`n<") -Split "`n"
        $This.Message   = $Content[0] -Replace "^\<\!\[LOG\[","" -Replace "\]LOG\]\!\>",""
        $This.Title     = If ($This.Message.Length -le 80) { $This.Message } Else { $This.Message.Substring(0,80) + "..." }
        $Sub            = $Content[1] -Split " "
        $This.Time      = $This.Clean($Sub[0])
        $This.Date      = $This.Clean($Sub[1])
        $This.Component = $This.Clean($Sub[2])
        $This.Type      = $This.Clean($Sub[4])
    }
    [String]Clean([String]$Item)
    {
        Return @( [Regex]::Matches($Item,"\`".+\`"").Value.Replace('"',"") )
    }
}

Class LogFilter
{
    [Object]$Output
    LogFilter([String]$Path)
    {
        If (!(Test-Path $Path))
        {
            Throw "Invalid log path"
        }

        $This.Output = Get-Content $Path | % { [LogItem]$_ }
    }
}

# [Example] 
# $Log = [LogFilter]"C:\Files\PSD.log"
