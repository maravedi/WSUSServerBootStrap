$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('WSUSUpstreamServer','UpdateLanguages','NumSynchronizationsPerDay','WSUSServerPort','AutoSynchronize','SynchronizationTimeOfDay')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}
$UpstreamServer = $Config.WSUSUpstreamServer
$UpdateLanguages = $Config.UpdateLanguages
$AutoSynchronize = $Config.AutoSynchronize
$NumSynchronizationsPerDay = $Config.NumSynchronizationsPerDay
$SynchronizationTimeOfday = (New-TimeSpan -Hours $Config.SynchronizationTimeOfDay)

$WSUS = Get-WSUSServer
$WSUSConfig = $WSUS.GetConfiguration()
$IsReplica = ($WSUSConfig).IsReplicaServer
$LanguagesSet = ($WSUSConfig).GetEnabledUpdateLanguages()


If(!$IsReplica) {
  Write-Verbose "This server is not a replica. Setting upstream server to $UpstreamServer"
  Try {
    Set-WsusServerSynchronization -UssServerName $UpstreamServer -PortNumber $Config.WSUSServerPort -Replica
  } Catch {
    Write-Error "Unable to set the upstream server to $UpstreamServer"
  }
} Else {
  Write-Verbose "This server is already a replica of $UpstreamServer."
}

If($LanguagesSet -ne $UpdateLanguages) {
  Write-Verbose "The update languages are not set. Setting them to: $($UpdateLanguages -join ', ')"
  $WSUSConfig.AllUpdateLanguagesEnabled = $false           
  $WSUSConfig.SetEnabledUpdateLanguages($UpdateLanguages)           
  $WSUSConfig.Save()
} Else {
  Write-Verbose "The update languages are set already."
}

$WSUSSubscription = $WSUS.GetSubscription()

If( ($WSUSSubscription.SynchronizeAutomatically -ne $AutoSynchronize) -Or ($WSUSSubscription.NumberOfSynchronizationsPerDay -ne $NumberOfSynchronizationsPerDay) -Or ($WSUSSubscription.SynchronizeAutomaticallyTimeOfDay -ne $SynchronizeAutomaticallyTimeOfDay.ToString()) ) {
  Write-Verbose "One of the WSUS subscription settings is not as requested. Setting it now."
  $WSUSSubscription.SynchronizeAutomatically = $AutoSynchronize
  $WSUSSubscription.SynchronizeAutomaticallyTimeOfDay = $SynchronizationTimeOfday
  $WSUSSubscription.NumberOfSynchronizationsPerDay = $NumSynchronizationsPerDay
  $WSUSSubscription.Save()
} Else {
  Write-Verbose "WSUS subscription settings appear to be set appropriately"
}

