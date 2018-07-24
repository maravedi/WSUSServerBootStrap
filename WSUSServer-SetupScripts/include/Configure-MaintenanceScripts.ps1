$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('RebootTaskName','ScheduledTaskKeyFileName','ScheduledTaskAESKeyFileName','ScheduledTaskUserName')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}

$MaintenanceScriptsPath = "$PSScriptRoot\maintenance_utils"
$MaintenanceScripts = Get-ChildItem -Path "$MaintenanceScriptsPath\*" -Include *.ps1
Foreach($Script in $MaintenanceScripts) {
  $ScriptContent = Get-Content $Script
  $ScriptContent | Select -First 10
}


