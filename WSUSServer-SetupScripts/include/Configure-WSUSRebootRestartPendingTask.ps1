$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('RebootTaskName','ScheduledTaskKeyFileName','ScheduledTaskAESKeyFileName','ScheduledTaskUserName')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}
$TaskName = $Config.RebootTaskName

$TaskExists = $False
Try {
  $TaskResult = Get-ScheduledTaskInfo -TaskName $TaskName -ErrorAction 'Stop'
  $TaskExists = $True
} Catch {
  $TaskExists = $False
}


If(!$TaskExists) {

  $Path = "$PSScriptRoot\maintenance_utils"
  If(Test-Path "$Path\$($Config.ScheduledTaskKeyFileName)") {
    $AESKey = Get-Content "$Path\$($Config.ScheduledTaskAESKeyFileName)"
    $EncStdStr = Get-Content "$Path\$($Config.ScheduledTaskKeyFileName)"
    $SecureString = ConvertTo-SecureString ($EncStdStr) -Key $AESKey
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $AESKey = $Null
    $EncStdStr = $Null
    $SecureString = $Null
    $BSTR = $Null
  } Else {
    Write-Error "Cannot find AES.key or keyfile.txt"
    Exit 1
  }


  If($Password) { 
    Try {
      Register-ScheduledTask -XML (Get-Content "$Path\$TaskName.xml" | Out-String) -TaskName $TaskName -User $Config.ScheduledTaskUserName -Password $Password
    } Catch {
      Write-Error "Failed to create the scheduled task: $TaskName"
    }
  } Else {
    Write-Error "Unable to initialize the credentials for AHC\SVC-WSUS"
  }
} Else {
  Write-Host "Scheduled Task ($TaskName) already exists. Skipping."
}

