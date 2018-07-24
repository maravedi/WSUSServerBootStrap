$Applications = @{
  'WSUSConsole' = "$($env:ProgramFiles)\Update Services\AdministrationSnapin\wsus.msc";
  'ResMon' = "$($env:windir)\System32\perfmon.exe";
  'TaskScheduler' = "$($env:windir)\System32\taskschd.msc";
}

Foreach($Application in $Applications.Keys) {
  $ApplicationName = $Application
  $ApplicationPath = $Applications[$Application]
  "$ApplicationName => $ApplicationPath"
  If(Test-Path $ApplicationPath) {
    Try {
      & "$PsScriptRoot\Set-PinnedApplication.ps1" -Action 'PinToTaskbar' -FilePath $ApplicationPath
    } Catch {
      Write-Host "$ApplicationName already pinned to taskbar"
    }
  } Else {
    Write-Error "Unable to pin application to taskbar because it doesn't exist: $ApplicationPath"
  }
}

