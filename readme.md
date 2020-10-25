[Install] - This following scriptlet will download all of the necessary files to install FightingEntropy

    If ( [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() | % IsInRole Administrators )
    {
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
        Add-Type -AssemblyName PresentationFramework
        $Install = Invoke-WebRequest -URI https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/2020.10.1/Install.ps1 -ContentType charset=utf-8 | % Content
        $Module  = Invoke-Expression $Install
    }

[Microsoft Deployment Toolkit] - Needed for configuring new deployment shares

    It is *the* toolkit...
    ...that Microsoft themselves uses...
    ...to deploy additional toolkits.

    It's not that weird.
    You're just thinking way too far into it, honestly.

    Regardless... it is quite a fearsome toolkit to have in one's pocket.
    Or, wherever really...
    ...at any given time.

    When you need to be taken seriously...?
    Well, it *should* be the first choice on one's agenda.
    But that's up to you.

    The [Microsoft Deployment Toolkit].
    Even Mr. Gates thinks it's awesome.
    
[Windows Assessment and Deployment Kit] - Needed
[Windows Preinstallation Environment Kit] - Needed

[FightngEntropy]

    With usage of this module, you will gain the ability to ... *list*

    When it comes to Write-Theme, whether for comedic intentions, OR, in the case of just wanting to be a general, all-around, 
    passed-many-a-checkered-flag-for-first-place-at-everything...-in-their-day-without-even-really-trying, 
    type of person..?

    Like Ricky Bobby, in the classic, hit movie, "Talledaga Nights"... when he says, "If you're not first, you're last..."

    Well... this module is dedicated to the people that keep trying to race this dude anyway.

    The types of high-shelf, category-5-hurricane's-in-their-mind-on-a-daily-basis, for years... 
    clever, engineering-marvel, master-extraordinaires... 
    some of them might even be war torn veterans who have seen a lot... done a lot. 
    
    Calculated as many functions, as they have had to snap a neck or two... 
    ...which is why they're the assassin grade programmers that everyone should be worried about.

    Whether they are literally or metaphorically that good..? 
    Well, snapping necks and cashing checks is in their MO.

    Maybe they have some stories that easily turn the most rock-hearted, brute force, men... 
    into a bunch of weepy little girls...

    Stories that even though you or anyone else may have heard before? The way they tell this story never gets old... 
    Everybody might actually try to walk out of the room as quickly as possible... 
    BEFORE they go on yet another "Did I ever tell you the story about the time that I ...?"

    Because everybody knows, that as soon as this person does this... 
    and hears this aforementioned awesome, story begin with that phrase...? 
    
    They know they're in for a 3 day adventure. 
    Where they're just getting paid to stand there and listen to this person's life story... 
    ...from the reflection pools of Washington DC, to the Louisiana Bayou, or Grand Canyon... 
    ...perhaps even wading through waist-high-water flash floods from torrential Asian-Monsoons... 
    ...having to carry your best friend to safety while he's dying...

    Maybe Tom Clancy could have a major involvement in the writing of the book, about the series of events based on 
    these people in particular... Maybe there's an instance where Tom Clancy just got up one day after hearing about 
    this story taking place... he just... randomly, out of the blue... said "Hey, I want to write a book about this."

    Perhaps the character for which Tom Clancy successfully envisioned and created as a direct result of observing 
    the most clever bastards out there, a character based on the real person that Tom Clancy thought would be a perfect 
    person to recruit as an acting replacement for Tom Cruise...

    He figured, Mr. Cruise is in all 14 Mission Impossible movies... 
    Sorta has an acting monopoly on good spy operative movies... 
    
    It is pretty easy to see how he's 'first place' material... 
    Losing Goose in Top Gun really drew out the perfect storm for Tom Cruises acting abilities to take root...
    ... and manifest into the much more mature version of the character that he's been able to tap into, on command... 

    Because... 
    I heard that Tom took it really hard when he lost Goose. 
    Not Tom Clancy, Tom Cruise. 
    
    I gotta say... I think that losing Goose could traumatize anybody, let alone any hardened warrior/soldier.

    Now, what I've just spent the last few paragraphs *describing*, is just a preview... 
    ...of the level I will have to rise to... 
    ...in order to merely *describe*... 
    ...the type of person who could fill Tom Cruises shoes any day of the week. 
    
    Because while Tom acts like he's a super secret top notch spy..?

    Well, the people that this module is written for, and dedicated to... are the type of people that could call 
    their spy buddies that live down the street, to keep tabs on you anywhere/everywhere..? But they don't. 
    
    They could also just out of nowhere, take a vacation whenever, wherever, go, see, do... at the drop of a pin... 
    ...but they don't do that either. 
    
    Why...?

    - long pause -
    
    Because they're too busy being awesome. That's why...

    So what you're left with, is a description of the type of grade/character of somebody who should have gotten a 
    Nobel Peace Prize by now. And in this specific (person/people)'s case, in my opinion it just so happens to be the case...
    That it is actually possible to make something that's too peaceful to receive a Nobel Peace Prize.

    It's like what I'd imagine a director at the Oscars goes through, when they get 'snubbed' for an Academy Award/Oscar.
    
    Some people have done plenty of things to get this damn thing, and yet, the prize continues to be given to Suzy Q down 
    the street. You say to yourself, that's odd... I know who that girl is. Turns out, she read this dude's Facebook posts
    every day, and... miraculously, it led to her getting a Nobel Peace Prize.
    
    I'm not saying that there IS a specific case of this having happened to (person/persons)... but maybe I am.
    
    Whatever the case may be... maybe you get this underground, back-stage version of events, where (that person/those people)
    *definitely* won at least 12 of them by now... You'd think it'd upset them that they can't go around telling people... 

    [Tangent : Skit]
    
    "Yeah I've got 12 of those." you announce, like a king.
    A person hears you, waits a second. 
    They didn't think you were talking to them, and the delay is noticed, causing the conversation to begin awkwardly.
    
    "Uh.. Ok? What are you telling *me* for? 12 what?"
    
    "Ah. I knew you'd ask. Nobel Peace Prizes" you announce, like a king.
    The person you just said that to, they're confused. 
    "Wait, huh?"
    
    "You asked me 12 what. Nobel Peace Prizes."
    "Didn't think that was possible... sounds like you're making that up."
    "No, I'm not."
    "You've got 12 Nobel Peace Prizes?"
    "Yes." you announce, like a king.
    "12 of them?"
    "Yeah man."

    [End Skit]

    This is the module that hopes, or attempts to be... one that was specifically tailor made.
    ...for the limited few people in this world that happen to have a constant category 5 hurricane going on in their mind every day... 
    ...and yet, they're as peaceful as can be.

    Getting snubbed for that many peace prizes would send any sane man that deserves one, over the edge.
    I just don't know how they do it. 
    
    Being told that you're too peaceful to receive a Nobel Peace Prize? 
    That should be enough to drive any one of these people I just described... 
    into a frenzy.
    
    Maybe they deserve this prize.
    I could imagine, some rich guy saying to himself...

    "I've got plenty of money folks. All that time, the money wasn't even what I wanted. 
    Went around helping people in need... but the world ignored the one need that remains vacant to this day...
    my need to receive one of these peace prizes."
    
    Maybe they earned it fair and square... 
    And yet...? 
    The prize continues to not be given to (this legend/these legends)...

    [Final Thought]
    FightingEntropy might not be that extreme, where it winds up earning a Nobel Peace Prize or anything like that.
    But it'll help people feel less salty over time.

    It could eventually help build a new generation of smart people...
    
