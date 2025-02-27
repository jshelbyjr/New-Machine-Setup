#Terminal and code editor
winget install --id=Microsoft.WindowsTerminal  -e
winget install --id=Microsoft.VisualStudioCode  -e
winget install --id=JanDeDobbeleer.OhMyPosh  -e
winget install --id=Microsoft.Git  -e

#language support
winget install Microsoft.Powershell --installer-type WIX --source winget #required due to update install method installing portable zip files
winget install --id=Python.Python.3.13 -e

#adding password manager
winget install --id=AgileBits.1Password -e

#Adding Google Chrome
winget install --id=Google.Chrome  -e

#update all
winget update --all

#Ensure we are now using PowerShell 7
pwsh.exe

# Set explorer to show hidden items and extensions
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
# Set-ItemProperty $key ShowSuperHidden 1
Stop-Process -processname explorer

#setup Oh-my-posh PowerShell profiles
$PSProfileRoot = $env:USERPROFILE + '\Documents'
$wPSDir = $PSProfileRoot + '\WindowsPowerShell'
$wPS = $wPSDir + '\Microsoft.PowerShell_profile.ps1'
$ps7Dir = $PSProfileRoot + '\PowerShell'
$ps7 = $ps7Dir + '\Microsoft.PowerShell_profile.ps1'
$vscode = $ps7Dir + '\Microsoft.VSCode_profile.ps1'

$wsprofile = Test-Path $wPS
$ps7profile = Test-Path $ps7

# Ensure PowerShell profiles exist
# Create folders if they don't exist
if (-not (Test-Path $wPSDir)) {
    Write-Host "Creating Windows PowerShell profile directory"
    New-Item -ItemType Directory -Path $wPSDir -Force -Verbose
    Write-Host "could not create folder"
}
if (-not (Test-Path $ps7Dir)) {
    Write-Host "Creating PS7 profile directory"
    New-Item -ItemType Directory -Path $ps7Dir -Force
}

# Create files if they don't exist
if (-not $wsprofile) {
    Write-Host "Creating Windows PowerShell profile file"
    New-Item -ItemType File -Path $wPS -Force
}
if (-not $ps7profile) {
    Write-Host "Creating PS7 profile file"
    New-Item -ItemType File -Path $ps7 -Force
    New-Item -ItemType File -Path $vscode -Force
} 

# Setup oh-my-posh themes for PS7 and Win PowerShell
#install NERD Font
oh-my-posh font install CascadiaCode

#set theme in profiles
$ps7content ='oh-my-posh --init --shell pwsh --config "$env:Posh-Themes_path\atomic.omp.json" | Invoke-Expression'
$wpscontent ='oh-my-posh --init --shell powershell --config "$env:Posh-Themes_path\atomic.omp.json" | Invoke-Expression'

Set-Content -path $ps7 -value $ps7content
Set-Content -path $vscode -value $ps7content
Add-Content -path $ps7 -value "Import-Module Terminal-Icons"
Add-Content -path $vscode -value "Import-Module Terminal-Icons"
Set-Content -path $WPS -value $wpscontent
Add-Content -path $WPS -value "Import-Module Terminal-Icons"

Write-Host "Don't forget to update Terminal default profile font and VSCode default font to use Caccadai NF" -background yellow -foreground red

#Install modules
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module PNP.PowerShell -Scope CurrentUser -force
Install-Module Microsoft.Graph -Scope CurrentUser -force

##Install WSL with default Ubuntu distribution 
wsl --install

#install Sandbox
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

#update WSL
# 1st time is interactive you have to set username/password
# when updating SUDO you have to again enter password

wsl.exe
bash
sudo apt update
sudo apt upgrade

sudo apt install unzip
curl -s https://ohmyposh.dev/install.sh | bash -s
exit
bash
oh-my-posh font install cascadiacode

cd
echo 'eval "$(${HOME}/.local/bin/oh-my-posh init bash --config ${HOME}/.cache/oh-my-posh/themes/atomic.omp.json)"' >> ~/.bashrc
eval "$(oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/atomic.omp.json)"

#Restart for all changes
Restart-Computer
