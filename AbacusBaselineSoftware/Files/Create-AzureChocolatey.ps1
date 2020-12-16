### Copy Script file to proper location

If (!(test-path -pathtype Container C:\AbacusScripts)) {New-item -itemtype directory -force -path c:\AbacusScripts}

Copy-Item ".\Install-AzureChocolatey.ps1" -Destination C:\AbacusScripts\Install-AzureChocolatey.ps1 -Force

### Create Scheduled Task

$Trigger= New-ScheduledTaskTrigger -At 8:00am -Daily
$User= "NT AUTHORITY\SYSTEM"
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass C:\AbacusScripts\Install-AzureChocolatey.ps1"
Register-ScheduledTask -TaskName "Install-AzureChocolatey" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force


#####  Call Second Step
.\Create-AbacusAzureScheduledTask.ps1