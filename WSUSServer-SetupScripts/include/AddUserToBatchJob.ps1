<#
.EXAMPLE
.\AddUserToBatchJob.ps1 -UserToAdd contoso\svc-wsus
.EXAMPLE
.\AddUserToBatchJob.ps1 -ViewCurrentSettings
#>
Param(
    $UserToAdd,
    [Switch]$ViewCurrentSettings
    )
# Written by Ingo Karstein, http://blog.karstein-consulting.com
# Modified to Version 2 by David Frazer
#  v1.0, 01/03/2014
#  v2.0, 02/08/2018

If(!$UserToAdd) {
  Throw "No username provided. $($MyInvocation.MyCommand.Name) execution halted."
}


#########################################################################
#  Below will prompt the user to run the script as Admin, or else fail
#########################################################################

  # Get the ID and security principal of the current user account
  $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
  $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
  # Get the security principal for the Administrator role
  $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
  # Check to see if we are currently running "as Administrator"
  if ($myWindowsPrincipal.IsInRole($adminRole))
     {
     # We are running "as Administrator" - so change the title and background color to indicate this
     $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
     }
  else
     {
     # We are not running "as Administrator" - so relaunch as administrator
   
     # Create a new process object that starts PowerShell
     $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
     # Specify the current script path and name as a parameter
     $newProcess.Arguments = "-noprofile","-noexit", $myInvocation.MyCommand.Definition, $UserToAdd;
   
     # Indicate that the process should be elevated
     $newProcess.Verb = "runas";
   
     # Start the new process
     [System.Diagnostics.Process]::Start($newProcess);
   
     # Exit from the current, unelevated, process
     exit
     }

#########################################################################


$Tmp = [System.IO.Path]::GetTempFileName()

Write-Host "Export current Local Security Policy" -ForegroundColor DarkCyan
secedit.exe /export /cfg "$($Tmp)" 

$PrivilegeContents = Get-Content -Path $Tmp 

If($ViewCurrentSettings) {
  $Contents = ($PrivilegeContents | Select-String "SeBatchLogonRight|SeServiceLogon").Line
  Foreach( $Row in $Contents) {
    $SIDEntries = $Row.Split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
    $EntryHeader = $SIDEntries[0]
    $SIDs = ($SIDEntries[1..($SIDEntries.Length - 1)] -Split ",").Trim()
    $SIDs = $SIDs -Replace '\*',''
    $Usernames = @()
    Foreach($SID in $SIDs) {
      $ObjSID = New-Object System.Security.Principal.SecurityIdentifier("$SID")
      $Usernames += ($ObjSID.Translate( [System.Security.Principal.NTAccount] )).Value
    }
    "$EntryHeader => `n`t$($Usernames -Join "`n`t")"
  }
  Exit
}

$CurrentSetting = ""

If( [String]::IsNullOrEmpty($UserToAdd) ) {
	Write-Host "No account specified."
	Exit
}

$SIDValue = $Null
Try {
	$NTPrincipal = New-Object System.Security.Principal.NTAccount "$UserToAdd"
	$SID = $NTPrincipal.Translate([System.Security.Principal.SecurityIdentifier])
	$SIDValue = $SID.Value.ToString()
} Catch {
	$SIDValue = $null
}

Write-Host "Account: $($UserToAdd)" -ForegroundColor DarkCyan

If( [String]::IsNullOrEmpty($SIDValue) ) {
	Write-Host "Account not found!" -ForegroundColor Red
	Exit -1
}

Write-Host "Account SID: $($SIDValue)" -ForegroundColor DarkCyan

foreach($Row in $PrivilegeContents) {
	if( $Row -like "SeBatchLogonRight*") {
		$SIDEntries = $Row.Split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
		$CurrentSetting = $SIDEntries[1].Trim()
	}
}

If( $CurrentSetting -notlike "*$($SIDValue)*" ) {
	Write-Host "Modify Setting ""Logon as Batch Job""" -ForegroundColor DarkCyan
	
	If( [String]::IsNullOrEmpty($CurrentSetting) ) {
		$CurrentSetting = "*$($SIDValue)"
	} Else {
		$CurrentSetting = "*$($SIDValue),$($CurrentSetting)"
	}
	
	Write-Host "$CurrentSetting"
	
	$Outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeBatchLogonRight=$($CurrentSetting)
"@

	$Tmp2 = [System.IO.Path]::GetTempFileName()
	
	
	Write-Host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
	$Outfile | Set-Content -Path $Tmp2 -Encoding Unicode -Force

	Push-Location (Split-Path $Tmp2)
	
	Try {
		secedit.exe /configure /db "secedit.sdb" /cfg "$($Tmp2)" /areas USER_RIGHTS 
	} Finally {	
		Pop-Location
	}
} Else {
	Write-Host "NO ACTIONS REQUIRED! Account already in ""Logon as Batch Job""" -ForegroundColor DarkCyan
}
Write-Host "Done." -ForegroundColor DarkCyan

