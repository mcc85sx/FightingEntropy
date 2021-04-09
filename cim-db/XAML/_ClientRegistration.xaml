<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Client Registration" 
        Height="520" 
        Width="800">
    <Window.Resources>
        <Style TargetType="TextBox" x:Key="_TextBox">
            <Setter Property="Height" Value="30"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontSize" Value="18"/>
        </Style>
    </Window.Resources>
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
                <ColumnDefinition Width="0.5*"/>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <GroupBox Grid.Column="0" Header="[First Name]">
                <TextBox Style="{StaticResource _TextBox}" Name="_First"/>
            </GroupBox>
            <GroupBox Grid.Column="1" Header="[Middle]">
                <TextBox Style="{StaticResource _TextBox}" Name="_MI"/>
            </GroupBox>
            <GroupBox Grid.Column="2" Header="[Last Name]">
                <TextBox Style="{StaticResource _TextBox}" Name="_Last"/>
            </GroupBox>
            <GroupBox Grid.Column="3" Header="[Gender]">
                <ComboBox Name="_Gender" Height="24" Margin="5" SelectedIndex="2">
                    <ComboBoxItem Content="Male"/>
                    <ComboBoxItem Content="Female"/>
                    <ComboBoxItem Content="N/A"/>
                </ComboBox>
            </GroupBox>
        </Grid>
        <GroupBox Grid.Row="1" Header="[Address]">
            <TextBox Style="{StaticResource _TextBox}" Name="_Address"/>
        </GroupBox>
        <Grid Grid.Row="2">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="3*"/>
                <ColumnDefinition Width="2*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="2*"/>
            </Grid.ColumnDefinitions>
            <GroupBox Grid.Column="0" Header="[Town/Village/City]">
                <TextBox Style="{StaticResource _TextBox}" Name="_City"/>
            </GroupBox>
            <GroupBox Grid.Column="1" Header="[Region]">
                <TextBox Style="{StaticResource _TextBox}" Name="_Region"/>
            </GroupBox>
            <GroupBox Grid.Column="2" Header="[Country]">
                <TextBox Style="{StaticResource _TextBox}" Name="_Country"/>
            </GroupBox>
            <GroupBox Grid.Column="3" Header="[Postal/Zip]">
                <TextBox Style="{StaticResource _TextBox}" Name="_Postal"/>
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
                    <ColumnDefinition Width="60"/>
                    <ColumnDefinition Width="60"/>
                    <ColumnDefinition Width="90"/>
                    <ColumnDefinition Width="4*"/>
                </Grid.ColumnDefinitions>
                <GroupBox Grid.Column="0" Header="[MM]">
                    <TextBox Style="{StaticResource _TextBox}" Name="_Month"/>
                </GroupBox>
                <GroupBox Grid.Column="1" Header="[DD]">
                    <TextBox Style="{StaticResource _TextBox}" Name="_Day"/>
                </GroupBox>
                <GroupBox Grid.Column="2" Header="[YYYY]">
                    <TextBox Style="{StaticResource _TextBox}" Name="_Year"/>
                </GroupBox>
                <GroupBox Grid.Column="3" Header="[DOB]">
                    <TextBlock Name="_DOB" Margin="5" />
                </GroupBox>
            </Grid>
            <GroupBox Header="[Phone]" Grid.Column="0" Grid.Row="1">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="40"/>
                        <ColumnDefinition Width="40"/>
                    </Grid.ColumnDefinitions>
                    <ComboBox Grid.Column="0" Margin="5"/>
                        <Button Grid.Column="1" Margin="5" Content="+" Name="_AddPhone"/>
                    <Button Grid.Column="2" Margin="5" Content="-" Name="_RemovePhone"/>
                </Grid>
            </GroupBox>
            <GroupBox Header="[Email]" Grid.Column="0" Grid.Row="2">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="40"/>
                        <ColumnDefinition Width="40"/>
                    </Grid.ColumnDefinitions>
                    <ComboBox Grid.Column="0" Margin="5"/>
                    <Button Grid.Column="1" Margin="5" Content="+" Name="_AddEmail"/>
                    <Button Grid.Column="2" Margin="5" Content="-" Name="_RemoveEmail"/>
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
        <GroupBox Grid.Row="4" Header="[Device]">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="40"/>
                    <ColumnDefinition Width="40"/>
                </Grid.ColumnDefinitions>
                <ComboBox Grid.Column="0" Margin="5"/>
                <Button Grid.Column="1" Margin="5" Content="+" Name="_AddDevice"/>
                <Button Grid.Column="2" Margin="5" Content="-" Name="_RemoveDevice"/>
            </Grid>
        </GroupBox>
        <GroupBox Grid.Row="5" Header="[Invoice]">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="40"/>
                    <ColumnDefinition Width="40"/>
                </Grid.ColumnDefinitions>
                <ComboBox Grid.Column="0" Margin="5"/>
                <Button Grid.Column="1" Margin="5" Content="+" Name="_AddInvoice"/>
                <Button Grid.Column="2" Margin="5" Content="-" Name="_RemoveInvoice"/>
            </Grid>
        </GroupBox>
    </Grid>
</Window>
