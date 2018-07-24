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
    [Array]$KeysToAdd
    )
Try {
  $PSObject = Get-Content $JSONFile | ConvertFrom-JSON
} Catch {
  Throw "Unable to read the provided JSON file. Make sure it is valid JSON format"
}

If($PSObject) {
  $Keys = $PSObject | Get-Member -MemberType NoteProperty | Select -Expand Name
  Foreach($KeyToAdd in $KeysToAdd) {
    $Keys += $KeyToAdd
  }
  $NewPSObject = $PSObject | Select-Object $Keys
  Return $NewPSObject
} Else {
  Throw "The provided file seems to be empty."
}


