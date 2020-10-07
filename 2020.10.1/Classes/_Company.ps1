Class _Company
{
    [String] $Name
    [String] $Branch
    [String] $Background
    [String] $Logo
    [String] $Phone
    [String] $Website
    [String] $Hours

    _Company() {}

    Load([String]$Name,[String]$Branch,[String]$Background,[String]$Logo,[String]$Phone,[String]$Website,[String]$Hours)
    { 
        $This.Name       = $Name
        $This.Branch     = $Branch
        $This.Background = $Background
        $This.Logo       = $Logo
        $This.Phone      = $Phone
        $This.Website    = $Website
        $This.Hours      = $Hours
    }
}