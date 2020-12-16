$connectionName = "AzureRunAsConnection"
$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
$logonAttempt = 0
$logonResult = $False
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    #Logging in to Azure...
    $connectionResult = Connect-AzAccount `
                           -ServicePrincipal `
                           -Tenant $servicePrincipalConnection.TenantId `
                           -ApplicationId $servicePrincipalConnection.ApplicationId `
                           -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    Start-Sleep -Seconds 30
}
#### Need to make the below come from central location/repository
### Set-AzVMCustomScriptExtension -ResourceGroupName <RG> -VMName <VM> -Location eastus -FileUri https://test.blob.core.windows.net/containerA/test/c_ext.ps1 -Run 'test\c_ext.ps1' -Name DemoScriptExtension

### Global Settings
$fileUri = @("https://xxxxxxx.blob.core.windows.net/buildServer1/Create-AzureChocolatey.ps1",
"https://xxxxxxx.blob.core.windows.net/buildServer1/Install-AzureChocolatey.ps1",
"https://xxxxxxx.blob.core.windows.net/buildServer1/Create-AbacusAzureScheduledTask.ps1",
"https://xxxxxxx.blob.core.windows.net/buildServer1/Run-AbacusAzureScheduledTask.ps1")
$settings = @{"fileUris" = $fileUri};
$protectedSettings = @{"commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File Create-AzureChocolatey.ps1"};

$AllVM = Get-AZVM -Status
$Key = (Get-AzStorageAccountKey -Name $SAName -ResourceGroupName $rgname).value[0]
### Target Running Machines
$RunningVM = $AllVM | ?{$_.PowerState -match "running"}



foreach ($vm in $RunningVM) {

    #run command
    
    Set-AzVMCustomScriptExtension -ResourceGroupName $rgname -Location $vm.location -VMName $vm.Name -ForceRerun $true -Name Install-AbacusAzureNightlyTask -Settings $settings -ProtectedSettings $protectedSettings

}