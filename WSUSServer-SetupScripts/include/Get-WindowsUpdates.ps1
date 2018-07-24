Try {
  Import-Module "$($PSScriptRoot)\PSWindowsUpdate\PSWindowsUpdate.psd1" -ErrorVariable $ImportError
} Catch {
  Throw "Unable to import to PSWindowsUpdate module.`n$($ImportError | Out-String)"
}

Try {
  Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$False
} Catch {
  Throw "Unable to add the Microsoft Update service ID"
}
Get-WUInstall -MicrosoftUpdate -AcceptAll -AutoReboot -Verbose -Debuger

