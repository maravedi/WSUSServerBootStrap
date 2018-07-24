$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('WSUSDiskNumber','WSUSDriveLetter')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}
$DiskNumber = $Config.WSUSDiskNumber
$DriveLetter = $Config.WSUSDriveLetter

If( !(Get-PSDrive $DriveLetter -ErrorAction SilentlyContinue).Name ){

Initialize-Disk -Number $DiskNumber
New-Partition -DiskNumber $DiskNumber -UseMaximumSize -DriveLetter $DriveLetter
Format-Volume -DriveLetter $DriveLetter -Confirm:$False
}
Else{
  Write-Host "$($DriveLetter): drive is already initialized and formatted."
}




