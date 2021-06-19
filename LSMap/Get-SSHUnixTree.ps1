
Function Get-SSHUnixTree
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$ComputerName,
        [Parameter(Mandatory,Position=1)][String]$KeyFile,
        [Parameter(Mandatory,Position=2)][String]$FilePath,
        [Parameter()][PSCredential]$Credential,
    )

    Class _Item
    {
        [UInt32]$Index
        [String]$Hex
        [String]$Type
        [String]$Path
        [String]$Name
        [Object]$Content
        _Item([UInt32]$Index,[String]$Type,[String]$Path,[String]$Name)
        {
            $This.Index = $Index
            $This.Hex   = ("0x{0:X6}" -f $Index)
            $This.Path  = $Path
            $This.Name  = $Name
            $This.Type  = $Type
        }
    }

    Class _Stock
    {
        [Object] $Stock
        [Object] $Stack
        _Stock([String]$ID)
        {
            $This.Stock = @{ }
            $Path       = $Null

            Invoke-SSHCommand -SessionID $ID -Command "cd .."
            Invoke-SSHCommand -SessionID $ID -Command "cd .."
            Invoke-SSHCommand -SessionID $ID -Command "ls -R /" | % Output | % { 
        
                $String = $_
            
                Switch -Regex ($String)
                {
                    \:
                    {
                        $Type = "Folder"
                        $Path = $String -Replace ":",""
                        $Name = @($Null,$String.Split("/")[-1])[$String.Split("/").Count -gt 1] -Replace ":",""
                    }
            
                    Default
                    {
                        $Type = "File"
                        $Name = ($Path -Split "/" | Select-Object -Last 1)
                    }
                }
                
                $This.Stock.Add($This.Stock.Count,[_Item]::New($This.Stock.Count,$Type,$Path,$Name))
            }

            $This.Stack = ForEach ( $X in 0..($This.Stock.Count - 1))
            {
                $This.Stock[$X]
            }
        }
    }

    $Session    = New-SSHSession -ComputerName $ComputerName -KeyFile $KeyFile -Credential $Credential
    $ID         = $Session.SessionID
    $Stack      = [_Stock] $ID | % Stack

    Set-Content $FilePath -Value @( 
    ForEach ($X in 0..($Stack.Count-1))
    {
        $Item = $Stack[$X]
        $Item.Hex
        $Item.Type
        $Item.Path
        $Item.Name
        " "
    }) -Verbose

    [Void](Get-SSHSession | ? SessionID -match $ID | Remove-SSHSession)

    $Stack
}
