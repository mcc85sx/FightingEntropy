Class Justify
{
    [Object] $InputObject
    [UInt32]       $Width = 88
    [Object]        $Swap

    Justify([String]$InputObject)
    {
        $This.InputObject = $InputObject -Split "`n"
        $This.Swap        = @( )

        ForEach ( $Line in $This.InputObject )
        {
            Switch([UInt32]($Line.Length -gt $This.Width))
            {
                0 
                {  
                    $This.Swap += $Line
                }

                1 
                { 
                    $Segment    = $Line

                    $Length     = $Line.Length
                    $Char       = $Line.ToCharArray()
                    $NewLine    = @{ }
                    $C          = -1

                    ForEach ( $X in 0..($Char.Count - 1) )
                    {
                        If ( $X % 88 -eq 0)
                        {
                            $C++
                            $NewLine.Add($C,@())
                        }
    
                        $NewLine[$C] += $Char[$X]
                    }

                    ForEach ( $I in 0..($NewLine.Count - 1))
                    {
                        $This.Swap += $NewLine[$I] -join ''
                    }
                }
            }
        }
    }
}

$Var = @"
The concept of being “Shaped By Fire”

Sometimes in life, you have to question what’s right in front of you.
Take the album, “Shaped By Fire”, by one of the most legendary, classic, top-notch metal bands that have ever existed… “As I Lay Dying”. 
It’s mean..? It’s in your face..? That’s just a short description of the album, “Shaped By Fire” for ya.

But, the reason I wrote this excerpt, is to have a little discussion about the difference between the album “Shaped By Fire” versus an actual fire shaping.
The concept of being shaped by fire should scare the poop out of anybody that hears about it.
Seriously.

The album “Shaped By Fire”, is something that you could in fact listen to right now.
(Side point - You could even support this band by going to https://www.asilaydying.com/
...and get yourself some 1) merchandise or 2) tickets for their next tour dates.)

The concept of BEING shaped by fire though, is something that I think the founder of the band found himself struggling with... 
That is, having a ring of fire rain down upon you. 
Ultimately, it’s the ex-girlfriend/wife that stands as a metaphor for being shaped by fire.

Over the years, I’ve found myself going on adventures with Tim and his crew.
Whether shadows actually are security, is beyond me.
There may have actually been an ocean between us, at one point or another.
I’m not going to ego trip into a powerless rise, because I’ve been awakened.
But- if I even see a traumatic fire shaping happening to somebody…?
Well, I’m not gonna stand for that.

Friends don’t let friends get shaped by fire.
Unless it’s the album “Shaped By Fire”. 
Then, you’d be doing your friends a real favor.
"@

Set-Content -Path $Home\Desktop\Fireshaping.ps1 -Value ([Justify]::New($Var).Swap)
