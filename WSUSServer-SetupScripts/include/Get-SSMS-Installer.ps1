$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('SSMSSourceDir','SSMSInstallFileName','LocalServerForTraceRoute')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}

$SourceDir = $Config.SSMSSourceDir
$InstallFile = $Config.SSMSInstallFileName
$DestDir = "$($env:SystemDrive)\temp"

$Installed = $False

Try {
  sqlcmd /?
  $Installed = $True
} Catch {
  $Installed = $False
}
If(!$Installed) {
  Try {
    $Error.Clear()
    If(!(Test-Path $DestDir)) {
      New-Item $DestDir -Type Directory -Force
    }
    Try {
      $TestServer = $Config.LocalServerForTraceRoute
      $NumHopsToFileSourceDir = ((Test-NetConnection $TestServer -TraceRoute).TraceRoute).Count
    } Catch {
      Write-Error "Unable to contact $TestServer. Setting NumHops to 2"
      $NumHopsToFileSourceDir = 2
    }
    If($NumHopsToFileSourceDir -gt 1) {
      ROBOCOPY.EXE $SourceDir $DestDir $InstallFile /Z /IPG:500 /IS /COPYALL
    } Else {
      ROBOCOPY.EXE $SourceDir $DestDir $InstallFile /Z /IS /COPYALL
    }
  } Catch {
    $ThisError = $Error
    Write-Error "Robocopy failed"
    Write-Error ($ThisError | Out-String)
  }
} Else {
  Write-Verbose "sqlcmd is installed. Skipping SSMS download"
}

