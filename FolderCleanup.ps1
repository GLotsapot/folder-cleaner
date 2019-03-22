<#
.SYNOPSIS
Delete files in a folder over a certain amount of days old, and delete empty folders

.DESCRIPTION
This script will check the remote share and move the Access Database files locally if the remote version is newer.
File removal is defined by the files last write time, not creation time

.PARAMETER BaseFolder
Specifies the folder to cleanup

.PARAMETER TrimDays
Specifis how how many days of files to keep

.EXAMPLE
FolderCleanup -BaseFolder "c:\temp" -TrimDays 30

.NOTES
AUTHORS
Sawyer Peacock - OGELP SysAdmin

FIXES
Version 1.0
- Initial Commit of the script

#>

param ([string]$BaseFolder = ".\", [string]$TrimDays = 30)

Get-ChildItem -recurse | Where {!$_.PSIsContainer -and $_.LastWriteTime -lt (get-date).AddDays(-31)} | Remove-Item -whatif

Get-ChildItem -recurse | Where {$_.PSIsContainer -and @(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |Remove-Item -recurse -whatif