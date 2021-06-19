Function Get-SSHUnixTree
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$ComputerName,
        [Parameter(Mandatory,Position=1)][String]$KeyFile,
        [Parameter(Mandatory,Position=2)][String]$FilePath,
        [Parameter()][PSCredential]$Credential
    )

    # Class
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

    $Session           = New-SSHSession -ComputerName $ComputerName -KeyFile $KeyFile -Credential $Credential
    $ID                = $Session.SessionID
    $Stack             = @{ }

    $Path              = $Null

    [Void](Invoke-SSHCommand -SessionID $ID -Command "cd ..")
    [Void](Invoke-SSHCommand -SessionID $ID -Command "cd ..")
    Invoke-SSHCommand -SessionID $ID -Command "ls -R /" | % Output | % { 
        
        $String        = $_
            
        Switch -Regex ($String)
        {
            (\:)
            {
                $Type  = "Folder"
                $Path  = $String -Replace ":",""
            }
            
            Default
            {
                $Type  = "File"
            }
        }

        $Name          = ($String -Split "/" | Select-Object -Last 1)
        If ( $Name[-1] -eq ":" )
        {
            $Name.TrimEnd(":")
        }
        $Stack.Add($Stack.Count,[_Item]::New($Stack.Count,$Type,$Path,$Name))
    }

    [Void](Get-SSHSession | ? SessionID -match $ID | Remove-SSHSession)

    $Stock = ForEach ( $X in 0..($Stack.Count - 1))
    {
        $Stack[$X]
    }

    Set-Content -LiteralPath $FilePath -Value @( 
            
        ForEach ($X in 0..($Stock.Count-1))
        {
            $Item = $Stock[$X]
            $Item.Hex
            $Item.Type
            $Item.Path
            $Item.Name
            " "
        }
    ) -Verbose

    $Stock
}
