Class _RootVar
{
    [String] $UNC
    [String] $CompanyName
    [String] $DCUser
    [String] $DCPass
    [String] $ShareName
    [String] $Website
    [String] $Phone
    [String] $Hours
    [String] $Background
    [String] $Logo
    [String] $Location
    [String] $DNSDomain
    [String] $LMUser
    [String] $LMPass
    [String] $Server
    [Object] $Source
    [Object] $Target

    _RootVar(){}
    Default()
    {        
        $This.UNC            = '\\dsc2\secured$'                                           # $R.0
        $This.CompanyName    = 'Secure Digits Plus LLC'                                    # $R.1
        $This.DCUser         = 'dsc2'                                                      # $R.2
        $This.DCPass         = 'Int3264!'                                                  # $R.3
        $This.ShareName      = 'dsc-deploy'                                                # $R.4
        $This.Website        = 'https://www.securedigitsplus.com'                          # $R.5
        $This.Phone          = '(518)847-3459'                                             # $R.6
        $This.Hours          = '24/7'                                                      # $R.7
        $This.Background     = 'OEMbg.jpg'                                                 # $R.8
        $This.Logo           = 'OEMlogo.bmp'                                               # $R.9
        $This.Location       = '(Vermont)'                                                 # $R.10
        $This.DNSDomain      = 'vermont.securedigitsplus.com'                              # $R.11
        $This.LMUser         = 'Administrator'                                             # $R.12
        $This.LMPass         = 'Int3264!'                                                  # $R.13
        $This.Server         = 'dsc2'                                                      # $R.14
        #$This.Source         = [_Source]::New(("{0}\{1}" -f $This.UNC, $This.CompanyName)) # $R.15
        #$This.Target         = [_Target]::New("C:\$($This.CompanyName)")                   # $R.16
    }
}
