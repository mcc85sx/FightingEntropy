Function Invoke-PSDWizard
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

    Class PSDWizardGUI
    {
        Static [String] $Tab = @(        '<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://PowerShell Deployment Wizard (featuring DVR)" Width="800" Height="600" Icon=" C:\ProgramData\Secure Digits Plus LLC\FightingEntropy\Graphics\icon.ico" ResizeMode="NoResize" FontWeight="SemiBold" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">',
        '    <Window.Resources>',
        '        <Style TargetType="Label">',
        '            <Setter Property="Height" Value="28"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="TextBox">',
        '            <Setter Property="TextAlignment" Value="Left"/>',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="ComboBox">',
        '            <Setter Property="HorizontalContentAlignment" Value="Left"/>',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="PasswordBox">',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="CheckBox">',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="Button">',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style TargetType="GroupBox">',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '    </Window.Resources>',
        '    <Grid>',
        '        <Grid.RowDefinitions>',
        '            <RowDefinition Height="*"/>',
        '            <RowDefinition Height="50"/>',
        '        </Grid.RowDefinitions>',
        '        <TabControl Grid.Row="0">',
        '            <TabItem Header="Locale">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="2*"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Grid.Row="0" Header="[Task Sequence]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="125"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="125"/>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Label     Grid.Column="0" Content="Task Sequence"/>',
        '                                <TextBox   Grid.Column="1" Name="Task_ID" IsReadOnly="True"/>',
        '                                <Label     Grid.Column="2" Content="Profile Name"/>',
        '                                <TextBox   Grid.Column="3" Name="Task_Profile"/>',
        '                            </Grid>',
        '                            <DataGrid Grid.Row="1" Name="Task_List" Margin="5">',
        '                                <DataGrid.Columns>',
        '                                    <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>',
        '                                    <DataGridTextColumn Header="ID"   Binding="{Binding ID}" Width="250"/>',
        '                                </DataGrid.Columns>',
        '                            </DataGrid>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <GroupBox Header="[Locale]" Grid.Row="1">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid Grid.Row="0">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="125"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="125"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Label     Grid.Column="0" Content="Time Zone"/>',
        '                            <ComboBox  Grid.Column="1" Name="Locale_Timezone"/>',
        '                            <Label     Grid.Column="2" Content="Keyboard layout"/>',
        '                            <ComboBox  Grid.Column="3" Name="Locale_Keyboard"/>',
        '                        </Grid>',
        '                        <Grid Grid.Row="1">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="125"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Label     Grid.Row="0" Grid.Column="0" Content="Primary"/>',
        '                            <Label     Grid.Row="1" Grid.Column="0" Content="Secondary"/>',
        '                            <ComboBox  Grid.Row="0" Grid.Column="1" Name="Locale_Language1"/>',
        '                            <ComboBox  Grid.Row="1" Grid.Column="1" Name="Locale_Language2"/>',
        '                        </Grid>',
        '                        </Grid>',
        '                        ',
        '                    </GroupBox>',
        '                </Grid>',
        '            </TabItem>',
        '            <TabItem Header="System">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="200"/>',
        '                        <RowDefinition Height="1.25*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <GroupBox Header="[System]" Grid.Row="0">',
        '                        <Grid>',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="150"/>',
        '                                <ColumnDefinition Width="250"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <!-- Column 0 -->',
        '                            <Label       Grid.Row="0" Grid.Column="0" Content="Serial Number"/>',
        '                            <Label       Grid.Row="1" Grid.Column="0" Content="Computer Name"/>',
        '                            <Label       Grid.Row="2" Grid.Column="0" Content="System Password"/>',
        '                            <Label       Grid.Row="3" Grid.Column="0" Content="Home Page"/>',
        '                            <!-- Column 1 -->',
        '                            <TextBox     Grid.Row="0" Grid.Column="1" Name="System_Serial" IsReadOnly="True"/>',
        '                            <TextBox     Grid.Row="1" Grid.Column="1" Name="System_Name"/>',
        '                            <PasswordBox Grid.Row="2" Grid.Column="1" Name="System_Password"/>',
        '                            <TextBox     Grid.Row="3" Grid.Column="1" Name="System_HomePage"/>',
        '                            <!-- Column 2 -->',
        '                            <CheckBox    Grid.Row="1" Grid.Column="2" Name="System_NameUsesSerial" Content="Set by Serial Number"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <GroupBox Header="[Domain]" Grid.Row="1">',
        '                        <Grid>',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="150"/>',
        '                                <ColumnDefinition Width="250"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <!-- Column 0 -->',
        '                            <ComboBox Grid.Row="0" Grid.Column="0" Name="Domain_Type"/>',
        '                            <Label    Grid.Row="1" Grid.Column="0" Content="Organization name"/>',
        '                            <Label    Grid.Row="2" Grid.Column="0" Content="Organizational Unit"/>',
        '                            <Label    Grid.Row="3" Grid.Column="0" Content="Username"/>',
        '                            <Label    Grid.Row="4" Grid.Column="0" Content="Admin Password"/>',
        '                            <!-- Column 1 -->',
        '                            <TextBox  Grid.Row="0" Grid.Column="1" Name="Domain_Name"/> ',
        '                            <TextBox  Grid.Row="1" Grid.Column="1" Name="Domain_Organization"/>',
        '                            <TextBox  Grid.Row="2" Grid.Column="1" Name="Domain_OU"/>',
        '                            <TextBox  Grid.Row="3" Grid.Column="1" Name="Domain_Username"/>',
        '                            <TextBox  Grid.Row="4" Grid.Column="1" Name="Domain_Password"/>',
        '                            <!-- Column 2 -->                           ',
        '                            <Label    Grid.Row="1" Grid.Column="2" Content="Name displayed in the deployment progress bar" HorizontalAlignment="Left"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                </Grid>',
        '            </TabItem>',
        '            <TabItem Header="Network">',
        '                <GroupBox Header="[Network]">',
        '                    <Grid Margin="10">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="250"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Grid Grid.Column="0">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Label Grid.Row="0" Content="Network type"/>',
        '                            <Label Grid.Row="1" Content="IP Address"/>',
        '                            <Label Grid.Row="2" Content="Gateway"/>',
        '                            <Label Grid.Row="3" Content="Subnet Mask"/>',
        '                            <Label Grid.Row="4" Content="DNS Server(s)"/>',
        '                        </Grid>',
        '                        <Grid Grid.Column="1">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <ComboBox Grid.Row="0" Name="Network_Type"/>',
        '                            <TextBox  Grid.Row="1" Name="Network_IPAddress"/>',
        '                            <TextBox  Grid.Row="2" Name="Network_Gateway"/>',
        '                            <TextBox  Grid.Row="3" Name="Network_SubnetMask"/>',
        '                            <TextBox  Grid.Row="4" Name="Network_DNS"/>',
        '                        </Grid>',
        '                    </Grid>',
        '                </GroupBox>',
        '            </TabItem>',
        '            <TabItem Header="Applications">',
        '                <GroupBox Header="[Applications]">',
        '                    <DataGrid SelectionMode="Extended" AutoGenerateColumns="True" Name="Applications" Margin="10" >',
        '                        <DataGrid.Columns>',
        '                            <DataGridTemplateColumn Header="Select" Width="50">',
        '                                <DataGridTemplateColumn.CellTemplate>',
        '                                    <DataTemplate>',
        '                                        <CheckBox IsChecked="{Binding Select}"/>',
        '                                    </DataTemplate>',
        '                                </DataGridTemplateColumn.CellTemplate>',
        '                            </DataGridTemplateColumn>',
        '                            <DataGridTextColumn     Header="Name"   Binding="{Binding Name}" Width="350"/>',
        '                            <DataGridTextColumn     Header="GUID"   Binding="{Binding GUID}" Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </GroupBox>',
        '            </TabItem>',
        '            <TabItem Header="Backup">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="320"/>',
        '                        <RowDefinition Height="120"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <GroupBox Grid.Column="0" Header="[Computer Backup]">',
        '                            <Grid>',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="2*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Grid.RowDefinitions>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                </Grid.RowDefinitions>',
        '                                <Label      Grid.Row="0" Grid.Column="0" Content="Backup type" />',
        '                                <ComboBox   Grid.Row="0" Grid.Column="1" Name="Computer_Backup_Type"/>',
        '                                <Label      Grid.Row="1" Grid.Column="0" Content="Backup location" />',
        '                                <Button     Grid.Row="1" Grid.Column="1" Content="Browse" Name="Computer_Backup_Browse"/>',
        '                                <TextBox    Grid.Row="2" Grid.Column="0" Grid.ColumnSpan="2" Name="Computer_Backup_Path"/>',
        '                                <Label      Grid.Row="3" Grid.Column="0" Content="Capture type" />',
        '                                <ComboBox   Grid.Row="3" Grid.Column="1" Name="Computer_Capture_Type"/>',
        '                                <Label      Grid.Row="4" Grid.Column="0" Content="Capture location" />',
        '                                <Button     Grid.Row="4" Grid.Column="1" Content="Browse" Name="Computer_capture_Browse"/>',
        '                                <TextBox    Grid.Row="5" Grid.Column="0" Grid.ColumnSpan="2" Name="Computer_Capture_Path"/>',
        '                                <Grid       Grid.Row="6" Grid.Column="1" >',
        '                                    <Grid.ColumnDefinitions>',
        '                                        <ColumnDefinition Width="*"/>',
        '                                        <ColumnDefinition Width="70"/>',
        '                                    </Grid.ColumnDefinitions>',
        '                                    <TextBox  Grid.Column="0" Name="Computer_Capture_FileName"/>',
        '                                    <ComboBox Grid.Column="1" Name="Computer_Capture_Extension"/>',
        '                                </Grid>',
        '                                <Label      Grid.Row="6" Grid.Column="0" Content="Capture name" />',
        '                            </Grid>',
        '                        </GroupBox>',
        '                        <GroupBox Grid.Column="1" Header="[User Backup]">',
        '                            <Grid>',
        '                                <Grid.ColumnDefinitions>',
        '                                    <ColumnDefinition Width="*"/>',
        '                                    <ColumnDefinition Width="2*"/>',
        '                                </Grid.ColumnDefinitions>',
        '                                <Grid.RowDefinitions>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                    <RowDefinition Height="40"/>',
        '                                </Grid.RowDefinitions>',
        '                                <Label      Grid.Row="0" Grid.Column="0" Content="Backup type" />',
        '                                <ComboBox   Grid.Row="0" Grid.Column="1" Name="User_Backup_Type" />',
        '                                <Label      Grid.Row="1" Grid.Column="0" Content="Backup location" />',
        '                                <Button     Grid.Row="1" Grid.Column="1" Content="Browse" Name="User_Backup_Browse"/>',
        '                                <TextBox    Grid.Row="2" Grid.Column="0" Grid.ColumnSpan="2" Name="User_Backup_Path"/>',
        '                                <CheckBox Grid.Row="3" Grid.Column="0" Content="Restore User" IsChecked="False" Name="User_Restore_Data" HorizontalAlignment="Right"/>',
        '                                <Button Grid.Row="3" Grid.Column="1" Content="Browse"/>',
        '                                <TextBox  Grid.Row="4" Grid.Column="0" Grid.ColumnSpan="2" Name="User_Restore_Path"/>',
        '                                <Grid       Grid.Row="5" Grid.Column="0" Grid.ColumnSpan="2">',
        '                                    <Grid.ColumnDefinitions>',
        '                                        <ColumnDefinition Width="*"/>',
        '                                        <ColumnDefinition Width="*"/>',
        '                                    </Grid.ColumnDefinitions>',
        '                                    <CheckBox Grid.Column="0" Content="Keep Partitions"   IsChecked="False" Name="Backup_Keep_Partitions" HorizontalAlignment="Center"/>',
        '                                    <CheckBox Grid.Column="1" Content="Move Data"         IsChecked="False" Name="Backup_Keep_Data" HorizontalAlignment="Center"/>',
        '                                </Grid>',
        '                            </Grid>',
        '                        </GroupBox>',
        '                    </Grid>',
        '                    <GroupBox Grid.Row="1" Header="[Storage Credentials]">',
        '                        <Grid>',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="*"/>',
        '                                <RowDefinition Height="*"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="125"/>',
        '                                <ColumnDefinition Width="250"/>',
        '                                <ColumnDefinition Width="125"/>',
        '                                <ColumnDefinition Width="250"/>                                ',
        '                            </Grid.ColumnDefinitions>',
        '                            <Label   Grid.Row="0" Grid.Column="0" Content="Username" />',
        '                            <TextBox Grid.Row="0" Grid.Column="1" Name="Backup_Credential_Username"/>',
        '                            <Label   Grid.Row="0" Grid.Column="2" Content="Password" />',
        '                            <TextBox Grid.Row="0" Grid.Column="3" Name="Backup_Credential_Password"/>',
        '                            <Label   Grid.Row="1" Grid.Column="0" Content="Domain" />',
        '                            <TextBox Grid.Row="1" Grid.Column="1" Name="Backup_Credential_Domain"/>',
        '                            <Label   Grid.Row="1" Grid.Column="2" Content="Confirm" />',
        '                            <TextBox Grid.Row="1" Grid.Column="3" Name="Backup_Credential_Confirm"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '',
        '                </Grid>',
        '            </TabItem>',
        '            <TabItem Header="Others">',
        '                <GroupBox Header="[Others]">',
        '                    <Grid>',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="250"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Grid Grid.Column="0">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Label Grid.Row="0" Content="Finish action"/>',
        '                            <Label Grid.Row="1" Content="WSUS Server"/>',
        '                            <Label Grid.Row="2" Content="Event service"/>',
        '                            <Label Grid.Row="3" Content="End Log files"/>',
        '                            <Label Grid.Row="4" Content="Real time log"/>',
        '                            <Label Grid.Row="5" Content="Product Key"/>',
        '                        </Grid>',
        '                        <Grid Grid.Column="1">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <ComboBox Grid.Row="0" Name="Misc_Finish_Action"/>',
        '                            <TextBox  Grid.Row="1" Name="Misc_WSUSServer"/>',
        '                            <TextBox  Grid.Row="2" Name="Misc_EventService"/>',
        '                            <TextBox  Grid.Row="3" Name="Misc_LogsSLShare"/>',
        '                            <TextBox  Grid.Row="4" Name="Misc_LogsSLShare_DynamicLogging"/>',
        '                            <ComboBox Grid.Row="5" Name="Misc_Product_Key_Type"/>',
        '                            <TextBox  Grid.Row="6" Name="Misc_Product_Key"/>',
        '                            <CheckBox Grid.Row="7" Name="Misc_HideShell" Content="Hide explorer deployment" ToolTip="Hide the product key wizard panes"/>',
        '                            <CheckBox Grid.Row="8" Name="Misc_NoExtraPartition" Content="Do not create extra partition" ToolTip="Hide the product key wizard panes"/>',
        '                        </Grid>',
        '                        <Grid Grid.Column="2">',
        '                            <Grid.RowDefinitions>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                                <RowDefinition Height="40"/>',
        '                            </Grid.RowDefinitions>',
        '                            <Label Grid.Row="2" Content="Set the live reporting in the monitoring section" HorizontalAlignment="Left"/>',
        '                            <CheckBox Grid.Row="3" Name="Misc_SLShare_Deployroot" Content="Set on the deployroot"/>',
        '                            <Label Grid.Row="4" Content="Enable the real time logging of your Task Sequence" HorizontalAlignment="Left"/>',
        '                        </Grid>',
        '                    </Grid>',
        '                </GroupBox>',
        '            </TabItem>',
        '        </TabControl>',
        '        <Grid Grid.Row="1">',
        '            <Grid.ColumnDefinitions>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '            </Grid.ColumnDefinitions>',
        '            <Button Grid.Column="0" Name="Start" Content="Start"/>',
        '            <Button Grid.Column="1" Name="Cancel" Content="Cancel"/>',
        '        </Grid>',
        '    </Grid>',
        '</Window>') 
    }

    Class LocaleItem
    {
        Hidden [String]$Type
        Hidden[String]$Line
        [String]$Name
        [String]$Value
        LocaleItem([UInt32]$Mode,[String]$Line)
        {
            $This.Type  = @("Keyboard","TimeZone")[$Mode]
            $This.Line  = $Line -Replace "\s+", " "
            $This.Name  = [Regex]::Matches($Line,"\`".+\`"").Value.Replace('"',"")
            $This.Value = [Regex]::Matches($Line,"\>.+\<").Value.TrimStart(">").TrimEnd("<")
        }
    }

    Class LocaleList
    {
        [String]$Path
        Hidden [Object]$Stack
        [Object]$Keyboard
        [Object]$Timezone
        LocaleList([String]$Path)
        {
            $This.Path     = $Path
            $This.Stack    = @( )

            $Content       = Get-Content $Path
            $X             = 0
            $Mode          = 0
            Do
            {
                $Line = $Content[$X]
                If ($Line -match "\<KeyboardLocale\>")
                { 
                    $X ++
                    Do
                    {
                        $Line = $Content[$X]
                        If ($Line -match "\<option")
                        {
                            $This.Stack += [LocaleItem]::New(0,$Line)
                        }
                        $X ++
                    }
                    Until ($Line -match "\<\/KeyboardLocale\>")
                }
                If ($Line -match "\<TimeZone\>")
                {
                    $X ++ 
                    Do
                    {
                        $Line = $Content[$X]
                        If ($Line -match "\<option")
                        {
                            $This.Stack += [LocaleItem]::New(1,$Line)
                        }
                        $X ++
                    }
                    Until ($Line -match "\<\/TimeZone\>")
                }
                $X ++
            }
            Until ($X -ge ($Content.Count- 1))

            $This.Keyboard = $This.Stack | ? Type -eq Keyboard
            $This.TimeZone = $This.Stack | ? Type -eq TimeZone
        }
    }

    Get-MDTModule | Import-Module
    # Restore-MDTPersistentDrive
    # Prep Xaml

    $Drive                  = "PSD:"
    $DeployRoot             = Get-ItemProperty $Drive | % UNCPath
    $Pack                   = Get-FEModule -Control | ? Name -match MDT_LanguageUI.xml | % { [LocaleList]$_.FullName }
    $Locale                 = [XML](Get-Content "$DeployRoot\Scripts\ListOfLanguages.xml") | % LocaleData | % Locale

    $tsenv                  = New-Object -ComObject Microsoft.SMS.TSEnvironment
    $Xaml                   = [XamlWindow][PSDWizardGUI]::Tab

    <# $Last = $Null
    $Xaml.Names | ? { $_ -notin "ContentPresenter","Border","ContentSite" } | % {
        
        $Item = $_.Split("_")[0]
        If ($Last -eq $Null -or $Item -ne $Last)
        {
            Write-Theme "$Item Tab" -Text
        }
        $X = "    # `$Xaml.IO.$_"
        $Y = $Xaml.IO.$_.GetType().Name 
        "{0}{1} # $Y" -f $X,(" "*(60-$X.Length) -join '')
        $Last = $_.Split("_")[0]
    
    } | Set-Clipboard #>

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Task Tab   ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Task_ID                                       # TextBox
    # $Xaml.IO.Task_Profile                                  # TextBox
    # $Xaml.IO.Task_List                                     # DataGrid
    
    $Xaml.IO.Task_List.ItemSource                = @( )
    $Xaml.IO.Task_List.ItemsSource               = @( Get-ChildItem "$Drive\Task Sequences" )
    $Xaml.IO.Task_List.Add_SelectionChanged(
    {
        If ($Xaml.IO.Task_List.SelectedIndex -ne -1)
        {
            $Xaml.IO.Task_ID.Text                = $Xaml.IO.Task_List.SelectedItem.ID
        }
    })
#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Locale Tab ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Locale_Timezone                               # ComboBox
    # $Xaml.IO.Locale_Keyboard                               # ComboBox
    # $Xaml.IO.Locale_Language1                              # ComboBox
    # $Xaml.IO.Locale_Language2                              # ComboBox
    $Xaml.IO.Locale_Timezone.ItemsSource                     = @( )
    $Xaml.IO.Locale_Keyboard.ItemsSource                     = @( )
    $Xaml.IO.Locale_Language1.ItemsSource                    = @( )
    $Xaml.IO.Locale_Language2.ItemsSource                    = @( )

    $Xaml.IO.Locale_Timezone.ItemsSource                     = @( $Pack.TimeZone.Value )
    $Xaml.IO.Locale_Keyboard.ItemsSource                     = @( $Pack.Keyboard.Value )
    $Xaml.IO.Locale_Language1.ItemsSource                    = @( $Locale.RefName )
    $Xaml.IO.Locale_Language2.ItemsSource                    = @( $Locale.RefName )
    
#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ System Tab ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.System_Serial                                 # TextBox
    # $Xaml.IO.System_Name                                   # TextBox
    # $Xaml.IO.System_Password                               # PasswordBox
    # $Xaml.IO.System_HomePage                               # TextBox
    # $Xaml.IO.System_NameUsesSerial                         # CheckBox



#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Domain Tab ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Domain_Type                                   # ComboBox
    # $Xaml.IO.Domain_Name                                   # TextBox
    # $Xaml.IO.Domain_Organization                           # TextBox
    # $Xaml.IO.Domain_OU                                     # TextBox
    # $Xaml.IO.Domain_Username                               # TextBox
    # $Xaml.IO.Domain_Password                               # TextBox

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Network Tab    ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Network_Type                                  # ComboBox
    # $Xaml.IO.Network_IPAddress                             # TextBox
    # $Xaml.IO.Network_Gateway                               # TextBox
    # $Xaml.IO.Network_SubnetMask                            # TextBox
    # $Xaml.IO.Network_DNS                                   # TextBox

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Applications Tab   ]__________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Applications                                  # DataGrid

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Computer Tab   ]______________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Computer_Backup_Type                          # ComboBox
    # $Xaml.IO.Computer_Backup_Browse                        # Button
    # $Xaml.IO.Computer_Backup_Path                          # TextBox
    # $Xaml.IO.Computer_Capture_Type                         # ComboBox
    # $Xaml.IO.Computer_capture_Browse                       # Button
    # $Xaml.IO.Computer_Capture_Path                         # TextBox
    # $Xaml.IO.Computer_Capture_FileName                     # TextBox
    # $Xaml.IO.Computer_Capture_Extension                    # ComboBox

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ User Tab   ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.User_Backup_Type                              # ComboBox
    # $Xaml.IO.User_Backup_Browse                            # Button
    # $Xaml.IO.User_Backup_Path                              # TextBox
    # $Xaml.IO.User_Restore_Data                             # CheckBox
    # $Xaml.IO.User_Restore_Path                             # TextBox

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Backup Tab ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Backup_Keep_Partitions                        # CheckBox
    # $Xaml.IO.Backup_Keep_Data                              # CheckBox
    # $Xaml.IO.Backup_Credential_Username                    # TextBox
    # $Xaml.IO.Backup_Credential_Password                    # TextBox
    # $Xaml.IO.Backup_Credential_Domain                      # TextBox
    # $Xaml.IO.Backup_Credential_Confirm                     # TextBox

#    ____                                                                                                    ________    
#   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   
#   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    
#    ¯¯¯\\__[ Misc Tab   ]__________________________________________________________________________________//¯¯¯        
#        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            
    # $Xaml.IO.Misc_Finish_Action                            # ComboBox
    # $Xaml.IO.Misc_WSUSServer                               # TextBox
    # $Xaml.IO.Misc_EventService                             # TextBox
    # $Xaml.IO.Misc_LogsSLShare                              # TextBox
    # $Xaml.IO.Misc_LogsSLShare_DynamicLogging               # TextBox
    # $Xaml.IO.Misc_Product_Key_Type                         # ComboBox
    # $Xaml.IO.Misc_Product_Key                              # TextBox
    # $Xaml.IO.Misc_HideShell                                # CheckBox
    # $Xaml.IO.Misc_NoExtraPartition                         # CheckBox
    # $Xaml.IO.Misc_SLShare_Deployroot                       # CheckBox


    # $Xaml.IO.Start                                         # Button
    # $Xaml.IO.Cancel                                        # Button
}
