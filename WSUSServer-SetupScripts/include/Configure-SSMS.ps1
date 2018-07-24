$LocalInstallerPath = "$($env:SystemDrive)\temp\SSMS-Setup-ENU.exe"
$Installed = $False

Try {
  $SQLCmd = Invoke-Command -ScriptBlock { sqlcmd /? }
} Catch {

}
If($SQLCmd) {
  $Installed = $True
} Else {
  $Installed = $False
}
If($Installed -eq $True) {
  Write-Host "SQL Server Management Studio and SQLCmd installed properly"
  Exit
}
ElseIf( (Test-Path $LocalInstallerPath) -And ($Installed -eq $False) ) { # -And ($LocalFileHash -eq $RemoteFileHash) ) {
  Try {
    $Error.Clear()
    $InstallationJob = Start-Job { & $Using:LocalInstallerPath /install /quiet /norestart }
    $Result = Wait-Job $InstallationJob | Receive-Job
    If (($InstallationJob | Get-Job).State -eq 'Completed' ) {
      Try {
        $SQLCmd = Invoke-Command -ScriptBlock { sqlcmd /? }
        If($SQLCmd) {
          $Installed = $True
        } Else {
          $Installed = $False
        }
      } Catch {
        Write-Error "The installation did not complete properly. 'sqlcmd.exe /?' does not run."
        Try {
          $LogPath = "$($env:userprofile)\AppData\Local\Temp\SsmsSetup\*log"
          If(Test-Path $LogPath) {
            $LastLogFile = (Get-ChildItem $LogPath | Sort LastWriteTime | Select -Last 1)
            $LogContent = Get-Content $LastLogFile
            $LogErrors = $LogContent | Where-Object { $_ -like "*error*" }
            If($LogErrors) {
              Write-Host "Installation log file error(s):`n$($LogErrors)"
            } Else {
              Write-Host "Check $LastLogFile for more details"
            }
          } Else {
            Write-Error "No installation log file exists. Try the install manually."
          }
        } Catch {
          Write-Error "No installation log file exists. Try the install manually."
        }
      }
    } Else {
      Write-Error "The installation job did not complete properly"
    }
  } Catch {
    $ThisError = $Error
    Write-Error "Installation failed for $LocalInstallerPath"
    Write-Error ($ThisError | Out-String)
  }
} Else {
  Write-Error "Either the installer does not exist, or the file hash does not match the remote file hash.`nLocalFileHash: $LocalFileHash`nRemoteFileHash: $RemoteFileHash"
}

If($Installed -eq $True) {
  Write-Host "SQL Server Management Studio and SQLCmd installed properly"
  If( (Test-Path $LocalInstallerPath) ){
    Try {
      Remove-Item $LocalInstallerPath -Force -ErrorAction 'Stop'
      Write-Host "Installer deleted from temp dir"
    } Catch {
      $ThisError = $Error
      Write-Error "Unable to delete installer: $LocalInstallerPath"
      Write-Error ($ThisError | Out-String)
    }
  }
}

