Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

New-Alias Install-WindowsUpdate Get-WUInstall
New-Alias Uninstall-WindowsUpdate Get-WUUninstall
New-Alias Get-WindowsUpdate Get-WUList
New-Alias Hide-WindowsUpdate Hide-WUUpdate

Export-ModuleMember -Function * -Alias *

# SIG # Begin signature block
# MIIOJgYJKoZIhvcNAQcCoIIOFzCCDhMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfX9J8oqEI3UUqoKoyoz3QEMl
# uzGgggnaMIIEmTCCA4GgAwIBAgIPFojwOSVeY45pFDkH5jMLMA0GCSqGSIb3DQEB
# BQUAMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQg
# TGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNV
# BAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVROLVVTRVJG
# aXJzdC1PYmplY3QwHhcNMTUxMjMxMDAwMDAwWhcNMTkwNzA5MTg0MDM2WjCBhDEL
# MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
# BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKjAoBgNVBAMT
# IUNPTU9ETyBTSEEtMSBUaW1lIFN0YW1waW5nIFNpZ25lcjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAOnpPd/XNwjJHjiyUlNCbSLxscQGBGue/YJ0UEN9
# xqC7H075AnEmse9D2IOMSPznD5d6muuc3qajDjscRBh1jnilF2n+SRik4rtcTv6O
# KlR6UPDV9syR55l51955lNeWM/4Og74iv2MWLKPdKBuvPavql9LxvwQQ5z1IRf0f
# aGXBf1mZacAiMQxibqdcZQEhsGPEIhgn7ub80gA9Ry6ouIZWXQTcExclbhzfRA8V
# zbfbpVd2Qm8AaIKZ0uPB3vCLlFdM7AiQIiHOIiuYDELmQpOUmJPv/QbZP7xbm1Q8
# ILHuatZHesWrgOkwmt7xpD9VTQoJNIp1KdJprZcPUL/4ygkCAwEAAaOB9DCB8TAf
# BgNVHSMEGDAWgBTa7WR0FJwUPKvdmam9WyhNizzJ2DAdBgNVHQ4EFgQUjmstM2v0
# M6eTsxOapeAK9xI1aogwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYD
# VR0lAQH/BAwwCgYIKwYBBQUHAwgwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2Ny
# bC51c2VydHJ1c3QuY29tL1VUTi1VU0VSRmlyc3QtT2JqZWN0LmNybDA1BggrBgEF
# BQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20w
# DQYJKoZIhvcNAQEFBQADggEBALozJEBAjHzbWJ+zYJiy9cAx/usfblD2CuDk5oGt
# Joei3/2z2vRz8wD7KRuJGxU+22tSkyvErDmB1zxnV5o5NuAoCJrjOU+biQl/e8Vh
# f1mJMiUKaq4aPvCiJ6i2w7iH9xYESEE9XNjsn00gMQTZZaHtzWkHUxY93TYCCojr
# QOUGMAu4Fkvc77xVCf/GPhIudrPczkLv+XZX4bcKBUCYWJpdcRaTcYxlgepv84n3
# +3OttOe/2Y5vqgtPJfO44dXddZhogfiqwNGAwsTEOYnB9smebNd0+dmX+E/CmgrN
# Xo/4GengpZ/E8JIh5i15Jcki+cPwOoRXrToW9GOUEB1d0MYwggU5MIIEIaADAgEC
# AhMdAAABwiBugk+hmBENAAQAAAHCMA0GCSqGSIb3DQEBCwUAMDgxEzARBgoJkiaJ
# k/IsZAEZFgNjb20xEzARBgoJkiaJk/IsZAEZFgNhaGMxDDAKBgNVBAMTA0RDMTAe
# Fw0xODAyMjcxMzIyNTBaFw0xOTAyMjcxMzIyNTBaMFExEzARBgoJkiaJk/IsZAEZ
# FgNjb20xEzARBgoJkiaJk/IsZAEZFgNhaGMxDjAMBgNVBAMTBVVzZXJzMRUwEwYD
# VQQDEwxEYXZpZCBGcmF6ZXIwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAOdZ
# VslEcUVBhkNOvls+hM6zPzqhxzaGKUSKtWXXyjl5GZMImD3C2os7yU2IZS6kLhzS
# 4yvAc6Zf6wU2vBXoO3IQwrIZw3u5AMs6xpgMlwWADnzCJ216sVWNsXuGd1ZggsUp
# kRQdzMdVndg9LEJk533LDcM0fJWzoujb9b2ZA16VAgMBAAGjggKlMIICoTAlBgkr
# BgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBpAGcAbgBpAG4AZzATBgNVHSUEDDAKBggr
# BgEFBQcDAzALBgNVHQ8EBAMCB4AwHQYDVR0OBBYEFBfr/bmcdw1n7D05uQ0gb9iO
# SAWrMB8GA1UdIwQYMBaAFAdsf7rwI0TdTBUSbvvUyU92uK5eMIHmBgNVHR8Egd4w
# gdswgdiggdWggdKGgaVsZGFwOi8vL0NOPURDMSg0KSxDTj1kYzEsQ049Q0RQLENO
# PVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3Vy
# YXRpb24sREM9YWhjLERDPWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jh
# c2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSGKGh0dHA6Ly9kYzEu
# YWhjLmNvbS9DZXJ0RW5yb2xsL0RDMSg0KS5jcmwwgfMGCCsGAQUFBwEBBIHmMIHj
# MIGeBggrBgEFBQcwAoaBkWxkYXA6Ly8vQ049REMxLENOPUFJQSxDTj1QdWJsaWMl
# MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERD
# PWFoYyxEQz1jb20/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRp
# ZmljYXRpb25BdXRob3JpdHkwQAYIKwYBBQUHMAKGNGh0dHA6Ly9kYzEuYWhjLmNv
# bS9DZXJ0RW5yb2xsL2RjMS5haGMuY29tX0RDMSg0KS5jcnQwNwYDVR0RBDAwLqAs
# BgorBgEEAYI3FAIDoB4MHERhdmlkLkZyYXplckBhZHZob21lY2FyZS5vcmcwDQYJ
# KoZIhvcNAQELBQADggEBAJB0Yada34o5Mu3czVDv6FuI93dA1Q5rYTWGsyfCF/9L
# DLGsZ7ohaRAbLuryLc5tTuHaqCICdy1lCP2eW5V6oEWokkdH/66nJNJXSkiv48ML
# z7KRFbPUF0dT9JWRgW2avOciQANVPQb1R5dA24ekNb4ykvx1ojK2uriVr9fmMngI
# jwNra7xTFQBXJlN27cEzHNdGn2Z3XzZ2MBm0OtjdX+WC0GjDBbsW9Kr0FY+cMEH6
# abey3mD2p3RDn44ECFaxBBRBIUcgwluZK/ll34HOPnpo1oGi4btuypF6OC4RLkDS
# agacPC5GEoDtKJTFK7crXdzw+alC2sSY2tzV9CJr8wUxggO2MIIDsgIBATBPMDgx
# EzARBgoJkiaJk/IsZAEZFgNjb20xEzARBgoJkiaJk/IsZAEZFgNhaGMxDDAKBgNV
# BAMTA0RDMQITHQAAAcIgboJPoZgRDQAEAAABwjAJBgUrDgMCGgUAoHgwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUJ5ek
# T2eBu2AiOZMtUbfqzJjepJ0wDQYJKoZIhvcNAQEBBQAEgYC9L+1OdxLmEEqOyf+6
# d1rAJLyLEe6DWw0H6a1Xzu9ABxnNeNNUOPhHsCf1wHCtbyG50F8hV0PMwHG5i0BY
# kRbM45jli6ACwzTqXcdjpN214YGl3FSboVkzQXKfPPmiGXv5B+GE2GY/tA/XzuMx
# ODq6+X2VL7OQ8pXlRR7qR/zn5aGCAkMwggI/BgkqhkiG9w0BCQYxggIwMIICLAIB
# ATCBqTCBlTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0
# IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYD
# VQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xHTAbBgNVBAMTFFVUTi1VU0VS
# Rmlyc3QtT2JqZWN0Ag8WiPA5JV5jjmkUOQfmMwswCQYFKw4DAhoFAKBdMBgGCSqG
# SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDYwNTE0Mjkz
# NVowIwYJKoZIhvcNAQkEMRYEFIwSyxQoGJn5+XbYoU/e91ntQZKMMA0GCSqGSIb3
# DQEBAQUABIIBAOWfdylZ+fI6rbVxarIDWyip91frOGXkZsuSnVXLXp+2+6zdocOj
# /C6Rpy7wUGAlWCpl1Q7svQ5aMHW4gAsFOFcCc0WnELcwJ6kkk2hwPIhcQN4jDULH
# W22TCnMGYmjpJEm+UToLBV0mZejJ8X2n5JP3ysakvxwaUeBTSBB/luTuQG2inRvA
# GW1wa95bgPt2+wYSFLA67MOLqgWfPvqMytKrC+T5DWnp5hplJXTtDGlY+/KJICPw
# bsDyKlEpCg/2NtzDC7peNmeUEEyJZM6Uc/YyOC6MqqG2NmAVSWFT6b61r/w9AYgV
# If8mYQMSzbZc//cFGqA1XmwqoaVvxTsxI+M=
# SIG # End signature block
