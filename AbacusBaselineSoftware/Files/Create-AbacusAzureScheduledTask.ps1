#Create-AbacusAzureScheduledTask.ps1

### Copy Script file to proper location

If (!(test-path -pathtype Container C:\AbacusScripts)) {New-item -itemtype directory -force -path c:\AbacusScripts}

Copy-Item ".\Run-AbacusAzureScheduledTask.ps1" -Destination C:\AbacusScripts\Run-AbacusAzureScheduledTask.ps1 -Force

### Create Scheduled Task

$Trigger= New-ScheduledTaskTrigger -At 7:00pm -Daily
$User= "NT AUTHORITY\SYSTEM"
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass C:\AbacusScripts\Run-AbacusAzureScheduledTask.ps1"
Register-ScheduledTask -TaskName "Run-AbacusAzureScheduledTask" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force