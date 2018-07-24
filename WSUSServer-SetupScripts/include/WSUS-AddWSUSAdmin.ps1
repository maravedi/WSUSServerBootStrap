
$ConfigPath = Split-Path -Path $PSSCriptRoot -Parent
$ConfigFile = "$ConfigPath\Config.json"
$Config = Get-Content $ConfigFile | Out-String | ConvertFrom-JSON
$RequiredConfigKeys = @('WSUSServiceUser','WSUSServerPort','AddWSUSServiceUserToLocalAdminGroup')
Foreach($ConfigKey in $RequiredConfigKeys) {
  If((!$Config.$ConfigKey) -Or ($Config.$ConfigKey -eq $Null)) {
    Throw "$ConfigKey is not set in the config file: $ConfigFile"
  }
}

$User = $Config.WSUSServiceUser
$WSUSServerPort = $Config.WSUSServerPort
$AddToLocalAdministratorsGroup = $Config.AddWSUSServiceUserToLocalAdminGroup

# 'Add' or 'Remove' are valid here
$Action = 'Add'
$OldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

$ExcludeDownstream = $True
$WSUSServer = $env:ComputerName
$Domain = (Get-ADDomain).Name

$Groups = @('WSUS Administrators', 'WSUS Reporters')
If($AddToLocalAdministratorsGroup) {
  $Groups += @('Administrators')
}

$WSUS = Get-WSUSServer -Name $WSUSServer -PortNumber $WSUSServerPort

If(!$ExcludeDownStream) {
  $UpdateServers = ($WSUS.GetChildServers()).FullDomainName
}

$UpdateServers += $WSUS.Name

Foreach($Server in $UpdateServers) {

  Foreach($Group in $Groups) {
    $InGroup = $False
    # Need greater than version 4 for Get-LocalGroupMember, otherwise we'll use ADSI
    If( (Get-Host).Version.Major -gt 4) {
      If((Get-LocalGroupMember -Group $Group).Name -contains "$Domain\$User") {
        $InGroup = $True
      }
    } Else {
      # PowerShell version doesn't have Get-LocalGroupMember, so we'll use ADSI
      $ADSI = [ADSI]("WinNT://" + $($env:ComputerName) + ",computer")
      $ThisGroup = $ADSI.psbase.children.find($Group)
      Function Get-Members {
        $Members = $ThisGroup.PSBase.Invoke("Members") | Foreach-Object { $_.GetType().InvokeMember("Adspath", 'GetProperty', $Null, $_, $Null) }
        Return $members
      }
      $GroupMembers = Get-Members
      If($GroupMembers -like "*$User*") {
        $InGroup = $True
      }

    }
    If(!$InGroup) {
      $UpdateGroup = [ADSI]"WinNT://$Server/$Group, group"
      $UpdateGroup.PSBase.Invoke("$Action",([ADSI]"WinNT://$Domain/$User").path)
      $Err = $?
      If($Err) {
        Write-Host "[COMPLETED]: $($Action.ToUpper()) of $Domain\$User to/from the group $Group on $Server"
      } Else {
        Write-Host "[FAILED]: $($Action.ToUpper()) of $Domain\$User to/from the group $Group on $Server"
        Write-Host "[ERROR DETAILS]: $($Error[0].Exception.Message)"
      }
    } Else {
      Write-Host "$Domain\$User is already a member of $Group"
    }
  }

}

$ErrorActionPreference = $OldErrorActionPreference




