
        Class FEObject
        {
            [String]                  $Name
            [Int32]                 $Height
            [Object[]]             $Content
            [Object[]]              $Output

            [String] Line ([String]$L)
            {
                Return @{ Line  = If ( $L.Length -ge 89 ) { "$($L.Substring(0,88))..." } Else { "$L$(" "*(92-$L.Length))" } } | % Line
            }

            [String] Pair ([String]$K,[String]$V)
            {
                Return @{ Key   = If ( $K.Length -ge 25 ) { "$($K.Substring(0,20))..." } Else { "$K$(" "*(25-$K.Length))" }
                          Value = If ( $V.Length -ge 64 ) { "$($V.Substring(0,59))..." } Else { "$V$(" "*(64-$V.Length))" }
                
                }         | % { "{0} : {1}" -f $_.Key, $_.Value }
            }
            
            [String[]] Names ([Object]$N)
            {
                Return @( $N | Get-Member | ? MemberType -eq Property | % { $This.Pair($_.Name, $N.($_.Name)) } )
            }

            Select([Object]$Object)
            {
                Switch($Object.GetType().Name)
                {
                    Hashtable { $Object.GetEnumerator() | Sort Name | % { 
                                $This.Content += $This.Pair($_.Name,$_.Value) } }
                    Int       { $This.Content += $This.Line($Object)  }
                    String    { $This.Content += $This.Line($Object)  }
                    Object    { $This.Content += $This.Names($Object) }
                }
            }

            FEObject([Object]$InputObject)
            {
                $This.Name             = $InputObject.GetType().Name
                $This.Content          = @( )
                
                If ( $This.Name -Match "(\w.\[\])" )
                {
                    ForEach ( $I in 0..( $InputObject.Count - 1 ) )
                    {
                        $This.Name     = $InputObject[$I].GetType().Name
                        $This.Select($InputObject[$I])
                    }
                }

                If ( $This.Name -Notmatch "(\w.\[\])" )
                {
                    $This.Select($InputObject)
                }

                $This.Height           = $This.Content.Count
            }
        }

        Class FEStack
        {
            Hidden [Object[]]   $Stack
            Hidden [String]      $Last
            Hidden [String]      $Name
            [Int32]              $Slot
            [Int32]            $Height
            [Object[]]          $Track

            FEStack([FEObject[]]$InputObject)
            {
                If ( $InputObject.Count -eq 1 ) { If ( $InputObject -notmatch "(\[\w.\])" ) { 0 } Else { 1 } } Else { 2 }

                $This.Stack        = $InputObject | % { [FEObject]$_ }
                $This.Height       = $InputObject | Measure-Object -Property Height -Sum | % Sum

                If ( $This.Height -eq 1 ) 
                {
                    $This.Slot     = 0

                    If ( $This.Stack.Content -match "(\[\w.\])" )
                    {
                        $This.Slot = 1
                    }
                }

                If ( $This.Height -gt 1 )
                {
                    $This.Slot     = 2
                }

                ForEach ( $I in 0..( $This.Stack.Count - 1 ) )
                {
                    $This.Name     = $This.Stack[$I].Name

                    If ( $This.Last -eq "String" -and $This.Name -eq "Hashtable" )
                    {
                        $This.Track += ([FEObject]" ").Content
                    }

                    ElseIf ( $This.Last -eq "Hashtable" -or $This.Name -eq "Hashtable" )
                    {
                         $This.Track += ([FEObject]" ").Content
                    }

                    If ( $This.Stack[$I].Content.Count -gt 1 )
                    {
                        ForEach ( $X in 0..( $This.Stack[$I].Content.Count - 1 ) )
                        {
                            $This.Track += $This.Stack[$I].Content[$X]
                        }
                    }

                    If ( $This.Stack[$I].Content.Count -eq 1 )
                    {
                        $This.Track += $This.Stack[$I].Content
                    }

                    $This.Last     = $This.Name
                }

                $This.Height       = $This.Track.Count
            }
        }

        #  
        #$String         = "Name Things Place Happening"
        #$Hashtable      = @{ Name ="Things"; Place = "Happening" }
        #$StringArray    = "Name Things Place Happening" -Split " "
        #$HashtableArray = $Hashtable | % { $_ , $_ }

        $ObjectList     = $String, $Hashtable, $StringArray, $HashtableArray

        $Stack          = [FEStack]::New($Objectlist)
