Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Import-module -Name C:\Users\daamioo\Set-Window2.psm1 









function CENTERWindow {
    param (
        $SelectedItemId
    )
    Write-Host $DesiredPositon $SelectedItem
    
    $left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
    $x = $left_most_screen.WorkingArea.X
    $y = $left_most_screen.WorkingArea.Y
    $screen_width = $left_most_screen.WorkingArea.Width+$left_most_screen.WorkingArea.Width
    $screen_height = $left_most_screen.WorkingArea.Height
    $id = $SelectedItemId
    Write-Host $screen_width
    Write-Host $screen_height
    Write-Host $x
    Write-Host $y

    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru
    #Set-Window -ProcessId $id -X $x -Y $screen_height -Width $screen_width -Height $screen_height -Passthru
}


function  LEFTWindow   {
    param (
        $SelectedItemId
    )
    Write-Host $DesiredPositon $SelectedItem

    $left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
    $x = $left_most_screen.WorkingArea.X
    $y = $left_most_screen.WorkingArea.Y
    $screen_width = $left_most_screen.WorkingArea.Width
    $screen_height = $left_most_screen.WorkingArea.Height
    $id = $SelectedItemId
    Write-Host $screen_width
    Write-Host $screen_height
    Write-Host $x
    Write-Host $y

    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru
    #Set-Window -ProcessId $id -X $x -Y $screen_height -Width $screen_width -Height $screen_height -Passthru
}


function RIGHTWindow {
    param (
    $SelectedItemId
    )
    Write-Host $DesiredPositon $SelectedItem

    $left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
    $x = $left_most_screen.WorkingArea.X
    $screen_width = $left_most_screen.WorkingArea.Width
    $screen_height = $left_most_screen.WorkingArea.Height
    $id = $SelectedItemId
    Write-Host $screen_width
    Write-Host $screen_height
    Write-Host $x
    Write-Host $y

    Set-Window -ProcessId $id -X 0 -Y 0 -Width $screen_width -Height $screen_height -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $id -X 0 -Y 0 -Width $screen_width -Height $screen_height -Passthru
    #Set-Window -ProcessId $id -X $x -Y $screen_height -Width $screen_width -Height $screen_height -Passthru
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 10000


$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Moving Utility'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$LEFTButton = New-Object System.Windows.Forms.Button
$LEFTButton.Location = New-Object System.Drawing.Point(15,120)
$LEFTButton.Size = New-Object System.Drawing.Size(75,23)
$LEFTButton.Text = 'LEFT'

$LEFTButton.Add_Click({
    LEFTWindow($listBox.SelectedItems.Id)
})
$form.Controls.Add($LEFTButton)


$CENTERButton = New-Object System.Windows.Forms.Button
$CENTERButton.Location = New-Object System.Drawing.Point(100,120)
$CENTERButton.Size = New-Object System.Drawing.Size(75,23)
$CENTERButton.Text = 'CENTER'
$CENTERButton.Add_Click({
    CENTERWindow($listBox.SelectedItems.Id)
 })
 $form.Controls.Add($CENTERButton)


$RIGHTButton = New-Object System.Windows.Forms.Button
$RIGHTButton.Location = New-Object System.Drawing.Point(185,120)
$RIGHTButton.Size = New-Object System.Drawing.Size(75,23)
$RIGHTButton.Text = 'RIGHT'
$RIGHTButton.Add_Click({
    RIGHTWindow($listBox.SelectedItems.Id)
 })
 $form.Controls.Add($RIGHTButton)


$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Select the app you wish to move'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'One'

[void] $listBox.Items.Add('ERROR')
#initial  update
$processes = Get-Process | Where-Object {$_.MainWindowTitle -ne ""}  | Select-Object MainWindowTitle , Id
$listBox.Items.Clear()
$processes | ForEach-Object {
    $listBox.Items.Add($_)
}


#refreshing updates
$timer.add_tick({ 
$processes = Get-Process | Where-Object {$_.MainWindowTitle -ne ""}  | Select-Object MainWindowTitle , Id
$listBox.Items.Clear()
$processes | ForEach-Object {
    $listBox.Items.Add($_)
}
})

$timer.start()

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true
$result = $form.ShowDialog()
