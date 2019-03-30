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