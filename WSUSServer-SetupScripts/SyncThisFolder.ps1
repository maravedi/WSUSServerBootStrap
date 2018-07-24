<#
.DESCRIPTION
A simple script to copy the contents of a remote folder to this one and overwrite the local contents.
.EXAMPLE
.\SyncThisFolder.ps1
#>
$ConfigFile = "$PSScriptRoot\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$SourceDir = $Config.SyncSource
$DestDir = (Get-Item $PSScriptRoot).FullName

Try {
  $Error.Clear()
  ROBOCOPY.EXE $SourceDir $DestDir /Z /COPYALL /MIR
} Catch {
  $ThisError = $Error
  Write-Error "Something went wrong!"
  Write-Error ($ThisError | Out-String)
}

