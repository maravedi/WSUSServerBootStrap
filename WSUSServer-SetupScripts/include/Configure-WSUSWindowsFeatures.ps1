$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('TimeZone')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}


$Features = Import-CSV "$($PSScriptRoot)\WSUS-WindowsFeatures.csv" | Select -Expand WindowsFeatures

$Failed = @()

# Setting the timezone accordingly
$TimeZone = $Config.TimeZone
& cmd /c %windir%\system32\tzutil /s $TimeZone

Foreach($Feature in $Features){
  If( (Get-WindowsFeature -Name $Feature).InstallState -ne "Installed"){
   Write-Host "Trying to install $($Feature)..."
   Add-WindowsFeature $Feature
   If(!$?){
     $Failed += $Feature
   }
  }
}
If($Failed.Count -gt 0){
  Write-Host "These features could not be installed:"
  $Failed
}
& 'C:\Program Files\Update Services\Tools\WsusUtil.exe' postinstall content_dir=E:\





