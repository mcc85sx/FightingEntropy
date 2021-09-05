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

    # (Get-Content $home\desktop\cim-db(1).xaml).Replace("'",'"') | % { "        '$_'," } | Set-Clipboard
    Class cimdbGUI
    {
        Static [String] $Tab = @(
            '<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://(Company Information Management Database)" Height="680" Width="800" Topmost="True" ResizeMode="NoResize" Icon="C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\icon.ico" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen" FontFamily="Consolas" Background="LightYellow">',
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
            '            <Button Grid.Row="1" Name="Client_Tab"    HorizontalContentAlignment="Right" Content="Client"/>',
            '            <Button Grid.Row="2" Name="Service_Tab"   HorizontalContentAlignment="Right" Content="Service"/>',
            '            <Button Grid.Row="3" Name="Device_Tab"    HorizontalContentAlignment="Right" Content="Device"/>',
            '            <Button Grid.Row="4" Name="Issue_Tab"     HorizontalContentAlignment="Right" Content="Issue"/>',
            '            <Button Grid.Row="5" Name="Purchase_Tab"  HorizontalContentAlignment="Right" Content="Purchase"/>',
            '            <Button Grid.Row="6" Name="Inventory_Tab" HorizontalContentAlignment="Right" Content="Inventory"/>',
            '            <Button Grid.Row="7" Name="Expense_Tab"   HorizontalContentAlignment="Right" Content="Expense"/>',
            '            <Button Grid.Row="8" Name="Account_Tab"   HorizontalContentAlignment="Right" Content="Account"/>',
            '            <Button Grid.Row="9" Name="Invoice_Tab"   HorizontalContentAlignment="Right" Content="Invoice"/>',
            '        </Grid>',
            '        <Grid Grid.Column="1">',
            '            <Grid.RowDefinitions>',
            '                <RowDefinition Height="*"/>',
            '                <RowDefinition Height="40"/>',
            '            </Grid.RowDefinitions>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_UID_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="1" Name="Get_UID_Result" ItemsSource="{Binding UID}" Margin="5" >',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="UID"    Binding="{Binding UID}"    Width="200"/>',
            '                            <DataGridTextColumn Header="Index"  Binding="{Binding Index}"  Width="50"/>',
            '                            <DataGridTextColumn Header="Slot"   Binding="{Binding Slot}"   Width="50"/>',
            '                            <DataGridTextColumn Header="Date"   Binding="{Binding Date}"   Width="100"/>',
            '                            <DataGridTextColumn Header="Time"   Binding="{Binding Time}"   Width="100"/>',
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
            '                            <TextBox Name="Mod_UID_UID"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Index]">',
            '                            <TextBox Name="Mod_UID_Index"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[Slot]">',
            '                            <TextBox Name="Mod_UID_Slot"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="3" Header="[Type]">',
            '                            <TextBox Name="Mod_UID_Type"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <Grid Grid.Row="1">',
            '                        <Grid.ColumnDefinitions>',
            '                            <ColumnDefinition Width="*"/>',
            '                            <ColumnDefinition Width="*"/>',
            '                        </Grid.ColumnDefinitions>',
            '                        <GroupBox Grid.Column="0" Header="[Date]">',
            '                            <TextBox Name="Mod_UID_Date"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Time]">',
            '                            <TextBox Name="Mod_UID_Time"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="2" Name="Mod_UID_Record" Margin="5">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="Name"  Binding="{Binding Name}"  Width="*"/>',
            '                            <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="2*"/>',
            '                        </DataGrid.Columns>',
            '                    </DataGrid>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Client_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="1" Name="Get_Client_Result" ItemsSource="{Binding Client}" Margin="5">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="DisplayNameName"  Binding="{Binding Record.DisplayName}"  Width="150"/>',
            '                            <DataGridTemplateColumn Header="Email" Width="150">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Email}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTemplateColumn Header="Phone" Width="100">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Phone}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"         Width="150"/>',
            '                            <DataGridTextColumn Header="First" Binding="{Binding Record.First}"        Width="150"/>',
            '                            <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"           Width="50"/>',
            '                            <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"          Width="100"/>',
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
            '                        <GroupBox Grid.Column="0" Header="[Last]">',
            '                            <TextBox Name="Mod_Client_Last"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[First]">',
            '                            <TextBox Name="Mod_Client_First"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[MI]">',
            '                            <TextBox Name="Mod_Client_MI"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="3" Header="[Gender]">',
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
            '                        <GroupBox Grid.Column="0" Header="[Address]">',
            '                            <TextBox Name="Mod_Client_Address"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[DOB(MM/DD/YYYY)]">',
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
            '                        <GroupBox Grid.Column="0" Header="[City]">',
            '                            <TextBox Name="Mod_Client_City"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Region]">',
            '                            <TextBox Name="Mod_Client_Region"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[Country]">',
            '                            <TextBox Name="Mod_Client_Country"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="3" Header="[Postal]">',
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
            '                            <TextBox  Grid.Column="0" Name="Mod_Client_Phone_Text"/>',
            '                            <Button   Grid.Column="1" Name="Mod_Client_Phone_Add"    Margin="5" Content="+"/>',
            '                            <ComboBox Grid.Column="2" Name="Mod_Client_Phone_List"/>',
            '                            <Button   Grid.Column="3" Name="Mod_Client_Phone_Remove" Margin="5" Content="-"/>',
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
            '                            <TextBox  Grid.Column="0" Name="Mod_Client_Email_Text"/>',
            '                            <Button   Grid.Column="1" Name="Mod_Client_Email_Add"    Margin="5" Content="+"/>',
            '                            <ComboBox Grid.Column="2" Name="Mod_Client_Email_List"/>',
            '                            <Button   Grid.Column="3" Name="Mod_Client_Email_Remove" Margin="5" Content="-"/>',
            '                        </Grid>',
            '                    </GroupBox>',
            '                    <TabControl Grid.Row="5">',
            '                        <TabItem Header="Device(s)">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="40"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Client_Device_Property" SelectedIndex="0"/>',
            '                                    <TextBox Grid.Column="1"  Name="Mod_Client_Device_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Client_Device_Result" ItemsSource="{Binding Device}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="250"/>',
            '                                        <DataGridTextColumn Header="Chassis"       Binding="{Binding Record.Chassis}"       Width="100"/>',
            '                                        <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="150"/>',
            '                                        <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="150"/>',
            '                                        <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Client"        Binding="{Binding Record.Client}"        Width="Auto"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Client_Device_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Client_Device_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Client_Device_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Issue(s)">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="40"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Client_Issue_Property" SelectedIndex="0"/>',
            '                                    <TextBox Grid.Column="1"  Name="Mod_Client_Issue_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Client_Issue_Result" ItemsSource="{Binding Issue}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}" Width="*"/>',
            '                                        <DataGridTextColumn Header="Status"      Binding="{Binding Record.Status}"      Width="*"/>',
            '                                        <DataGridTextColumn Header="Description" Binding="{Binding Record.Description}" Width="*"/>',
            '                                        <DataGridTextColumn Header="Client"      Binding="{Binding Record.Client}"      Width="*"/>',
            '                                        <DataGridTextColumn Header="Device"      Binding="{Binding Record.Device}"      Width="*"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Client_Issue_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Client_Issue_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Client_Issue_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Invoice(s)">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="40"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                               </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Client_Invoice_Property" SelectedIndex="0"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Client_Invoice_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid     Grid.Row="1"    Name="Mod_Client_Invoice_Result" ItemsSource="{Binding Invoice}" Margin="5">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}"   Width="*"/>',
            '                                        <DataGridTextColumn Header="Mode"        Binding="{Binding Record.Mode}"   Width="*"/>',
            '                                        <DataGridTextColumn Header="Date"        Binding="{Binding Record.Date}"   Width="*"/>',
            '                                        <DataGridTextColumn Header="Name"        Binding="{Binding Record.Name}"   Width="*"/>',
            '                                        <DataGridTextColumn Header="Phone"       Binding="{Binding Record.Phone}"  Width="*"/>',
            '                                        <DataGridTextColumn Header="Email"       Binding="{Binding Record.Email}"  Width="*"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Client_Invoice_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Client_Invoice_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Client_Invoice_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                    </TabControl> ',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                            <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}" Width="250"/>',
            '                            <DataGridTextColumn Header="Name"        Binding="{Binding Record.Name}"        Width="150"/>',
            '                            <DataGridTextColumn Header="Cost"        Binding="{Binding Record.Cost}"        Width="80"/>',
            '                            <DataGridTextColumn Header="Description" Binding="{Binding Record.Description}" Width="300"/>',
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
            '                        <TextBox Name="Mod_Service_Name" IsEnabled="False"/>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="1" Header="[Description]">',
            '                        <TextBox Name="Mod_Service_Description" IsEnabled="False"/>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="2" Header="[Cost]">',
            '                        <TextBox Name="Mod_Service_Cost" IsEnabled="False"/>',
            '                    </GroupBox>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                            <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="250"/>',
            '                            <DataGridTextColumn Header="Chassis"       Binding="{Binding Record.Chassis}"       Width="100"/>',
            '                            <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="150"/>',
            '                            <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="150"/>',
            '                            <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="150"/>',
            '                            <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="150"/>',
            '                            <DataGridTextColumn Header="Client"        Binding="{Binding Record.Client}"        Width="Auto"/>',
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
            '                            <ComboBox Name="Mod_Device_Chassis_List" SelectedIndex="8">',
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
            '                            <TextBox Name="Mod_Device_Vendor"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[Model]">',
            '                            <TextBox Name="Mod_Device_Model"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="3" Header="[Specification]">',
            '                            <TextBox Name="Mod_Device_Specification"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <Grid Grid.Row="1">',
            '                        <Grid.ColumnDefinitions>',
            '                            <ColumnDefinition Width="*"/>',
            '                            <ColumnDefinition Width="2*"/>',
            '                        </Grid.ColumnDefinitions>',
            '                        <GroupBox Grid.Column="0" Header="[Serial]">',
            '                            <TextBox Name="Mod_Device_Serial"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Display Name]">',
            '                            <TextBox Name="Mod_Device_DisplayName"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <TabControl Grid.Row="2">',
            '                        <TabItem Header="Client">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="40"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="150"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Row="0" Grid.Column="0" Name="Mod_Device_Client_Property"/>',
            '                                    <TextBox  Grid.Row="0" Grid.Column="1" Name="Mod_Device_Client_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid     Grid.Row="1" Grid.Column="0" Name="Mod_Device_Client_Result" ItemsSource="{Binding Client}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}"  Width="150"/>',
            '                                        <DataGridTemplateColumn Header="Email" Width="150">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox SelectedIndex="0" ItemsSource="{Binding Record.Email}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTemplateColumn Header="Phone" Width="100">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox SelectedIndex="0" ItemsSource="{Binding Record.Phone}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"         Width="150"/>',
            '                                        <DataGridTextColumn Header="First" Binding="{Binding Record.First}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"           Width="50"/>',
            '                                        <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"          Width="100"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Device_Client_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Device_Client_List">',
            '                                        <ComboBox.ItemTemplate>',
            '                                            <DataTemplate>',
            '                                                <TextBlock Text="{Binding Record.DisplayName}"/>',
            '                                            </DataTemplate>',
            '                                        </ComboBox.ItemTemplate>',
            '                                    </ComboBox>',
            '                                    <Button Grid.Column="2"   Name="Mod_Device_Client_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                    </TabControl>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Issue_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid     Grid.Row="1"    Name="Get_Issue_Result" ItemsSource="{Binding Issue}" Margin="5">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}"   Width="150"/>',
            '                            <DataGridTextColumn Header="Status"       Binding="{Binding Record.Status}"        Width="100"/>',
            '                            <DataGridTextColumn Header="Description"  Binding="{Binding Record.Description}"   Width="200"/>',
            '                            <DataGridTemplateColumn Header="Client" Width="150">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Client}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTemplateColumn Header="Device" Width="150">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Device}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTemplateColumn Header="Service" Width="150">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Service}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
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
            '                        <GroupBox Grid.Column="0" Header="[Status]">',
            '                            <ComboBox SelectedIndex="4" Name="Mod_Issue_Status_List">',
            '                                <ComboBoxItem Content="New"/>',
            '                                <ComboBoxItem Content="Diagnosed"/>',
            '                                <ComboBoxItem Content="Commit"/>',
            '                                <ComboBoxItem Content="Complete"/>',
            '                                <ComboBoxItem Content="-"/>',
            '                            </ComboBox>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Description]">',
            '                            <TextBox Name="Mod_Issue_Description"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <TabControl Grid.Row="1">',
            '                        <TabItem Header="Client">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0" Margin="5">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="150"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Issue_Client_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Issue_Client_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Issue_Client_Result" ItemsSource="{Binding Client}">',
            '                                    <DataGrid.Columns>',
            '                                <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}"  Width="150"/>',
            '                                <DataGridTemplateColumn Header="Email" Width="150">',
            '                                    <DataGridTemplateColumn.CellTemplate>',
            '                                        <DataTemplate>',
            '                                            <ComboBox ItemsSource="{Binding Record.Email}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                        </DataTemplate>',
            '                                    </DataGridTemplateColumn.CellTemplate>',
            '                                </DataGridTemplateColumn>',
            '                                <DataGridTemplateColumn Header="Phone" Width="100">',
            '                                    <DataGridTemplateColumn.CellTemplate>',
            '                                        <DataTemplate>',
            '                                            <ComboBox ItemsSource="{Binding Record.Phone}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                        </DataTemplate>',
            '                                    </DataGridTemplateColumn.CellTemplate>',
            '                                </DataGridTemplateColumn>',
            '                                <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"         Width="150"/>',
            '                                <DataGridTextColumn Header="First" Binding="{Binding Record.First}"        Width="150"/>',
            '                                <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"           Width="50"/>',
            '                                <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"          Width="100"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Issue_Client_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Issue_Client_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Issue_Client_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Device">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="50"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0" Margin="5">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="150"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Issue_Device_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Issue_Device_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Issue_Device_Result" ItemsSource="{Binding Device}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="250"/>',
            '                                        <DataGridTextColumn Header="Chassis"       Binding="{Binding Record.Chassis}"       Width="100"/>',
            '                                        <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="150"/>',
            '                                        <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="150"/>',
            '                                        <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Client"        Binding="{Binding Record.Client}"        Width="Auto"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Issue_Device_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Issue_Device_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Issue_Device_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Service">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0" Margin="5">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="150"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Issue_Service_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Issue_Service_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid     Grid.Row="1"    Name="Mod_Issue_Service_Result" ItemsSource="{Binding Service}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}" Width="250"/>',
            '                                        <DataGridTextColumn Header="Name"        Binding="{Binding Record.Name}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Cost"        Binding="{Binding Record.Cost}"        Width="80"/>',
            '                                        <DataGridTextColumn Header="Description" Binding="{Binding Record.Description}" Width="300"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Issue_Service_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Issue_Service_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Issue_Service_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                    </TabControl>',
            '                    <DataGrid Grid.Row="2" Name="Mod_Issue_Record_List">',
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
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Purchase_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Purchase_Result" ItemsSource="{Binding Purchase}">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="200"/>',
            '                            <DataGridTextColumn Header="Distributor"   Binding="{Binding Record.Distributor}"   Width="150"/>',
            '                            <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="150"/>',
            '                            <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="150"/>',
            '                            <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="150"/>',
            '                            <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="150"/>',
            '                            <DataGridTemplateColumn Header="IsDevice"   Width="60">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox SelectedIndex="{Binding Record.IsDevice}">',
            '                                            <ComboBoxItem Content="False"/>',
            '                                            <ComboBoxItem Content="True"/>',
            '                                        </ComboBox>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTextColumn Header="Device"        Binding="{Binding Record.Device}"      Width="200"/>                            ',
            '                            <DataGridTextColumn Header="Cost"          Binding="{Binding Record.Cost}"        Width="80"/>',
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
            '                        <RowDefinition Height="110"/>',
            '                        <RowDefinition Height="70"/>',
            '                    </Grid.RowDefinitions>',
            '                    <GroupBox Grid.Row="0" Header="[Display Name]">',
            '                        <TextBox Name="Mod_Purchase_DisplayName"/>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="1" Header="[Distributor]">',
            '                        <TextBox Name="Mod_Purchase_Distributor"/>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="2" Header="[URL]">',
            '                        <TextBox Name="Mod_Purchase_URL"/>',
            '                    </GroupBox>',
            '                    <Grid Grid.Row="3">',
            '                        <Grid.ColumnDefinitions>',
            '                            <ColumnDefinition Width="*"/>',
            '                            <ColumnDefinition Width="*"/>',
            '                            <ColumnDefinition Width="2*"/>',
            '                        </Grid.ColumnDefinitions>',
            '                        <GroupBox Grid.Column="0" Header="[Vendor]">',
            '                            <TextBox Name="Mod_Purchase_Vendor"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Model]">',
            '                            <TextBox Name="Mod_Purchase_Model"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[Specification]">',
            '                            <TextBox Name="Mod_Purchase_Specification"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <GroupBox Grid.Row="4" Header="[Serial]">',
            '                        <TextBox Name="Mod_Purchase_Serial"/>',
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
            '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Purchase_IsDevice">',
            '                                    <ComboBoxItem Content="No"/>',
            '                                    <ComboBoxItem Content="Yes"/>',
            '                                </ComboBox>',
            '                                <ComboBox Grid.Column="1" Name="Mod_Purchase_Device_Property"/>',
            '                                <TextBox  Grid.Column="2" Name="Mod_Purchase_Device_Filter"/>',
            '                            </Grid>',
            '                            <Grid Grid.Row="1">',
            '                                <Grid.ColumnDefinitions>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                </Grid.ColumnDefinitions>',
            '                                <ComboBox Grid.Column="0" Name="Mod_Purchase_Device_Result"/>',
            '                                <Button   Grid.Column="1" Name="Mod_Purchase_Device_Add"    Content="+"/>',
            '                                <ComboBox Grid.Column="2" Name="Mod_Purchase_Device_List"/>',
            '                                <Button   Grid.Column="3" Name="Mod_Purchase_Device_Remove" Content="-"/>',
            '                            </Grid>',
            '                        </Grid>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="6" Header="[Cost]">',
            '                        <TextBox Name="Mod_Purchase_Cost"/>',
            '                    </GroupBox>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Inventory_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Inventory_Result" ItemsSource="{Binding Inventory}">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}" Width="200"/>',
            '                            <DataGridTextColumn Header="Vendor"      Binding="{Binding Record.Vendor}"      Width="150"/>',
            '                            <DataGridTextColumn Header="Model"       Binding="{Binding Record.Model}"       Width="150"/>',
            '                            <DataGridTextColumn Header="Serial"      Binding="{Binding Record.Serial}"      Width="150"/>',
            '                            <DataGridTextColumn Header="Title"       Binding="{Binding Record.Title}"       Width="200"/>',
            '                            <DataGridTemplateColumn Header="IsDevice" Width="75">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox SelectedIndex="{Binding Record.IsDevice}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">',
            '                                            <ComboBoxItem Content="False"/>',
            '                                            <ComboBoxItem Content="True"/>',
            '                                        </ComboBox>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTemplateColumn Header="Device" Width="150">',
            '                                <DataGridTemplateColumn.CellTemplate>',
            '                                    <DataTemplate>',
            '                                        <ComboBox ItemsSource="{Binding Record.Device}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                    </DataTemplate>',
            '                                </DataGridTemplateColumn.CellTemplate>',
            '                            </DataGridTemplateColumn>',
            '                            <DataGridTextColumn Header="Cost"  Binding="{Binding Record.Cost}" Width="80"/>',
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
            '                            <TextBox Name="Mod_Inventory_Vendor"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Model]">',
            '                            <TextBox Name="Mod_Inventory_Model"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="2" Header="[Serial]">',
            '                            <TextBox Name="Mod_Inventory_Serial"/>',
            '                        </GroupBox>',
            '                    </Grid>',
            '                    <Grid Grid.Row="1">',
            '                        <Grid.ColumnDefinitions>',
            '                            <ColumnDefinition Width="*"/>',
            '                            <ColumnDefinition Width="*"/>',
            '                        </Grid.ColumnDefinitions>',
            '                        <GroupBox Grid.Column="0" Header="[Title]">',
            '                            <TextBox Name="Mod_Inventory_Title"/>',
            '                        </GroupBox>',
            '                        <GroupBox Grid.Column="1" Header="[Cost]">',
            '                            <TextBox Name="Mod_Inventory_Cost"/>',
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
            '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Inventory_IsDevice">',
            '                                    <ComboBoxItem Content="No"/>',
            '                                    <ComboBoxItem Content="Yes"/>',
            '                                </ComboBox>',
            '                                <ComboBox Grid.Column="1" Name="Mod_Inventory_Device_Property"/>',
            '                                <TextBox  Grid.Column="2" Name="Mod_Inventory_Device_Filter"/>',
            '                            </Grid>',
            '                            <Grid Grid.Row="1">',
            '                                <Grid.ColumnDefinitions>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                </Grid.ColumnDefinitions>',
            '                                <ComboBox Grid.Column="0" Name="Mod_Inventory_Device_Result"/>',
            '                                <Button   Grid.Column="1" Name="Mod_Inventory_Device_Add"    Content="+"/>',
            '                                <ComboBox Grid.Column="2" Name="Mod_Inventory_Device_List"/>',
            '                                <Button   Grid.Column="3" Name="Mod_Inventory_Device_Remove" Content="-"/>',
            '                            </Grid>',
            '                        </Grid>',
            '                    </GroupBox>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Expense_Filter"/>',
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
            '                        <TextBox Name="Mod_Expense_DisplayName"/>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="1" Header="[Recipient]">',
            '                        <TextBox Name="Mod_Expense_Recipient"/>',
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
            '                                <ComboBox Grid.Column="0" SelectedIndex="0" Name="Mod_Expense_IsAccount">',
            '                                    <ComboBoxItem Content="No"/>',
            '                                    <ComboBoxItem Content="Yes"/>',
            '                                </ComboBox>',
            '                                <ComboBox Grid.Column="1" Name="Mod_Expense_Account_Property"/>',
            '                                <TextBox  Grid.Column="2" Name="Mod_Expense_Account_Filter"/>',
            '                            </Grid>',
            '                            <Grid Grid.Row="1">',
            '                                <Grid.ColumnDefinitions>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                </Grid.ColumnDefinitions>',
            '                                <ComboBox Grid.Column="0" Name="Mod_Expense_Account_Result"/>',
            '                                <Button   Grid.Column="1" Name="Mod_Expense_Account_Add"    Content="+"/>',
            '                                <ComboBox Grid.Column="2" Name="Mod_Expense_Account_List"/>',
            '                                <Button   Grid.Column="3" Name="Mod_Expense_Account_Remove" Content="-"/>',
            '                            </Grid>',
            '                        </Grid>',
            '                    </GroupBox>',
            '                    <GroupBox Grid.Row="3" Header="[Cost]">',
            '                        <TextBox Name="Mod_Expense_Cost"/>',
            '                    </GroupBox>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Account_Filter"/>',
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
            '                                <ComboBox Grid.Column="0" Name="Mod_Account_Object_Property"/>',
            '                                <TextBox  Grid.Column="1" Name="Mod_Account_Object_Filter"/>',
            '                            </Grid>',
            '                            <Grid Grid.Row="1">',
            '                                <Grid.ColumnDefinitions>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                    <ColumnDefinition Width="*"/>',
            '                                    <ColumnDefinition Width="40"/>',
            '                                </Grid.ColumnDefinitions>',
            '                                <ComboBox Grid.Column="0" Name="Mod_Account_Object_Result"/>',
            '                                <Button   Grid.Column="1" Name="Mod_Account_Object_Add"    Content="+"/>',
            '                                <ComboBox Grid.Column="2" Name="Mod_Account_Object_List"/>',
            '                                <Button   Grid.Column="3" Name="Mod_Account_Object_Remove" Content="-"/>',
            '                            </Grid>',
            '                        </Grid>',
            '                    </GroupBox>',
            '                </Grid>',
            '            </Grid>',
            '            <Grid Grid.Row="0">',
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
            '                        <TextBox  Grid.Column="1" Name="Get_Invoice_Filter"/>',
            '                    </Grid>',
            '                    <DataGrid Grid.Row="1" Margin="5" Name="Get_Invoice_Result" ItemsSource="{Binding Invoice}">',
            '                        <DataGrid.Columns>',
            '                            <DataGridTextColumn Header="Date"  Binding="{Binding Record.Date}"  Width="*"/>',
            '                            <DataGridTextColumn Header="Name"  Binding="{Binding Record.Name}"  Width="*"/>',
            '                            <DataGridTextColumn Header="Phone" Binding="{Binding Record.Last}"  Width="*"/>',
            '                            <DataGridTextColumn Header="Email" Binding="{Binding Record.First}" Width="*"/>',
            '                        </DataGrid.Columns>',
            '                    </DataGrid>',
            '                </Grid>',
            '                <Grid Name="Mod_Invoice" Visibility="Collapsed">',
            '                    <Grid.RowDefinitions>',
            '                        <RowDefinition Height="70"/>',
            '                        <RowDefinition Height="*"/>',
            '                        <RowDefinition Height="180"/>',
            '                    </Grid.RowDefinitions>',
            '                    <GroupBox Grid.Row="0" Header="[Mode]">',
            '                        <ComboBox Name="Mod_Invoice_Mode_List"/>',
            '                    </GroupBox>',
            '                    <TabControl Grid.Row="1">',
            '                        <TabItem Header="Client">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Invoice_Client_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Invoice_Client_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Invoice_Client_Result" ItemsSource="{Binding Client}">',
            '                                        <DataGrid.Columns>',
            '                                            <DataGridTextColumn Header="DisplayNameName"  Binding="{Binding Record.DisplayName}"  Width="150"/>',
            '                                            <DataGridTemplateColumn Header="Email" Width="150">',
            '                                                <DataGridTemplateColumn.CellTemplate>',
            '                                                    <DataTemplate>',
            '                                                        <ComboBox ItemsSource="{Binding Record.Email}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                    </DataTemplate>',
            '                                                </DataGridTemplateColumn.CellTemplate>',
            '                                            </DataGridTemplateColumn>',
            '                                            <DataGridTemplateColumn Header="Phone" Width="100">',
            '                                                <DataGridTemplateColumn.CellTemplate>',
            '                                                    <DataTemplate>',
            '                                                        <ComboBox ItemsSource="{Binding Record.Phone}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                    </DataTemplate>',
            '                                                </DataGridTemplateColumn.CellTemplate>',
            '                                            </DataGridTemplateColumn>',
            '                                            <DataGridTextColumn Header="Last"  Binding="{Binding Record.Last}"         Width="150"/>',
            '                                            <DataGridTextColumn Header="First" Binding="{Binding Record.First}"        Width="150"/>',
            '                                            <DataGridTextColumn Header="MI"    Binding="{Binding Record.MI}"           Width="50"/>',
            '                                            <DataGridTextColumn Header="DOB"   Binding="{Binding Record.DOB}"          Width="100"/>',
            '                                        </DataGrid.Columns>',
            '                                    </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Invoice_Client_Add" Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Invoice_Client_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Invoice_Client_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Issue">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Invoice_Issue_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Invoice_Issue_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Invoice_Issue_Result" ItemsSource="{Binding Issue}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName"  Binding="{Binding Record.DisplayName}"   Width="150"/>',
            '                                        <DataGridTextColumn Header="Status"       Binding="{Binding Record.Status}"        Width="100"/>',
            '                                        <DataGridTextColumn Header="Description"  Binding="{Binding Record.Description}"   Width="200"/>',
            '                                        <DataGridTemplateColumn Header="Client" Width="150">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox ItemsSource="{Binding Record.Client}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTemplateColumn Header="Device" Width="150">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox ItemsSource="{Binding Record.Device}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTemplateColumn Header="Service" Width="150">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox ItemsSource="{Binding Record.Service}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Invoice_Issue_Add"    Content="+" />',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Invoice_Issue_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Invoice_Issue_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Purchase">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Invoice_Purchase_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Invoice_Purchase_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Invoice_Purchase_Result" ItemsSource="{Binding Purchase}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName"   Binding="{Binding Record.DisplayName}"   Width="200"/>',
            '                                        <DataGridTextColumn Header="Distributor"   Binding="{Binding Record.Distributor}"   Width="150"/>',
            '                                        <DataGridTextColumn Header="Vendor"        Binding="{Binding Record.Vendor}"        Width="150"/>',
            '                                        <DataGridTextColumn Header="Model"         Binding="{Binding Record.Model}"         Width="150"/>',
            '                                        <DataGridTextColumn Header="Specification" Binding="{Binding Record.Specification}" Width="150"/>',
            '                                        <DataGridTextColumn Header="Serial"        Binding="{Binding Record.Serial}"        Width="150"/>',
            '                                        <DataGridTemplateColumn Header="IsDevice"   Width="60">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox SelectedIndex="{Binding Record.IsDevice}">',
            '                                                        <ComboBoxItem Content="False"/>',
            '                                                        <ComboBoxItem Content="True"/>',
            '                                                    </ComboBox>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTextColumn Header="Device"        Binding="{Binding Record.Device}"      Width="200"/>                            ',
            '                                        <DataGridTextColumn Header="Cost"          Binding="{Binding Record.Cost}"        Width="80"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Invoice_Purchase_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Invoice_Purchase_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Invoice_Purchase_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                        <TabItem Header="Inventory">',
            '                            <Grid>',
            '                                <Grid.RowDefinitions>',
            '                                    <RowDefinition Height="50"/>',
            '                                    <RowDefinition Height="*"/>',
            '                                    <RowDefinition Height="40"/>',
            '                                </Grid.RowDefinitions>',
            '                                <Grid Grid.Row="0">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="120"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <ComboBox Grid.Column="0" Name="Mod_Invoice_Inventory_Property"/>',
            '                                    <TextBox  Grid.Column="1" Name="Mod_Invoice_Inventory_Filter"/>',
            '                                </Grid>',
            '                                <DataGrid Grid.Row="1" Name="Mod_Invoice_Inventory_Result" ItemsSource="{Binding Inventory}">',
            '                                    <DataGrid.Columns>',
            '                                        <DataGridTextColumn Header="DisplayName" Binding="{Binding Record.DisplayName}" Width="200"/>',
            '                                        <DataGridTextColumn Header="Vendor"      Binding="{Binding Record.Vendor}"      Width="150"/>',
            '                                        <DataGridTextColumn Header="Model"       Binding="{Binding Record.Model}"       Width="150"/>',
            '                                        <DataGridTextColumn Header="Serial"      Binding="{Binding Record.Serial}"      Width="150"/>',
            '                                        <DataGridTextColumn Header="Title"       Binding="{Binding Record.Title}"       Width="200"/>',
            '                                        <DataGridTemplateColumn Header="IsDevice" Width="75">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox SelectedIndex="{Binding Record.IsDevice}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center">',
            '                                                        <ComboBoxItem Content="False"/>',
            '                                                        <ComboBoxItem Content="True"/>',
            '                                                    </ComboBox>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTemplateColumn Header="Device" Width="150">',
            '                                            <DataGridTemplateColumn.CellTemplate>',
            '                                                <DataTemplate>',
            '                                                    <ComboBox ItemsSource="{Binding Record.Device}" Margin="0" Padding="2" Height="18" FontSize="10" VerticalContentAlignment="Center"/>',
            '                                                </DataTemplate>',
            '                                            </DataGridTemplateColumn.CellTemplate>',
            '                                        </DataGridTemplateColumn>',
            '                                        <DataGridTextColumn Header="Cost"  Binding="{Binding Record.Cost}" Width="80"/>',
            '                                    </DataGrid.Columns>',
            '                                </DataGrid>',
            '                                <Grid Grid.Row="2">',
            '                                    <Grid.ColumnDefinitions>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                        <ColumnDefinition Width="*"/>',
            '                                        <ColumnDefinition Width="40"/>',
            '                                    </Grid.ColumnDefinitions>',
            '                                    <Button   Grid.Column="0" Name="Mod_Invoice_Inventory_Add"    Content="+"/>',
            '                                    <ComboBox Grid.Column="1" Name="Mod_Invoice_Inventory_List"/>',
            '                                    <Button   Grid.Column="2" Name="Mod_Invoice_Inventory_Remove" Content="-"/>',
            '                                </Grid>',
            '                            </Grid>',
            '                        </TabItem>',
            '                    </TabControl>',
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

    Class UID
    {
        [Object] $UID
        [UInt32] $Index
        [UInt32] $Slot
        [Object] $Type
        [Object] $Date
        [Object] $Time
        [UInt32] $Sort
        [Object] $Record
        UID([UInt32]$Index,[UInt32]$Slot)
        {
            $This.UID    = New-GUID | % GUID
            $This.Index  = $Index
            $This.Slot   = $Slot
            $This.Type   = ("Client Service Device Issue Purchase Inventory Expense Account Invoice" -Split " ")[$Slot]
            $This.Date   = Get-Date -UFormat "%m/%d/%Y"
            $This.Time   = Get-Date -UFormat "%H:%M:%S"
            $This.Sort   = 0
        }
        [String] ToString()
        {
            Return $This.Slot
        }
    }

    Class Client
    {
        [Object]         $UID
        [UInt32]       $Index
        [UInt32]        $Slot
        [Object]        $Type
        [Object]        $Date
        [Object]        $Time
        [UInt32]        $Sort
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
        [Object[]]     $Issue
        [Object[]]   $Invoice
        Client([Object]$UID,[UInt32]$Rank)
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Phone   = @( )
            $This.Email   = @( )
            $This.Device  = @( )
            $This.Issue   = @( )
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
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]          $Name
        [String]   $Description
        [Float]           $Cost
        Service([Object]$UID,[UInt32]$Rank) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
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
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]       $Chassis
        [String]        $Vendor
        [String]         $Model
        [String] $Specification
        [String]        $Serial
        [Object]        $Client
        Device([Object]$UID,[UInt32]$Rank) 
        { 
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
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
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]        $Status
        [String]   $Description
        [Object]        $Client
        [Object]        $Device
        [Object[]]     $Service
        Issue([Object]$UID,[UInt32]$Rank)
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Service  = @( )
        }
        [String] ToString()
        {
            Return "Issue"
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
        [Object]          $Sort
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
        Purchase([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
        }
        [String] ToString()
        {
            Return "Purchase"
        }
    }

    Class Inventory
    {
        [Object]           $UID
        [UInt32]         $Index
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [String]        $Vendor
        [String]         $Model
        [String]        $Serial
        [Object]         $Title
        [Object]          $Cost
        [Bool]        $IsDevice
        [Object]        $Device
        Inventory([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Device = @( )
        }
        [String] ToString()
        {
            Return "Inventory"
        }
    }

    Class Expense
    {
        [Object]           $UID
        [UInt32]         $Index
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [Object]   $DisplayName
        [Object]     $Recipient
        [Object]     $IsAccount
        [Object]       $Account
        [Object]          $Cost
        Expense([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
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
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [Object]        $Object
        Account([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank
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
        [UInt32]          $Slot
        [Object]          $Type
        [Object]          $Date
        [Object]          $Time
        [UInt32]          $Sort
        [UInt32]          $Rank
        [String]   $DisplayName
        [UInt32]          $Mode
        [Object]        $Client
        [Object[]]       $Issue
        [Object[]]    $Purchase
        [Object[]]   $Inventory
        Invoice([Object]$UID,[UInt32]$Rank) 
        {
            $This.UID  = $UID.UID
            $This.Slot = $UID.Slot
            $This.Type = $UID.Type
            $This.Date = $UID.Date
            $This.Time = $UID.Time
            $This.Sort = $UID.Sort
            $This.Rank = $Rank

            $This.Issue     = @( )
            $This.Purchase  = @( )
            $This.Inventory = @( )
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
        [Object[]]    $Purchase
        [Object[]]   $Inventory
        [Object[]]     $Expense
        [Object[]]     $Account
        [Object[]]     $Invoice
        [Object[]]      $Sorted
        DB()
        {
            $This.UID       = @( )
            $This.Client    = @( )
            $This.Service   = @( )
            $This.Device    = @( )
            $This.Issue     = @( )
            $This.Purchase  = @( )
            $This.Inventory = @( )
            $This.Expense   = @( )
            $This.Account   = @( )
            $This.Invoice   = @( )  
            $This.Sorted    = @( )
        }
        [Object] NewUID([Object]$Slot)
        {
            If ($Slot -notin 0..8)
            {
                Throw "Invalid entry"
            }

            $Item                = [UID]::New($This.UID.Count,$Slot)
            $Type                = $Item.Type
            $X                   = $This.$Type.Count
            $Item.Record         = Switch ($Slot)
            {
                0 { [Client]::New($Item,$X)    } 1 { [Service]::New($Item,$X)   } 2 { [Device]::New($Item,$X)    }
                3 { [Issue]::New($Item,$X)     } 4 { [Purchase]::New($Item,$X)  } 5 { [Inventory]::New($Item,$X) } 
                6 { [Expense]::New($Item,$X)   } 7 { [Account]::New($Item,$X)   } 8 { [Invoice]::New($Item,$X)   }
            }

            $Item.Record.Index   = $This.UID.Count
            $Item.Record.Rank    = $X

            Switch($Slot)
            {
                0 { $This.Client     += $Item } 1 { $This.Service    += $Item } 2 { $This.Device     += $Item }
                3 { $This.Issue      += $Item } 4 { $This.Purchase   += $Item } 5 { $This.Inventory  += $Item }
                6 { $This.Expense    += $Item } 7 { $This.Account    += $Item } 8 { $This.Invoice    += $Item }
            }

            $This.UID           += $Item

            Return $Item
        }
        [Object] GetUID([Object]$UID)
        {
            Return $This.UID | ? UID -match $UID
        }
        [Void] SortUID([Object]$UID)
        {
            $Item             = $This.GetUID($UID)
            $Type             = $Item.Type
            $Item.Slot        = 9
            $Item.Type        = "Sorted"
            $Item.Record.Rank = $This.Sorted.Count
            $Item.Sort        = 1
            $This.Sorted     += $Item

            $This.$Type       = @( $This.$Type | ? Type -ne "Sorted" )
            $X                = 0
            ForEach ( $Object in $This.$Type )
            {
                $Object.Record.Rank = $X
                $X ++
            }
        }
    }

    Class Template
    {
        [String[]] $UID
        [String[]] $Client
        [String[]] $Service
        [String[]] $Device
        [String[]] $Issue
        [String[]] $Purchase
        [String[]] $Inventory
        [String[]] $Expense
        [String[]] $Account
        [String[]] $Invoice
        Template()
        {
            $This.UID          = "UID","Index","Slot","Date"
            $This.Client       = @($This.UID;"Rank","DisplayName","Email","Phone","Last","First","DOB")
            $This.Service      = @($This.UID;"Rank","DisplayName","Name","Cost","Description")
            $This.Device       = @($This.UID;"Rank","DisplayName","Chassis","Vendor","Model","Specification","Serial","Client")
            $This.Issue        = @($This.UID;"Rank","Status","Description","Client","Device")
            $This.Purchase     = @($This.UID;"Rank","Distributor","Vendor","Serial","Model","IsDevice","Device","Cost")
            $This.Inventory    = @($This.UID;"Rank","Vendor","Model","Serial","Title","Cost","IsDevice","Device")
            $This.Expense      = @($This.UID;"Rank","Recipient","Account","Cost")
            $This.Account      = @($This.UID;"Rank","Object")
            $This.Invoice      = @($This.UID;"DisplayName","Mode","Phone","Email")
        }
    }

    Class Main
    {
        [String[]]       $Slot = ("UID Client Service Device Issue Purchase Inventory Expense Account Invoice" -Split " ")
        [UInt32]            $X
        [UInt32]            $Y
        [String]      $Current
        [Object]           $DB
        [Object]         $Xaml
        [Object]         $Temp
        [Object[]]      $Names
        [Object]     $Selected
        Main([Object]$Xaml)
        {
            $This.DB       = [DB]::New()
            $This.Xaml     = $Xaml
            $This.Temp     = [Template]::New()
            $This.Names    = $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % { [DGList]::New($_,$This.Xaml.IO.$_.GetType().Name) }
        }
        Collapse()
        {
            $This.Names    | ? Value -eq TextBox | % { $This.Xaml.IO.$($_.Name).Text       = ""          }
            $This.Names    | ? Name -match Grid  | % { $This.Xaml.IO.$($_.Name).Visibility = "Collapsed" }
        }
        Menu([UInt32]$X)
        {
            $This.X                       = $X
            $This.Y                       = 0
            $This.Collapse()
            $This.Current                 = $This.Slot[$X]
            $Sx                           = $This.Current
            $Gx                           = "Get_{0}"        -f $Sx
            $Mx                           = "Mod_{0}"        -f $Sx
            $Dg                           = "Get_{0}_Result" -f $Sx
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
            }

            Else
            {
                $This.Xaml.IO.View.IsEnabled    = 0
                $This.Xaml.IO.New.IsEnabled     = 1
                $This.Xaml.IO.Edit.IsEnabled    = 0
                $This.Xaml.IO.Save.IsEnabled    = 0
                $This.Xaml.IO.Delete.IsEnabled  = 0
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
            $This.Collapse()
            $This.Current                 = $This.Slot[$This.X]
            $Sx                           = $This.Current
            $Gx                           = "Get_{0}"        -f $Sx
            $Mx                           = "Mod_{0}"        -f $Sx
            $Dg                           = "Get_{0}_Result" -f $Sx
            $This.Xaml.IO.$Gx.Visibility  = "Collapsed"
            $This.Xaml.IO.$Mx.Visibility  = "Visible"
            $This.Xaml.IO.$Dg.ItemsSource = @( )
            $This.Xaml.IO.$Dg.ItemsSource = @( $This.DB.$Sx )
        }
        View([String]$UID)
        {
            $Item = $This.DB.GetUID($UID)

            Switch($This.Current)
            {
                UID
                {
                    $This.Xaml.IO.Mod_UID_UID.Text                       = $Item.UID
                    $This.Xaml.IO.Mod_UID_Index.Text                     = $Item.Index
                    $This.Xaml.IO.Mod_UID_Slot.Text                      = $Item.Slot
                    $This.Xaml.IO.Mod_UID_Type.Text                      = $Item.Type
                    $This.Xaml.IO.Mod_UID_Date.Text                      = $Item.Date
                    $This.Xaml.IO.Mod_UID_Time.Text                      = $Item.Time
                    $This.Xaml.IO.Mod_UID_Record.ItemsSource             = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
                Client
                {
                    $This.Xaml.IO.Mod_Client_Last.Text                   = $Item.Record.Last
                    $This.Xaml.IO.Mod_Client_First.Text                  = $Item.Record.First
                    $This.Xaml.IO.Mod_Client_MI.Text                     = $Item.Record.MI
                    $This.Xaml.IO.Mod_Client_Gender.SelectedIndex        = @(0,1)[$Item.Record.Gender]
                    $This.Xaml.IO.Mod_Client_Address.Text                = $Item.Record.Address
                    $This.Xaml.IO.Mod_Client_Month.Text                  = $Item.Record.Month
                    $This.Xaml.IO.Mod_Client_Day.Text                    = $Item.Record.Day
                    $This.Xaml.IO.Mod_Client_Year.Text                   = $Item.Record.Year
                    $This.Xaml.IO.Mod_Client_City.Text                   = $Item.Record.City
                    $This.Xaml.IO.Mod_Client_Region.Text                 = $Item.Record.Region
                    $This.Xaml.IO.Mod_Client_Country.Text                = $Item.Record.Country
                    $This.Xaml.IO.Mod_Client_Postal.Text                 = $Item.Record.Postal
                    $This.Xaml.IO.Mod_Client_Phone_List.ItemsSource      = @($Item.Record.Phone)
                    $This.Xaml.IO.Mod_Client_Email_List.ItemsSource      = @($Item.Record.Email)
                    $This.Xaml.IO.Mod_Client_Device_List.ItemsSource     = @($Item.Record.Device)
                    $This.Xaml.IO.Mod_Client_Issue_List.ItemsSource      = @($Item.Record.Issue)
                    $This.Xaml.IO.Mod_Client_Invoice_List.ItemsSource    = @($Item.Record.Invoice)
                }
                Service
                {
                    $This.Xaml.IO.Mod_Service_Name.Text                  = $Item.Record.Name
                    $This.Xaml.IO.Mod_Service_Description.Text           = $Item.Record.Description
                    $This.Xaml.IO.Mod_Service_Cost.Text                  = $Item.Record.Cost
                }
                Device
                {
                    $This.Xaml.IO.Mod_Device_DisplayName.Text            = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Device_Chassis_List.SelectedIndex  = @{ Desktop = 0; Laptop = 1; Smartphone = 2; Tablet = 3; Console = 4; Server = 5; Network = 6; Other = 7; "-" = 8 }[$Item.Record.Chassis]
                    $This.Xaml.IO.Mod_Device_Vendor.Text                 = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Device_Model.Text                  = $Item.Record.Model
                    $This.Xaml.IO.Mod_Device_Specification.Text          = $Item.Record.Specfication
                    $This.Xaml.IO.Mod_Device_Serial.Text                 = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Device_Client_Result.ItemsSource   = @($Item.Record.Client)
                }
                Issue
                {
                    $This.Xaml.IO.Mod_Issue_Status_List.SelectedIndex    = @{ "-" = 0; New = 1; Diagnosed = 2; Commit = 3; Complete = 4}[$Item.Record.Status]
                    $This.Xaml.IO.Mod_Issue_Description.Text             = $Item.Record.Description
                    $This.Xaml.IO.Mod_Issue_Client_List.ItemsSource      = $Item.Record.Client
                    $This.Xaml.IO.Mod_Issue_Device_List.ItemsSource      = $Item.Record.Device
                    $This.Xaml.IO.Mod_Issue_Service_List.ItemsSource     = @($Item.Record.Service)
                    $This.Xaml.IO.Mod_Issue_Record_List.ItemsSource      = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
                Purchase
                {
                    $This.Xaml.IO.Mod_Purchase_DisplayName.Text          = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Purchase_Distributor.Text          = $Item.Record.Distributor
                    $This.Xaml.IO.Mod_Purchase_URL.Text                  = $Item.Record.URL
                    $This.Xaml.IO.Mod_Purchase_Vendor.Text               = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Purchase_Model.Text                = $Item.Record.Model
                    $This.Xaml.IO.Mod_Purchase_Specification.Text        = $Item.Record.Specification
                    $This.Xaml.IO.Mod_Purchase_Serial.Text               = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Purchase_IsDevice.SelectedIndex    = @(0,1)[$Item.Record.IsDevice]
                    $This.Xaml.IO.Mod_Purchase_Device_List.ItemsSource   = $Item.Record.Device
                    $This.Xaml.IO.Mod_Purchase_Cost.Text                 = $Item.Record.Cost
                }
                Inventory
                {
                    $This.Xaml.IO.Mod_Inventory_Vendor.Text              = $Item.Record.Vendor
                    $This.Xaml.IO.Mod_Inventory_Model.Text               = $Item.Record.Model
                    $This.Xaml.IO.Mod_Inventory_Serial.Text              = $Item.Record.Serial
                    $This.Xaml.IO.Mod_Inventory_Title.Text               = $Item.Record.Title
                    $This.Xaml.IO.Mod_Inventory_Cost.Text                = $Item.Record.Cost
                    $This.Xaml.IO.Mod_Inventory_IsDevice.SelectedIndex   = @(0,1)[$Item.Record.IsDevice]
                    $This.Xaml.IO.Mod_Inventory_Device_List.ItemsSource  = $Item.Record.Device
                }
                Expense
                {
                    $This.Xaml.IO.Mod_Expense_DisplayName.Text           = $Item.Record.DisplayName
                    $This.Xaml.IO.Mod_Expense_Recipient.Text             = $Item.Record.Recipient
                    $This.Xaml.IO.Mod_Expense_IsAccount.SelectedIndex    = @(0,1)[$Item.Record.IsAccount]
                    $This.Xaml.IO.Mod_Expense_Account_List.ItemsSource   = $Item.Record.Account
                    $This.Xaml.IO.Mod_Expense_Cost.Text                  = $Item.Record.Cost
                }
                Account
                {
                    $This.Xaml.IO.Mod_Account_Object_List.ItemsSource    = @($Item.Record.Object)
                }
                Invoice
                {
                    $This.Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex    = @{ Quick = 0 ; Default = 1 }[$Item.Record.Mode]
                    $This.Xaml.IO.Mod_Invoice_Client_List.ItemsSource    = @($Item.Record.Client)
                    $This.Xaml.IO.Mod_Invoice_Issue_List.ItemsSource     = @($Item.Record.Issue)
                    $This.Xaml.IO.Mod_Invoice_Purchase_List.ItemsSource  = @($Item.Record.Purchase)
                    $This.Xaml.IO.Mod_Invoice_Inventory_List.ItemsSource = @($Item.Record.Inventory)

                    $This.Xaml.IO.Mod_Invoice_Record_List.ItemsSource    = ForEach ( $Object in $Item.Record | Get-Member | ? MemberType -eq Property | % Name ) 
                    {
                        [DGList]::New($Object,$Item.Record.$Object)
                    }
                }
            }
        }
    }

    $Xaml = [XamlWindow][cimdbGUI]::Tab

    $Temp = $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % { [DGList]::New($_,$Xaml.IO.$_.GetType().Name) }

    # Open ComboBox/DataGrid ItemsSource
    $Xaml.Names | ? { $_ -match "(Result|Property)" } | % { $Xaml.IO.$_.ItemsSource = @( ) }
    $Temp = [Template]::New()

    # Stage ComboBox Items
    $Xaml.Names | ? { $_ -match "(Property)" } | % { 

        $Xaml.IO.$_.ItemsSource = Switch -Regex ($_)
        {
            UID_Property       { $Temp.UID       } Client_Property    { $Temp.Client    } 
            Service_Property   { $Temp.Service   } Device_Property    { $Temp.Device    } 
            Issue_Property     { $Temp.Issue     } Purchase_Property  { $Temp.Purchase  }
            Inventory_Property { $Temp.Inventory } Expense_Property   { $Temp.Expense   } 
            Account_Property   { $Temp.Account   } Invoice_Property   { $Temp.Invoice   }
        }
        $Xaml.IO.$_.SelectedIndex = 0
    }

    $Main = [Main]::New($Xaml)

    0..100 | % { $X = Get-Random -Minimum 0 -Maximum 9; $Main.DB.NewUID($X) }

    $Xaml.IO.UID_Tab.Add_Click(        { $Main.Menu(0) } )
    $Xaml.IO.Client_Tab.Add_Click(     { $Main.Menu(1) } )
    $Xaml.IO.Service_Tab.Add_Click(    { $Main.Menu(2) } )
    $Xaml.IO.Device_Tab.Add_Click(     { $Main.Menu(3) } )
    $Xaml.IO.Issue_Tab.Add_Click(      { $Main.Menu(4) } )
    $Xaml.IO.Purchase_Tab.Add_Click(   { $Main.Menu(5) } )
    $Xaml.IO.Inventory_Tab.Add_Click(  { $Main.Menu(6) } )
    $Xaml.IO.Expense_Tab.Add_Click(    { $Main.Menu(7) } )
    $Xaml.IO.Account_Tab.Add_Click(    { $Main.Menu(8) } )
    $Xaml.IO.Invoice_Tab.Add_Click(    { $Main.Menu(9) } )

    # View
    $Xaml.IO.View.Add_Click(
    {
        $Main.Selected = $Xaml.IO."Get_$($Main.Current)_Result".Items[$Xaml.IO."Get_$($Main.Current)_Result".SelectedIndex]
        $Main.Mode(0)
        $Main.Names    | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 0 }

        $Main.View($Main.Selected.UID)
    })

    # New
    $Xaml.IO.New.Add_Click(            
    { 
        $Main.Mode(1)
        $Main.Names    | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 1  }
        $Main.TextBox  | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).Text      = "" }
    })

    # Edit
    $Xaml.IO.Edit.Add_Click(           
    {
        $Main.Selected = $Xaml.IO."Get_$($Main.Current)_Result".SelectedItem
        $Main.Mode(2)
        $Main.TextBox  | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 1 }
        $Main.Button   | ? Name -match "Mod_$($Main.Current)" | % { $Xaml.IO.$($_.Name).IsEnabled = 1 }

        $Main.View($Main.Selected.UID)
    })

    # Save
    $Xaml.IO.Save.Add_Click(           
    {
        If ($Mode.Y -eq 2)
        {
            $Main.DB.SortUID($Main.Selected.GUID)
        }

        Switch($Main.Current)
        {
            Client
            {
                # Email
                If ($Xaml.IO.Mod_Client_Email_List.Items.Count -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Must specify an email address","Error")
                }

                If ($Xaml.IO.Mod_Client_Email_List.Items.Count -gt 0)
                {
                    ForEach ($Email in $Xaml.IO.Mod_Client_Email_List.Items)
                    {
                        If ($Email -in $Main.DB.Client.Record.Email)
                        {
                            Throw [System.Windows.MessageBox]::Show("That email address is already used in another account","Error")
                        }
                    }
                }

                # Phone
                If ($Xaml.IO.Mod_Client_Phone_List.Items.Count -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Must specify an email address","Error")
                }

                If ($Xaml.IO.Mod_Client_Email_List.Items.Count -gt 0)
                {
                    ForEach ($Phone in $Xaml.IO.Mod_Client_Phone_List.Items)
                    {
                        If ($Email -in $Main.DB.Client.Record.Phone)
                        {
                            Throw [System.Windows.MessageBox]::Show("That phone number is already used in another account","Error")
                        }
                    }
                }

                # Name
                If ($Xaml.IO.Mod_Client_Last.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Last name missing","Error")
                }
                
                If ($Xaml.IO.Mod_Client_First.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("First name missing","Error")
                }

                If ($Xaml.IO.Mod_Client_MI.Text.Length -ne 0)
                {
                    $DisplayName = "{0}, {1} {2}." -f $Xaml.IO.Mod_Client_Last.Text,$Xaml.IO.Mod_Client_First.Text,$Xaml.IO.Mod_Client_MI.Text
                }

                If ($Xaml.IO.Mod_Client_MI.Text.Length -eq 0)
                {
                    $DisplayName = "{0}, {1}" -f $Xaml.IO.Mod_Client_Last.Text,$Xaml.IO.Mod_Client_First.Text
                }

                If ( $Xaml.IO.Mod_Client_Month.Text -notin 1..12 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid DOB/month","Error")
                }

                If ( $Xaml.IO.Mod_Client_Day.Text -notin 1..31 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid DOB/day","Error")
                }

                If ( $Xaml.IO.Mod_Client_Year.Text -notin 1900..[UInt32](Get-Date -UFormat %Y))
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid DOB/year","Error")
                }

                $DOB = "{0}/{1}/{2}" -f $Xaml.IO.Mod_Client_Month.Text,$Xaml.IO.Mod_Client_Day.Text,$Xaml.IO.Mod_Client_Year.Text

                If ($Full -in $Main.DB.Client.Record.DisplayName -and $DOB -in $Main.DB.Client.Record.DOB )
                {
                    Throw [System.Windows.MessageBox]::Show("The customer is already in the database","Error")
                }

                If ( $Xaml.IO.Mod_Client_Gender.SelectedItem.Content -eq "-" )
                {
                    Throw [System.Windows.MessageBox]::Show("Gender missing","Error")
                }

                If ( $Xaml.IO.Mod_Client_Address.Text.Length -eq 0 )
                {
                    Throw [System.Windows.MessageBox]::Show("Address missing","Error")
                }

                If ( $Xaml.IO.Mod_Client_City.Text.Length -eq 0 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid town/city","Error")
                }

                If ( $Xaml.IO.Mod_Client_Region.Text.Length -eq 0 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid region/state","Error")
                }

                If ( $Xaml.IO.Mod_Client_Country.Text.Length -eq 0 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid country","Error")
                }

                If ( $Xaml.IO.Mod_Client_Postal.Text.Length -ne 5 )
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid town/city","Error")
                }

                $Item                                 = $Main.DB.NewUID(0)
                $Item.Record.DisplayName              = $DisplayName
                $Item.Record.Last                     = $Xaml.IO.Mod_Client_Last.Text 
                $Item.Record.First                    = $Xaml.IO.Mod_Client_First.Text
                $Item.Record.MI                       = $Xaml.IO.Mod_Client_MI.Text
                $Item.Record.Gender                   = @(0,1)[$Xaml.IO.Mod_Client_Gender.SelectedIndex]
                $Item.Record.Address                  = $Xaml.IO.Mod_Client_Address.Text
                $Item.Record.Month                    = $Xaml.IO.Mod_Client_Month.Text
                $Item.Record.Day                      = $Xaml.IO.Mod_Client_Day.Text
                $Item.Record.Year                     = $Xaml.IO.Mod_Client_Year.Text
                $Item.Record.DOB                      = $DOB
                $Item.Record.City                     = $Xaml.IO.Mod_Client_City.Text 
                $Item.Record.Region                   = $Xaml.IO.Mod_Client_Region.Text
                $Item.Record.Country                  = $Xaml.IO.Mod_Client_Country.Text
                $Item.Record.Postal                   = $Xaml.IO.Mod_Client_Postal.Text
                $Item.Record.Phone                    = @($Xaml.IO.Mod_Client_Phone_List.Items)
                $Item.Record.Email                    = @($Xaml.IO.Mod_Client_Email_List.Items)
                $Item.Record.Device                   = @($Xaml.IO.Mod_Client_Device_List.Items)
                $Item.Record.Invoice                  = @($Xaml.IO.Mod_Client_Invoice_List.Items)

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(1)
            }
            Service
            {
                If ($Xaml.IO.Mod_Service_Name.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No service name listed","Error")
                }

                If ($Xaml.IO.Mod_Service_Description.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No service description listed","Error")
                }

                If ($Xaml.IO.Mod_Service_Cost.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No service cost listed","Error")
                }

                $DisplayName = "{0}/{1}" -f $Xaml.IO.Mod_Service_Name.Text, $Xaml.IO.Mod_Service_Cost.Text

                If ( $DisplayName -in $Main.DB.Service.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("That service is already in the database","Error")
                }

                $Item                    = $Main.DB.NewUID(1)
                $Item.Record.DisplayName = $DisplayName
                $Item.Record.Name        = $Xaml.IO.Mod_Service_Name.Text
                $Item.Record.Description = $Xaml.IO.Mod_Service_Description.Text
                $Item.Record.Cost        = [Float]($Xaml.IO.Mod_Service_Cost.Text.TrimStart("$"))

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(2)
            }
            Device
            {
                If ($Xaml.IO.Mod_Device_Chassis_List.SelectedIndex -eq 8)
                {
                    Throw [System.Windows.MessageBox]::Show("Must select a chassis type","Error")
                }
                
                If ($Xaml.IO.Mod_Device_Vendor.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Missing a vendor name","Error") 
                }

                If ($Xaml.IO.Mod_Device_Model.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Missing a model name","Error")
                }

                If ($Xaml.IO.Mod_Device_Specification.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Missing a specification","Error")
                }

                If ($Xaml.IO.Mod_Device_Serial.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Missing a serial number","Error")
                }

                $DisplayName = "{0}/{1}/{2}/{3}" -f @($Xaml.IO.Mod_Device_Vendor.Text,
                                                      $Xaml.IO.Mod_Device_Model.Text,
                                                      $Xaml.IO.Mod_Device_Specification.Text,
                                                      $Xaml.IO.Mod_Device_Serial.Text)
                
                If ($DisplayName -in $Mod.DB.Device.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("That device is already registered","Error")
                }

                If ($Xaml.IO.Mod_Device_Client_List.Items.Count -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No client was attached to the device","Error" )
                }

                $Item                      = $Main.DB.NewUID(2)
                $Item.Record.DisplayName   = $DisplayName
                $Item.Record.Chassis       = $Xaml.IO.Mod_Device_Chassis_List.SelectedItem.Content
                $Item.Record.Vendor        = $Xaml.IO.Mod_Device_Vendor.Text
                $Item.Record.Model         = $Xaml.IO.Mod_Device_Model.Text
                $Item.Record.Specification = $Xaml.IO.Mod_Device_Specification.Text
                $Item.Record.Serial        = $Xaml.IO.Mod_Device_Serial.Text

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(3)
            }
            Issue
            {
                If ($Xaml.IO.Mod_Issue_Status_List.SelectedIndex -eq 4)
                {
                    Throw [System.Windows.MessageBox]::Show("Must select an issue status","Error")
                }

                If ($Xaml.IO.Mod_Issue_Description.Text -eq "")
                {
                    Throw [System.Windows.MessageBox]::Show("Must enter in a description","Error")
                }

                If ($Xaml.IO.Mod_Issue_Client_List.Items.Count -ne 1)
                {
                    Throw [System.Windows.MessageBox]::Show("Must assign (1) client to the issue","Error")
                }

                If ($Xaml.IO.Mod_Issue_Device_List.Items.Count -ne 1)
                {
                    Throw [System.Windows.MessageBox]::Show("Must assign (1) device to the issue","Error")
                }

                If ($Xaml.IO.Mod_Issue_Service_List.Items.Count -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Must assign at least (1) service to the issue","Error")
                }

                $DisplayName = "{0}/{1}/{2}" -f @($Xaml.IO.Mod_Issue_Status_List.SelectedItem.Content,
                                                  $Xaml.IO.Mod_Issue_Client_List.SelectedItem.Content,
                                                  $Xaml.IO.Mod_Issue_Device_List.SelectedItem.Content)

                If ($DisplayName -in $Main.DB.Issue.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("That status/client/device is already in the system","Error")
                }

                $Item                    = $Main.DB.NewUID(3)
                $Item.Record.DisplayName = $DisplayName
                $Item.Record.Status      = $Xaml.IO.Mod_Issue_Status_List.SelectedItem.Content
                $Item.Record.Description = $Xaml.IO.Mod_Issue_Description.Text
                $Item.Record.Client      = $Xaml.IO.Mod_Issue_Client_List.SelectedItem.Content
                $Item.Record.Device      = $Xaml.IO.Mod_Issue_Device_List.SelectedItem.Content
                $Item.Record.Service     = @($Xaml.IO.Mod_Issue_Service_List.Items)

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(4)
            }
            Purchase
            {
                If ($Xaml.IO.Mod_Purchase_Distributor.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Distributor cannot be left blank","Error")
                }

                If ($Xaml.IO.Mod_Purchase_URL.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Purchase URL cannot be blank","Error")
                }

                If ($Xaml.IO.Mod_Purchase_Vendor.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Invalid vendor","Error")
                }
                
                If ($Xaml.IO.Mod_Purchase_Model.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Invalid model name","Error")
                }

                If ($Xaml.IO.Mod_Purchase_Specification.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Invalid specification","Error")
                }   

                If ($Xaml.IO.Mod_Purchase_Serial.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::New("Serial cannot be blank, use (N/A) if necessary","Error")
                }

                If ($Xaml.IO.Mod_Purchase_IsDevice.SelectedItem -eq "True")
                {
                    If ($Xaml.IO.Mod_Purchase_Device_List.Items.Count -ne 1)
                    {
                        Throw [System.Windows.MessageBox]::Show("If this is a device, create the device and select it","Error")
                    }
                }

                If ($Xaml.IO.Mod_Purchase_Cost.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Cost cannot be left blank","Error")
                }

                $DisplayName              = "{0}/{1}/{2}/{3}" -f @($Xaml.IO.Mod_Purchase_Distributor.Text
                                                                   $Xaml.IO.Mod_Purchase_Vendor.Text,
                                                                   $Xaml.IO.Mod_Purchase_Model.Text,
                                                                   $Xaml.IO.Mod_Purchase_Specification.Text)
                If ($DisplayName -in $Main.DB.Purchase.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("That item already exists in the database","Error")
                }

                $Item                      = $Main.DB.NewUID(4)
                $Item.Record.DisplayName   = $DisplayName
                $Item.Record.Distributor   = $Xaml.IO.Mod_Purchase_Distributor.Text
                $Item.Record.URL           = $Xaml.IO.Mod_Purchase_URL.Text
                $Item.Record.Vendor        = $Xaml.IO.Mod_Purchase_Vendor.Text
                $Item.Record.Model         = $Xaml.IO.Mod_Purcahse_Model.Text
                $Item.Record.Specification = $Xaml.IO.Mod_Purchase_Specification.Text
                $Item.Record.Serial        = $Xaml.IO.Mod_Purchase_Serial.Text
                $Item.Record.IsDevice      = @(0,1)[$Xaml.IO.Mod_Purchase_IsDevice]
                If ($Item.Record.IsDevice -eq $True)
                {
                    $Item.Record.Device    = $Xaml.IO.Mod_Purchase_Device.SelectedItem.Content
                }
                $Item.Record.Cost          = [Float]($Xaml.IO.Mod_Purchase_Cost.Text.TrimStart("$"))

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(5)
            }
            Inventory
            {
                If ($Xaml.IO.Mod_Inventory_Vendor.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid vendor specified","Error")
                }

                If ($Xaml.IO.Mod_Inventory_Model.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid model specified","Error")
                }

                If ($Xaml.IO.Mod_Inventory_Serial.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Invalid serial specified","Error")
                }

                If ($Xaml.IO.Mod_Inventory_Title.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Title not listed","Error")
                }

                If ($Xaml.IO.Mod_Inventory_Cost.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Cost not listed","Error")
                }

                If ($Xaml.IO.Mod_Inventory_IsDevice.SelectedItem.Content -eq "True" )
                {
                    If ($Xaml.IO.Mod_Inventory_Device_List.Items.Count -ne 1)
                    {
                        Throw [System.Windows.MessageBox]::Show("If this is a device, must specify (1) device","Error")
                    }
                }

                $DisplayName = "{0}/{1}/{2}/{3}" -f @($Xaml.IO.Mod_Inventory_Title.Text,
                                                      $Xaml.IO.Mod_Inventory_Vendor.Text,
                                                      $Xaml.IO.Mod_Inventory_Model.Text,
                                                      $Xaml.IO.Mod_Inventory_Serial.Text)
                
                If ($DisplayName -in $Main.DB.Inventory.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("There is an item already in the inventory with these attributes","Error")
                }

                $Item                     = $Main.DB.NewUID(5)
                $Item.Record.DisplayName  = $DisplayName
                $Item.Record.Vendor       = $Xaml.IO.Mod_Inventory_Vendor.Text
                $Item.Record.Model        = $Xaml.IO.Mod_Inventory_Model.Text
                $Item.Record.Serial       = $Xaml.IO.Mod_Inventory_Serial.Text
                $Item.Record.Title        = $Xaml.IO.Mod_Inventory_Title.Text
                $Item.Record.Cost         = [Float]($Xaml.IO.Mod_Inventory_Cost.Text.TrimStart("$"))
                $Item.Record.IsDevice     = @(0,1)[$Xaml.IO.Mod_Inventory_IsDevice.SelectedIndex]
                If ($Item.Record.IsDevice -eq $True)
                {
                    $Item.Record.Device   = $Xaml.IO.Mod_Inventory_Device.SelectedItem.Content
                }

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(6)
            }
            Expense
            {
                If ($Xaml.IO.Mod_Expense_DisplayName.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Enter a display name for the expense","Error")
                }

                If ($Xaml.IO.Mod_Expense_Recipient.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No recipient specified","Error")
                }

                If ($Xaml.IO.Mod_Expense_IsAccount.SelectedItem.Content -eq "True")
                {
                    If ($Xaml.IO.Mod_Expense_Account_List.Items.Count -ne 1)
                    {
                        Throw [System.Windows.MessageBox]::Show("If this is an account, specify the account","Error")
                    }
                }

                If ($Xaml.IO.Mod_Expense_Cost.Text.Length -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("No cost associated with the expense","Error")
                }

                If ($Xaml.IO.Mod_Expense_DisplayName.Text -in $Main.DB.Expense.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("An expense with that name is already in the database","Error")
                }

                $Item               = $Main.DB.NewUID(6)
                $Item.Record.DisplayName = $Xaml.IO.Mod_Expense_DisplayName.Text
                $Item.Record.Recipient   = $Xaml.IO.Mod_Expense_Recipient.Text
                $Item.Record.IsAccount   = @(0,1)[$Xaml.IO.Mod_Expense_IsAccount.SelectedIndex]
                If ($Item.Record.IsAccount -eq $True)
                {
                    $Item.Record.Account = $Xaml.IO.Mod_Expense_Account.SelectedItem.Content
                }
                $Item.Record.Cost        = [Float]($Xaml.IO.Mod_Expense_Cost.Text.TrimStart("$"))

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(7)
            }
            Account
            {
                If ($Xaml.IO.Mod_Account_Object_List.Items.Count -eq 0)
                {
                    Throw [System.Windows.MessageBox]::Show("Must specify an account object","Error")
                }

                If ($Xaml.IO.Mod_Account_Object_List.SelectedItem.Content -in $Main.DB.Account.Record.Object)
                {
                    Throw [System.Windows.MessageBox]::Show("That account is already in the database","Error")
                }

                $Item                    = $Main.DB.NewUID(7)
                $Item.Record.Account     = $Xaml.IO.Mod_Account_List.SelectedItem.Content

                [System.Windows.MessageBox]::Show("[$($Item.Record.Account)] added to the database")
                $Main.Menu(8)
            }
            Invoice
            {
                If ($Xaml.IO.Mod_Invoice_Client.List.Count -ne 1)
                {
                    Throw [System.Windows.MessageBox]::Show("Must specify a client","Error")
                }

                Switch($Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex)
                {
                    0 # Issue
                    {
                        If ($Xaml.IO.Mod_Invoice_Issue_List.Items.Count -eq 0)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify an issue","Error")
                        }
                    }
                    1 # Purchase
                    {
                        If ($Xaml.IO.Mod_Invoice_Purchase_List.Items.Count -eq 0)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify a purchase","Error")
                        }
                    }

                    2 # Inventory
                    {
                        If ($Xaml.IO.Mod_Invoice_Inventory_List.Items.Count -eq 0)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify inventory item","Error")
                        }
                    }

                    3 # Issue/Purchase
                    {
                        If ( 0 -in $Xaml.IO.Mod_Invoice_Issue_List.Items.Count, $Xaml.IO.Mod_Invoice_Purchase_List.Items.Count)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify an issue AND a purchase","Error")
                        }
                    }

                    4 # Issue/Inventory
                    {
                        If ( 0 -in $Xaml.IO.Mod_Invoice_Issue_List.Items.Count, $Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify an issue AND an inventory item","Error")
                        }
                    }

                    5 # Purchase/Inventory
                    {
                        If ( 0 -in $Xaml.IO.Mod_Invoice_Purchase_List.Items.Count, $Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify a purchase AND an inventory item","Error")
                        }
                    }

                    6 # Issue/Purchase/Inventory
                    {
                        If ( 0 -in $Xaml.IO.Mod_Invoice_Issue.List.Items.Count, $Xaml.IO.Mod_Invoice_Purchase_List.Items.Count, $Xaml.IO.Mod_Invoice_Inventory_List.Items.Count)
                        {
                            Throw [System.Windows.MessageBox]::Show("Must specify at least (1) issue, (1) purchase, and (1) inventory item","Error")
                        }
                    }

                    7 # Null
                    {
                        Throw [System.Windows.MessageBox]::Show("Cannot create a null invoice","Error")
                    }
                }

                $DisplayName              = "{0}/{1}/{2}" -f @( Get-Date -UFormat "(%m-%d-%Y)",
                                                                $Xaml.IO.Mod_Invoice_Client_List.SelectedItem.Content,
                                                                $Xaml.IO.Mod_Invoice_Mode_List.SelectedIndex)
                
                If ($DisplayName -in $Main.DB.Invoice.Record.DisplayName)
                {
                    Throw [System.Windows.MessageBox]::Show("That item already exists within the database","Error")
                }
                $Item                     = $Main.DB.NewUID(8)
                $Item.Record.DisplayName  = $DisplayName
                $Item.Record.Mode         = $Xaml.IO.Mod_Invoice_Mode_List.SelectedItem.Content
                $Item.Record.Client       = $Xaml.IO.Mod_Invoice_Client_List.SelectedItem.Content
                $Item.Record.Issue        = @($Xaml.IO.Mod_Invoice_Issue.Items)
                $Item.Record.Purchase     = @($Xaml.IO.Mod_Invoice_Purchase.Items)
                $Item.Record.Inventory    = @($Xaml.IO.Mod_Invoice_Inventory.Items)

                [System.Windows.MessageBox]::Show("[$DisplayName] added to the database")
                $Main.Menu(9)
            }
        }
    })

    # Delete
    $Xaml.IO.Delete.Add_Click(           
    {
        $Index = $Xaml.IO."Get_$($Main.Current)_Result".SelectedIndex = 15
        $Main.Selected = $Xaml.IO."Get_$($Main.Current)_Result".Items[$Index]
        $Main.DB.SortUID($Main.Selected.UID)
        $Main.Mode(4)
    })

    # UID
    $Xaml.IO.Get_UID_Result.Add_SelectionChanged(
    {
        $Xaml.IO.View.IsEnabled   = @(0,1)[$Xaml.IO.Get_UID_Result.SelectedIndex -ne -1]
        $Xaml.IO.Delete.IsEnabled = @(0,1)[$Xaml.IO.Get_UID_Result.SelectedIndex -ne -1]
    })

    $Xaml.IO.Get_UID_Filter.Add_TextChanged(
    {
        Start-Sleep -Milliseconds 25
        $Xaml.IO.Get_UID_Result.ItemsSource = @( )

        If ( $Xaml.IO.Get_UID_Filter.Text -ne "" )
        {
            $List = @( $Xaml.IO.Get_UID_Result.Items | ? $Xaml.IO.Get_UID_Property.SelectedItem -match $Xaml.IO.Get_UID_Filter.Text )
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

    # Client
    $Xaml.IO.Get_Client_Result.Add_SelectionChanged(
    {
        $Xaml.IO.View.IsEnabled   = @(0,1)[$Xaml.IO.Get_Client_Result.SelectedIndex -ne -1]
        $Xaml.IO.Delete.IsEnabled = @(0,1)[$Xaml.IO.Get_Client_Result.SelectedIndex -ne -1]
    })

    $Xaml.IO.Get_UID_Filter.Add_TextChanged(
    {
        Start-Sleep -Milliseconds 25
        $Xaml.IO.Get_Client_Result.ItemsSource = @( )

        If ( $Xaml.IO.Get_Client_Filter.Text -ne "" )
        {
            $List = @( $Xaml.IO.Get_Client_Result.Items | ? $Xaml.IO.Get_Client_Property.SelectedItem -match $Xaml.IO.Get_Client_Filter.Text )
            If ( $List -ne $Null )
            {
                $Xaml.IO.Get_Client_Result.ItemsSource = @( $List )
            }
        }
        If ( $Xaml.IO.Get_Client_Filter.Text -eq "" )
        {
            $Xaml.IO.Get_Client_Result.ItemsSource = @( $Main.DB.UID )
        }
    })
}
