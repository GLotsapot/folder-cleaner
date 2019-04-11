<#
.SYNOPSIS
Delete files in a folder over a certain amount of days old, and delete empty folders

.DESCRIPTION
This script will check the remote share and move the Access Database files locally if the remote version is newer.
File removal is defined by the files last write time, not creation time

.PARAMETER path
Specifies the folder to cleanup

.PARAMETER age
Specifis how how many days of files to keep

.EXAMPLE
FolderCleanup -path "c:\temp" -age 30

.NOTES
AUTHORS
Sawyer Peacock - OGELP SysAdmin

FIXES
Version 1.0
- Initial Commit of the script

Version 1.1
- Added in coding for checking to see if folder exists
- Added addtional output to console


#>
 param (
    [string]$path = ".\",
    [string]$age = -30
 )

 Write-Output "Cleaning $path of files older than $age days" 

 if(Test-Path -Path $path) {
    # cd $path
	
	Write-Output "Deleting old files....."
	Get-ChildItem -recurse -File -Path $path | 
		Where {!$_.PSIsContainer -and $_.LastWriteTime -lt (get-date).AddDays($age)} | 
		Remove-Item

    Write-Output "Deleting Empty Folders...."
	Get-ChildItem -recurse -Directory -Path $path | 
		Where {$_.PSIsContainer -and @(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} | 
		Remove-Item -Recurse
 }
 else {
    
    throw "The folder does not exist: $path"
 }
# SIG # Begin signature block
# MIIGBAYJKoZIhvcNAQcCoIIF9TCCBfECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUliAVd3O3jlYeYmCj0GldpG1W
# F3GgggN5MIIDdTCCAl2gAwIBAgIIbgl7NxpVGjMwDQYJKoZIhvcNAQELBQAwSDEL
# MAkGA1UEBhMCQ0ExEDAOBgNVBAgTB09udGFyaW8xEzARBgNVBAcTCkJlbGxldmls
# bGUxEjAQBgNVBAMTCVNhd3llci1DQTAeFw0xOTAyMjcwMDAwMDBaFw0yMDAyMjYy
# MzU5NTlaMHwxCzAJBgNVBAYTAkNBMRAwDgYDVQQIEwdPbnRhcmlvMRMwEQYDVQQH
# EwpCZWxsZXZpbGxlMRcwFQYDVQQDEw5zcGVhY29jay1jc2lnbjEtMCsGCSqGSIb3
# DQEJARYec3BlYWNvY2tAc2hvcmVsaW5lc2Nhc2lub3MuY29tMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEA88A5/4c/dCzU4xHgAbEYplGtSzYpwr26p3nb
# +WgE/A2CgQ3H1gsjzrlsvuf05rh3Vm8YBdlB6HNymh5LLjOQBX/KUhGkAjuxx7Kz
# MH7xVG7wCIL/1q3eWNIW/T8L9PeKKiwogJK+x5WU0LoirwOxwqqgJ24I1Dt/dxuW
# w0io8phfg33hYox1YGF8hV3gd03cfV3JoXCLwuHS8+FlklPu8OqOJf/lke/O1WMa
# GtLOBQvWA9dFjjwiKEIcabQDpgmxD+rHECTanrsOGG+DpteRax2o3oUHuRnrmWW1
# QLdc8j/8MKASuVPoWXCq40KjpRD2UwKJl/a4O7XkrJnMOH0aHwIDAQABoy8wLTAJ
# BgNVHRMEAjAAMAsGA1UdDwQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzANBgkq
# hkiG9w0BAQsFAAOCAQEAhTAw4YvKQlxKwE2Ce7jlw1eVi1+7FjTSJDRfoPYeFFps
# 4YDJjXs7wmEY9jVB8PlDT+/I54a1on4d+CeXmYPM1zR57vKShv1duHQkvalWIQ6m
# HL5qO2vQbCKYdJJ77bfPsi0f2mwymeulACH9jBzvxaAPCpqrfBbRXxk+l+vGxTG0
# M+qGKav3kuo17OOh0iLoewNDQwTB8Y+C6dVaSnyK7Xliq+d6WOMCAQG2z/i0MILW
# /6G4myig/Ch6W6BLxwi190rKtIxBrfa0F+Zn8CGiZls6XEFDErY+FYdGZl1iLL+k
# cMvfzln7pmsvVByXse0k7eiy7LfTvyHrLXQcmH1rbDGCAfUwggHxAgEBMFQwSDEL
# MAkGA1UEBhMCQ0ExEDAOBgNVBAgTB09udGFyaW8xEzARBgNVBAcTCkJlbGxldmls
# bGUxEjAQBgNVBAMTCVNhd3llci1DQQIIbgl7NxpVGjMwCQYFKw4DAhoFAKB4MBgG
# CisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcC
# AQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYE
# FDDlKxl3eCccN9rZf2P/+LeHBws3MA0GCSqGSIb3DQEBAQUABIIBADunKU3c/phq
# ZmMqvMBBouwb7GGnGyvYYatpidwEZaHEHkQeDUx/XXcY+5rk0wPRkjFXOzE9AQX1
# Ze7ic+Qi7n9+/w/80JnJSYwDs2U0JD3JQz8v+flEHckJb6F/KHrt1kA2BDRfh3cE
# hlvnf0tQ0brjVxe8cNFwOr5ROcEA3b8x9nSpVfjQN21hXSR7zLiSQeVO1HSKcRRJ
# R9AhN2JTCWkifGsZ9L4wR/RxIKVGOaQuJmAPZk1BBqaHmfUsxNN6tLER7+Gqpo/0
# 1fMD/WidT0xSnPqXQxVEmoQ6WLQtJJgQNs03F1FaRA1xXzQPkmXS/lCP7vE5+Mih
# wxbyt+9PGHs=
# SIG # End signature block
