# Creates a class template with formatting
<# Explanation
____________________________________________________________
--[action]--[(Note: $test is a sample herestring)]
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
$test=@"
[UInt32]$Step
[Bool]$WildcardProxy
[UInt32]$CustomCertQuota
[UInt32]$PageRuleQuota
[Bool]$PhishDetect
[Bool]$MultiRailAllow
"@

Format-Class $test "Meta"
____________________________________________________________
--[result]--
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 Name     : Meta
 Input    : {[UInt32] $Step, [Bool]   $WildcardProxy, [UInt32] $CustomCertQuota, [UInt32] $PageRuleQuota...}
 Property : {Step, WildcardProxy, CustomCertQuota, PageRuleQuota...}
 MaxType  : 8
 MaxName  : 15
 Output   : {Class _Meta, {,    [UInt32]             $Step,    [Bool]      $WildcardProxy...}
____________________________________________________________
--[action]--
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Format-Class $test "Meta" | % Output 
____________________________________________________________
--[result]--
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Class _Meta 
{
   [UInt32]             $Step
   [Bool]      $WildcardProxy
   [UInt32]  $CustomCertQuota
   [UInt32]    $PageRuleQuota
   [Bool]        $PhishDetect
   [Bool]     $MultiRailAllow
   _Meta([Object]$Meta)
    {
        $This.Step             = $Meta.Step
        $This.WildcardProxy    = $Meta.WildcardProxy
        $This.CustomCertQuota  = $Meta.CustomCertQuota
        $This.PageRuleQuota    = $Meta.PageRuleQuota
        $This.PhishDetect      = $Meta.PhishDetect
        $This.MultiRailAllow   = $Meta.MultiRailAllow
   }
}
____________________________________________________________
--[reason]--[(Too much time doing this manually...)]
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
#>

Function Format-Class
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String[]]$InputObject,
        [Parameter(Position=1)][String]$Name)

    Class _Property
    {
        [String] $Type
        [String] $Name
        _Property([String]$Line)
        {
            $This.Type                  = [Regex]::Matches($Line,"(\[\w+(\[\])*\])").Value
            $This.Name                  = $Line.Split("\$")[1]
        }
    }

    Class _Stack
    {
        [String]            $Name
        [Object]           $Input
        [Object[]]      $Property
        [UInt32]         $MaxType
        [UInt32]         $MaxName
        [Object]          $Output
        _Stack([String]$Name,[Object[]]$InputObject)
        {
            $This.Name                  = $Name
            $This.Input                 = $InputObject
            $This.Property              = @( )

            ForEach ( $Item in $This.Input )
            {
                $This.Property         += [_Property]::New($Item)
            }

            $TypeList                   = $This.Property | % { $_.Type.Length } | Sort-Object -Descending
            
            Switch ([Int32]($TypeList.Count -gt 1))
            {
                0 { $This.MaxType       = $TypeList    }
                1 { $This.MaxType       = $TypeList[0] }
            }

            $NameList                   = $This.Property | % { $_.Name.Length } | Sort-Object -Descending

            Switch ([Int32]($NameList.Count -gt 1))
            {
                0 { $This.MaxName       = $NameList    }
                1 { $This.MaxName       = $NameList[0] }
            }

            $This.Output                = @( )

            # Writing Output
            $This.Output               += ("Class _{0}" -f $This.Name)
            $This.Output               += "{"
            
            # Property definitions
            ForEach ( $Line in $This.Property )
            {
                $TypeBuff               = @((" ")*((1+$This.MaxType)-($Line.Type.Length))) -join " "
                $NameBuff               = @((" ")*((1+$This.MaxName)-($Line.Name.Length))) -join " "

                $This.Output           += ('   {0}{1}{2}${3}' -f $Line.Type,$TypeBuff,$NameBuff,$Line.Name)
            }
            
            # Method declaration
            $This.Output               += ("   _{0}([Object]`${0})" -f $This.Name)
            $This.Output               += "    {"

            # Value definitions
            ForEach ( $Line in $This.Property )
            {
                $NameBuff               = @((" ")*((1+$This.MaxName)-($Line.Name.Length))) -join " "

                $This.Output           += ("        `$This.{0}{1} = `${2}.{3}" -f $Line.Name,$NameBuff,$This.Name,$Line.Name)
            }

            # Closing
            $This.Output               += "   }"
            $This.Output               += "}"

            # Complete
        }
    }

    If ( $InputObject.Count -eq 1 )
    {
        $InputObject = $InputObject -Split "`n"
    }

    [_Stack]::New($Name,$InputObject)

}
