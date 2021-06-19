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
        _Item([UInt32]$Index,[String]$Type,[String]$Path)
        {
            $This.Index = $Index
            $This.Hex   = ("0x{0:X6}" -f $Index)
            $This.Type  = $Type
            $This.Path  = $Path
            $This.Name  = $Path -Split "(\/|\\)" | Select-Object -Last 1
        }
    }

    $Time              = [System.Diagnostics.Stopwatch]::StartNew()
    Write-Host "[$($Time.Elapsed)] Connecting [~]"

    $Session           = New-SSHSession -ComputerName $ComputerName -KeyFile $KeyFile -Credential $Credential
    $ID                = $Session.SessionID
    $List              = Invoke-SSHCommand -SessionID $ID -Command "du -a /" | % Output

    $Stack             = @{ }
    Write-Host "[$($Time.Elapsed)] Populating [~] hashtable"
    ForEach ( $X in 0..( $List.Count - 1 ) )
    { 
        $Item          = $List[$X] -Split "`t"
        $Type          = $Item[0]
        $Path          = $Item[1]
        
        # Write-Progress -Activity $Path -Status "[$X/$($List.Count)]" -PercentComplete (($X/$List.Count) * 100)

        $Stack.Add($Stack.Count,[_Item]::New($Stack.Count,$Type,$Path))
    }

    Write-Host "[$($Time.Elapsed)] [~] Assigning hashtable to array"
    $Output = 0..($Stack.Count - 1) | % { $Stack[$_] }

    Write-Host "[$($Time.Elapsed)] [~]   Writing [$FilePath]"
    Set-Content -LiteralPath $FilePath -Value @( 
            
        ForEach ($X in 0..($Output.Count-1))
        {
            $Item = $Output[$X]
            $Item.Hex
            $Item.Type
            $Item.Path
            $Item.Name
            " "
        }
    ) -Verbose

    $Output

    [Void](Get-SSHSession | ? SessionID -match $ID | Remove-SSHSession)

    $Time.Stop()
    Write-Host "[$($Time.Elapsed)] Complete [+]"
}
