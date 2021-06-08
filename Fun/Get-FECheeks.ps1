Function Get-FECheeks
{
    Class _Fun
    {
        [String] $Name
        [String] $Url
        [Object] $Content

        _Fun([String]$Name)
        {
            $This.Name = $Name
            $This.Url  = "https://github.com/mcc85sx/FightingEntropy/blob/master/Fun/$Name.txt?raw=true"
            $This.Content = Invoke-WebRequest $This.Url -UseBasicParsing | % Content
        }
    }

    $Stories = "&MicrosoftDeploymentToolkit","&TopShelfToolkit","&ShapedByFire","My&Briefcase","&ChaosEmeralds"
    $Titles  = $Stories -Replace "&","" 

    $Item    = @{ }
    $Item.Add(0,@{"[Title]"="FightingEntropy";Version="2021.6.0";Company="Secure Digits Plus LLC";Author="Michael C. Cook Sr.";Description="Beginning the fight against ID theft and cybercrime"})
    
    Switch($Host.UI.PromptForChoice("Choose story","Select a story",$Stories,0))
    {
        0 
        {
            $Cap = $Titles[0] | % { [_Fun]::New($_) }
            $Item.Add(1,@{"[Document]"= $Titles[0]})
            $Item.Add(2,$Cap.Content -Split "`n")
        }

        1 
        { 
            $Cap = $Titles[1] | % { [_Fun]::New($_) }
            $Item.Add(1,@{"[Document]"= $Titles[1]})
            $Item.Add(2,$Cap.Content -Split "`n")
        }

        2 
        {
            $Cap = $Titles[2] | % { [_Fun]::New($_) }
            $Item.Add(1,@{"[Document]"= $Titles[2]})
            $Item.Add(2,$Cap.Content -Split "`n")
        }

        3 
        { 
            $Cap = $Titles[3] | % { [_Fun]::New($_) }
            $Item.Add(1,@{"[Document]"= $Titles[3]})
            $Item.Add(2,$Cap.Content -Split "`n")
        }
        
        4
        {
            $Cap = $Titles[4] | % { [_Fun]::New($_) }
            $Item.Add(1,@{"[Document]"= $Titles[4]})
            $Item.Add(2,$Cap.Content -Split "`n")
        }

        Default
        {
            Write-Theme "[!] Error" 12,4,15,0
        }
    }

    Write-Theme $Item
}
