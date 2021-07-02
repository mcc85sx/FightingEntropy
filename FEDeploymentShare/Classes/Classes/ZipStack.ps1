Class ZipStack
    {
        [String]    $Path
        [Object] $Content
        ZipStack([String]$Path)
        {
            $This.Path    = $Path
            $This.Content = IRM $Path
        }
        [Object[]] ZipTown([String]$Zip)
        {
            $Value = [Regex]::Matches($This.Content,"($Zip)+.+").Value 
            
            If ( $Value -eq $Null )
            {
                Throw "No result found"
            }

            Else
            {
                $Return = @( )

                ForEach ($Item in $Value)
                {
                    $Return += [ZipEntry]$Item    
                }

                Return $Return
            }   
        }
        [Object[]] TownZip([String]$Town)
        {
            $Value = [Regex]::Matches($This.Content,"\d{5}\t\d{1}\t($Town)+.+").Value 
            
            If ( $Value -eq $Null )
            {
                Throw "No result found"
            }

            Else
            {
                $Return = @( )

                ForEach ($Item in $Value)
                {
                    $Return += [ZipEntry]$Item    
                }

                Return $Return
            }  
        }
    }