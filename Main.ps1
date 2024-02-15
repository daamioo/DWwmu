# elevate to admin  source : https://ss64.com/ps/syntax-elevate.html
#If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
#{
#  # Relaunch as an elevated process:
#  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs 
#  exit
#}
# Now running elevated so launch the script:
#& "d:\long path name\script name.ps1" "Long Argument 1" "Long Argument 2"




Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Import-module -Name C:\Users\daamioo\Set-Window2.psm1 





function MOVEWindow{
param(
$mode,
$SelectedItemId
)
    #get display size 
    $left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
    $id = $SelectedItemId
    Write-Host $id




switch ($mode)
{
    #LEFT
    1 {
        $x = $left_most_screen.WorkingArea.X
        $y = $left_most_screen.WorkingArea.Y
        $screen_width = $left_most_screen.WorkingArea.Width
        $screen_height = $left_most_screen.WorkingArea.Height
    
    }
    #RIGHT
    2 {
        $x = 0
        $y = 0
        $screen_width = $left_most_screen.WorkingArea.Width
        $screen_height = $left_most_screen.WorkingArea.Height
    }
    #CENTER
    3 {
        $x = $left_most_screen.WorkingArea.X
        $y = $left_most_screen.WorkingArea.Y
        $screen_width = $left_most_screen.WorkingArea.Width+$left_most_screen.WorkingArea.Width
        $screen_height = $left_most_screen.WorkingArea.Height
    }
    #TOP
    4 {
		$x = $left_most_screen.WorkingArea.X
        $y = $left_most_screen.WorkingArea.Y
        $screen_width = $left_most_screen.WorkingArea.Width
        $screen_height = $left_most_screen.WorkingArea.Height
		
		

	}
    #BOTTOM
    5{
		$x = 0
        $y = 0
        $screen_width = $left_most_screen.WorkingArea.Width
        $screen_height = $left_most_screen.WorkingArea.Height
		
	}
}
    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $id -X $x -Y $y -Width $screen_width -Height $screen_height -Passthru


}




#timer init
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 10000

#form init
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Moving Utility'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'
#$Form.minimumSize = New-Object System.Drawing.Size(300,200)
#$Form.maximumSize = New-Object System.Drawing.Size(300,200)
$form.Topmost = $true
#$form.Scale(1.2)
$form.AutoScaleMode = 'Font'

$flipBechavour=$false



#button creation 
#LEFT
$LEFTButton = New-Object System.Windows.Forms.Button
$LEFTButton.Location = New-Object System.Drawing.Point(15,120)
$LEFTButton.Size = New-Object System.Drawing.Size(75,23)
$LEFTButton.Text = 'LEFT'
$LEFTButton.Add_Click({
   MOVEWindow 1 $listBox.SelectedItems.Id
})




$form.Controls.Add($LEFTButton)

#CENTER
$CENTERButton = New-Object System.Windows.Forms.Button
$CENTERButton.Location = New-Object System.Drawing.Point(100,120)
$CENTERButton.Size = New-Object System.Drawing.Size(75,23)
$CENTERButton.Text = 'CENTER'
$CENTERButton.Add_Click({
   MOVEWindow 3 $listBox.SelectedItems.Id
 })
 $form.Controls.Add($CENTERButton)

#RIGHT
$RIGHTButton = New-Object System.Windows.Forms.Button
$RIGHTButton.Location = New-Object System.Drawing.Point(185,120)
$RIGHTButton.Size = New-Object System.Drawing.Size(75,23)
$RIGHTButton.Text = 'RIGHT'
$RIGHTButton.Add_Click({
   MOVEWindow 2 $listBox.SelectedItems.Id
 })
 $form.Controls.Add($RIGHTButton)


#TOP
#LEFT
$TOPButton = New-Object System.Windows.Forms.Button
$TOPButton.Location = New-Object System.Drawing.Point(15,120)
$TOPButton.Size = New-Object System.Drawing.Size(75,23)
$TOPButton.Text = 'TOP'
$TOPButton.Add_Click({
   MOVEWindow 4 $listBox.SelectedItems.Id
})
$TOPButton.Visible= $false
$form.Controls.Add($TOPButton)

#BOTTOM
$BOTTOMButton = New-Object System.Windows.Forms.Button
$BOTTOMButton.Location = New-Object System.Drawing.Point(185,120)
$BOTTOMButton.Size = New-Object System.Drawing.Size(75,23)
$BOTTOMButton.Text = 'BOTTOM'
$BOTTOMButton.Add_Click({
   MOVEWindow 5 $listBox.SelectedItems.Id
 })
 $BOTTOMButton.Visible= $false
 $form.Controls.Add($BOTTOMButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Select the app you wish to move'
$form.Controls.Add($label)


#list initialization
$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,10)

$listBox.SelectionMode = 'One'

[void] $listBox.Items.Add('ERROR')







#initial  list update
$processes = Get-Process | Where-Object {$_.MainWindowTitle -ne ""}  | Select-Object MainWindowTitle , Id
$listBox.Items.Clear()
$processes | ForEach-Object {
    $listBox.Items.Add($_)
}

$LastState = 0
#UI REFRESH
$timer.add_tick({ 
$processes = Get-Process | Where-Object {$_.MainWindowTitle -ne ""}  | Select-Object MainWindowTitle , Id
$listBox.Items.Clear()
$processes | ForEach-Object {
    $listBox.Items.Add($_)
}

$CurentState= 0
#$CurentState = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration\CMO01C20_09_07D9_75_4D4F4351_41333530_00000000_FFFFFFFF_0+CMO01C20_09_07D9_75_4D4F4351_41333530_00000000_FFFFFFFF_1^5C8681772B3C097FC5B11CBF9F01382C\00\00' -Name Rotation
if($CurentState -ne $LastState){
$LastState = $CurentState
switch ($CurentState)
{
    #RIGHT(P)-LEFT
    1 {
    $LEFTButton.Visible=$true
    $CENTERButton.Visible=$true
    $RIGHTBUTTON.Visible=$true


    $TOPButton.Visible=$false
    $BOTTOMButton=$false
    
   


    }
    #BOTTOM-TOP
    2 {
    $LEFTButton.Visible=$false
    $CENTERButton.Visible=$false
    $RIGHTBUTTON.Visible=$false


    $TOPButton.Visible=$true
    $BOTTOMButton.Visible=$true

    

    }
    ##LEFT-RIGHT(P)
    3 {
    $LEFTButton.Visible=$false
    $CENTERButton.Visible=$false
    $RIGHTBUTTON.Visible=$false

    $TOPButton.Visible=$false
    $BOTTOMButton=$false

   

    }
    #TOP-BOTTOM
    4 {
    $LEFTButton.Visible=$false
    $CENTERButton.Visible=$false
    $RIGHTBUTTON.Visible=$false

    $TOPButton.Visible=$false
    $BOTTOMButton=$false
    

}	
	
}
}

})

$timer.start()

$listBox.Height = 70
$form.Controls.Add($listBox)



$result = $form.ShowDialog()
