<#
.SYNOPSIS

.DESCRIPTION

.LINK

.NOTES
          FileName: Invoke-FEWizard.ps1
          Solution: FightingEntropy PowerShell Deployment for MDT
          Purpose: Preexisting Environment Graphical User Interface 
          Author: Michael C. Cook Sr.
          Contact: @mcc85s
          Primary: @mcc85s 
          Created: 2021-09-21
          Modified: 2021-09-21

          Version - 0.0.0 - () - Finalized functional version 1.

          TODO:

.Example
#>
Function Invoke-FEWizard
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][Object]$Root)

    Class DGList
    {
        [String] $Name
        [Object] $Value
        DGList([String]$Name,[Object]$Value)
        {
            $This.Name  = $Name
            $This.Value = $Value
        }
    }

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

    # (Get-Content $home\desktop\FEWizard.xaml) | % { "'$_',"} | Set-Clipboard
    Class FEWizardGUI
    {
        Static [String] $Tab = @('<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="[FightingEntropy]://PowerShell Deployment Wizard (featuring DVR)" Width="800" Height="600" ResizeMode="NoResize" FontWeight="SemiBold" HorizontalAlignment="Center" WindowStartupLocation="CenterScreen">',
        '    <Window.Resources>',
        '        <Style TargetType="Label">',
        '            <Setter Property="Height" Value="28"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
        '        <Style x:Key="DropShadow">',
        '            ',
        '            <Setter Property="TextBlock.Effect">',
        '                <Setter.Value>',
        '                    <DropShadowEffect ShadowDepth="1"/>',
        '                </Setter.Value>',
        '            </Setter>',
        '        </Style>',
        '        <Style TargetType="{x:Type TextBox}" BasedOn="{StaticResource DropShadow}">',
        '            <Setter Property="TextBlock.TextAlignment" Value="Left"/>',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Setter Property="HorizontalContentAlignment" Value="Left"/>',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="4"/>',
        '            <Setter Property="FontSize" Value="12"/>',
        '            <Setter Property="Foreground" Value="#000000"/>',
        '            <Setter Property="TextWrapping" Value="Wrap"/>',
        '            <Style.Resources>',
        '                <Style TargetType="Border">',
        '                    <Setter Property="CornerRadius" Value="2"/>',
        '                </Style>',
        '            </Style.Resources>',
        '        </Style>',
        '        <Style TargetType="{x:Type PasswordBox}" BasedOn="{StaticResource DropShadow}">',
        '            <Setter Property="TextBlock.TextAlignment" Value="Left"/>',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Setter Property="HorizontalContentAlignment" Value="Left"/>',
        '            <Setter Property="Margin" Value="4"/>',
        '            <Setter Property="Height" Value="24"/>',
        '        </Style>',
        '        <Style TargetType="CheckBox">',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Setter Property="Height" Value="24"/>',
        '            <Setter Property="Margin" Value="5"/>',
        '        </Style>',
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
        '            <Setter Property="FontWeight" Value="SemiBold"/>',
        '            <Setter Property="FontSize" Value="14"/>',
        '            <Setter Property="Foreground" Value="Black"/>',
        '            <Setter Property="Background" Value="#DFFFBA"/>',
        '            <Setter Property="BorderThickness" Value="2"/>',
        '            <Setter Property="VerticalContentAlignment" Value="Center"/>',
        '            <Style.Resources>',
        '                <Style TargetType="Border">',
        '                    <Setter Property="CornerRadius" Value="5"/>',
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
        '            <Setter Property="Margin" Value="5"/>',
        '            <Setter Property="BorderThickness" Value="2"/>',
        '            <Setter Property="BorderBrush" Value="Gray"/>',
        '        </Style>',
        '    </Window.Resources>',
        '    <Grid>',
        '        <Grid.Resources>',
        '            <Style TargetType="Grid">',
        '                <Setter Property="Background" Value="LightYellow"/>',
        '            </Style>',
        '        </Grid.Resources>',
        '        <Grid.RowDefinitions>',
        '            <RowDefinition Height="45"/>',
        '            <RowDefinition Height="*"/>',
        '            <RowDefinition Height="45"/>',
        '        </Grid.RowDefinitions>',
        '        <Grid Grid.Row="0">',
        '            <Grid.ColumnDefinitions>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '            </Grid.ColumnDefinitions>',
        '            <Button Grid.Column="0" Name="Locale_Tab" Content="Locale"/>',
        '            <Button Grid.Column="1" Name="System_Tab" Content="System"/>',
        '            <Button Grid.Column="2" Name="Network_Tab" Content="Network"/>',
        '            <Button Grid.Column="3" Name="Applications_Tab" Content="Applications"/>',
        '            <Button Grid.Column="4" Name="Backup_Tab" Content="Backup"/>',
        '            <Button Grid.Column="5" Name="Others_Tab" Content="Others"/>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="Locale_Panel" Visibility="Collapsed">',
        '            <Grid.RowDefinitions>',
        '                <RowDefinition Height="2*"/>',
        '                <RowDefinition Height="*"/>',
        '            </Grid.RowDefinitions>',
        '            <GroupBox Grid.Row="0" Header="[Task Sequence] - (Select a task sequence to proceed)">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Label     Grid.Column="0" Content="Task Sequence"/>',
        '                        <TextBox   Grid.Column="1" Name="Task_ID" IsReadOnly="True"/>',
        '                        <Label     Grid.Column="2" Content="Profile Name"/>',
        '                        <TextBox   Grid.Column="3" Name="Task_Profile"/>',
        '                    </Grid>',
        '                    <DataGrid Grid.Row="1" Name="Task_List" Margin="5">',
        '                        <DataGrid.Columns>',
        '                            <DataGridTextColumn Header="Type"    Binding="{Binding Type}"    Width="80"/>',
        '                            <DataGridTextColumn Header="Version" Binding="{Binding Version}" Width="125"/>',
        '                            <DataGridTextColumn Header="ID"      Binding="{Binding ID}"      Width="80"/>',
        '                            <DataGridTextColumn Header="Name"    Binding="{Binding Name}"    Width="*"/>',
        '                        </DataGrid.Columns>',
        '                    </DataGrid>',
        '                </Grid>',
        '            </GroupBox>',
        '            <GroupBox Header="[Locale] - (Time Zone/Keyboard/Language)" Grid.Row="1">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid Grid.Row="0">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Label     Grid.Column="0" Content="Time Zone"/>',
        '                        <ComboBox  Grid.Column="1" Name="Locale_Timezone"/>',
        '                        <Label     Grid.Column="2" Content="Keyboard layout"/>',
        '                        <ComboBox  Grid.Column="3" Name="Locale_Keyboard"/>',
        '                    </Grid>',
        '                    <Grid Grid.Row="1">',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="125"/>',
        '                            <ColumnDefinition Width="*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="*"/>',
        '                            <RowDefinition Height="*"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label     Grid.Row="0" Grid.Column="0" Content="Primary"/>',
        '                        <CheckBox  Grid.Row="1" Grid.Column="0" Content="Secondary" Name="Locale_SecondLanguage"/>',
        '                        <ComboBox  Grid.Row="0" Grid.Column="1" Name="Locale_Language1"/>',
        '                        <ComboBox  Grid.Row="1" Grid.Column="1" Name="Locale_Language2"/>',
        '                    </Grid>',
        '                </Grid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="System_Panel" Visibility="Visible">',
        '            <Grid.RowDefinitions>',
        '                <RowDefinition Height="200"/>',
        '                <RowDefinition Height="240"/>',
        '            </Grid.RowDefinitions>',
        '            <GroupBox Header="[System]" Grid.Row="0">',
        '                <Grid Margin="5">',
        '                    <Grid.ColumnDefinitions>',
        '                        <ColumnDefinition Width="150"/>',
        '                        <ColumnDefinition Width="240"/>',
        '                        <ColumnDefinition Width="125"/>',
        '                        <ColumnDefinition Width="*"/>',
        '                    </Grid.ColumnDefinitions>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="40"/>',
        '                    </Grid.RowDefinitions>',
        '                    <!-- Column 0 -->',
        '                    <Label       Grid.Row="0" Grid.Column="0" Content="Serial Number"/>',
        '                    <Label       Grid.Row="1" Grid.Column="0" Content="Computer Name"/>',
        '                    <Label       Grid.Row="2" Grid.Column="0" Content="System Password"/>',
        '                    <Label       Grid.Row="3" Grid.Column="0" Content="Processor"/>',
        '                    <!-- Column 1 -->',
        '                    <TextBox     Grid.Row="0" Grid.Column="1" Name="System_Serial" IsReadOnly="True"/>',
        '                    <TextBox     Grid.Row="1" Grid.Column="1" Name="System_Name"/>',
        '                    <PasswordBox Grid.Row="2" Grid.Column="1" Name="System_Password"/>',
        '                    <TextBox     Grid.Row="3" Grid.Column="1" Name="System_Processor" IsReadOnly="True"/>',
        '                    <!-- Column 2 -->',
        '                    <StackPanel Grid.Row="0" Grid.Column="2" Orientation="Horizontal">',
        '                        <Label    Content="Chassis"/>',
        '                        <CheckBox Name="System_IsVM" Content="VM" IsEnabled="False"/>',
        '                    </StackPanel>',
        '                    <CheckBox    Grid.Row="1" Grid.Column="2" Name="System_UseSerial" Content="Use Serial #"/>',
        '                    <Label       Grid.Row="2" Grid.Column="2" Content="Architecture"/>',
        '                    <Label       Grid.Row="3" Grid.Column="2" Content="Memory"/>',
        '                    <!-- Column 3 -->',
        '                    <ComboBox    Grid.Row="0" Grid.Column="3" Name="System_Chassis" IsEnabled="False"/>',
        '                    <ComboBox    Grid.Row="2" Grid.Column="3" Name="System_Architecture" IsEnabled="False"/>',
        '                    <TextBox     Grid.Row="3" Grid.Column="3" Name="System_Memory" IsReadOnly="True"/>',
        '                </Grid>',
        '            </GroupBox>',
        '            <GroupBox Header="[Domain]" Grid.Row="1">',
        '                <Grid Margin="5">',
        '                    <Grid.ColumnDefinitions>',
        '                        <ColumnDefinition Width="150"/>',
        '                        <ColumnDefinition Width="240"/>',
        '                        <ColumnDefinition Width="150"/>',
        '                        <ColumnDefinition Width="*"/>',
        '                    </Grid.ColumnDefinitions>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="40"/>',
        '                        <RowDefinition Height="80"/>',
        '                    </Grid.RowDefinitions>',
        '                    <!-- Column 0 -->',
        '                    <StackPanel Grid.Row="0" Grid.Column="0" Orientation="Horizontal">',
        '                        <Label Content="Org. Name"/>',
        '                        <CheckBox Content="Modify" Name="Domain_OrgModify" HorizontalAlignment="Left"/>',
        '                    </StackPanel>',
        '                    <Label    Grid.Row="1" Grid.Column="0" Content="Org. Unit"/>',
        '                    <Label    Grid.Row="2" Grid.Column="0" Content="Home Page"/>',
        '                    <GroupBox Grid.Row="3" Grid.ColumnSpan="4" Header="[Credential (Username/Password/Confirm)]">',
        '                        <Grid Margin="4">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="1.25*"/>',
        '                                <ColumnDefinition Width="20"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <TextBox     Grid.Column="0" Name="Domain_Username"/>',
        '                            <PasswordBox Grid.Column="2" Name="Domain_Password"/>',
        '                            <PasswordBox Grid.Column="3" Name="Domain_Confirm"/>',
        '                        </Grid>',
        '                    </GroupBox>',
        '                    <!-- Column 1 -->',
        '                    <TextBox  Grid.Row="0" Grid.Column="1" Name="Domain_Organization" IsReadOnly="True"/>',
        '                    ',
        '                    <TextBox  Grid.Row="1" Grid.Column="1" Grid.ColumnSpan="3" Name="Domain_OU"/>',
        '                    <TextBox  Grid.Row="2" Grid.Column="1" Grid.ColumnSpan="3" Name="Domain_HomePage"/>',
        '                    <!-- Column 2 -->',
        '                    <ComboBox Grid.Row="0" Grid.Column="2" Name="Domain_Type"/>',
        '                    <!-- Column 3 -->',
        '                    <TextBox  Grid.Row="0" Grid.Column="3" Name="Domain_Name"/>',
        '                </Grid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="Network_Panel" Visibility="Collapsed">',
        '            <GroupBox Header="[Network]">',
        '                <Grid Margin="5">',
        '                    <Grid.ColumnDefinitions>',
        '                        <ColumnDefinition Width="125"/>',
        '                        <ColumnDefinition Width="250"/>',
        '                        <ColumnDefinition Width="*"/>',
        '                    </Grid.ColumnDefinitions>',
        '                    <Grid Grid.Column="0">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label Grid.Row="0" Content="Network type"/>',
        '                        <Label Grid.Row="1" Content="IP Address"/>',
        '                        <Label Grid.Row="2" Content="Gateway"/>',
        '                        <Label Grid.Row="3" Content="Subnet Mask"/>',
        '                        <Label Grid.Row="4" Content="DNS Server(s)"/>',
        '                    </Grid>',
        '                    <Grid Grid.Column="1">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <ComboBox Grid.Row="0" Name="Network_Type"/>',
        '                        <TextBox  Grid.Row="1" Name="Network_IPAddress"/>',
        '                        <TextBox  Grid.Row="2" Name="Network_Gateway"/>',
        '                        <TextBox  Grid.Row="3" Name="Network_SubnetMask"/>',
        '                        <TextBox  Grid.Row="4" Name="Network_DNS"/>',
        '                    </Grid>',
        '                </Grid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="Applications_Panel" Visibility="Collapsed">',
        '            <GroupBox Header="[Applications]">',
        '                <DataGrid Name="Applications" Margin="10">',
        '                    <DataGrid.Columns>',
        '                        <DataGridTemplateColumn Header="Select" Width="50">',
        '                            <DataGridTemplateColumn.CellTemplate>',
        '                                <DataTemplate>',
        '                                    <CheckBox IsChecked="{Binding Select}"/>',
        '                                </DataTemplate>',
        '                            </DataGridTemplateColumn.CellTemplate>',
        '                        </DataGridTemplateColumn>',
        '                        <DataGridTextColumn Header="Name"      Binding="{Binding Name}"      Width="150"/>',
        '                        <DataGridTextColumn Header="Version"   Binding="{Binding Version}"   Width="100"/>',
        '                        <DataGridTextColumn Header="Publisher" Binding="{Binding Publisher}" Width="150"/>',
        '                        <DataGridTextColumn Header="GUID"      Binding="{Binding GUID}"      Width="*"/>',
        '                    </DataGrid.Columns>',
        '                </DataGrid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="Backup_Panel" Visibility="Collapsed">',
        '            <Grid.RowDefinitions>',
        '                <RowDefinition Height="320"/>',
        '                <RowDefinition Height="120"/>',
        '            </Grid.RowDefinitions>',
        '            <Grid Grid.Row="0">',
        '                <Grid.ColumnDefinitions>',
        '                    <ColumnDefinition Width="*"/>',
        '                    <ColumnDefinition Width="*"/>',
        '                </Grid.ColumnDefinitions>',
        '                <GroupBox Grid.Column="0" Header="[Computer Backup]">',
        '                    <Grid>',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label      Grid.Row="0" Grid.Column="0" Content="Backup type" />',
        '                        <ComboBox   Grid.Row="0" Grid.Column="1" Name="Computer_Backup_Type"/>',
        '                        <Label      Grid.Row="1" Grid.Column="0" Content="Backup location" />',
        '                        <Button     Grid.Row="1" Grid.Column="1" Content="Browse" Name="Computer_Backup_Browse"/>',
        '                        <TextBox    Grid.Row="2" Grid.Column="0" Grid.ColumnSpan="2" Name="Computer_Backup_Path"/>',
        '                        <Label      Grid.Row="3" Grid.Column="0" Content="Capture type" />',
        '                        <ComboBox   Grid.Row="3" Grid.Column="1" Name="Computer_Capture_Type"/>',
        '                        <Label      Grid.Row="4" Grid.Column="0" Content="Capture location" />',
        '                        <Button     Grid.Row="4" Grid.Column="1" Content="Browse" Name="Computer_capture_Browse"/>',
        '                        <TextBox    Grid.Row="5" Grid.Column="0" Grid.ColumnSpan="2" Name="Computer_Capture_Path"/>',
        '                        <Grid       Grid.Row="6" Grid.Column="1" >',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="70"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <TextBox  Grid.Column="0" Name="Computer_Capture_FileName"/>',
        '                            <ComboBox Grid.Column="1" Name="Computer_Capture_Extension"/>',
        '                        </Grid>',
        '                        <Label      Grid.Row="6" Grid.Column="0" Content="Capture name" />',
        '                    </Grid>',
        '                </GroupBox>',
        '                <GroupBox Grid.Column="1" Header="[User Backup]">',
        '                    <Grid>',
        '                        <Grid.ColumnDefinitions>',
        '                            <ColumnDefinition Width="*"/>',
        '                            <ColumnDefinition Width="2*"/>',
        '                        </Grid.ColumnDefinitions>',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label      Grid.Row="0" Grid.Column="0" Content="Backup type" />',
        '                        <ComboBox   Grid.Row="0" Grid.Column="1" Name="User_Backup_Type" />',
        '                        <Label      Grid.Row="1" Grid.Column="0" Content="Backup location" />',
        '                        <Button     Grid.Row="1" Grid.Column="1" Content="Browse" Name="User_Backup_Browse"/>',
        '                        <TextBox    Grid.Row="2" Grid.Column="0" Grid.ColumnSpan="2" Name="User_Backup_Path"/>',
        '                        <CheckBox Grid.Row="3" Grid.Column="0" Content="Restore User" IsChecked="False" Name="User_Restore_Data" HorizontalAlignment="Right"/>',
        '                        <Button Grid.Row="3" Grid.Column="1" Content="Browse"/>',
        '                        <TextBox  Grid.Row="4" Grid.Column="0" Grid.ColumnSpan="2" Name="User_Restore_Path"/>',
        '                        <Grid       Grid.Row="5" Grid.Column="0" Grid.ColumnSpan="2">',
        '                            <Grid.ColumnDefinitions>',
        '                                <ColumnDefinition Width="*"/>',
        '                                <ColumnDefinition Width="*"/>',
        '                            </Grid.ColumnDefinitions>',
        '                            <CheckBox Grid.Column="0" Content="Keep Partitions"   IsChecked="False" Name="Backup_Keep_Partitions" HorizontalAlignment="Center"/>',
        '                            <CheckBox Grid.Column="1" Content="Move Data"         IsChecked="False" Name="Backup_Keep_Data" HorizontalAlignment="Center"/>',
        '                        </Grid>',
        '                    </Grid>',
        '                </GroupBox>',
        '            </Grid>',
        '            <GroupBox Grid.Row="1" Header="[Storage Credentials]">',
        '                <Grid>',
        '                    <Grid.RowDefinitions>',
        '                        <RowDefinition Height="*"/>',
        '                        <RowDefinition Height="*"/>',
        '                    </Grid.RowDefinitions>',
        '                    <Grid.ColumnDefinitions>',
        '                        <ColumnDefinition Width="125"/>',
        '                        <ColumnDefinition Width="250"/>',
        '                        <ColumnDefinition Width="125"/>',
        '                        <ColumnDefinition Width="250"/>',
        '                    </Grid.ColumnDefinitions>',
        '                    <Label   Grid.Row="0" Grid.Column="0" Content="Username" />',
        '                    <TextBox Grid.Row="0" Grid.Column="1" Name="Backup_Credential_Username"/>',
        '                    <Label   Grid.Row="0" Grid.Column="2" Content="Password" />',
        '                    <TextBox Grid.Row="0" Grid.Column="3" Name="Backup_Credential_Password"/>',
        '                    <Label   Grid.Row="1" Grid.Column="0" Content="Domain" />',
        '                    <TextBox Grid.Row="1" Grid.Column="1" Name="Backup_Credential_Domain"/>',
        '                    <Label   Grid.Row="1" Grid.Column="2" Content="Confirm" />',
        '                    <TextBox Grid.Row="1" Grid.Column="3" Name="Backup_Credential_Confirm"/>',
        '                </Grid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="1" Name="Others_Panel" Visibility="Collapsed">',
        '            <GroupBox Header="[Others]">',
        '                <Grid>',
        '                    <Grid.ColumnDefinitions>',
        '                        <ColumnDefinition Width="125"/>',
        '                        <ColumnDefinition Width="250"/>',
        '                        <ColumnDefinition Width="*"/>',
        '                    </Grid.ColumnDefinitions>',
        '                    <Grid Grid.Column="0">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label Grid.Row="0" Content="Finish action"/>',
        '                        <Label Grid.Row="1" Content="WSUS Server"/>',
        '                        <Label Grid.Row="2" Content="Event service"/>',
        '                        <Label Grid.Row="3" Content="End Log files"/>',
        '                        <Label Grid.Row="4" Content="Real time log"/>',
        '                        <Label Grid.Row="5" Content="Product Key"/>',
        '                    </Grid>',
        '                    <Grid Grid.Column="1">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <ComboBox Grid.Row="0" Name="Misc_Finish_Action"/>',
        '                        <TextBox  Grid.Row="1" Name="Misc_WSUSServer"/>',
        '                        <TextBox  Grid.Row="2" Name="Misc_EventService"/>',
        '                        <TextBox  Grid.Row="3" Name="Misc_LogsSLShare"/>',
        '                        <TextBox  Grid.Row="4" Name="Misc_LogsSLShare_DynamicLogging"/>',
        '                        <ComboBox Grid.Row="5" Name="Misc_Product_Key_Type"/>',
        '                        <TextBox  Grid.Row="6" Name="Misc_Product_Key"/>',
        '                        <CheckBox Grid.Row="7" Name="Misc_HideShell" Content="Hide explorer deployment" ToolTip="Hide the product key wizard panes"/>',
        '                        <CheckBox Grid.Row="8" Name="Misc_NoExtraPartition" Content="Do not create extra partition" ToolTip="Hide the product key wizard panes"/>',
        '                    </Grid>',
        '                    <Grid Grid.Column="2">',
        '                        <Grid.RowDefinitions>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                            <RowDefinition Height="40"/>',
        '                        </Grid.RowDefinitions>',
        '                        <Label Grid.Row="2" Content="Set the live reporting in the monitoring section" HorizontalAlignment="Left"/>',
        '                        <CheckBox Grid.Row="3" Name="Misc_SLShare_Deployroot" Content="Set on the deployroot"/>',
        '                        <Label Grid.Row="4" Content="Enable the real time logging of your Task Sequence" HorizontalAlignment="Left"/>',
        '                    </Grid>',
        '                </Grid>',
        '            </GroupBox>',
        '        </Grid>',
        '        <Grid Grid.Row="2">',
        '            <Grid.ColumnDefinitions>',
        '                <ColumnDefinition Width="*"/>',
        '                <ColumnDefinition Width="*"/>',
        '            </Grid.ColumnDefinitions>',
        '            <Button Grid.Column="0" Name="Start" Content="Start"/>',
        '            <Button Grid.Column="1" Name="Cancel" Content="Cancel"/>',
        '        </Grid>',
        '    </Grid>',
        '</Window>' -join "`n") 
    }

    Class Locale
    {
        [String]$ID
        [String]$Keyboard
        [String]$Culture
        [String]$Name
        Locale([Object]$Culture)
        {
            $This.ID       = $Culture.ID
            $This.Keyboard = $Culture.DefaultKeyboard
            $This.Culture  = $Culture.SSpecificCulture
            $This.Name     = $Culture.RefName
        }
    }

    Class Timezone
    {
        [String]$ID
        [String]$DisplayName
        Timezone([Object]$Timezone)
        {
            $This.ID          = $Timezone.ID
            $This.Displayname = $Timezone.DisplayName
        }
    }

    Class System
    {
        [Object] $OperatingSystem
        [Object] $NetworkAdapter
        [Object] $SystemEnclosure
        [Object] $BIOS
        [Object] $Processor
        [Object] $ComputerSystem
        [Object] $Product
        [Object] $Baseboard
        System()
        {
            $This.OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem | Select *
            $This.NetworkAdapter  = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 1" | ? DefaultIPGateway
            $This.SystemEnclosure = Get-WmiObject -Class Win32_SystemEnclosure
            $This.BIOS            = Get-WmiObject -Class Win32_BIOS
            $This.Processor       = Get-WmiObject -Class Win32_Processor
            $This.ComputerSystem  = Get-WmiObject -Class Win32_ComputerSystem
            $This.Product         = Get-WmiObject -Class Win32_ComputerSystemProduct
            $This.Baseboard       = Get-WmiObject -Class Win32_BaseBoard
        }
    }

    Class TaskSequence
    {
        [String]$ID
        [String]$Type
        [String]$Version
        [String]$Name
        TaskSequence([Object]$TaskSequence)
        {
            $Path         = $TaskSequence.PSPath -Replace "^.+\:\\",""
            $This.ID      = $TaskSequence.ID
            $This.Type    = $Path.Split('\')[1]
            $This.Version = $Path.Split('\')[2]
            $This.Name    = $TaskSequence.Name
        }
    }

    Class Application
    {
        [Bool]$Select
        [String]$Name
        [String]$Version
        [String]$Publisher
        [String]$GUID
        Application([Object]$Application)
        {
            $Path           = $Application.PSPath -Replace "^.+\:\\",""
            $This.Select    = 0
            $This.Name      = $Application.ShortName
            $This.Version   = $Application.Version
            $This.Publisher = $Application.Publisher
            $This.GUID      = $Application.GUID
        }
    }

    Class Main
    {
        [Object] $Xaml
        [Object] $IO
        [Object] $Names
        Hidden [Object] $DeploymentShare
        [Object] $TSEnv
        Hidden [Object] $FileSystem
        [Object] $TaskSequences
        [Object] $Applications
        [Object] $Control
        [Object] $Scripts
        [Object] $CS
        [Object] $WMI
        [Object] $Timezone
        [Object] $Locale
        Main([Object]$Root)
        {
            $This.DeploymentShare = $Root.DS
            $This.TaskSequences   = $Root.DS | ? PSPath -match Task        | ? { -not $_.PsIsContainer } | % { [TaskSequence]$_ }
            $This.Applications    = $Root.DS | ? PSPath -match Application | ? { -not $_.PSIsContainer } | % {  [Application]$_ }
            $This.TSEnv           = $Root.TSEnv
            $This.Control         = $Root.Control
            $This.Scripts         = $Root.Scripts
            $This.CS              = Get-Content "$($Root.Control)\CustomSettings.ini" 
            $This.Xaml            = [XamlWindow][FEWizardGUI]::Tab
            $This.IO              = $This.Xaml.IO
            $This.Names           = $This.Xaml.Names | ? { $_ -notin "ContentPresenter","ContentSite","Border" } | % { [DGList]::New($_,$This.IO.$_.GetType().Name)}
            $This.WMI             = [System]::New()
            $This.Timezone        = [System.TimeZoneInfo]::GetSystemTimeZones() | % { [Timezone]$_ }
            $This.Locale          = [XML](Get-Content "$($Root.Scripts)\ListOfLanguages.xml") | % LocaleData | % Locale | % { [Locale]$_ }
        }
        View([UInt32]$Slot)
        {
            $This.Names | ? Name -match _Panel | % { $This.IO.$($_.Name).Visibility = "Collapsed" }
            $This.Names | ? Name -match _Tab   | % { 
                
                $Ix = $_.Name
                $This.IO.$Ix.Background  = "#DFFFBA"
                $This.IO.$Ix.Foreground  = "#000000"
                $This.IO.$Ix.BorderBrush = "#000000"
            }

            $Item = ("Locale System Network Applications Backup Others" -Split " ")[$Slot]
            $Tx   = "{0}_Tab"   -f $Item
            $Px   = "{0}_Panel" -f $Item

            $This.IO.$Tx.Background  = "#4444FF"
            $This.IO.$Tx.Foreground  = "#FFFFFF"
            $This.IO.$Tx.BorderBrush = "#111111"
            $This.IO.$Px.Visibility  = "Visible"
        }
        Invoke()
        {
            $This.Xaml.Invoke()
        }
    }

    $Xaml                                             = [Main]::New($Root)

    # [Locale Panel]
    # Task Sequence Panel
    $Xaml.IO.Task_List.ItemsSource                    = @( )
    $Xaml.IO.Task_List.ItemsSource                    = @( $Xaml.TaskSequences )
    $Xaml.IO.Task_List.Add_SelectionChanged(
    {
        If ( $Xaml.IO.Task_List.SelectedIndex -ne -1)
        {
            $Xaml.IO.Task_ID.Text                     = $Xaml.IO.Task_List.SelectedItem.ID
        }
    })

    # Timezone
    $Xaml.IO.Locale_Timezone.ItemsSource              = @( )
    $Xaml.IO.Locale_Timezone.ItemsSource              = @( $Xaml.TimeZone.DisplayName )
    If ($Xaml.TSEnv["TimeZoneName"] -ne $Null)
    {
        $Xaml.IO.Locale_Timezone.SelectedItem         = $Xaml.Timezone | ? ID -eq $Xaml.TSEnv["TimeZoneName"] | % DisplayName
    }

    Else
    {
        $Xaml.IO.Locale_Timezone.SelectedIndex        = 0
    }

    # Keyboard
    $Xaml.IO.Locale_Keyboard.ItemsSource              = @( )
    $Xaml.IO.Locale_Keyboard.ItemsSource              = @( $Xaml.Locale.Culture )
    If ($Xaml.TSEnv["KeyboardLocale"] -ne $Null)
    {
        $Xaml.IO.Locale_Keyboard.SelectedItem         = $Xaml.Locale | ? Culture -eq $Xaml.TSEnv["KeyboardLocale"] | Select-Object -Last 1 | % Culture
    }
    Else
    {
        $Xaml.IO.Locale_Keyboard.SelectedIndex        = 0
    }

    # Language1
    $Xaml.IO.Locale_Language1.ItemsSource             = @( )
    $Xaml.IO.Locale_Language1.ItemsSource             = @( $Xaml.Locale.Name )
    If ($Xaml.TSEnv["KeyboardLocale"] -ne $Null)
    {

        $Xaml.IO.Locale_Language1.SelectedItem        = $Xaml.Locale | ? Culture -eq $Xaml.TSEnv["KeyboardLocale"] | Select-Object -Last 1 | % Name
    }
    Else
    {
        $Xaml.IO.Locale_Timezone.SelectedIndex        = 0
    }

    $Xaml.IO.Locale_Language2.ItemsSource             = @( )
    $Xaml.IO.Locale_SecondLanguage.IsChecked          = $False
    $Xaml.IO.Locale_SecondLanguage.Add_Click(
    {
        $Item = $Xaml.IO.Locale_SecondLanguage
        If (!$Item.IsChecked)
        {
            $Xaml.IO.Locale_Language2.IsEnabled       = $False
            $Xaml.IO.Locale_Language2.ItemsSource     = @( )
        }
        If ($Item.IsChecked)
        {
            $Xaml.IO.Locale_Language2.IsEnabled       = $True
            $Xaml.IO.Locale_Language2.ItemsSource     = @( $Xaml.Locale.Name )
            $Xaml.IO.Locale_Language2.SelectedIndex   = 0
        }
    })

    # [System]
    $Xaml.IO.System_Serial.Text                       = $Xaml.TSEnv["SerialNumber"]
    $Xaml.IO.System_IsVM.IsChecked                    = $Xaml.TSEnv["IsVm"]
    $Xaml.IO.System_Processor.Text                    = $Xaml.WMI.Processor.Name -Replace "\s+"," "
    $Xaml.IO.System_Memory.Text                       = "$([UInt32]$Xaml.TSEnv["Memory"] + 1)MB"

    $X                                                = $Null
    If     ($Xaml.TSEnv["IsDesktop"] -eq $True)   {$X = 0}
    ElseIf ($Xaml.TsEnv["IsLaptop"]  -eq $True)   {$X = 1}
    ElseIf ($Xaml.TsEnv["IsSff"]     -eq $True)   {$X = 2}
    ElseIf ($Xaml.TsEnv["IsServer"]  -eq $True)   {$X = 3}
    ElseIf ($Xaml.TsEnv["IsTablet"]  -eq $True)   {$X = 4}

    $Xaml.IO.System_Chassis.SelectedIndex             = $X
    $Xaml.IO.System_Chassis.ItemsSource               = @( )
    $Xaml.IO.System_Chassis.ItemsSource               = @("Desktop;Laptop;Small Form Factor;Server;Tablet" -Split ";")
    $Xaml.IO.System_IsVm.IsChecked                    = $Xaml.TSEnv["IsVm"]
    $Xaml.IO.System_Architecture.ItemsSource          = @( )
    $Xaml.IO.System_Architecture.ItemsSource          = @("x86","x64")
    $Xaml.IO.System_Architecture.SelectedIndex        = @(0,1)[$Xaml.TSEnv["Architecture"] -eq "x64"]
    $Xaml.IO.System_UseSerial.IsChecked               = 0
    $Xaml.IO.System_UseSerial.Add_Click(
    {
        If ($Xaml.IO.System_UseSerial.IsChecked)
        {
            $Xaml.IO.System_Name.Text                 = ($Xaml.TSEnv["SerialNumber"].Replace("-","")[0..14] -join '')
        }
        If (!$Xaml.IO.System_UseSerial.IsChecked)
        {
            $Xaml.IO.System_Name.Text                 = $Null
        }
    })

    # [Domain]
    $Xaml.IO.Domain_Type.ItemsSource                  = @( )
    $Xaml.IO.Domain_Type.ItemsSource                  = @("Domain","Workgroup")
    $Xaml.IO.Domain_Type.SelectedIndex                = 1
    $Xaml.IO.Domain_OrgModify.IsChecked               = $False
    $Xaml.IO.Domain_OrgName.Text                      = $Xaml.TSEnv["_SMSTSOrgName"]
    $Xaml.IO.Domain_OrgModify.Add_Click(
    {
        If ($Xaml.IO.Domain_OrgModify.IsChecked)
        {
            $Xaml.IO.Domain_OrgName.IsReadOnly        = $False
        }
        If (!$Xaml.IO.Domain_OrgModify.IsChecked)
        {
            $Xaml.IO.Domain_OrgName.IsReadOnly        = $True
        }
    })
    $Xaml.IO.Domain_Name.Text                         = $Xaml.TSEnv["UserDomain"]
    $Xaml.IO.Domain_Password.Password                 = $Xaml.TSEnv["UserPassword"]

    # [Network]
    $Xaml.IO.Network_Type.ItemsSource                 = @( )
    $Xaml.IO.Network_Type.ItemsSource                 = @("DHCP","Static")
    $Xaml.IO.Network_Type.SelectedIndex               = 0

    $Xaml.IO.Network_IPAddress.Text                   = $Xaml.TSEnv["IPAddress001"]
    $Xaml.IO.Network_IPAddress.IsReadOnly             = $True

    $IPInfo                                           = $Xaml.WMI.NetworkAdapter | ? IPAddress -eq $This.TSEnv["IPAddress001"] | Select *
    
    $Xaml.IO.Network_Gateway.Text                     = $IPInfo.DefaultIPGateway | ? { $_ -match "\d+\." } | Select-Object -First 1
    $Xaml.IO.Network_Gateway.IsReadOnly               = $True
    
    $Xaml.IO.Network_SubnetMask.Text                  = $IPInfo.IPSubnet         | ? { $_ -match "\d+\."} | Select-Object -First 1
    $Xaml.IO.Network_SubnetMask.IsReadOnly            = $True

    $Xaml.IO.Network_Dns.Text                         = $IPInfo.DNSServerSearchOrder -join ","
    $Xaml.IO.Network_Dns.IsReadOnly                   = $True

    $Xaml.IO.Network_Type.Add_SelectionChanged(
    {
        If ($Xaml.IO.Network_Type.SelectedIndex -eq 0)
        {
            $Xaml.IO.Network_IPAddress.IsReadOnly             = $True
            $Xaml.IO.Network_Gateway.IsReadOnly               = $True
            $Xaml.IO.Network_SubnetMask.IsReadOnly            = $True
            $Xaml.IO.Network_Dns.IsReadOnly                   = $True
        }
        If ($Xaml.IO.Network_Type.SelectedIndex -eq 1)
        {
            $Xaml.IO.Network_IPAddress.IsReadOnly             = $False
            $Xaml.IO.Network_Gateway.IsReadOnly               = $False
            $Xaml.IO.Network_SubnetMask.IsReadOnly            = $False
            $Xaml.IO.Network_Dns.IsReadOnly                   = $False
        }
    })

    # [Applications]
    $Xaml.IO.Applications.ItemsSource                 = @( )
    $Xaml.IO.Applications.ItemsSource                 = @( $Xaml.Applications )

    # [Backup]
    $Xaml.IO.Computer_Backup_Type.ItemsSource         = @( )
    $Xaml.IO.Computer_Backup_Type.ItemsSource         = @("Do not backup the existing computer","Automatically determine the location","Specify a location","-")
    $Xaml.IO.Computer_Backup_Type.SelectedIndex       = 3

    $Xaml.IO.Computer_Capture_Type.ItemsSource        = @( )
    $Xaml.IO.Computer_Capture_Type.ItemsSource        = @("Do not capture","Capture my computer","Sysprep this computer","Prepare to capture the machine","-")
    $Xaml.IO.Computer_Capture_Type.SelectedIndex      = 4

    $Xaml.IO.Computer_Capture_Extension.ItemsSource   = @( )
    $Xaml.IO.Computer_Capture_Extension.ItemsSource   = @("WIM","VHD","-")
    $Xaml.IO.Computer_Capture_Extension.SelectedIndex = 2

    $Xaml.IO.User_Backup_Type.ItemsSource             = @( )
    $Xaml.IO.User_Backup_Type.ItemsSource             = @("Do not save data and settings","Automatically determine the location","Specify a location","-")
    $Xaml.IO.User_Backup_Type.SelectedIndex           = 3

    # [Others]
    $Xaml.IO.Misc_Finish_Action.ItemsSource           = @( )
    $Xaml.IO.Misc_Finish_Action.ItemsSource           = @("Do nothing","Reboot","Shutdown","LogOff","-")
    $Xaml.IO.Misc_Finish_Action.SelectedIndex         = 4

    $Xaml.IO.Misc_Product_Key_Type.ItemsSource        = @( )
    $Xaml.IO.Misc_Product_Key_Type.ItemsSource        = @("No product key is required","Activate with multiple activation key(MAK)","Use a specific product key","-")
    $Xaml.IO.Misc_Product_Key_Type.SelectedIndex      = 3

    # [Menu Selection]
    $Xaml.IO.Locale_Tab.Add_Click(
    {
        $Xaml.View(0)
    })

    $Xaml.IO.System_Tab.Add_Click(
    {
        $Xaml.View(1)
    })

    $Xaml.IO.Network_Tab.Add_Click(
    {
        $Xaml.View(2)
    })

    $Xaml.IO.Applications_Tab.Add_Click(
    {
        $Xaml.View(3)
    })

    $Xaml.IO.Backup_Tab.Add_Click(
    {
        $Xaml.View(4)
    })

    $Xaml.IO.Others_Tab.Add_Click(
    {
        $Xaml.View(5)
    })

    $Xaml.IO.Start.Add_Click(
    {
        $Xaml.IO.DialogResult = $True
        $Xaml.IO.Close()
    })
    
    $Xaml.IO.Cancel.Add_Click(
    {
        $Xaml.IO.DialogResult = $False
        $Xaml.IO.Close()
    })

    $Xaml.Invoke()
    Return $Xaml
}
