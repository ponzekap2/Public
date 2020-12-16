If (!(test-path -pathtype Container C:\AbacusScripts)) {New-item -itemtype directory -force -path c:\AbacusScripts}
Start-Transcript c:\AbacusScripts\InstallAbacusChocolateyTranscript.log
$ChocoPath = "C:\ProgramData\chocolatey\bin\choco.exe"


$ChocoInstalled = [System.IO.File]::Exists($ChocoPath)

if ($ChocoInstalled -match "False") {

    Write-Output "Chocolatey not installed"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

}

# Add repository from full chocolatey path

$SourceList = C:\ProgramData\chocolatey\bin\choco.exe source list

### Check if abacus feed is installed

$AbacusSourceList = $SourceList -match "accessabacus"

if ($AbacusSourceList.count -lt 1) {Write-Output "Missing"

C:\ProgramData\chocolatey\bin\choco source add -n=abacus-test-feed -s="https://pkgs.dev.azure.com/accessabacus/Chocolatey/_packaging/test-feed/nuget/v2" -u="adm-pponzeka@accessabacus.com" -p="qtdhnuvl43jir4uksjmrwudzkxzyw3wyyauhasayb4lkkkruu4za"

}






