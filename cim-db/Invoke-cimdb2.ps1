Function Invoke-cimdb2
{
    Add-Type -AssemblyName PresentationFramework

    Class XamlWindow 
    {
        Hidden [Object]        $XAML
        Hidden [Object]         $XML
        [String[]]            $Names
        [Object]               $Node
        [Object]                 $IO
        [String[]] FindNames()
        {
            Return @( [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % { 

                ($_ -Replace "(\s+)(Name|=|'|`"|\s)","").Split('"')[1] 

            } | Select-Object -Unique ) 
        }
        XamlWindow([String]$XAML)
        {           
            If ( !$Xaml )
            {
                Throw "Invalid XAML Input"
            }

            [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

            $This.Xaml               = $Xaml
            $This.XML                = [XML]$Xaml
            $This.Names              = $This.FindNames()
            $This.Node               = [System.XML.XmlNodeReader]::New($This.XML)
            $This.IO                 = [System.Windows.Markup.XAMLReader]::Load($This.Node)

            ForEach ( $I in 0..( $This.Names.Count - 1 ) )
            {
                $Name                = $This.Names[$I]
                $This.IO             | Add-Member -MemberType NoteProperty -Name $Name -Value $This.IO.FindName($Name) -Force 
            }
        }
        Invoke()
        {
            $This.IO.Dispatcher.InvokeAsync({ $This.IO.ShowDialog() }).Wait()
        }
    }

    # (Get-Content $home\desktop\cim-db.xaml).Replace("'",'"') | % { "        '$_'," } | Set-Clipboard
    Class cimdbGUI
    {
        Static [String] $Tab = @(        '<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"     xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"     Title="[FightingEntropy]://(Company Information Management Database)"      Height="680"      Width="800"     Topmost="True"      ResizeMode="NoResize"      Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\icon.ico"      HorizontalAlignment="Center"      WindowStartupLocation="CenterScreen"     FontFamily="Consolas"     Background="LightYellow">',
        '    <Window.Resources>',
        '        <Style TargetType="ToolTip">',
        '            <Setter Property="Background" Value="#000000"/>',
        '            <Setter Property="Foreground" Value="#66D066"/>',
        '        </Style>',
        '        <Style TargetType="TabItem">',
        '            <Setter Property="FontSize" Value="15"/>',
        '            <Setter Property="FontWeight" Value="Heavy"/>',
        '            <Setter Property="Template">',
        '                <Setter.Value>',
        '                    <ControlTemplate TargetType="TabItem">',
        '                        <Border Name="Border" BorderThickness="2" BorderBrush="Black" CornerRadius="2" Margin="2">',
        '                            <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Right" ContentSource="Header" Margin="5"/>',
        '                        </Border>',
        '                        <ControlTemplate.Triggers>',
        '                            <Trigger Property="IsSelected" Value="True">',
        '                                <Setter TargetName="Border" Property="Background" Value="#4444FF"/>',
        '                                <Setter Property="Foreground" Value="#FFFFFF"/>',
        '                            </Trigger>',
        '                            <Trigger Property="IsSelected" Value="False">',
        '                                <Setter TargetName="Border" Property="Background" Value="#DFFFBA"/>',
        '                                <Setter Property="Foreground" Value="#000000"/>',
        '                            </Trigger>',
        '                        </ControlTemplate.Triggers>',
        '                    </ControlTemplate>',
        '                </Setter.Value>',
        '            </Setter>',
        '        </Style>',
        '        <Style TargetType="Button">',
        '            <Setter Property="Margin" Value="5"/>',
        '            <Setter Property="Padding" Value="5"/>',
        '            <Setter Property="FontSize" Value="15"/>',
        '            <Setter Property="FontWeight" Value="Heavy"/>',
        '            <Setter Property="Foreground" Value="Black"/>',
        '            <Setter Property="Background" Value="#DFFFBA"/>',
        '            <Setter Property="BorderThickness" Value="2"/>',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Style.Resources>',
        '                <Style TargetType="Border">',
        '                    <Setter Property="CornerRadius" Value="2"/>',
        '                </Style>',
        '            </Style.Resources>',
        '        </Style>',
        '        <Style TargetType="TextBox">',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="4"/>',
        '            <Setter Property="FontSize" Value="12"/>',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Setter Property="BorderThickness" Value="2"/>',
        '            <Setter Property="Foreground" Value="#000000"/>',
        '            <Style.Resources>',
        '                <Style TargetType="Border">',
        '                    <Setter Property="CornerRadius" Value="2"/>',
        '                </Style>',
        '            </Style.Resources>',
        '        </Style>',
        '        <Style TargetType="ComboBox">',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '            <Setter Property="FontSize" Value="12"/>',
        '            <Setter Property="FontWeight" Value="Normal"/>',
        '        </Style>',
        '        <Style TargetType="DataGrid">',
        '            <Setter Property="Margin" Value="5"/>',
        '            <Setter Property="AutoGenerateColumns" Value="False"/>',
        '            <Setter Property="AlternationCount" Value="2"/>',
        '            <Setter Property="HeadersVisibility" Value="Column"/>',
        '            <Setter Property="CanUserResizeRows" Value="False"/>',
        '            <Setter Property="CanUserAddRows" Value="False"/>',
        '            <Setter Property="IsReadOnly" Value="True"/>',
        '            <Setter Property="IsTabStop" Value="True"/>',
        '            <Setter Property="IsTextSearchEnabled" Value="True"/>',
        '            <Setter Property="SelectionMode" Value="Extended"/>',
        '            <Setter Property="ScrollViewer.CanContentScroll" Value="True"/>',
        '            <Setter Property="ScrollViewer.VerticalScrollBarVisibility" Value="Auto"/>',
        '            <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Auto"/>',
        '        </Style>',
        '        <Style TargetType="DataGridRow">',
        '            <Style.Triggers>',
        '                <Trigger Property="AlternationIndex" Value="0">',
        '                    <Setter Property="Background" Value="White"/>',
        '                </Trigger>',
        '                <Trigger Property="AlternationIndex" Value="1">',
        '                    <Setter Property="Background" Value="#FFD6FFFB"/>',
        '                </Trigger>',
        '                <Trigger Property="IsMouseOver" Value="True">',
        '                    <Setter Property="ToolTip">',
        '                        <Setter.Value>',
        '                            <TextBlock TextWrapping="Wrap" Width="400" Background="#000000" Foreground="#00FF00"/>',
        '                        </Setter.Value>',
        '                    </Setter>',
        '                    <Setter Property="ToolTipService.ShowDuration" Value="360000000"/>',
        '                </Trigger>',
        '            </Style.Triggers>',
        '        </Style>',
        '        <Style TargetType="DataGridColumnHeader">',
        '            <Setter Property="FontSize"   Value="12"/>',
        '            <Setter Property="FontWeight" Value="Normal"/>',
        '        </Style>',
        '        <Style TargetType="TabControl">',
        '            <Setter Property="TabStripPlacement" Value="Top"/>',
        '            <Setter Property="HorizontalContentAlignment" Value="Center"/>',
        '            <Setter Property="Background" Value="LightYellow"/>',
        '        </Style>',
        '        <Style TargetType="GroupBox">',
        '            <Setter Property="Foreground" Value="Black"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '            <Setter Property="FontSize" Value="12"/>',
        '            <Setter Property="FontWeight" Value="Normal"/>',
        '        </Style>',
        '    </Window.Resources>',
        '    <Grid>',
        '        <Grid.ColumnDefinitions>',
        '            <ColumnDefinition Width="120"/>',
        '            <ColumnDefinition Width="*"/>',
        '        </Grid.ColumnDefinitions>',
        '        <Grid Grid.Column="0">',
        '            <Grid.RowDefinitions>',
        '                <RowDefinition Height="120"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '                <RowDefinition Height="40"/>',
        '            </Grid.RowDefinitions>',
        '            <Button Grid.Row="0" Name="UID_Tab">',
        '                <Image Source="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\sdplogo.png"/>',
        '            </Button>',
        '            <Button Grid.Row="1" Name="Client_Tab" HorizontalContentAlignment="Right" Content="Client"/>',
        '            <Button Grid.Row="2" Name="Service_Tab" HorizontalContentAlignment="Right" Content="Service"/>',
        '            <Button Grid.Row="3" Name="Device_Tab" HorizontalContentAlignment="Right" Content="Device"/>',
        '            <Button Grid.Row="4" Name="Issue_Tab" HorizontalContentAlignment="Right" Content="Issue"/>',
        '            <Button Grid.Row="5" Name="Inventory_Tab" HorizontalContentAlignment="Right" Content="Inventory"/>',
        '            <Button Grid.Row="6" Name="Purchase_Tab" HorizontalContentAlignment="Right" Content="Purchase"/>',
        '            <Button Grid.Row="7" Name="Expense_Tab" HorizontalContentAlignment="Right" Content="Expense"/>',
        '            <Button Grid.Row="8" Name="Account_Tab" HorizontalContentAlignment="Right" Content="Account"/>',
        '            <Button Grid.Row="9" Name="Invoice_Tab" HorizontalContentAlignment="Right" Content="Invoice"/>',
        '        </Grid>',
        '        <Grid Grid.Column="1">',
        '            <Grid.RowDefinitions>',
        '                <RowDefinition Height="*"/>',
        '                <RowDefinition Height="40"/>',
        '            </Grid.RowDefinitions>',
        '            <Grid Grid.Row="0" Name="UID_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_UID" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_UID_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_UID_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_UID_Result" ItemsSource="{Binding UID}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="UID"    Binding="{Binding UID}"    Width="200"/>',
        '                            <DataGridTextColumn Header="Index"  Binding="{Binding Index}"  Width="50"/>',
        '                            <DataGridTextColumn Header="Slot"   Binding="{Binding Slot}"   Width="50"/>',
        '                            <DataGridTextColumn Header="Date"   Binding="{Binding Date}"   Width="100"/>',
        '                            <DataGridTextColumn Header="Time"   Binding="{Binding Time}"   Width="100"/>',
        '                            <DataGridTextColumn Header="Record" Binding="{Binding Record}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_UID" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="200"/>',
        '                            <ColumnDefinition Width="120"/>',
        '                            <ColumnDefinition Width="60"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[UID]">',
        '                            <TextBox Name="Mod_UID_UID_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Index]">',
        '                            <TextBox Name="Mod_UID_Index_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[Slot]">',
        '                            <TextBox Name="Mod_UID_Slot_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="3" Header="[Type]">',
        '                            <TextBox Name="Mod_UID_Type_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Date]">',
        '                            <TextBox Name="Mod_UID_Date_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Time]">',
        '                            <TextBox Name="Mod_UID_Time_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="2" Margin="5" Name="Mod_UID_Record_List">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>',
        '                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="2*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Client_Grid" Visibility="Visible">',
        '                <Grid Name="Get_Client" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Client_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Client_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Client_Result" ItemsSource="{Binding Client}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                            <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"  Width="*"/>',
        '                            <DataGridTextColumn Header="First" Binding="{Binding Record.First}" Width="*"/>',
        '                            <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"    Width="0.25*"/>',
        '                            <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"   Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Client" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="2*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                            <ColumnDefinition Width="0.5*"/>',
        '                            <ColumnDefinition Width="120"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Last]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_Last"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[First]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_First"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[MI]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_MI"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="3" Header="[Gender]" IsEnabled="False">',
        '                            <ComboBox Name="Mod_Client_Gender" SelectedIndex="2">',
        '                                <ComboBoxItem Content="Male"/>',
        '                                <ComboBoxItem Content="Female"/>',
        '                                <ComboBoxItem Content="-"/>',
        '                            </ComboBox>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="3*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Address]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_Address"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[DOB(MM/DD/YYYY)]" IsEnabled="False">',
        '                            <Grid>',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="0.6*"/>',
        '                                    <ColumnDefinition Width="0.6*"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <TextBox Grid.Column="0" Name="Mod_Client_Month"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Client_Day"/>',
        '                                <TextBox Grid.Column="2" Name="Mod_Client_Year"/>',
        '                            </Grid>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="2">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="3*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="1.5*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[City]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_City"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Region]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_Region"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[Country]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_Country"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="3" Header="[Postal]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Client_Postal"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <GroupBox Header="[Phone Number(s)]" Grid.Row="3">',
        '                        <Grid>',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="40"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="40"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <TextBox Grid.Column="0" Name="Mod_Client_Phone_Text" IsEnabled="False"/>',
        '                            <Button Grid.Column="1" Margin="5" Content="+" Name="Mod_Client_Phone_Add" IsEnabled="False"/>',
        '                            <ComboBox Grid.Column="2" Name="Mod_Client_Phone_List"/>',
        '                            <Button Grid.Column="3" Margin="5" Content="-" Name="Mod_Client_Phone_Remove" IsEnabled="False"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <GroupBox Header="[Email Address(es)]" Grid.Row="4">',
        '                        <Grid>',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="40"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="40"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <TextBox Grid.Column="0" Name="Mod_Client_Email_Text" IsEnabled="False"/>',
        '                            <Button Grid.Column="1" Margin="5" Content="+" Name="Mod_Client_Email_Add" IsEnabled="False"/>',
        '                            <ComboBox Grid.Column="2" Name="Mod_Client_Email_List"/>',
        '                            <Button Grid.Column="3" Margin="5" Content="-" Name="Mod_Client_Email_Remove" IsEnabled="False"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <Grid Grid.Row="5">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="*"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Grid Grid.Row="0">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="160"/>',
        '                                <ColumnDefinition Width="160"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Button Grid.Column="0" Content="Device(s)" Name="Mod_Client_Device_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="1" Content="Invoice(es)" Name="Mod_Client_Invoice_Tab" IsEnabled="False"/>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Client_Device_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Client_Device_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Client_Device_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Client_Device_Result" ItemsSource="{Binding Device}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="*"/>',
        '                                    <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="*"/>',
        '                                    <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Client_Device_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Client_Device_List" IsEnabled="False"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Client_Device_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Client_Invoice_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Client_Invoice_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Client_Invoice_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Margin="5" Name="Mod_Client_Invoice_Result" ItemsSource="{Binding Invoice}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Date" Binding="{Binding Record.Date}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Phone"  Binding="{Binding Record.Phone}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Email" Binding="{Binding Record.Email}" Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Client_Invoice_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Client_Invoice_List" IsEnabled="False"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Client_Invoice_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </Grid>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Service_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Service" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Service_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Service_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Service_Result" ItemsSource="{Binding Service}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name"        Binding="{Binding Record.Name}" Width="*"/>',
        '                            <DataGridTextColumn Header="Description" Binding="{Binding Record.Description}" Width="*"/>',
        '                            <DataGridTextColumn Header="Cost"        Binding="{Binding Record.Cost}" Width="0.5*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Service" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Row="0" Header="[Name]">',
        '                        <TextBox Name="Mod_Service_Name_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="1" Header="[Description]">',
        '                        <TextBox Name="Mod_Service_Description_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="2" Header="[Cost]">',
        '                        <TextBox Name="Mod_Service_Cost_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Device_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Device" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Device_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Device_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Device_Result" ItemsSource="{Binding Device}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="*"/>',
        '                            <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="*"/>',
        '                            <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="*"/>',
        '                            <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="*"/>',
        '                            <DataGridTextColumn Header="Title"         Binding="{Binding Record.Title}"         Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Device" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="300"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="1.5*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Chassis]">',
        '                            <ComboBox Name="Mod_Device_Chassis_List" SelectedIndex="8" IsEnabled="False">',
        '                                <ComboBoxItem Content="Desktop"/>',
        '                                <ComboBoxItem Content="Laptop"/>',
        '                                <ComboBoxItem Content="Smartphone"/>',
        '                                <ComboBoxItem Content="Tablet"/>',
        '                                <ComboBoxItem Content="Console"/>',
        '                                <ComboBoxItem Content="Server"/>',
        '                                <ComboBoxItem Content="Network"/>',
        '                                <ComboBoxItem Content="Other"/>',
        '                                <ComboBoxItem Content="-"/>',
        '                            </ComboBox>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Vendor]">',
        '                            <TextBox Name="Mod_Device_Vendor_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[Model]">',
        '                            <TextBox Name="Mod_Device_Model_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="3" Header="[Specification]">',
        '                            <TextBox Name="Mod_Device_Specification_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Serial]">',
        '                            <TextBox Name="Mod_Device_Serial_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Display Name]">',
        '                            <TextBox Name="Mod_Device_DisplayName_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="2">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="*"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Grid Grid.Row="0">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Button Grid.Column="0" Content="Client"   Name="Mod_Device_Client_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="1" Content="Issue"    Name="Mod_Device_Issue_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="2" Content="Purchase" Name="Mod_Device_Purchase_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="3" Content="Invoice"  Name="Mod_Device_Invoice_Tab" IsEnabled="False"/>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Device_Client_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Row="0" Grid.Column="0" Name="Mod_Device_Client_Property"/>',
        '                                <TextBox Grid.Row="0" Grid.Column="1" Name="Mod_Device_Client_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Grid.Column="0" Name="Mod_Device_Client_Result" ItemsSource="{Binding Client}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.DisplayName}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"         Width="*"/>',
        '                                    <DataGridTextColumn Header="First" Binding="{Binding Record.First}" Width="*"/>',
        '                                    <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}" Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Device_Client_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Device_Client_List">',
        '                                    <ComboBox.ItemTemplate>',
        '                                        <DataTemplate>',
        '                                            <TextBlock Text="{Binding Record.DisplayName}"/>',
        '                                        </DataTemplate>',
        '                                    </ComboBox.ItemTemplate>',
        '                                </ComboBox>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Device_Client_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Device_Issue_Grid" Visibility="Visible">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Row="0" Grid.Column="0" Name="Mod_Device_Issue_Property"/>',
        '                                <TextBox Grid.Row="0" Grid.Column="1" Name="Mod_Device_Issue_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Device_Issue_Result" ItemsSource="{Binding Issue}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Vendor" Binding="{Binding Record.Vendor}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"  Binding="{Binding Record.Model}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Spec."  Binding="{Binding Record.Specification}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Serial" Binding="{Binding Record.Serial}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="Title"  Binding="{Binding Record.Title}"   Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Device_Issue_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Device_Issue_List">',
        '                                    <ComboBox.ItemTemplate>',
        '                                        <DataTemplate>',
        '                                            <TextBlock Text="{Binding Record.DisplayName}"/>',
        '                                        </DataTemplate>',
        '                                    </ComboBox.ItemTemplate>',
        '                                </ComboBox>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Device_Issue_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Device_Purchase_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Row="0" Grid.Column="0" Name="Mod_Device_Purchase_Property"/>',
        '                                <TextBox Grid.Row="0" Grid.Column="1" Name="Mod_Device_Purchase_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Device_Purchase_Result" ItemsSource="{Binding Purchase}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Name"   Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Vendor" Binding="{Binding Record.Vendor}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Serial" Binding="{Binding Record.Serial}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"  Binding="{Binding Record.Model}"   Width="*"/>',
        '                                    <DataGridTextColumn Header="Device" Binding="{Binding Record.Device}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"  Binding="{Binding Record.DOB}"   Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Device_Purchase_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Device_Purchase_List">',
        '                                    <ComboBox.ItemTemplate>',
        '                                        <DataTemplate>',
        '                                            <TextBlock Text="{Binding Record.DisplayName}"/>',
        '                                        </DataTemplate>',
        '                                    </ComboBox.ItemTemplate>',
        '                                </ComboBox>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Device_Purchase_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Device_Invoice_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Row="0" Grid.Column="0" Name="Mod_Device_Invoice_Property"/>',
        '                                <TextBox Grid.Row="0" Grid.Column="1" Name="Mod_Device_Invoice_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Device_Invoice_Result" ItemsSource="{Binding Invoice}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="UID"   Binding="{Binding Record.UID}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Date"  Binding="{Binding Record.Date}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Phone" Binding="{Binding Record.Phone}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Email"  Binding="{Binding Record.Email}"  Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Device_Invoice_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Device_Invoice_List">',
        '                                    <ComboBox.ItemTemplate>',
        '                                        <DataTemplate>',
        '                                            <TextBlock Text="{Binding Record.DisplayName}"/>',
        '                                        </DataTemplate>',
        '                                    </ComboBox.ItemTemplate>',
        '                                </ComboBox>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Device_Invoice_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="3" Name="Mod_Device_Record_List">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="100"/>',
        '                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Issue_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Issue" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Issue_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Issue_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Issue_Result" ItemsSource="{Binding Issue}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Client"   Binding="{Binding Record.Client}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Device"   Binding="{Binding Record.Device}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Status"   Binding="{Binding Record.Status}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Purchase" Binding="{Binding Record.Purchase}" Width="*"/>',
        '                            <DataGridTextColumn Header="Service"  Binding="{Binding Record.Service}"  Width="*"/>',
        '                            <DataGridTextColumn Header="Invoice"  Binding="{Binding Record.Invoice}"  Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Issue" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="*"/>',
        '                        <RowDefinition Height="180"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Status]" IsEnabled="False">',
        '                            <ComboBox Name="Mod_Issue_Status_List">',
        '                                <ComboBoxItem Content="New"/>',
        '                                <ComboBoxItem Content="Diagnosed"/>',
        '                                <ComboBoxItem Content="Commit"/>',
        '                                <ComboBoxItem Content="Complete"/>',
        '                            </ComboBox>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Description]" IsEnabled="False">',
        '                            <TextBox Name="Mod_Issue_Description_Text"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="*"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Grid Grid.Row="0">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Button Grid.Column="0" Content="Client" Name="Mod_Issue_Client_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="1" Content="Device" Name="Mod_Issue_Device_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="2" Content="Purchase" Name="Mod_Issue_Purchase_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="3" Content="Service" Name="Mod_Issue_Service_Tab" IsEnabled="False"/>',
        '                            <Button Grid.Column="4" Content="Invoice" Name="Mod_Issue_Invoice_Tab" IsEnabled="False"/>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Issue_Client_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="50"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0" Margin="5">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Issue_Client_Property"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Issue_Client_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Issue_Client_Result" ItemsSource="{Binding Client}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="First" Binding="{Binding Record.First}" Width="*"/>',
        '                                    <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"   Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Issue_Client_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Issue_Client_List"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Issue_Client_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Issue_Device_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="50"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="50"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0" Margin="5">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Issue_Device_Property"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Issue_Device_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Issue_Device_Result" ItemsSource="{Binding Device}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Vendor" Binding="{Binding Record.Vendor}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"  Binding="{Binding Record.Model}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Spec."  Binding="{Binding Record.Specification}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Serial" Binding="{Binding Record.Serial}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="Title"  Binding="{Binding Record.Title}"   Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Issue_Device_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Issue_Device_List"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Issue_Device_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Issue_Purchase_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="50"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="50"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0" Margin="5">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Issue_Purchase_Property"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Issue_Purchase_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Issue_Purchase_Result" ItemsSource="{Binding Purchase}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Distributor"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Vendor" Binding="{Binding Record.First}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Serial"    Binding="{Binding Record.MI}"    Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"   Binding="{Binding Record.DOB}"   Width="*"/>',
        '                                    <DataGridTextColumn Header="Device" Binding="{Binding Record.IsDevice}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Model"   Binding="{Binding Record.DOB}"   Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Issue_Purchase_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Issue_Purchase_List"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Issue_Purchase_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Issue_Service_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="50"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0" Margin="5">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Issue_Service_Property"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Issue_Service_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Issue_Service_Result" ItemsSource="{Binding Service}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Description"  Binding="{Binding Record.Description}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Cost" Binding="{Binding Record.Cost}" Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Issue_Service_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Issue_Service_List"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Issue_Service_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Issue_Invoice_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="50"/>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0" Margin="5">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="150"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Issue_Invoice_Property"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Issue_Invoice_Filter"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Mod_Issue_Invoice_Result" ItemsSource="{Binding Invoice}">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="UID"   Binding="{Binding Record.UID}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Date"  Binding="{Binding Record.Date}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                                    <DataGridTextColumn Header="Phone" Binding="{Binding Record.Phone}" Width="*"/>',
        '                                    <DataGridTextColumn Header="Email"  Binding="{Binding Record.Email}"  Width="*"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                            <Grid Grid.Row="2">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Button Grid.Column="0" Content="+" Name="Mod_Issue_Invoice_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Issue_Invoice_List"/>',
        '                                <Button Grid.Column="2" Content="-" Name="Mod_Issue_Invoice_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </Grid>',
        '                    <DataGrid Name="Mod_Issue_Record_List" Grid.Row="2">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="100"/>',
        '                            <DataGridTemplateColumn Header="Value" Width="*">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <ComboBox ItemsSource="{Binding Value}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Inventory_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Inventory" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Inventory_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Inventory_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Inventory_Result" ItemsSource="{Binding Inventory}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name"       Binding="{Binding Record.DisplayName}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Vendor"     Binding="{Binding Record.Vendor}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Serial"     Binding="{Binding Record.Serial}"   Width="*"/>',
        '                            <DataGridTextColumn Header="Model"      Binding="{Binding Record.Model}"    Width="*"/>',
        '                            <DataGridTextColumn Header="Title"      Binding="{Binding Record.Title}"    Width="2*"/>',
        '                            <DataGridTemplateColumn Header="Device" Width="60">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <ComboBox SelectedIndex="{Binding Record.IsDevice}">',
        '                                            <ComboBoxItem Content="N"/>',
        '                                            <ComboBoxItem Content="Y"/>',
        '                                            <ComboBoxItem Content="-"/>',
        '                                        </ComboBox>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>',
        '                            <DataGridTextColumn Header="Cost"  Binding="{Binding Record.Cost}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Inventory" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="105"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Vendor]">',
        '                            <TextBox Name="Mod_Inventory_Vendor_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Model]">',
        '                            <TextBox Name="Mod_Inventory_Model_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[Serial]">',
        '                            <TextBox Name="Mod_Inventory_Serial_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Title]">',
        '                            <TextBox Name="Mod_Inventory_Title_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Cost]">',
        '                            <TextBox Name="Mod_Inventory_Cost_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <GroupBox Grid.Row="2" Header="[Device]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="60"/>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Inventory_IsDevice_List" IsEnabled="False">',
        '                                    <ComboBoxItem Content="No"/>',
        '                                    <ComboBoxItem Content="Yes"/>',
        '                                </ComboBox>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Inventory_Device_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="2" Name="Mod_Inventory_Device_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Inventory_Device_Result" IsEnabled="False"/>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Inventory_Device_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Inventory_Device_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Inventory_Device_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Purchase_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Purchase" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Purchase_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Purchase_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Purchase_Result" ItemsSource="{Binding Purchase}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}" Width="*"/>',
        '                            <DataGridTextColumn Header="Distributor"  Binding="{Binding Record.Distributor}" Width="*"/>',
        '                            <DataGridTextColumn Header="Vendor"       Binding="{Binding Record.Vendor}"      Width="*"/>',
        '                            <DataGridTextColumn Header="Serial"       Binding="{Binding Record.Serial}"      Width="2*"/>',
        '                            <DataGridTextColumn Header="Model"        Binding="{Binding Record.Model}"       Width="*"/>',
        '                            <DataGridTemplateColumn Header="Device"   Width="60">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <ComboBox SelectedIndex="{Binding Record.IsDevice}">',
        '                                            <ComboBoxItem Content="N"/>',
        '                                            <ComboBoxItem Content="Y"/>',
        '                                            <ComboBoxItem Content="-"/>',
        '                                        </ComboBox>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>',
        '                            <DataGridTextColumn Header="Cost"  Binding="{Binding Record.Cost}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Purchase" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="105"/>',
        '                        <RowDefinition Height="70"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Row="0" Header="[Display Name]">',
        '                        <TextBox Name="Mod_Purchase_DisplayName_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="1" Header="[Distributor]">',
        '                        <TextBox Name="Mod_Purchase_Distributor_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="2" Header="[URL]">',
        '                        <TextBox Name="Mod_Purchase_URL_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <Grid Grid.Row="3">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Vendor]">',
        '                            <TextBox Name="Mod_Purchase_Vendor_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[Model]">',
        '                            <TextBox Name="Mod_Purchase_Model_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="2" Header="[Specification]">',
        '                            <TextBox Name="Mod_Purchase_Specification_Text" IsEnabled="False"/>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <GroupBox Grid.Row="4" Header="[Serial]">',
        '                        <TextBox Name="Mod_Purchase_Serial_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="5" Header="[Device]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="60"/>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Purchase_IsDevice_List" IsEnabled="False">',
        '                                    <ComboBoxItem Content="No"/>',
        '                                    <ComboBoxItem Content="Yes"/>',
        '                                </ComboBox>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Purchase_Device_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="2" Name="Mod_Purchase_Device_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Purchase_Device_Result" IsEnabled="False"/>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Purchase_Device_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Purchase_Device_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Purchase_Device_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="6" Header="[Cost]">',
        '                        <TextBox Name="Mod_Purchase_Cost_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Expense_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Expense" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Expense_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Expense_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Expense_Result" ItemsSource="{Binding Expense}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Recipient"    Binding="{Binding Record.Recipient}"   Width="*"/>',
        '                            <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}" Width="1.5*"/>',
        '                            <DataGridTemplateColumn Header="IsAccount" Width="60">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <ComboBox SelectedIndex="{Binding IsAccount}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">',
        '                                            <ComboBoxItem Content="False"/>',
        '                                            <ComboBoxItem Content="True"/>',
        '                                        </ComboBox>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>   ',
        '                            <DataGridTextColumn Header="Account"      Binding="{Binding Record.Account}"     Width="*"/>',
        '                            <DataGridTextColumn Header="Cost"         Binding="{Binding Record.Cost}"        Width="0.5*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Expense" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="105"/>',
        '                        <RowDefinition Height="70"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Row="0" Header="[Display Name]">',
        '                        <TextBox Name="Mod_Expense_DisplayName_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="1" Header="[Recipient]">',
        '                        <TextBox Name="Mod_Expense_Recipient_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="2" Header="[Account]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Expense_IsAccount_List" IsEnabled="False">',
        '                                    <ComboBoxItem Content="No"/>',
        '                                    <ComboBoxItem Content="Yes"/>',
        '                                </ComboBox>',
        '                                <ComboBox Grid.Column="1" Name="Mod_Expense_Account_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="2" Name="Mod_Expense_Account_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Expense_Account_Result" IsEnabled="False"/>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Expense_Account_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Expense_Account_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Expense_Account_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <GroupBox Grid.Row="3" Header="[Cost]">',
        '                        <TextBox Name="Mod_Expense_Cost_Text" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Account_Grid" Visibility="Collapsed">',
        '                <Grid Name="Get_Account" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Account_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Account_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Account_Result" ItemsSource="{Binding Account}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Object"  Binding="{Binding Record.Object}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Account" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="105"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Column="0" Header="[Object]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Account_Object_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Account_Object_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Account_Object_Result" IsEnabled="False"/>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Account_Object_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Account_Object_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Account_Object_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="0" Name="Invoice_Grid" Visibility="Visible">',
        '                <Grid Name="Get_Invoice" Visibility="Collapsed">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="4*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <ComboBox Grid.Column="0" Name="Get_Invoice_Property"/>',
        '                        <TextBox Grid.Column="1" Name="Get_Invoice_Filter"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Invoice_Result" ItemsSource="{Binding Invoice}">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Date" Binding="{Binding Record.Date}" Width="*"/>',
        '                            <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
        '                            <DataGridTextColumn Header="Phone"  Binding="{Binding Record.Last}"  Width="*"/>',
        '                            <DataGridTextColumn Header="Email" Binding="{Binding Record.First}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '                <Grid Name="Mod_Invoice" Visibility="Visible">',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="70"/>',
        '                        <RowDefinition Height="*"/>',
        '                        <RowDefinition Height="180"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Row="0" Header="[Mode]">',
        '                        <ComboBox Name="Mod_Invoice_Mode_List" IsEnabled="False"/>',
        '                    </GroupBox>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="*"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Grid Grid.Row="0">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Button Grid.Column="0" Name="Mod_Invoice_Client_Tab" Content="Client"/>',
        '                            <Button Grid.Column="1" Name="Mod_Invoice_Inventory_Tab" Content="Inventory"/>',
        '                            <Button Grid.Column="2" Name="Mod_Invoice_Service_Tab" Content="Service"/>',
        '                            <Button Grid.Column="3" Name="Mod_Invoice_Purchase_Tab" Content="Purchase"/>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Invoice_Client_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Invoice_Client_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Invoice_Client_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <DataGrid Grid.Column="0" Name="Mod_Invoice_Client_Result" ItemsSource="{Binding Client}">',
        '                                    <DataGrid.Columns>',
        '                                        <DataGridTextColumn Header="Name"  Binding="{Binding Record.DisplayName}" Width="*"/>',
        '                                        <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"        Width="*"/>',
        '                                        <DataGridTextColumn Header="First" Binding="{Binding Record.First}"       Width="*"/>',
        '                                        <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"          Width="*"/>',
        '                                        <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"         Width="*"/>',
        '                                    </DataGrid.Columns>',
        '                                </DataGrid>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Invoice_Client_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Invoice_Client_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Invoice_Client_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Invoice_Inventory_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Invoice_Inventory_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Invoice_Inventory_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <DataGrid Grid.Column="0" Name="Mod_Invoice_Inventory_Result" ItemsSource="{Binding Inventory}">',
        '                                    <DataGrid.Columns>',
        '                                        <DataGridTextColumn Header="Name"     Binding="{Binding Record.DisplayName}" Width="*"/>',
        '                                        <DataGridTextColumn Header="Vendor"   Binding="{Binding Record.Vendor}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Serial"   Binding="{Binding Record.Serial}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Model"    Binding="{Binding Record.Model}"       Width="*"/>',
        '                                        <DataGridTextColumn Header="Title"    Binding="{Binding Record.Title}"       Width="*"/>',
        '                                        <DataGridTextColumn Header="IsDevice" Binding="{Binding Record.IsDevice}"    Width="*"/>',
        '                                        <DataGridTextColumn Header="Device"   Binding="{Binding Record.Device}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Cost"     Binding="{Binding Record.Cost}"        Width="*"/>',
        '                                    </DataGrid.Columns>',
        '                                </DataGrid>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Invoice_Inventory_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Invoice_Inventory_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Invoice_Inventory_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Invoice_Service_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Invoice_Service_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Invoice_Service_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <DataGrid Grid.Column="0" Name="Mod_Invoice_Service_Result" ItemsSource="{Binding Service}">',
        '                                    <DataGrid.Columns>',
        '                                        <DataGridTextColumn Header="Name"        Binding="{Binding Record.DisplayName}" Width="*"/>',
        '                                        <DataGridTextColumn Header="Description" Binding="{Binding Record.Vendor}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Cost"        Binding="{Binding Record.Serial}"      Width="*"/>',
        '                                    </DataGrid.Columns>',
        '                                </DataGrid>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Invoice_Service_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Invoice_Service_List"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Invoice_Service_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1" Name="Mod_Invoice_Purchase_Grid" Visibility="Collapsed">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="120"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <ComboBox Grid.Column="0" Name="Mod_Invoice_Purchase_Property" IsEnabled="False"/>',
        '                                <TextBox Grid.Column="1" Name="Mod_Invoice_Purchase_Filter" IsEnabled="False"/>',
        '                            </Grid>',
        '                            <Grid Grid.Row="1">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="40"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <DataGrid Grid.Column="0" Name="Mod_Invoice_Purchase_Result" ItemsSource="{Binding Purchase}">',
        '                                    <DataGrid.Columns>',
        '                                        <DataGridTextColumn Header="Name"          Binding="{Binding Record.DisplayName}" Width="*"/>',
        '                                        <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"       Width="*"/>',
        '                                        <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="*"/>',
        '                                        <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"       Width="*"/>',
        '                                        <DataGridTextColumn Header="IsDevice"      Binding="{Binding Record.IsDevice}"    Width="*"/>',
        '                                        <DataGridTextColumn Header="Device"        Binding="{Binding Record.Device}"      Width="*"/>',
        '                                        <DataGridTextColumn Header="Cost"          Binding="{Binding Record.Cost}"        Width="*"/>',
        '                                    </DataGrid.Columns>',
        '                                </DataGrid>',
        '                                <Button Grid.Column="1" Content="+" Name="Mod_Invoice_Purchase_Add" IsEnabled="False"/>',
        '                                <ComboBox Grid.Column="2" Name="Mod_Invoice_Purchase_List" IsEnabled="False"/>',
        '                                <Button Grid.Column="3" Content="-" Name="Mod_Invoice_Purchase_Remove" IsEnabled="False"/>',
        '                            </Grid>',
        '                        </Grid>',
        '                    </Grid>',
        '                    <DataGrid Name="Mod_Invoice_Record_List" Grid.Row="2">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="100"/>',
        '                            <DataGridTemplateColumn Header="Value" Width="*">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <ComboBox ItemsSource="{Binding Value}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '            </Grid>',
        '            <Grid Grid.Row="1">',
        '                <Grid.ColumnDefinitions>',
        '                    <ColumnDefinition Width="*"/>',
        '                    <ColumnDefinition Width="*"/>',
        '                    <ColumnDefinition Width="*"/>',
        '                    <ColumnDefinition Width="*"/>',
        '                    <ColumnDefinition Width="*"/>',
        '                </Grid.ColumnDefinitions>',
        '                <Button Grid.Column="0" Name="View" Content="View"/>',
        '                <Button Grid.Column="1" Name="New" Content="New"/>',
        '                <Button Grid.Column="2" Name="Edit" Content="Edit"/>',
        '                <Button Grid.Column="3" Name="Save" Content="Save"/>',
        '                <Button Grid.Column="4" Name="Delete" Content="Delete"/>',
        '            </Grid>',
        '        </Grid>',
        '    </Grid>',
        '</Window>')
    }

    Class DGList
    {
        [String] $Name
        [Object] $Value
        DGList([String]$Name,[Object]$Value)
        {
            $This.Name  = $Name
            $This.Value = $Value -join ", "
        }
    }

    Class Postal
    {
        Hidden [Object] $Line
        [String] $Postal
        [String] $City
        [String] $County
        Postal([String]$Line)
        {
            $This.Line  = $Line -Split "\t"
            $This.Postal = $This.Line[0]
            $This.City   = $This.Line[1]
            $This.County = $This.Line[2]
        }
    }

    Class UID
    {
        [Object] $UID
        [UInt32] $Index
        [Object] $Slot
        [Object] $Type
        [Object] $Date
        [Object] $Time
        [Object] $Record
        UID([UInt32]$Slot)
        {
            $This.UID    = New-GUID | % GUID
            $This.Slot   = $Slot
            $This.Date   = Get-Date -UFormat "%m/%d/%Y"
            $This.Time   = Get-Date -UFormat "%H:%M:%S"
        }
        [String] ToString()
        {
            Return $This.Slot
        }
    }

    Class Client
    {
        [Object]         $UID
        [Object]       $Index
        [Object]        $Slot
        [Object]        $Type
        [Object]        $Date
        [Object]        $Time
        [UInt32]        $Rank
        [String] $DisplayName
        [String]       $First
        [String]          $MI
        [String]        $Last
        [Object]     $Address
        [Object]        $City
        [Object]      $Region
        [Object]     $Country
        [Object]      $Postal
        [UInt32]       $Month
        [UInt32]         $Day
        [UInt32]        $Year
        [String]         $DOB
        [String]      $Gender
        [Object]       $Image
        [Object[]]     $Phone
        [Object[]]     $Email
        [Object[]]    $Device
        [Object[]]   $Invoice
        Client([Object]$UID)
        {
            $This.UID  = $UID.UID
            $This.Slot = 0
            $This.Type = "Client"
            $This.Date = $UID.Date
            $This.Time = $UID.Time

            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Invoice = @( )
        }
        [String] ToString()
        {
            Return "Client"
        }
    }

    Class Service
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]          $Name
        [String]   $Description
        [Float]           $Cost
        Service([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 1
            $This.Type = "Service"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Service"
        }
    }

    Class Device
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [String]          $Rank
        [String]   $DisplayName
        [String]       $Chassis
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Object]        $Client
        [Object[]]       $Issue
        [Object[]]    $Purchase
        [Object[]]     $Invoice
        Device([Object]$UID) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = 2
            $This.Type = "Device"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Device"
        }
    }

    Class Issue
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]        $Status
        [String[]] $Description
        [Object]        $Client
        [Object]        $Device
        [Object[]]    $Purchase
        [Object[]]     $Service
        [Object[]]     $Invoice
        Issue([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 3
            $This.Type = "Issue"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Issue"
        }
    }

    Class Inventory
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]        $Vendor
        [String]         $Model
        [String]        $Serial
        [Object]         $Title
        [Object]          $Cost
        [Bool]        $IsDevice
        [Object[]]      $Device
        Inventory([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 4
            $This.Type = "Inventory"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Inventory"
        }
    }

    Class Purchase
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]   $Distributor
        [Object]           $URL
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Bool]        $IsDevice
        [Object]        $Device
        [Object]          $Cost
        Purchase([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 5
            $This.Type = "Purchase"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Purchase"
        }
    }

    Class Expense
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]     $Recipient
        [Object]     $IsAccount
        [Object]       $Account
        [Object]          $Cost
        Expense([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 6
            $This.Type = "Expense"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Expense"
        }
    }

    Class Account
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [String]   $DisplayName
        [Object]        $Object
        Account([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 7
            $This.Type = "Account"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Account"
        }
    }

    Class Invoice
    {
        [Object]           $UID
        [UInt32]         $Index
        [Object]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Rank
        [String]   $DisplayName
        [UInt32]          $Mode
        [Object]        $Client
        [Object]     $Inventory
        [Object]       $Service
        [Object]      $Purchase
        Invoice([Object]$UID) 
        {
            $This.UID  = $UID.UID
            $This.Slot = 8
            $This.Type = "Invoice"
            $This.Date = $UID.Date
            $This.Time = $UID.Time
        }
        [String] ToString()
        {
            Return "Invoice"
        }
    }

    Class DB
    {
        [Object[]]         $UID
        [Object[]]      $Client
        [Object[]]     $Service
        [Object[]]      $Device
        [Object[]]       $Issue
        [Object[]]   $Inventory
        [Object[]]    $Purchase
        [Object[]]     $Expense
        [Object[]]     $Account
        [Object[]]     $Invoice
        DB()
        {
            $This.UID       = @( )
            $This.Client    = @( )
            $This.Service   = @( )
            $This.Device    = @( )
            $This.Issue     = @( )
            $This.Inventory = @( )
            $This.Purchase  = @( )
            $This.Expense   = @( )
            $This.Account   = @( )
            $This.Invoice   = @( )  
        }
        [UInt32] GetCount([UInt32]$X)
        {
            Return ( $X + 1 )
        }
        [UInt32] GetIndex()
        {
            Return ($This.GetCount($This.UID.Count) - 1)
        }
        [UInt32] GetRank([UInt32]$Slot)
        {
            Return $This.GetCount(
            @(  
                $This.Client.Count    ,
                $This.Service.Count   ,
                $This.Device.Count    ,
                $This.Issue.Count     , 
                $This.Inventory.Count ,
                $This.Purchase.Count  ,
                $This.Expense.Count   ,
                $This.Account.Count   ,
                $This.Invoice.Count   
            
            )[$Slot]) - 1
        }
        [Object] NewUID([Object]$Slot)
        {
            If ($Slot -notin 0..8)
            {
                Throw "Invalid entry"
            }

            $Item                = [UID]::New($Slot)
            $Item.Type           = @("Client Service Device Issue Inventory Purchase Expense Account Invoice" -Split " ")[$Slot]
            $Item.Index          = $This.GetIndex()
            $Item.Record         = Switch ($Slot)
            {
                0 { [Client]::New($Item)    } 1 { [Service]::New($Item)   } 2 { [Device]::New($Item)    }
                3 { [Issue]::New($Item)     } 4 { [Inventory]::New($Item) } 5 { [Purchase]::New($Item)  }
                6 { [Expense]::New($Item)   } 7 { [Account]::New($Item)   } 8 { [Invoice]::New($Item)   }
            }

            $Item.Record.Index   = $Item.Index
            $Item.Record.Rank    = $This.GetRank($Slot)

            Switch($Slot)
            {
                0 { $This.Client     += $Item } 1 { $This.Service    += $Item } 2 { $This.Device     += $Item }
                3 { $This.Issue      += $Item } 4 { $This.Inventory  += $Item } 5 { $This.Purchase   += $Item } 
                6 { $This.Expense    += $Item } 7 { $This.Account    += $Item } 8 { $This.Invoice    += $Item }
            }

            $This.UID           += $Item

            Return $Item
        }
        [Object] GetUID([Object]$UID)
        {
            Return $This.UID | ? UID -match $UID
        }
    }

    Class Template
    {
        [String[]] $UID
        [String[]] $Client
        [String[]] $Service
        [String[]] $Device
        [String[]] $Issue
        [String[]] $Inventory
        [String[]] $Purchase
        [String[]] $Expense
        [String[]] $Account
        [String[]] $Invoice
        Template()
        {
            $This.UID          = @("UID","Index","Date","Rank","DisplayName")
            $This.Client       = @($This.UID; "DOB", "Phone", "Email")
            $This.Service      = @($This.UID; "Description")
            $This.Device       = @($This.UID; "Vendor", "Model", "Specification", "Serial", "Title")
            $This.Issue        = @($This.UID; "Status","Description","Client","Device","Purchase","Service","Invoice")
            $This.Inventory    = @($This.UID; "Vendor","Model","Serial","Title","Cost","IsDevice","Device")
            $This.Purchase     = @($This.UID; "Distributor","Vendor","Serial","Model","IsDevice","Device","Cost")
            $This.Expense      = @($This.UID; "Recipient","Account","Cost")
            $This.Account      = @($This.UID; "Object")
            $This.Invoice      = @($This.UID; "Client","Inventory","Service","Purchase")
            $This.UID          = $This.UID[0..3]
        }
    }

    Class Main
    {
        [String[]]       $Slot = ("UID Client Service Device Issue Inventory Purchase Expense Account Invoice" -Split " ")
        [UInt32]            $X
        [UInt32]            $Y
        [UInt32]            $Z
        [String]      $Current
        [Object]           $DB
        [Object]         $Xaml
        [Object]         $Temp
        [Object[]]      $Names
        [Object[]]       $Grid
        [Object[]]    $TextBox
        [Object[]]   $ComboBox
        [Object[]]     $Button
        [Object[]]   $DataGrid
        [Object]     $Selected
        Main([Object]$Xaml)
        {
            $This.DB       = [DB]::New()
            $This.Xaml     = $Xaml
            $This.Temp     = [Template]::New()
            $This.Names    = $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % { [DGList]::New($_,$This.Xaml.IO.$_.GetType().Name) }
            $This.Grid     = $This.Names | ? Value -eq Grid
            $This.TextBox  = $This.Names | ? Value -eq TextBox
            $This.ComboBox = $This.Names | ? Value -eq ComboBox
            $This.Button   = $This.Names | ? Value -eq Button
            $This.DataGrid = $This.Names | ? Value -eq DataGrid
        }
        Collapse()
        {
            $This.TextBox  | % Name | % { $This.Xaml.IO.$_.Text       = ""          }
            $This.Grid     | % Name | % { $This.Xaml.IO.$_.Visibility = "Collapsed" }
        }
        Menu([UInt32]$X)
        {
            $This.X                       = $X
            $This.Y                       = 0
            $This.Z                       = 0
            $This.Collapse()
            $This.Current                 = $This.Slot[$X]
            $Sx                           = $This.Current
            $Gr                           = "{0}_Grid"       -f $Sx
            $Gx                           = "Get_{0}"        -f $Sx
            $Mx                           = "Mod_{0}"        -f $Sx
            $Dg                           = "Get_{0}_Result" -f $Sx
            $This.Xaml.IO.$Gr.Visibility  = "Visible"
            $This.Xaml.IO.$Gx.Visibility  = "Visible"
            $This.Xaml.IO.$Mx.Visibility  = "Collapsed"
            $This.Xaml.IO.$Dg.ItemsSource = @( )
            $This.Xaml.IO.$Dg.ItemsSource = @( $This.DB.$Sx )

            If ($X -eq 0)
            {
                $This.Xaml.IO.View.IsEnabled    = 0
                $This.Xaml.IO.New.IsEnabled     = 0
                $This.Xaml.IO.Edit.IsEnabled    = 0
                $This.Xaml.IO.Save.IsEnabled    = 0
                $This.Xaml.IO.Delete.IsEnabled  = 0
                $This.Xaml.IO.Refresh.IsEnabled = 1
            }

            Else
            {
                $This.Xaml.IO.View.IsEnabled    = 0
                $This.Xaml.IO.New.IsEnabled     = 1
                $This.Xaml.IO.Edit.IsEnabled    = 0
                $This.Xaml.IO.Save.IsEnabled    = 0
                $This.Xaml.IO.Delete.IsEnabled  = 0
                $This.Xaml.IO.Refresh.IsEnabled = 1
            }

            ForEach ( $I in 0..9 )
            {
                $Tx = "{0}_Tab" -f $This.Slot[$I]

                If ( $This.Slot[$I] -eq $This.Current )
                {
                    $This.Xaml.IO.$Tx.Background   = "#4444FF"
                    $This.Xaml.IO.$Tx.Foreground   = "#FFFFFF"
                    $This.Xaml.IO.$Tx.BorderBrush  = "#111111"
                }

                Else
                {
                    $This.Xaml.IO.$Tx.Background  = "#DFFFBA"
                    $This.Xaml.IO.$Tx.Foreground  = "#000000"
                    $This.Xaml.IO.$Tx.BorderBrush = "#000000"
                }
            }
        }
        Mode([UInt32]$Y)
        {
            $This.Y                       = $Y
            $This.Z                       = 0
            $This.Collapse()
            $This.Current                 = $This.Slot[$This.X]
            $Sx                           = $This.Current
            $Gr                           = "{0}_Grid"       -f $Sx
            $Gx                           = "Get_{0}"        -f $Sx
            $Mx                           = "Mod_{0}"        -f $Sx
            $Dg                           = "Get_{0}_Result" -f $Sx
            $This.Xaml.IO.$Gr.Visibility  = "Visible"
            $This.Xaml.IO.$Gx.Visibility  = "Collapsed"
            $This.Xaml.IO.$Mx.Visibility  = "Visible"
            $This.Xaml.IO.$Dg.ItemsSource = @( )
            $This.Xaml.IO.$Dg.ItemsSource = @( $This.DB.$Sx )
        }
    }

    $Xaml = [XamlWindow][cimdbGUI]::Tab

    # Open ComboBox/DataGrid ItemsSource
    $Xaml.Names | ? { $_ -match "(Result|Property)" } | % { $Xaml.IO.$_.ItemsSource = @( ) }
    $Temp = [Template]::New()

    # Stage ComboBox Items
    $Xaml.Names | ? { $_ -match "(Property)" } | % { 

        $Xaml.IO.$_.ItemsSource = Switch -Regex ($_)
        {
            UID_Property       { $Temp.UID       } Client_Property    { $Temp.Client    } 
            Service_Property   { $Temp.Service   } Device_Property    { $Temp.Device    } 
            Issue_Property     { $Temp.Issue     } Inventory_Property { $Temp.Inventory }
            Purchase_Property  { $Temp.Purchase  } Expense_Property   { $Temp.Expense   } 
            Account_Property   { $Temp.Account   } Invoice_Property   { $Temp.Invoice   }
        }
        $Xaml.IO.$_.SelectedIndex = 0
    }

    $Main = [Main]::New($Xaml)

    # For testing DB
    # 0..30 | % { $X = Get-Random -Minimum 0 -Maximum 8; $Main.DB.NewUID($X) }

    $Xaml.IO.UID_Tab.Add_Click(        { $Main.Menu(0) } )
    $Xaml.IO.Client_Tab.Add_Click(     { $Main.Menu(1) } )
    $Xaml.IO.Service_Tab.Add_Click(    { $Main.Menu(2) } )
    $Xaml.IO.Device_Tab.Add_Click(     { $Main.Menu(3) } )
    $Xaml.IO.Issue_Tab.Add_Click(      { $Main.Menu(4) } )
    $Xaml.IO.Inventory_Tab.Add_Click(  { $Main.Menu(5) } )
    $Xaml.IO.Purchase_Tab.Add_Click(   { $Main.Menu(6) } )
    $Xaml.IO.Expense_Tab.Add_Click(    { $Main.Menu(7) } )
    $Xaml.IO.Account_Tab.Add_Click(    { $Main.Menu(8) } )
    $Xaml.IO.Invoice_Tab.Add_Click(    { $Main.Menu(9) } )

    # View
    $Xaml.IO.View.Add_Click(
    {
        $Main.Selected = $Xaml.IO."Get_$($Main.Current)_Result".SelectedItem
        $Main.Mode(0)
        $Main.TextBox  | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$_.IsEnabled = 0 }
        $Main.Button   | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$_.IsEnabled = 0 }
        Switch($Main.Current)
        {
            UID
            {
                $Xaml.IO.Mod_UID_UID_Text.Text   = $Main.Selected.UID
                $Xaml.IO.Mod_UID_Index_Text.Text = $Main.Selected.Index
                $Xaml.IO.Mod_UID_Slot_Text.Text  = $Main.Selected.Slot
                $Xaml.IO.Mod_UID_Type_Text.Text  = $Main.Selected.Type
                $Xaml.IO.Mod_UID_Date_Text.Text  = $Main.Selected.Date
                $Xaml.IO.Mod_UID_Time_Text.Text  = $Main.Selected.Time
                $Xaml.IO.Mod_UID_Record_List.ItemsSource = ForEach ( $Object in $Select.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                {
                    [DGList]::New($Object,$Select.Record.$Object)
                })
            }

            Client
            {
                $Xaml.IO.Mod_Client_Last.Text            = $Main.Selected.Record.Last
                $Xaml.IO.Mod_Client_First.Text           = $Main.Selected.Record.First
                $Xaml.IO.Mod_Client_MI.Text              = $Main.Selected.Record.MI
                $Xaml.IO.Mod_Client_Address.Text         = $Main.Selected.Record.Address
                $Xaml.IO.Mod_Client_Month.Text           = $Main.Selected.Record.Month
                $Xaml.IO.Mod_Client_Day.Text             = $Main.Selected.Record.Day
                $Xaml.IO.Mod_Client_Year.Text            = $Main.Selected.Record.Year
                $Xaml.IO.Mod_Client_City.Text            = $Main.Selected.Record.City
                $Xaml.IO.Mod_Client_Region.Text          = $Main.Selected.Record.Region
                $Xaml.IO.Mod_Client_Country.Text         = $Main.Selected.Record.Country
                $Xaml.IO.Mod_Client_Postal.Text          = $Main.Selected.Record.Postal
                $Xaml.IO.Mod_Client_Phone_List.ItemsSource   = @($Main.Selected.Record.Phone)
                $Xaml.IO.Mod_Client_Email_List.ItemsSource   = @($Main.Selected.Record.Email)
                $Xaml.IO.Mod_Client_Device_List.ItemsSource  = @($Main.Selected.Record.Device)
                $Xaml.IO.Mod_Client_Invoice_List.ItemsSource = @($Main.Selected.Record.Invoice)

            }

            Service
            {
                $Xaml.IO.Mod_Service_Name.Text           = $Main.Selected.Record.Name
                $Xaml.IO.Mod_Service_Description.Text    = $Main.Selected.Record.Description
                $Xaml.IO.Mod_Service_Cost.Text           = $Main.Selected.Record.Cost
            }

            Device
            {
                $Xaml.IO.Mod_Device_DisplayName.Text           = $Main.Selected.Record.DisplayName
                $Xaml.IO.Mod_Device_Chassis_List.SelectedIndex = @{ Desktop = 0; Laptop = 1; Smartphone = 2; Tablet = 3; Console = 4; Console = 5; Server = 6; Network = 7; Other = 8; "-" = 9 }[$Main.Selected.Record.Chassis]
                $Xaml.IO.Mod_Device_Vendor_Text.Text           = $Main.Selected.Record.Vendor
                $Xaml.IO.Mod_Device_Model_Text.Text            = $Main.Selected.Record.Model
                $Xaml.IO.Mod_Device_Specification_Text.Text    = $Main.Selected.Record.Specfication
                $Xaml.IO.Mod_Device_Serial_Text.Text           = $Main.Selected.Record.Serial
                $Xaml.IO.Mod_Client_Result.ItemsSource         = @($Main.Selected.Record.Client)
                $Xaml.IO.Mod_Issue_Result.ItemsSource          = @($Main.Selected.Record.Issue)
                $Xaml.IO.Mod_Purchase_Result.ItemsSource       = @($Main.Selected.Record.Purchase)
                $Xaml.IO.Mod_Invoice_Result.ItemsSource        = @($Main.Selected.Record.Invoice)
            }

            Issue
            {
                $Xaml.IO.Mod_Issue_DisplayName.Text            = $Main.Selected.Record.DisplayName
                $Xaml.IO.Mod_Issue_Status_List.SelectedIndex   = @{ New = 0; Diagnosed = 1; Commit = 2; Complete = 3}[$Main.Selected.Record.Status]
                $Xaml.IO.Mod_Issue_Description_Text.Text       = $Main.Selected.Record.Description
                $Xaml.IO.Mod_Issue_Client_List.ItemsSource     = $Main.Selected.Record.Client
                $Xaml.IO.Mod_Issue_Device_List.ItemsSource     = $Main.Selected.Record.Device
                $Xaml.IO.Mod_Issue_Purchase_List.ItemsSource   = @($Main.Selected.Record.Purchase)
                $Xaml.IO.Mod_Issue_Service_List.ItemsSource    = @($Main.Selected.Record.Service)
                $Xaml.IO.Mod_Issue_Invoice_List.ItemsSource    = @($Main.Selected.Record.Invoice)
                $Xaml.IO.Mod_Issue_Record_List.ItemsSource     = ForEach ( $Object in $Select.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                {
                    [DGList]::New($Object,$Select.Record.$Object)
                })
            }
            Inventory
            {
                $Xaml.IO.Mod_Inventory_DisplayName.Text        = $Main.Selected.Record.DisplayName
                $Xaml.IO.Mod_Inventory_Vendor_Text.Text        = $Main.Selected.Record.Vendor
                $Xaml.IO.Mod_Inventory_Model_Text.Text         = $Main.Selected.Record.Model
                $Xaml.IO.Mod_Inventory_Serial_Text.Text        = $Main.Selected.Record.Serial
                $Xaml.IO.Mod_Inventory_Title_Text.Text         = $Main.Selected.Record.Title
                $Xaml.IO.Mod_Inventory_Cost_Text.Text          = $Main.Selected.Record.Cost
                $Xaml.IO.Mod_Inventory_IsDevice_List.SelectedIndex = @(0,1)[$Main.Selected.Record.IsDevice]
                $Xaml.IO.Mod_Inventory_Device_List.ItemsSource = $Main.Selected.Record.Device
            }
            Purchase
            {
                $Xaml.IO.Mod_Purchase_DisplayName_Text.Text    = $Main.Selected.Record.DisplayName
                $Xaml.IO.Mod_Purchase_Distributor_Text.Text    = $Main.Selected.Record.Distributor
                $Xaml.IO.Mod_Purchase_URL_Text.Text            = $Main.Selected.Record.URL
                $Xaml.IO.Mod_Purchase_Vendor_Text.Text         = $Main.Selected.Record.Vendor
                $Xaml.IO.Mod_Purchase_Model_Text.Text          = $Main.Selected.Record.Model
                $Xaml.IO.Mod_Purchase_Specification_Text       = $Main.Selected.Record.Specification
                $Xaml.IO.Mod_Purchase_Serial_Text              = $Main.Selected.Record.Serial
                $Xaml.IO.Mod_Purchase_IsDevice_List.SelectedIndex = @(0,1)[$Main.Selected.Record.IsDevice]
                $Xaml.IO.Mod_Purchase_Device_List.ItemsSource  = $Main.Selected.Record.Device
                $Xaml.IO.Mod_Purchase_Cost_Text                = $Main.Selected.Record.Cost
            }
            Expense
            {
                $Xaml.IO.Mod_Expense_DisplayName_Text.Text     = $Main.Selected.Record.DisplayName
                $Xaml.IO.Mod_Expense_Recipient_Text.Text       = $Main.Selected.Record.Recipient
                $Xaml.IO.Mod_Expense_IsAccount_List.SelectedIndex = @(0,1)[$Main.Selected.Record.IsAccount]
                $Xaml.IO.Mod_Expense_Account_List.ItemsSource  = $Main.Selected.Record.Account
                $Xaml.IO.Mod_Expense_Cost_Text.Text            = $Main.Selected.Record.Cost
            }
            Account
            {
                $Xaml.IO.Mod_Account_Object_List.ItemsSource   = @($Main.Selected.Record.Object)
            }
            Invoice
            {
                $Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex    = @{ Quick = 0 ; Default = 1 }[$Main.Selected.Record.Mode]
                $Xaml.IO.Mod_Invoice_Client_List.ItemsSource    = @($Main.Selected.Record.Client)
                $Xaml.IO.Mod_Invoice_Inventory_List.ItemsSource = @($Main.Selected.Record.Inventory)
                $Xaml.IO.Mod_Invoice_Service_List.ItemsSource   = @($Main.Selected.Record.Service)
                $Xaml.IO.Mod_Invoice_Purchase_List.ItemsSource  = @($Main.Selected.Record.Purchase)

                $Xaml.IO.Mod_Invoice_Record_List.ItemsSource     = ForEach ( $Object in $Select.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                {
                    [DGList]::New($Object,$Select.Record.$Object)
                })
            }
        }
    })

    # New
    $Xaml.IO.New.Add_Click(            
    { 
        $Main.Mode(1)
        $Main.TextBox | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 1  }
        $Main.TextBox | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).Text      = "" }
    })

    # Edit
    $Xaml.IO.Edit.Add_Click(           
    {
        $Main.Mode(2)
        $Main.TextBox | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 1 }
    })

    # Save
    $Xaml.IO.Save.Add_Click(           
    { 
        $Main.Mode(3)
    })

    # Delete
    $Xaml.IO.Save.Add_Click(           
    { 
        $Main.Mode(4)
    })

    # UID
    $Xaml.IO.Get_UID_Result.Add_SelectionChanged(
    {
        $Xaml.IO.View.IsEnabled = @(0,1)[$Xaml.IO.Get_UID_Result.SelectedIndex -ne -1]
    })

    $Xaml.IO.Get_UID_Filter.Add_TextChanged(
    {
        Start-Sleep -Milliseconds 25
        $Xaml.IO.Get_UID_Result.ItemsSource = @( )

        If ( $Xaml.IO.Get_UID_Filter.Text -ne "" )
        {
            $List = @( $Xaml.IO.Get_UID_Result | ? $Xaml.IO.Get_UID_Property.SelectedItem -match $Xaml.IO.Get_UID_Filter.Text )
            If ( $List -ne $Null )
            {
                $Xaml.IO.Get_UID_Result.ItemsSource = @( $List )
            }
        }
        If ( $Xaml.IO.Get_UID_Filter.Text -eq "" )
        {
            $Xaml.IO.Get_UID_Result.ItemsSource = @( $Main.DB.UID )
        }
    })
}
