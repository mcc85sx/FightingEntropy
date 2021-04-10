Class _Xaml
{
    Hidden [Object]        $Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Company Information Management Database [FightingEntropy]://(cim-db)" 
    Height="600" 
    Width="800"
    FontFamily="Consolas">
<Window.Resources>
    <Style TargetType="TabItem">
        <Setter Property="FontSize" Value="15"/>
        <Setter Property="FontWeight" Value="Heavy"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TabItem">
                    <Border Name="Border" BorderThickness="2,2,2,2" BorderBrush="Black" CornerRadius="2" Margin="2">
                        <ContentPresenter x:Name="ContentSite" VerticalAlignment="Center" HorizontalAlignment="Right" ContentSource="Header" Margin="5"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter TargetName="Border" Property="Background" Value="#4444FF"/>
                            <Setter Property="Foreground" Value="#FFFFFF"/>
                        </Trigger>
                        <Trigger Property="IsSelected" Value="False">
                            <Setter TargetName="Border" Property="Background" Value="#DFFFBA"/>
                            <Setter Property="Foreground" Value="#000000"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    <Style TargetType="Button">
        <Setter Property="FontSize" Value="16"/>
        <Setter Property="FontWeight" Value="Heavy"/>
        <Setter Property="Foreground" Value="Black"/>
        <Setter Property="BorderThickness" Value="2"/>
        <Style.Resources>
            <Style TargetType="Border">
                <Setter Property="CornerRadius" Value="2"/>
            </Style>
        </Style.Resources>
    </Style>
    <Style TargetType="TextBox">
        <Setter Property="Height" Value="24"/>
        <Setter Property="Margin" Value="4"/>
        <Setter Property="FontSize" Value="12"/>
        <Setter Property="BorderThickness" Value="2"/>
        <Setter Property="Foreground" Value="#000000"/>
        <Style.Resources>
            <Style TargetType="Border">
                <Setter Property="CornerRadius" Value="2"/>
            </Style>
        </Style.Resources>
    </Style>
    <Style TargetType="ComboBox">
        <Setter Property="Height" Value="24"/>
        <Setter Property="Margin" Value="5"/>
        <Setter Property="FontSize" Value="12"/>
        <Setter Property="FontWeight" Value="Normal"/>
    </Style>
    <Style TargetType="DataGridColumnHeader">
        <Setter Property="FontSize"   Value="12"/>
        <Setter Property="FontWeight" Value="Normal"/>
    </Style>
</Window.Resources>
<TabControl TabStripPlacement="Left" HorizontalContentAlignment="Right">
    <TabControl.Resources>
        <Style TargetType="GroupBox">
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="Normal"/>
        </Style>
    </TabControl.Resources>
    <TabItem Header="Client">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetClientSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Name"/>
                            <ComboBoxItem Content="Phone Number"/>
                            <ComboBoxItem Content="Email Address"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >
                            
                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetClientSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetClientSearchBox">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name" Width="*"/>
                            <DataGridTextColumn Header="Last" Width="*"/>
                            <DataGridTextColumn Header="First" Width="*"/>
                            <DataGridTextColumn Header="MI" Width="0.25*"/>
                            <DataGridTextColumn Header="DOB" Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </TabItem>
            <TabItem Header="View">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="3*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_ViewClientLast"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_ViewClientFirst"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_ViewClientMI"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="1" Header="[Address]">
                        <TextBox Name="_ViewClientAddress"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_ViewClientCity"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_ViewClientRegion"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_ViewClientCountry"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_ViewClientPostal"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="3">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Column="0" Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2.5*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBox Grid.Column="0" Name="_ViewClientMonth"/>
                                    <TextBox Grid.Column="1" Name="_ViewClientDay"/>
                                    <TextBox Grid.Column="2" Name="_ViewClientYear"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Column="3" Header="[Gender]">
                                <ComboBox Name="_ViewClientGender" SelectedIndex="2">
                                    <ComboBoxItem Content="Male"/>
                                    <ComboBoxItem Content="Female"/>
                                    <ComboBoxItem Content="-"/>
                                </ComboBox>
                            </GroupBox>
                        </Grid>
                        <GroupBox Header="[Phone Number(s)]" Grid.Column="0" Grid.Row="1">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddPhone"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemovePhone"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddEmail"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveEmail"/>
                            </Grid>
                        </GroupBox>
                        <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                    </Grid>
                    <Grid Grid.Row="4">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="240"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                    </Grid>
                    <GroupBox Grid.Row="4" Header="[Device(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddDevice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveDevice"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0" Margin="5"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_ViewClientAddInvoice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_ViewClientRemoveInvoice"/>
                        </Grid>
                    </GroupBox>
                </Grid>
            </TabItem>
            <TabItem Header="Edit">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="3*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_EditClientFirst"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_EditClientMI"/>
                        </GroupBox>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_EditClientLast"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="1" Header="[Address]">
                        <TextBox Name="_EditClientAddress"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_EditClientCity"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_EditClientRegion"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_EditClientCountry"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_EditClientPostal"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="3">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Column="0" Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2.5*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBox Grid.Column="0" Name="_EditClientMonth"/>
                                    <TextBox Grid.Column="1" Name="_EditClientDay"/>
                                    <TextBox Grid.Column="2" Name="_EditClientYear"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Column="3" Header="[Gender]">
                                <ComboBox Name="_EditClientGender" Height="24" Margin="5" SelectedIndex="2">
                                    <ComboBoxItem Content="Male"/>
                                    <ComboBoxItem Content="Female"/>
                                    <ComboBoxItem Content="-"/>
                                </ComboBox>
                            </GroupBox>
                        </Grid>
                        <GroupBox Header="[Phone Number(s)]"  Grid.Column="0" Grid.Row="1">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Margin="5"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddPhone"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemovePhone"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Margin="5"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddEmail"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveEmail"/>
                            </Grid>
                        </GroupBox>
                        <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                    </Grid>
                    <Grid Grid.Row="4">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="240"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                    </Grid>
                    <GroupBox Grid.Row="4" Header="[Device(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0" Margin="5"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddDevice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveDevice"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0" Margin="5"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_EditClientAddInvoice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_EditClientRemoveInvoice"/>
                        </Grid>
                    </GroupBox>
                </Grid>
            </TabItem>
            <TabItem Header="New">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="3*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="0.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="1" Header="[First]">
                            <TextBox Name="_NewClientFirst"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[MI]">
                            <TextBox Name="_NewClientMI"/>
                        </GroupBox>
                        <GroupBox Grid.Column="0" Header="[Last]">
                            <TextBox Name="_NewClientLast"/>
                        </GroupBox>
                    </Grid>
                    <GroupBox Grid.Row="1" Header="[Address]">
                        <TextBox Name="_NewClientAddress"/>
                    </GroupBox>
                    <Grid Grid.Row="2">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="3*"/>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="1.5*"/>
                        </Grid.ColumnDefinitions>
                        <GroupBox Grid.Column="0" Header="[City]">
                            <TextBox Name="_NewClientCity"/>
                        </GroupBox>
                        <GroupBox Grid.Column="1" Header="[Region]">
                            <TextBox Name="_NewClientRegion"/>
                        </GroupBox>
                        <GroupBox Grid.Column="2" Header="[Country]">
                            <TextBox Name="_NewClientCountry"/>
                        </GroupBox>
                        <GroupBox Grid.Column="3" Header="[Postal]">
                            <TextBox Name="_NewClientPostal"/>
                        </GroupBox>
                    </Grid>
                    <Grid Grid.Row="3">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        <Grid Grid.Column="0" Grid.Row="0">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2.5*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <GroupBox Grid.Column="0" Header="[DOB(MM/DD/YYYY)]">
                                <Grid>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="0.5*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBox Grid.Column="0" Name="_NewClientMonth"/>
                                    <TextBox Grid.Column="1" Name="_NewClientDay"/>
                                    <TextBox Grid.Column="2" Name="_NewClientYear"/>
                                </Grid>
                            </GroupBox>
                            <GroupBox Grid.Column="3" Header="[Gender]">
                                <ComboBox Name="_NewClientGender" Height="24" Margin="5" SelectedIndex="2">
                                    <ComboBoxItem Content="Male"/>
                                    <ComboBoxItem Content="Female"/>
                                    <ComboBoxItem Content="-"/>
                                </ComboBox>
                            </GroupBox>
                        </Grid>
                        <GroupBox Header="[Phone Number(s)]"  Grid.Column="0" Grid.Row="1">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Margin="5"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddPhone"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemovePhone"/>
                            </Grid>
                        </GroupBox>
                        <GroupBox Header="[Email Address(es)]" Grid.Column="0" Grid.Row="2">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="40"/>
                                    <ColumnDefinition Width="40"/>
                                </Grid.ColumnDefinitions>
                                <ComboBox Grid.Column="0" Margin="5"/>
                                <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddEmail"/>
                                <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveEmail"/>
                            </Grid>
                        </GroupBox>
                        <Canvas Grid.Column="1" Grid.RowSpan="3"/>
                    </Grid>
                    <Grid Grid.Row="4">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="240"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="60"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                    </Grid>
                    <GroupBox Grid.Row="4" Header="[Device(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0" Margin="5"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddDevice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveDevice"/>
                        </Grid>
                    </GroupBox>
                    <GroupBox Grid.Row="5" Header="[Invoice(s)]">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="40"/>
                                <ColumnDefinition Width="40"/>
                            </Grid.ColumnDefinitions>
                            <ComboBox Grid.Column="0" Margin="5"/>
                            <Button Grid.Column="1" Margin="5" Content="+" Name="_NewClientAddInvoice"/>
                            <Button Grid.Column="2" Margin="5" Content="-" Name="_NewClientRemoveInvoice"/>
                        </Grid>
                    </GroupBox>
                </Grid>
            </TabItem>
        </TabControl>
    </TabItem>
    <TabItem Header="Service">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetServiceSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Name"/>
                            <ComboBoxItem Content="Description"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >

                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetServiceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetServiceSearchBox">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Name" Width="*"/>
                            <DataGridTextColumn Header="Description" Width="*"/>
                            <DataGridTextColumn Header="Cost" Width="0.5*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </TabItem>
            <TabItem Header="View">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_ViewServiceName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_ViewServiceDescription"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_ViewServiceCost"/>
                    </GroupBox>
                </Grid>
            </TabItem>
            <TabItem Header="Edit">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_EditServiceName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_EditServiceDescription"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_EditServiceCost"/>
                    </GroupBox>
                </Grid>
            </TabItem>
            <TabItem Header="New">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Name]">
                        <TextBox Name="_NewServiceName"/>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Description]">
                        <TextBox Name="_NewServiceDescription"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Cost]">
                        <TextBox Name="_NewServiceCost"/>
                    </GroupBox>
                </Grid>
            </TabItem>
        </TabControl>
    </TabItem>
    <TabItem Header="Device">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetDeviceSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Vendor"/>
                            <ComboBoxItem Content="Model"/>
                            <ComboBoxItem Content="Specification"/>
                        </ComboBox>
                        <TextBox Grid.Column="1" >

                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetDeviceSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetDeviceSearchBox">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor" Width="*"/>
                            <DataGridTextColumn Header="Model" Width="*"/>
                            <DataGridTextColumn Header="Specification" Width="*"/>
                            <DataGridTextColumn Header="Serial" Width="*"/>
                            <DataGridTextColumn Header="Owner"  Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </TabItem>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                        <RowDefinition Height="64"/>
                    </Grid.RowDefinitions>
                    <GroupBox Grid.Row="0" Header="[Chassis]">
                        <ComboBox Name="_NewDeviceChassis">
                            <ComboBoxItem Content="Desktop"/>
                            <ComboBoxItem Content="Laptop"/>
                            <ComboBoxItem Content="Smartphone"/>
                            <ComboBoxItem Content="Tablet"/>
                            <ComboBoxItem Content="Console"/>
                            <ComboBoxItem Content="Server"/>
                            <ComboBoxItem Content="Network"/>
                            <ComboBoxItem Content="Other"/>
                        </ComboBox>
                    </GroupBox>
                    <GroupBox Grid.Row="1" Header="[Vendor]">
                        <TextBox Name="_NewDeviceVendor"/>
                    </GroupBox>
                    <GroupBox Grid.Row="2" Header="[Model]">
                        <TextBox Name="_NewDeviceModel"/>
                    </GroupBox>
                    <GroupBox Grid.Row="3" Header="[Specification]">
                        <TextBox Name="_NewDeviceSpecification"/>
                    </GroupBox>
                </Grid>
            </TabItem>
        </TabControl>
    </TabItem>
    <TabItem Header="Issue">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="35"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="35"/>
                    </Grid.RowDefinitions>
                    <Grid Grid.Row="0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="4*"/>
                        </Grid.ColumnDefinitions>
                        <ComboBox Grid.Column="0" Name="_GetIssueSearchType" SelectedIndex="0" BorderThickness="1">
                            <ComboBoxItem Content="Client"/>
                            <ComboBoxItem Content="Device"/>
                            
                        </ComboBox>
                        <TextBox Grid.Column="1" >

                        </TextBox>
                        <TextBox Grid.Column="1" Name="_GetIssueSearchFilter"/>
                    </Grid>
                    <DataGrid Grid.Row="1" Margin="5" Name="_GetIssueSearchBox">
                        <DataGrid.Columns>
                            <DataGridTextColumn Header="Vendor" Width="*"/>
                            <DataGridTextColumn Header="Model" Width="*"/>
                            <DataGridTextColumn Header="Specification" Width="*"/>
                            <DataGridTextColumn Header="Serial" Width="*"/>
                            <DataGridTextColumn Header="Owner"  Width="*"/>
                        </DataGrid.Columns>
                    </DataGrid>
                </Grid>
            </TabItem>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
    <TabItem Header="Inventory">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get"/>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
    <TabItem Header="Purchase">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get"/>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
    <TabItem Header="Expense">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get"/>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
    <TabItem Header="Account">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get"/>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
    <TabItem Header="Invoice">
        <TabControl TabStripPlacement="Top" HorizontalContentAlignment="Center">
            <TabItem Header="Get"/>
            <TabItem Header="View"/>
            <TabItem Header="Edit"/>
            <TabItem Header="New"/>
        </TabControl>
    </TabItem>
</TabControl>
</Window>
"@
    [String[]]            $Names
    Hidden [Object]         $XML
    [Object]               $Node
    [Object]                 $IO

    [String[]] FindNames()
    {
        [Regex]"((Name)\s*=\s*('|`")\w+('|`"))" | % Matches $This.Xaml | % Value | % {
            
            $Line   = $_.Split('"')[1]
            If ( $Line -notin $This.Names )
            {
                $This.Names += $Line
                $Line
            }
        }

        Return $This.Names
    }

    _Xaml()
    {           
        [System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

        $This.Names              = $This.FindNames()
        $This.XML                = [XML]$This.Xaml
        $This.Node               = [System.Xml.XmlNodeReader]::New($This.XML)
        $This.IO                 = [System.Windows.Markup.XamlReader]::Load($This.Node)
    
        $This.Names              | % { 
            
            $This.IO             | Add-Member -MemberType NoteProperty -Name $_ -Value $This.IO.FindName($_) -Force
        
        }
    }

    Invoke()
    {
        $This.IO.Dispatcher.InvokeAsync{$This.IO.ShowDialog()}.Wait()
    }
}
