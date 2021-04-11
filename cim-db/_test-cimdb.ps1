Add-Type -AssemblyName PresentationFramework
irm https://github.com/mcc85sx/FightingEntropy/blob/master/cim-db/Functions/cim-db.ps1?raw=true | iex

$Cim = cim-db

0..1000 | % { 
    
    $x = Get-Random -Maximum 8
    $Cim.DB.AddUID($x)
    Write-Host ("Added [+] {0}" -f $Cim.DB.UID[$_].Type)
}

$Cim.IO._GetUIDSearchBox.ItemsSource       = $Cim.DB.UID
$Cim.IO._GetClientSearchBox.ItemsSource    = $Cim.DB.Client
$Cim.IO._GetServiceSearchBox.ItemsSource   = $Cim.DB.Service
$Cim.IO._GetDeviceSearchBox.ItemsSource    = $Cim.DB.Device
$Cim.IO._GetIssueSearchBox.ItemsSource     = $Cim.DB.Issue
$Cim.IO._GetInventorySearchBox.ItemsSource = $Cim.DB.Inventory
$Cim.IO._GetPurchaseSearchBox.ItemsSource  = $Cim.DB.Purchase
$Cim.IO._GetExpenseSearchBox.ItemsSource   = $Cim.DB.Expense
$Cim.IO._GetAccountSearchBox.ItemsSource   = $Cim.DB.Account

$Cim.Window.Invoke()
