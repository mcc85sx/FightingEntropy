$PowerShell = @("PowerShell 7 + Windows Terminal, a match made by the gods themselves";"-"*80;("Once upon a time, there was a bunch of peop" +
            "le sitting around.");" ";"One that just decided to *really* up the ante on their (widely/historically) known";("ability to engineer t" +
            "he best software on planet Earth.");" ";"After a number of years continually attempting to one-up themselves...?";("They took notice of an" + 
            " ameteur who stood no chance whatsoever, against the cosmos, alone.");" ";("Impressed, with his imbuement of mystical power of (writing/n" + 
              "arration) capabilities...");("...when combined with the total raw horsepower behind PowerShell 7...?");" ";("Maybe you oughtta stop and " + 
              "ask yourself...");"...if you somehow got invited to an action packed cinematic event.";" ";("The only problem with PowerShell 7 + Window" + 
              "s Terminal...");"...is that you won't want to stop using it.";"It's like pringles, but better.";("No contenders on the table, that have " + 
              "as much potential.");" ";"Could you imagine if perhaps... some guys that have been doing this a long time...";("didn't think that it cou" + 
              "ld come down to this?");" ";"Some senior engineers sat around and watched in shock and awe at the ameteur...";("...as if he were slaying" +
              " demons in a video game. On Mars. Or, wherever.");" ";"'Sometimes in life, ya just gotta sit back, and watch the new kid kick some ass.'";
              "(and)","'We have no idea if he ever needed any bubble gum... just went around kicking asses.'";" ";" -Microsoft")

            Switch((Host).UI.PromptForChoice("Funny Stuff?","Do you have a sense of humor?",[String[]]@("&Yes","&Maybe","&No","&Piss off..."),0))
            {
                0 { Write-Theme $PowerShell; Start-Sleep -Seconds 60 }
                1 { Write-Theme $PowerShell -Palette 11,9,15,0; Start-Sleep -Seconds 60 }
                2 { Write-Theme "Module [:] Installed" }
                3 { Write-Theme "Module [:] Installed"; Start-Sleep -Seconds 1; Write-Theme "By the way, you didn't have to be so rude about it..." }
            }
