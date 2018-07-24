$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('TargetOU')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}
$TargetOU = $Config.TargetOU
Write-Host "Making sure RSAT is installed."
Add-WindowsFeature RSAT -IncludeAllSubFeature | out-null

if( -Not $? ){
  Write-Host "Unable to install RSAT."
  exit 1
}

Get-ADComputer $env:ComputerName | Move-ADObject -TargetPath $TargetOU
$ComputerAdded = $?

$Success = (Get-ADComputer $env:ComputerName).DistinguishedName -eq "CN=$($env:ComputerName),$($TargetOU)"

If( $ComputerAdded -And $Success ){
  Write-Host "Server is now in the Servers OU."
  exit 0
}
Elseif( -Not $Success ){
  Write-Host "Server could not be added to the Servers OU."
  exit 1
}
Else{
  Write-Host "Unable to add the server to the Servers OU."
  exit 1	
}

