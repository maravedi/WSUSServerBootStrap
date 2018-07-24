<#
.SYNOPSIS
  Converts a JSON file to a PSObject and then adds the provided keys.
.DESCRIPTION
  Reads a JSON file and its current keys, then appends the new keys to those. The result is a PSObject with all keys.
  The new keys will have no value. The expectation is that the output will be captured in a variable that will then be
  converted to a JSON object and saved to a JSON file.
.NOTES
#>
Param(
    [Parameter(Mandatory=$True)]
    $JSONFile,
    [Parameter(Mandatory=$True)]
    [HashTable]$ItemsToAdd
    )
Try {
  $FullFilePath = Resolve-Path $JSONFile | Select -Expand ProviderPath
  $PSObject = Get-Content $FullFilePath | ConvertFrom-JSON
} Catch {
  Throw "Unable to read the provided JSON file. Make sure it is valid JSON format"
}

If($PSObject) {
  $Keys = $PSObject | Get-Member -MemberType NoteProperty | Select -Expand Name
  $Keys += ($ItemsToAdd.Keys | Foreach-Object ToString)
  $NewPSObject = $PSObject | Select-Object $Keys
  Foreach($NewItem in $ItemsToAdd.GetEnumerator()) {
    $Key = $NewItem.Key
    $Value = $NewItem.Value
    If([Bool]($NewPSObject.PSObject.Properties.Name -eq $Key)) {
      $NewPSObject.$Key = $Value
    } Else {
      Write-Error "$Key does not exist as a property of the PSObject"
    }
  }
  Write-Host ($NewPSObject | ConvertTo-JSON | Out-String)
  $Confirm = Read-Host "Do you want to save this JSON object to this file?`n`t$($FullFilePath | Out-String)`n[y/n]"
  If($Confirm -in "y","yes") {
    $NewPSObject | ConvertTo-JSON | Out-File $FullFilePath
  } Else {
    Write-Host "User declined to update the JSON file"
    Write-Host "File NOT updated:`n`t$($FulleFilePath | Out-String)"
    Return $NewPSObject
  }
} Else {
  Throw "The provided file seems to be empty."
}



