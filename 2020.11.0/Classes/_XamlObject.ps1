Class _XamlObject
{
    [String] $Xaml

    Hidden [Hashtable] $Hash = @{
        
        Certificate = @"
<Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | Hybrid @ Certificate Info'
                                                      Width = '350'
                                                     Height = '200'
                                                    Topmost = 'True' 
                                                       Icon = ''
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
            <GroupBox
                                     Header = 'Company Information / Certificate Generation'
                                      Width = '330'
                                     Height = '160'
                          VerticalAlignment = 'Top' >
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height = '2*' />
                        <RowDefinition Height = '*' />
                    </Grid.RowDefinitions>
                    <Grid Grid.Row = '0' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '2.5*' />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '*' />
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row = '0' Grid.Column = '0' Margin = '10' TextAlignment = 'Right' >Company:</TextBlock>
                        <TextBox Name = 'Company' Grid.Row = '0' Grid.Column = '1' Height = '24' Margin = '5' />
                        <TextBlock Grid.Row = '1' Grid.Column = '0' Margin = '10' TextAlignment = 'Right' >Domain:</TextBlock>
                        <TextBox Name = 'Domain' Grid.Row = '1' Grid.Column = '1' Height = '24' Margin = '5' />
                    </Grid>
                    <Grid Grid.Row = '1' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '*' />
                        </Grid.ColumnDefinitions>
                        <Button Name =  'Ok' Content = 'Ok' Grid.Column = '0' Margin = '10' />
                        <Button Name =  'Cancel' Content = 'Cancel' Grid.Column = '1' Margin = '10' />
                    </Grid>
                </Grid>
            </GroupBox>
        </Window>
"@
        Login = @"
    <Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | Hybrid @ AD Login'
                                                      Width = '480'
                                                     Height = '280'
                                                    Topmost = 'True' 
                                                       Icon = ''
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
            <GroupBox
                                     Header = 'Enter Directory Services Admin Account'
                                      Width = '450'
                                     Height = '240' Margin = '5'
                          VerticalAlignment = 'Center'>
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height = '2*' />
                        <RowDefinition Height = '1.25*' />
                    </Grid.RowDefinitions>
                    <Grid Grid.Row = '0' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '3*' />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '*' />
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Column = '0' Grid.Row = '0' Margin = '10' TextAlignment = 'Right' >
                            Username:</TextBlock>
                        <TextBox Name = 'Username' Grid.Column = '1' Grid.Row = '0' Height = '24' Margin = '5' >
                            </TextBox>
                        <TextBlock Grid.Column = '0' Grid.Row = '1' Margin = '10' TextAlignment = 'Right' >
                            Password:</TextBlock>
                        <PasswordBox Name = 'Password' Grid.Column = '1' Grid.Row = '1' Height = '24' Margin = '5' PasswordChar = '*' >
                            </PasswordBox>
                        <TextBlock Grid.Column = '0' Grid.Row = '2' Margin = '10' TextAlignment = 'Right' >
                            Confirm:</TextBlock>
                        <PasswordBox Name =  'Confirm' Grid.Column = '1' Grid.Row = '2' Height = '24' Margin = '5' PasswordChar = '*' >
                            </PasswordBox>
                    </Grid>
                    <Grid Grid.Row = '1' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '*' />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*'/>
                            <RowDefinition Height = '*'/>
                        </Grid.RowDefinitions>
                        <RadioButton Name = 'Switch' Grid.Row = '0' Grid.Column = '0' Content = 'Change' VerticalAlignment = 'Center' HorizontalAlignment = 'Center' />
                        <TextBox Name = 'Port' Grid.Row = '0' Grid.Column = '1' VerticalAlignment = 'Center' HorizontalAlignment = 'Center' Width = '120' IsEnabled = 'False' >
                            389</TextBox>
                        <Button Name = 'Ok' Content = 'Ok' Grid.Column = '0' Grid.Row = '1' Margin = '5' >
                            </Button>
                        <Button Name = 'Cancel' Content = 'Cancel' Grid.Column = '1' Grid.Row = '1' Margin = '5' >
                            </Button>
                        </Grid>
                    </Grid>
                </GroupBox>
            </Window>
"@
        NewAccount = @"
                <Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | Hybrid @ Account Designation'
                                                      Width = '480'
                                                     Height = '280'
                                                    Topmost = 'True' 
                                                       Icon = ''
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
            <GroupBox
                                     Header = 'Enter Username and Password'
                                      Width = '450'
                                     Height = '240' Margin = '5'
                          VerticalAlignment = 'Center'>
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height = '2*' />
                        <RowDefinition Height = '1.25*' />
                    </Grid.RowDefinitions>
                    <Grid Grid.Row = '0' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '3*' />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '*' />
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Column = '0' Grid.Row = '0' Margin = '10' TextAlignment = 'Right' >
                            Username:</TextBlock>
                        <TextBox Name = 'Username' Grid.Column = '1' Grid.Row = '0' Height = '24' Margin = '5' >
                            </TextBox>
                        <TextBlock Grid.Column = '0' Grid.Row = '1' Margin = '10' TextAlignment = 'Right' >
                            Password:</TextBlock>
                        <PasswordBox Name = 'Password' Grid.Column = '1' Grid.Row = '1' Height = '24' Margin = '5' PasswordChar = '*' >
                            </PasswordBox>
                        <TextBlock Grid.Column = '0' Grid.Row = '2' Margin = '10' TextAlignment = 'Right' >
                            Confirm:</TextBlock>
                        <PasswordBox Name =  'Confirm' Grid.Column = '1' Grid.Row = '2' Height = '24' Margin = '5' PasswordChar = '*' >
                            </PasswordBox>
                    </Grid>
                    <Grid Grid.Row = '1' >
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width = '*' />
                            <ColumnDefinition Width = '*' />
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*'/>
                            <RowDefinition Height = '*'/>
                        </Grid.RowDefinitions>
                        <RadioButton Name = 'Switch' Grid.Row = '0' Grid.Column = '0' Content = 'Change' VerticalAlignment = 'Center' HorizontalAlignment = 'Center' Visibility = 'Collapsed'/>
                        <TextBox Name = 'Port' Grid.Row = '0' Grid.Column = '1' VerticalAlignment = 'Center' HorizontalAlignment = 'Center' Width = '120' IsEnabled = 'False' Visibility = 'Collapsed'>
                            389</TextBox>
                        <Button Name = 'Ok' Content = 'Ok' Grid.Column = '0' Grid.Row = '1' Margin = '5' >
                            </Button>
                        <Button Name = 'Cancel' Content = 'Cancel' Grid.Column = '1' Grid.Row = '1' Margin = '5' >
                            </Button>
                        </Grid>
                    </Grid>
                </GroupBox>
            </Window>
"@

    HybridDSCPromo = @"
           <Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | Hybrid @ Desired State Controller Promotion'
                                                      Width = '800'
                                                     Height = '800'
                                                    Topmost = 'True' 
                                                       Icon = ''
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height = '20' />
                <RowDefinition Height = '*' />
            </Grid.RowDefinitions>
            <Menu Grid.Row = '0' Height = '20' >
                <MenuItem Header = 'New' >
                    <MenuItem Name = 'Forest' Header = 'Install-ADDSForest' IsCheckable = 'True' />
                    <MenuItem Name = 'Tree' Header = 'Install-ADDSDomain Tree' IsCheckable = 'True' />
                    <MenuItem Name = 'Child' Header = 'Install-ADDSDomain Child' IsCheckable = 'True' />
                    <MenuItem Name = 'Clone' Header = 'Install-ADDSDomainController' IsCheckable = 'True' />
                </MenuItem>
            </Menu>
            <GroupBox
                                                   Grid.Row = '1'
                                                     Header = '[ Hybrid-DSC Domain Service Configuration ]'
                                        HorizontalAlignment = 'Center'
                                          VerticalAlignment = 'Center'
                                                      Width = '760'
                                                     Height = '740' >
                <Grid>
                    <Grid Grid.Row = '1' Margin = '10' >
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '*' />
                            <RowDefinition Height = '10*' />
                        </Grid.RowDefinitions>
                        <Grid Grid.Row = '0' >
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width = '*' />
                                <ColumnDefinition Width = '*' />
                            </Grid.ColumnDefinitions>
                            <GroupBox Name = 'ForestModeBox' Header = 'ForestMode' Grid.Column = '0' Margin = '5' Visibility = 'Collapsed' >
                                <ComboBox Name = 'ForestMode' Height = '24' SelectedIndex = '0' >
                                    <ComboBoxItem Content = 'Windows Server 2000 ( Default )' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2003' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2008' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2008 R2' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2012' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2012 R2' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2016' IsSelected = 'True' />
                                    <ComboBoxItem Content = 'Windows Server 2019' IsSelected = 'False' />
                                </ComboBox>
                            </GroupBox>
                            <GroupBox Name = 'DomainModeBox' Header = 'DomainMode' Grid.Column = '1' Margin = '5' Visibility = 'Collapsed' >
                                <ComboBox Name = 'DomainMode' Height = '24' SelectedIndex = '0' >
                                    <ComboBoxItem Content = 'Windows Server 2000 ( Default )' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2003' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2008' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2008 R2' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2012' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2012 R2' IsSelected = 'False' />
                                    <ComboBoxItem Content = 'Windows Server 2016' IsSelected = 'True' />
                                    <ComboBoxItem Content = 'Windows Server 2019' IsSelected = 'False' />
                                </ComboBox>
                            </GroupBox>
                        <GroupBox Name = 'ParentDomainNameBox' Header = 'Parent Domain Name' Grid.Column = '0' Margin = '5' Visibility = 'Collapsed' >
                            <TextBox Name = 'ParentDomainName' Text = '&lt;Domain Name&gt;' Height = '20' Margin = '5' />
                        </GroupBox>
                        </Grid>
                        <Grid Grid.Row = '1' >
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width = '*' />
                                <ColumnDefinition Width = '2.5*' />
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height = '3.5*' />
                                <RowDefinition Height = '*' />
                            </Grid.RowDefinitions>
                        <GroupBox Header = 'Service Options' Grid.Row = '0' Grid.Column = '0' Margin = '5' >
                            <Grid Grid.Row = '0' Grid.Column = '0' >
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '5*' />
                                    <ColumnDefinition Width = '*' />
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                    <RowDefinition Height =  '*' />
                                </Grid.RowDefinitions>
                                <TextBlock Grid.Column = '0' Grid.Row = '0' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '0' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '1' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '1' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '2' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '2' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '3' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '3' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '4' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '4' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '5' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '5' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '6' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '6' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '7' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '7' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '8' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '8' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '9' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '9' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '10' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '10' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '11' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '11' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '12' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '12' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '13' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '13' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '14' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '14' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '15' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '15' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Column = '0' Grid.Row = '16' Margin = '5' TextAlignment = 'Right' >:</TextBlock>
                                <CheckBox Grid.Column = '1' Grid.Row = '16' Margin = '5' Name = '' IsEnabled = 'True' IsChecked = 'False' />
                            </Grid>
                        </GroupBox>
                        <Grid Grid.Row = '0' Grid.Column = '1' Margin = '10 , 0 , 10 , 0' >
                            <Grid.RowDefinitions>
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                                <RowDefinition Height = '*' />
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row = '0' Header = 'DatabasePath' Name = 'DatabasePathBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'DatabasePath' />
                            </GroupBox>
                            <GroupBox Grid.Row = '1' Header = 'SysvolPath' Name = 'SysvolPathBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'SysvolPath' />
                            </GroupBox>
                            <GroupBox Grid.Row = '2' Header = 'LogPath' Name = 'LogPathBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'LogPath' />
                            </GroupBox>
                            <GroupBox Grid.Row = '3' Header = 'Credential' Name = 'CredentialBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '*' />
                                        <ColumnDefinition Width = '3*' />
                                    </Grid.ColumnDefinitions>
                                    <Button Content = 'Credential' Name = 'CredentialButton' Grid.Column = '0' />
                                    <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'Credential' Grid.Column = '1' />
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row = '4' Header = 'DomainName' Name = 'DomainNameBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'DomainName' />
                            </GroupBox>
                            <GroupBox Grid.Row = '5' Header = 'DomainNetBIOSName' Name = 'DomainNetBIOSNameBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'DomainNetBIOSName' />
                            </GroupBox>
                            <GroupBox Grid.Row = '6' Header = 'NewDomainName' Name = 'NewDomainNameBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'NewDomainName' />
                            </GroupBox>
                            <GroupBox Grid.Row = '7' Header = 'NewDomainNetBIOSName' Name = 'NewDomainNetBIOSNameBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'NewDomainNetBIOSName' />
                            </GroupBox>
                            <GroupBox Grid.Row = '8' Header = 'SiteName' Name = 'SiteNameBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'SiteName' />
                            </GroupBox>
                            <GroupBox Grid.Row = '9' Header = 'ReplicationSourceDC' Name = 'ReplicationSourceDCBox' Visibility = 'Visible' BorderBrush = '{x:Null}' >
                                <TextBox Height = '20' Margin = '10 , 0 , 10 , 0' Name = 'ReplicationSourceDC' />
                            </GroupBox>
                        </Grid>
                        <GroupBox Grid.Row = '1' Header = 'Roles' Margin = '5' >
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*' />
                                    <RowDefinition Height = '*' />
                                    <RowDefinition Height = '*' />
                                    <RowDefinition Height = '*' />
                                </Grid.RowDefinitions>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '5*' />
                                    <ColumnDefinition Width = '*' />
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Row = '0' TextAlignment = 'Right' Margin = '5' IsEnabled = 'True' >Install DNS:</TextBlock>
                                <CheckBox Name = 'InstallDNS' Grid.Row = '0' Grid.Column = '1' Margin = '5' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Row = '1' TextAlignment = 'Right' Margin = '5' IsEnabled = 'True' >Create DNS Delegation:</TextBlock>
                                <CheckBox Name = 'CreateDNSDelegation' Grid.Row = '1' Grid.Column = '1' Margin = '5' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Row = '2' TextAlignment = 'Right' Margin = '5' IsEnabled = 'True' >No Global Catalog:</TextBlock>
                                <CheckBox Name = 'NoGlobalCatalog' Grid.Row = '2' Grid.Column = '1' Margin = '5' IsEnabled = 'True' IsChecked = 'False' />
                                <TextBlock Grid.Row = '3' TextAlignment = 'Right' Margin = '5' IsEnabled = 'True' >Critical Replication Only:</TextBlock>
                                <CheckBox Name = 'CriticalReplicationOnly' Grid.Row = '3' Grid.Column = '1' Margin = '5' IsEnabled = 'True' IsChecked = 'False' />
                            </Grid>
                        </GroupBox>
                        <GroupBox Grid.Row = '1' Grid.Column = '1' Header = 'Initialization' Margin = '5' >
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*' />
                                    <RowDefinition Height = '*' />
                                </Grid.RowDefinitions>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width = '*' />
                                    <ColumnDefinition Width = '*' />
                                </Grid.ColumnDefinitions>
                                <GroupBox Grid.Row = '0' Grid.Column = '0' Header = 'SafeModeAdministratorPassword' >
                                    <PasswordBox Name = 'SafeModeAdministratorPassword' Height = '20' Margin = '5' PasswordChar = '*' />
                                </GroupBox>
                                <GroupBox Grid.Row = '0' Grid.Column = '1' Header = 'Confirm' >
                                    <PasswordBox Name = 'Confirm' Height = '20' Margin = '5' PasswordChar = '*' />
                                </GroupBox>
                                <Button Name = 'Start' Grid.Row = '1' Grid.Column = '0' Content = 'Start' Margin = '5' Width = '100' Height = '20' />
                                <Button Name = 'Cancel' Grid.Row = '1' Grid.Column = '1' Content = 'Cancel' Margin = '5' Width = '100' Height = '20' />
                            </Grid>
                        </GroupBox>
                    </Grid>
                </Grid>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
"@
        DCFound = @"
"@
        DSCRoot = @"
        <Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | Hybrid @ DSC Root Installation'
                                                      Width = '640'
                                                     Height = '450'
                                                    Topmost = 'True' 
                                                       Icon = ''
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
        <Grid>
                <Grid.Background>
                    <ImageBrush Stretch = 'UniformToFill' ImageSource = '' />
                </Grid.Background>
                <Grid.RowDefinitions>
                    <RowDefinition Height = '250' />
                    <RowDefinition Height = '*' />
                    <RowDefinition Height = '*' />
                    <RowDefinition Height = '40' />
                    <RowDefinition Height = '20' />
                </Grid.RowDefinitions>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width = '*' />
                    <ColumnDefinition Width = '2*' />
                    <ColumnDefinition Width = '2*' />
                    <ColumnDefinition Width = '*' />
                </Grid.ColumnDefinitions>
                <Image Grid.Row = '0' Grid.ColumnSpan = '4' HorizontalAlignment = 'Center' Width = '640' Height = '250' Source = '' />
                <TextBlock Grid.Row = '1' Grid.Column = '1' Grid.ColumnSpan = '2' HorizontalAlignment = 'Center' Padding = '5' Foreground = '#00FF00' FontWeight = 'Bold' VerticalAlignment = 'Center'>
                    Hybrid - Desired State Controller - Dependency Installation Path
                </TextBlock>
                <TextBox Grid.Row = '2' Grid.Column = '1' Grid.ColumnSpan = '2' Height = '22' TextWrapping = 'Wrap' Margin = '10' HorizontalContentAlignment = 'Center' Name = 'Install' >
                        <TextBox.Effect>
                    <DropShadowEffect/>
                </TextBox.Effect>
                </TextBox>
                <Button Grid.Row = '3' Grid.Column = '1' Name = 'Start' Content = 'Start' Margin = '10' />
            <Button Grid.Row = '3' Grid.Column = '2' Name = 'Cancel' Content = 'Cancel' Margin = '10' />
            </Grid>
        </Window>
"@
        ProvisionDSC = @"
<Window
                                                      xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                                    xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                                      Title = 'Secure Digits Plus LLC | FightingEntropy @ New Deployment Share'
                                                      Width = '640'
                                                     Height = '960'
                                                    Topmost = 'True' 
                                                       Icon = '/icon.ico'
                                                 ResizeMode = 'NoResize'
                                        HorizontalAlignment = 'Center'
                                      WindowStartupLocation = 'CenterScreen' >
	<Window.Resources>
		<Style TargetType    = 'Label' x:Key = 'HeadLabel' >
			<Setter Property = 'TextBlock.TextAlignment' Value = 'Center' />
			<Setter Property = 'FontWeight' Value = 'Heavy' />
			<Setter Property = 'FontSize' Value = '18' />
			<Setter Property = 'Margin' Value = '5' />
			<Setter Property = 'Foreground' Value = 'White' />
			<Setter Property = 'Template' >
				<Setter.Value>
					<ControlTemplate TargetType = 'Label' >
						<Border CornerRadius = '2,2,2,2' 
                                Background = '#FF0080FF' 
                                BorderBrush = 'Black'
                                BorderThickness = '3'>
							<ContentPresenter x:Name = 'contentPresenter'
                                              ContentTemplate = '{ TemplateBinding ContentTemplate }'
                                              Margin = '5' />
						</Border>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style TargetType = 'RadioButton' x:Key = 'RadButton' >
			<Setter Property = 'HorizontalAlignment' Value = 'Center' />
			<Setter Property = 'VerticalAlignment' Value = 'Center' />
			<Setter Property = 'Foreground' Value = 'Black' />
		</Style>
		<Style TargetType = 'TextBox' x:Key = 'TextBro'>
			<Setter Property = 'VerticalContentAlignment' Value = 'Center' />
			<Setter Property = 'Margin' Value = '2' />
			<Setter Property = 'TextWrapping' Value = 'Wrap' />
			<Setter Property = 'Height' Value = '24' />
		</Style>
	</Window.Resources>

	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height = '250' />
			<RowDefinition Height = '*' />
			<RowDefinition Height = '40' />
		</Grid.RowDefinitions>
		<Grid.Background>
			<ImageBrush Stretch = 'UniformToFill'
                        ImageSource = '/background.jpg' />
		</Grid.Background>
		<Image Grid.Row = '0'
               Source = '/banner.png'/>
		<TabControl Grid.Row = '1'
                    Background = '{x:Null}'
                    BorderBrush = '{x:Null}'
                    Foreground = '{x:Null}'
                    HorizontalAlignment = 'Center'>
			<TabItem Header = 'Stage Deployment Server'
                    BorderBrush = '{x:Null}'
                    Width = '280' >
				<TabItem.Effect>
					<DropShadowEffect/>
				</TabItem.Effect>
				<Grid>
					<Grid.RowDefinitions>
						<RowDefinition Height = '*' />
						<RowDefinition Height = '*' />
					</Grid.RowDefinitions>
					<GroupBox Grid.Row = '0'
                                Margin = '10'
                                Padding = '5'
                                Foreground = 'Black'
                                Background = 'White'>
						<Grid Grid.Row = '0'>
							<Grid.RowDefinitions>
								<RowDefinition Height = '50'/>
								<RowDefinition Height = '30'/>
								<RowDefinition Height = '*'/>
								<RowDefinition Height = '*'/>
								<RowDefinition Height = '*'/>
							</Grid.RowDefinitions>
							<Label Content = 'Deployment Share Settings'
                                        Style = '{ StaticResource HeadLabel }'
                                        Foreground = 'White'
                                        Grid.Row = '0'/>
							<Grid Grid.Row = '1'>
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*' />
									<ColumnDefinition Width = '*' />
								</Grid.ColumnDefinitions>
								<RadioButton Grid.Column = '0' Content = 'Standard @ MDT Share' Name = 'Legacy' Style = '{ StaticResource RadButton }' />
								<RadioButton Grid.Column = '1' Content = 'Enhanced @ PSD Share' Name = 'Remaster' Style = '{ StaticResource RadButton }' />
							</Grid>
							<GroupBox Grid.Row = '2' Header = 'Directory Path'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'Directory' />
							</GroupBox>
							<GroupBox Grid.Row = '3' Header = 'Samba Share'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'Samba' />
							</GroupBox>
							<Grid Grid.Row = '4'>
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*' />
									<ColumnDefinition Width = '2*' />
								</Grid.ColumnDefinitions>
								<GroupBox Grid.Column = '0' Header = 'PS Drive'>
									<TextBox Style = '{ StaticResource TextBro }' Name = 'DSDrive' />
								</GroupBox>
								<GroupBox Grid.Column = '1' Header = 'Description'>
									<TextBox Style = '{ StaticResource TextBro }' Name = 'Description' />
								</GroupBox>
							</Grid>
						</Grid>
					</GroupBox>
					<GroupBox Grid.Row = '1' 
                              Margin = '10'
                              Padding = '5' 
                              Foreground = 'Black'
                              Background = 'White'>
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height = '50' />
								<RowDefinition Height = '30' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
							</Grid.RowDefinitions>
							<Label Content = 'BITS / IIS Settings' Style = '{ StaticResource HeadLabel }' Foreground = 'White' Grid.Row = '0'/>
							<Grid Grid.Row = '1'>
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*' />
									<ColumnDefinition Width = '*' />
								</Grid.ColumnDefinitions>
								<RadioButton Grid.Column = '0' Name = 'IIS_Install' Content = 'Install BITS/IIS for MDT' Style = '{ StaticResource RadButton }'/>
								<RadioButton Grid.Column = '1' Name = 'IIS_Skip' Content = 'Do not install BITS/IIS for MDT' Style = '{ StaticResource RadButton }'/>
							</Grid>
							<GroupBox Grid.Row = '2' Header = 'Name'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'IIS_Name' />
							</GroupBox>
							<GroupBox Grid.Row = '3' Header = 'App Pool'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'IIS_AppPool' />
							</GroupBox>
							<GroupBox Grid.Row = '4' Header = 'Virtual Host'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'IIS_Proxy' />
							</GroupBox>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
			<TabItem Header = 'Image Info' HorizontalAlignment = 'Center' Width = '280' BorderBrush = '{x:Null}' >
				<TabItem.Effect>
					<DropShadowEffect/>
				</TabItem.Effect>
				<Grid>
					<Grid.RowDefinitions>
						<RowDefinition Height = '7*'/>
						<RowDefinition Height = '5*'/>
					</Grid.RowDefinitions>
					<GroupBox Grid.Row = '0'
                              Margin = '10'
                              Padding = '5' 
                              Foreground = 'Black'
                              Background = 'White'>
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height = '50' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
							</Grid.RowDefinitions>
							<Label Grid.Row = '0' Style = '{ StaticResource HeadLabel }' Content = 'Image Branding Settings' />
							<GroupBox Grid.Row = '1' Header = 'Organization'>
								<TextBox Style = '{ StaticResource TextBro }' Name = 'Company' />
							</GroupBox>
							<GroupBox Grid.Row = '2' Header = 'Support Website' >
								<TextBox Style = '{ StaticResource TextBro }' Name = 'WWW' />
							</GroupBox>
							<Grid Grid.Row = '3'>
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*' />
									<ColumnDefinition Width = '*' />
								</Grid.ColumnDefinitions>
								<GroupBox Grid.Column = '0' Header = 'Support Phone'>
									<TextBox Style = '{ StaticResource TextBro }' Name = 'Phone' />
								</GroupBox>
								<GroupBox Grid.Column = '1' Header = 'Support Hours'>
									<TextBox Style = '{ StaticResource TextBro }' Name = 'Hours' />
								</GroupBox>
							</Grid>
							<Grid Grid.Row = '4' Grid.RowSpan = '2' >
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*'/>
									<ColumnDefinition Width = '100'/>
								</Grid.ColumnDefinitions>
								<Grid.RowDefinitions>
									<RowDefinition Height = '*' />
									<RowDefinition Height = '*' />
								</Grid.RowDefinitions>
								<GroupBox Header = 'Logo [120x120]' Grid.Row = '0' Grid.Column = '0'>
									<TextBox Style = '{ StaticResource TextBro }' Width = '400' Grid.Column = '1' Name = 'Logo' />
								</GroupBox>
								<Button Margin = '5,15,5,5' Height = '20' Grid.Row = '0' Grid.Column = '1' Content = 'Logo' Name = 'LogoBrowse' />
								<GroupBox Header = 'Background' Grid.Row = '1' Grid.Column = '0'>
									<TextBox Style = '{ StaticResource TextBro }' Width = '400' Grid.Column = '1' Name = 'Background' />
								</GroupBox>
								<Button Margin = '5,15,5,5' Height = '20' Grid.Row = '1' Grid.Column = '1' Content = 'Background' Name = 'BackgroundBrowse' />
							</Grid>
						</Grid>
					</GroupBox>
					<GroupBox Grid.Row = '1'
                              Margin = '10'
                              Padding = '5'
                              Foreground = 'Black'
                              Background = 'White'>
						<Grid>
							<Grid.RowDefinitions>
								<RowDefinition Height = '50' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
								<RowDefinition Height = '*' />
							</Grid.RowDefinitions>
							<Label Grid.Row = '0' Style = '{ StaticResource HeadLabel }' Content = 'Domain / Network Credentials' />
							<GroupBox Grid.Row = '1' Header = 'Domain Name' >
								<TextBox Style = '{ StaticResource TextBro }' Name = 'Branch' />
							</GroupBox>
							<GroupBox Grid.Row = '2' Header = 'NetBIOS Domain' >
								<TextBox Style = '{ StaticResource TextBro }' Name = 'NetBIOS' />
							</GroupBox>
							<Grid Grid.Row = '3'>
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width = '*' />
									<ColumnDefinition Width = '*' />
								</Grid.ColumnDefinitions>
								<GroupBox Grid.Column = '0' Header = 'Target/Local Administrator Username'>
									<TextBox Style = '{ StaticResource TextBro }' Name = 'LMCred_User' />
								</GroupBox>
								<GroupBox Grid.Column = '1' Header = 'Target/Local Administrator Password'>
									<PasswordBox Margin = '5' Name = 'LMCred_Pass' PasswordChar = '*' />
								</GroupBox>
							</Grid>
						</Grid>
					</GroupBox>
				</Grid>
			</TabItem>
		</TabControl>
		<Grid Grid.Row = '2' >
			<Grid.ColumnDefinitions>
				<ColumnDefinition Width = '*' />
				<ColumnDefinition Width = '*' />
			</Grid.ColumnDefinitions>
			<Button Grid.Column = '0' Name = 'Start' Content = 'Start' Width = '100' Height = '24' />
			<Button Grid.Column = '1' Name = 'Cancel' Content = 'Cancel' Width = '100' Height = '24' />
		</Grid>
	</Grid>
</Window>
"@
        Service = @"
        <Window             xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                      xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                        Title = '[FightingEntropy] @ ViperBomb'
                       Height = '800'
                        Width = '800'
                      Topmost = 'True'
                  BorderBrush = 'Black'
                   ResizeMode = 'NoResize'
          HorizontalAlignment = 'Center'
        WindowStartupLocation = 'CenterScreen'>
    <Window.Resources>
        <Style TargetType    = "Label">
            <Setter Property = "HorizontalAlignment"
                                Value    = "Center"/>
            <Setter Property = "VerticalAlignment"
                                Value    = "Center"/>
            <Setter Property = "Padding"
                                Value    = "5"/>
        </Style>
        <Style      x:Key = 'SeparatorStyle1' 
                   TargetType = '{x:Type Separator}'>
            <Setter Property = 'SnapsToDevicePixels' 
                        Value    = 'True'/>
            <Setter Property = 'Margin' 
                        Value    = '0,0,0,0'/>
            <Setter Property = 'Template'>
                <Setter.Value>
                    <ControlTemplate TargetType     = '{x:Type Separator}'>
                        <Border Height              = '24' 
                                    SnapsToDevicePixels = 'True' 
                                    Background          = '#FF4D4D4D' 
                                    BorderBrush         = 'Azure' 
                                    BorderThickness     = '1,1,1,1' 
                                    CornerRadius        = '5,5,5,5'/>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType    = '{x:Type ToolTip}'>
            <Setter Property = 'Background' 
                        Value    = 'Black'/>
            <Setter Property="Foreground"
                        Value="LightGreen"/>
        </Style>
    </Window.Resources>
    <Window.Effect>
        <DropShadowEffect/>
    </Window.Effect>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height = '20'/>
            <RowDefinition Height = '*'/>
            <RowDefinition Height = '60'/>
        </Grid.RowDefinitions>
        <Menu            Grid.Row = '0'
                           IsMainMenu = 'True'>
            <MenuItem      Header = 'Configuration'>
                <MenuItem    Name = 'Profile_0' Header = '0 - Windows 10 Home / Default Max'/>
                <MenuItem    Name = 'Profile_1' Header = '1 - Windows 10 Home / Default Min'/>
                <MenuItem    Name = 'Profile_2' Header = '2 - Windows 10 Pro / Default Max'/>
                <MenuItem    Name = 'Profile_3' Header = '3 - Windows 10 Pro / Default Min'/>
                <MenuItem    Name = 'Profile_4' Header = '4 - Desktop / Default Max'/>
                <MenuItem    Name = 'Profile_5' Header = '5 - Desktop / Default Min'/>
                <MenuItem    Name = 'Profile_6' Header = '6 - Desktop / Default Max'/>
                <MenuItem    Name = 'Profile_7' Header = '7 - Desktop / Default Min'/>
                <MenuItem    Name = 'Profile_8' Header = '8 - Laptop / Default Max'/>
                <MenuItem    Name = 'Profile_9' Header = '9 - Laptop / Default Min'/>
            </MenuItem>
            <MenuItem     Header         = 'Info'>
                <MenuItem Name           = 'URL'
                            Header         = 'Resources'/>
                <MenuItem Name           = 'About'
                            Header         = 'About'/>
                <MenuItem Name           = 'Copyright'
                            Header         = 'Copyright'/>
                <MenuItem Name           = 'MadBomb'
                            Header         = 'MadBomb122'/>
                <MenuItem Name           = 'BlackViper'
                            Header         = 'BlackViper'/>
                <MenuItem Name           = 'Site'
                            Header         = 'Company Website'/>
                <MenuItem Name           = 'Help'
                            Header         = 'Help'/>
            </MenuItem>
        </Menu>
        <Grid Grid.Row                   = '1'>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width  = '*'/>
            </Grid.ColumnDefinitions>
            <TabControl BorderBrush      = 'Gainsboro' 
                            Grid.Row         = '1' 
                            Name             = 'TabControl'>
                <TabControl.Resources>
                    <Style TargetType    = 'TabItem'>
                        <Setter Property = 'Template'>
                            <Setter.Value>
                                <ControlTemplate TargetType                   = 'TabItem'>
                                    <Border Name                              = 'Border' 
                                                BorderThickness                   = '1,1,1,0' 
                                                BorderBrush                       = 'Gainsboro' 
                                                CornerRadius                      = '4,4,0,0' 
                                                Margin                            = '2,0'>
                                        <ContentPresenter x:Name              = 'ContentSite' 
                                                            VerticalAlignment   = 'Center' 
                                                            HorizontalAlignment = 'Center' 
                                                            ContentSource       = 'Header' 
                                                            Margin              = '10,2'/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property      = 'IsSelected' 
                                                    Value         = 'True'>
                                            <Setter TargetName = 'Border' 
                                                        Property   = 'Background' 
                                                        Value      = 'LightSkyBlue'/>
                                        </Trigger>
                                        <Trigger Property      = 'IsSelected' 
                                                    Value         = 'False'>
                                            <Setter TargetName = 'Border' 
                                                        Property   = 'Background' 
                                                        Value      = 'GhostWhite'/>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </TabControl.Resources>
                <TabItem Header = 'Service Dialog'>
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '60'/>
                            <RowDefinition Height = '32'/>
                            <RowDefinition Height =  '*'/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width = '0.45*'/>
                                <ColumnDefinition Width = '0.15*'/>
                                <ColumnDefinition Width = '0.25*'/>
                                <ColumnDefinition Width = '0.15*'/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column = "0" Header = "Operating System" Margin = "5">
                                <Label Name = "Caption"/>
                            </GroupBox>
                            <GroupBox Grid.Column = "1" Header = "Release ID" Margin = "5">
                                <Label Name = "ReleaseID"/>
                            </GroupBox>
                            <GroupBox Grid.Column = "2" Header = "Version" Margin = "5">
                                <Label Name = "Version"/>
                            </GroupBox>
                            <GroupBox Grid.Column = "3" Header = "Chassis" Margin = "5">
                                <Label Name = "Chassis"/>
                            </GroupBox>
                        </Grid>
                        <Grid Grid.Row            = '1'>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width = '0.66*'/>
                                <ColumnDefinition Width = '0.33*'/>
                                <ColumnDefinition Width = "1*"/>
                            </Grid.ColumnDefinitions>
                            <TextBox  Grid.Column = '0' Margin ='5' Name = 'Search' TextWrapping      = 'Wrap'></TextBox>
                            <ComboBox Grid.Column = '1' Margin ='5' Name = 'Select' VerticalAlignment = 'Center'>
                                <ComboBoxItem Content = 'Checked'/>
                                <ComboBoxItem Content = 'Display Name' IsSelected='True'/>
                                <ComboBoxItem Content = 'Name'/>
                                <ComboBoxItem Content = 'Current Setting'/>
                            </ComboBox>
                            <TextBlock Grid.Column = '2' 
                                                Margin         = '5' 
                                                TextAlignment  = 'Center'>Service State:
                                            <Run   Background  = '#66FF66' 
                                                Text           = 'Compliant'/> /
                                            <Run   Background     = '#FFFF66' 
                                                Text           = 'Unspecified'/> /
                                            <Run   Background     = '#FF6666' 
                                                Text           = 'Non Compliant'/>
                            </TextBlock>
                        </Grid>
                        <DataGrid Grid.Row                 = '2'
                                    Grid.Column                = '0'
                                    Name                       = 'DataGrid'
                                    FrozenColumnCount          = '2' 
                                    AutoGenerateColumns        = 'False' 
                                    AlternationCount           = '2' 
                                    HeadersVisibility          = 'Column' 
                                    CanUserResizeRows          = 'False' 
                                    CanUserAddRows             = 'False' 
                                    IsTabStop                  = 'True' 
                                    IsTextSearchEnabled        = 'True' 
                                    SelectionMode              = 'Extended'>
                            <DataGrid.RowStyle>
                                <Style TargetType          = '{x:Type DataGridRow}'>
                                    <Style.Triggers>
                                        <Trigger Property  = 'AlternationIndex'
                                                    Value      = '0'>
                                            <Setter Property = 'Background'
                                                        Value    = 'White'/>
                                        </Trigger>
                                        <Trigger Property    = 'AlternationIndex'
                                                    Value       = '1'>
                                            <Setter Property = 'Background'
                                                        Value    = '#FFD8D8D8'/>
                                        </Trigger>
                                        <Trigger Property    = 'IsMouseOver'
                                                    Value       = 'True'>
                                            <Setter Property = 'ToolTip'>
                                                <Setter.Value>
                                                    <TextBlock Text         = '{Binding Description}'
                                                                TextWrapping = 'Wrap'
                                                                Width        = '400'
                                                                Background   = '#FFFFFFBF'
                                                                Foreground   = 'Black'/>
                                                </Setter.Value>
                                            </Setter>
                                            <Setter Property                = 'ToolTipService.ShowDuration'
                                                        Value                   = '360000000'/>
                                        </Trigger>
                                        <MultiDataTrigger>
                                            <MultiDataTrigger.Conditions>
                                                <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'True'/>
                                                <Condition Binding          = '{Binding Matches}' 
                                                            Value            = 'False'/>
                                            </MultiDataTrigger.Conditions>
                                            <Setter Property                = 'Background' 
                                                        Value                   = '#F08080'/>
                                        </MultiDataTrigger>
                                        <MultiDataTrigger>
                                            <MultiDataTrigger.Conditions>
                                                <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'False'/>
                                                <Condition Binding          = '{Binding Matches}' 
                                                            Value            = 'False'/>
                                            </MultiDataTrigger.Conditions>
                                            <Setter Property                = 'Background' 
                                                        Value                   = '#FFFFFF64'/>
                                        </MultiDataTrigger>
                                        <MultiDataTrigger>
                                            <MultiDataTrigger.Conditions>
                                                <Condition Binding          = '{Binding Scope}'
                                                            Value            = 'True'/>
                                                <Condition Binding          = '{Binding Matches}'
                                                            Value            = 'True'/>
                                            </MultiDataTrigger.Conditions>
                                            <Setter Property                = 'Background'
                                                        Value                   = 'LightGreen'/>
                                        </MultiDataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </DataGrid.RowStyle>
                            <DataGrid.Columns>
                                <DataGridTextColumn Header                  = 'Index' 
                                                        Width                   = '50'
                                                        Binding                 = '{Binding Index}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'Name'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding Name}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'Scoped' 
                                                        Width                   = '75'
                                                        Binding                 = '{Binding Scope}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'Profile'
                                                        Width                   = '100'
                                                        Binding                 = '{Binding Slot}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'Status'
                                                        Width                   = '75'
                                                        Binding                 = '{Binding Status}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'StartType' 
                                                        Width                   = '75' 
                                                        Binding                 = '{Binding StartMode}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'DisplayName'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding DisplayName}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'PathName'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding PathName}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                                <DataGridTextColumn Header                  = 'Description'
                                                        Width                   = '150'
                                                        Binding                 = '{Binding Description}'
                                                        CanUserSort             = 'True'
                                                        IsReadOnly              = 'True'/>
                            </DataGrid.Columns>
                        </DataGrid>
                    </Grid>
                </TabItem>
                <TabItem                            Header                  = 'Preferences'>
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height = '1.25*'/>
                            <RowDefinition Height = '*'/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Row = '0'>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width = '*'/>
                                <ColumnDefinition Width = '*'/>
                                <ColumnDefinition Width = '*'/>
                            </Grid.ColumnDefinitions>
                            <Grid Grid.Column = '2'>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*'/>
                                    <RowDefinition Height = '*'/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row = '0' Header = 'Bypass / Checks [ Risky Options ]' Margin = '5'>
                                    <Grid>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*'/>
                                            <RowDefinition Height = '*'/>
                                            <RowDefinition Height = '*'/>
                                        </Grid.RowDefinitions>
                                        <CheckBox   Grid.Row = '1' Margin = '5' Name = 'ByBuild' Content = "Skip Build/Version Check" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        <ComboBox   Grid.Row = '0' VerticalAlignment = 'Center' Height = '24' Name = 'ByEdition'>
                                            <ComboBoxItem Content = 'Override Edition Check' IsSelected = 'True'/>
                                            <ComboBoxItem Content = 'Windows 10 Home'/>
                                            <ComboBoxItem Content = 'Windows 10 Pro'/>
                                        </ComboBox>
                                        <CheckBox   Grid.Row = '2' Margin = '5' Name = 'ByLaptop' Content = 'Enable Laptop Tweaks' HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Grid>
                                </GroupBox>
                                <GroupBox Grid.Row = '1' Header = 'Display' Margin = '5' >
                                    <Grid HorizontalAlignment="Center" VerticalAlignment="Center" >
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                        </Grid.RowDefinitions>
                                        <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DispActive'    Content = "Show Active Services"           />
                                        <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DispInactive'  Content = "Show Inactive Services"         />
                                        <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DispSkipped'   Content = "Show Skipped Services"          />
                                    </Grid>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Column = '0'>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*'/>
                                    <RowDefinition Height = '2*'/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row = '0' Header = 'Service Configuration' Margin = '5'>
                                    <ComboBox  Grid.Row = '1' Name = 'ServiceProfile' Height ='24'>
                                        <ComboBoxItem Content = 'Black Viper (Sparks v1.0)' IsSelected = 'True'/>
                                        <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsEnabled = 'False'/>
                                    </ComboBox>
                                </GroupBox>
                                <GroupBox Grid.Row = '1' Header = 'Miscellaneous' Margin = '5'>
                                    <Grid HorizontalAlignment="Center" VerticalAlignment="Center">
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                        </Grid.RowDefinitions>
                                        <CheckBox  Grid.Row = '0' Margin = '5' Name = 'MiscSimulate'     Content = "Simulate Changes [ Dry Run ]"   />
                                        <CheckBox  Grid.Row = '1' Margin = '5' Name = 'MiscXbox'         Content = "Skip All Xbox Services"         />
                                        <CheckBox  Grid.Row = '2' Margin = '5' Name = 'MiscChange'       Content = "Allow Change of Service State"  />
                                        <CheckBox  Grid.Row = '3' Margin = '5' Name = 'MiscStopDisabled' Content = "Stop Disabled Services"         />
                                    </Grid>
                                </GroupBox>
                            </Grid>
                            <Grid Grid.Column = '1'>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '*'/>
                                    <RowDefinition Height = '2*'/>
                                </Grid.RowDefinitions>
                                <GroupBox Grid.Row = '0' Header = 'User Interface' Margin = '5'>
                                    <ComboBox  Grid.Row = '1' Name = 'ScriptProfile' Height = '24' >
                                        <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsSelected =  'True'/>
                                        <ComboBoxItem Content = 'MadBomb (MadBomb122 v1.0)' IsEnabled  = 'False' />
                                    </ComboBox>
                                </GroupBox>
                                <GroupBox Grid.Row='1' Header = 'Development' Margin='5'>
                                    <Grid HorizontalAlignment="Center" VerticalAlignment="Center" >
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                            <RowDefinition Height = '30'/>
                                        </Grid.RowDefinitions>
                                        <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DevErrors'  Content = "Diagnostic Output [ On Error ]" />
                                        <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DevLog'     Content = "Enable Development Logging"     />
                                        <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DevConsole' Content = "Enable Console"                 />
                                        <CheckBox  Grid.Row = '3' Margin = '5' Name = 'DevReport'  Content = "Enable Diagnostic"              />
                                    </Grid>
                                </GroupBox>
                            </Grid>
                        </Grid>
                        <Grid Grid.Row = '1'>
                            <Grid.RowDefinitions>
                                <RowDefinition Height = '*'/>
                                <RowDefinition Height = '*'/>
                            </Grid.RowDefinitions>
                            <GroupBox Grid.Row = '0' Header = 'Logging: Create logs for all changes made via this utility' Margin = '5'>
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '75'/>
                                        <ColumnDefinition Width = '*'/>
                                        <ColumnDefinition Width = '6*'/>
                                    </Grid.ColumnDefinitions>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*' />
                                        <RowDefinition Height = '*' />
                                    </Grid.RowDefinitions>
                                    <CheckBox Grid.Row = '0' Grid.Column = '0' Margin = '5' Name = 'LogSvcSwitch' Content   = 'Services' FlowDirection = 'RightToLeft' HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Button   Grid.Row = '0' Grid.Column = '1' Margin = '5' Name = 'LogSvcBrowse' Content   = 'Browse'  />
                                    <TextBox  Grid.Row = '0' Grid.Column = '2' Margin = '5' Name = 'LogSvcFile'   IsEnabled = 'False' HorizontalAlignment="Stretch" VerticalAlignment="Center"   />
                                    <CheckBox Grid.Row = '1' Grid.Column = '0' Margin = '5' Name = 'LogScrSwitch'  Content   = 'Script'   FlowDirection = 'RightToLeft' VerticalAlignment="Center" HorizontalAlignment="Center" />
                                    <Button   Grid.Row = '1' Grid.Column = '1' Margin = '5' Name = 'LogScrBrowse'  Content   = 'Browse'  />
                                    <TextBox  Grid.Row = '1' Grid.Column = '2' Margin = '5' Name = 'LogScrFile'    IsEnabled = 'False' HorizontalAlignment="Stretch" VerticalAlignment="Center"   />
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Row = '1' Header = 'Backup: Save your current Service Configuration' Margin = '5'>
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '75'/>
                                        <ColumnDefinition Width = '*'/>
                                        <ColumnDefinition Width = '6*'/>
                                    </Grid.ColumnDefinitions>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*' />
                                        <RowDefinition Height = '*' />
                                    </Grid.RowDefinitions>
                                    <CheckBox Grid.Row = '0' Grid.Column = '0' Margin = '5' Name = 'RegSwitch' Content   = 'reg.*'   FlowDirection = 'RightToLeft' HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Button   Grid.Row = '0' Grid.Column = '1' Margin = '5' Name = 'RegBrowse' Content   = 'Browse'  />
                                    <TextBox  Grid.Row = '0' Grid.Column = '2' Margin = '5' Name = 'RegFile'   IsEnabled = 'False' HorizontalAlignment="Stretch" VerticalAlignment="Center"   />
                                    <CheckBox Grid.Row = '1' Grid.Column = '0' Margin = '5' Name = 'CsvSwitch' Content   = 'csv.*'  FlowDirection = 'RightToLeft' HorizontalAlignment="Center" VerticalAlignment="Center" />
                                    <Button   Grid.Row = '1' Grid.Column = '1' Margin = '5' Name = 'CsvBrowse' Content   = 'Browse'  />
                                    <TextBox  Grid.Row = '1' Grid.Column = '2' Margin = '5' Name = 'CsvFile'   IsEnabled = 'False' VerticalAlignment="Center"   />
                                </Grid>
                            </GroupBox>
                        </Grid>
                    </Grid>
                </TabItem>
                <TabItem Header = 'Console'>
                    <Grid Background = '#FFE5E5E5'>
                        <ScrollViewer VerticalScrollBarVisibility = 'Visible'>
                            <TextBlock Name = 'ConsoleOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>
                        </ScrollViewer>
                    </Grid>
                </TabItem>
                <TabItem Header = 'Diagnostics'>
                    <Grid Background = '#FFE5E5E5'>
                        <ScrollViewer VerticalScrollBarVisibility = 'Visible'>
                            <TextBlock Name = 'DiagnosticOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>
                        </ScrollViewer>
                    </Grid>
                </TabItem>
            </TabControl>
        </Grid>
        <Grid Grid.Row = '2'>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width = '2*'/>
                <ColumnDefinition Width = '*'/>
                <ColumnDefinition Width = '*'/>
                <ColumnDefinition Width = '2*'/>
            </Grid.ColumnDefinitions>
            <GroupBox Grid.Column = "0" Header = "Service Configuration" Margin = "5">
                <Label Name = "ServiceLabel"/>
            </GroupBox>
            <Button Grid.Column = '1' Name =  'Start' Content = 'Start'  FontWeight = 'Bold' Margin = '10'/>
            <Button Grid.Column = '2' Name = 'Cancel' Content = 'Cancel' FontWeight = 'Bold' Margin = '10'/>
            <GroupBox Grid.Column = "3" Header = "Module Version" Margin = "5">
                <Label Name = "ScriptLabel" />
            </GroupBox>
        </Grid>
    </Grid>
</Window>
"@
}

    _XamlObject([String]$Type)
    {
        If ( $Type -notin ("Certificate;Login;New Account;HybridDSCPromo;DCFound;DSCRoot;ProvisionDSC;Service" -Split ";") )
        {
            Throw "Invalid Type"
        }

        $This.Xaml = $This.Hash.$Type
    }
}
