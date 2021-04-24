$Cim.Window.Names | ? { $_ -match "SearchProperty" } | % {

    $Prop = $_
    $Verb = Switch -Regex ($Prop)
    {
        _Get  { "_Get" }
        _View { "_View" }
        _Edit { "_Edit" } 
        _New  { "_New" }
    }

    $Noun = $Prop -Replace $Verb,"" -Replace "SearchProperty"

    $Slot = Switch -Regex ($Noun)
    {
        ^UID           { "UID" }

        ^Client$       { "Client" }
        ^\w+Client$    { "Client" }

        ^Service$      { "Service"   }
        ^\w+Service$   { "Service"   }

        ^Device$       { "Device"    }
        ^\w+Device$    { "Device"    }

        ^Inventory$    { "Inventory" }
        ^\w+Inventory$ { "Inventory" }

        ^Issue$        { "Issue"     }
        ^\w+Issue$     { "Issue"     }

        ^Purchase$     { "Purchase"  }
        ^\w+Purchase$  { "Purchase"  }

        ^Expense$      { "Expense"   }
        ^\w+Expense$   { "Expense"   }

        ^Account$      { "Account"    }
        ^\w+Account$   { "Account"    }

        ^Invoice$      { "Invoice"    }
        ^\w+Invoice$   { "Invoice"    }

        ^\w+Object$    { "Object" }
    }

    $Item = "`$This.IO.$Verb$Noun`SearchProperty.SelectedIndex"
    "            {0}{1}= 0" -f $Item,(@(" ")*(60-$Item.length) -join '')
}
