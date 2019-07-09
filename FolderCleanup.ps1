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
Delete everything in the Temp folder that's over 30 days old
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

Version 1.2
- Adding logging to file in the scan folder. (Useful as it will clean itself up)
- Resolved the wierd backwards $age variable.
- Added code to ensure its a positive number (for backwards compatibility)
- Made the $path a required paramter to prevent accidental Script Seppuku

#>
 param (
    [Parameter(Mandatory=$True)]
    [string]$path = ".\",
    [int]$age = 30
 )

if($age -lt 0) { $age = $age * -1 }

# $LogName = $(Get-Item -Path $path).FullName + "\FolderCleanup_" + $(Get-Date -Format "yyyyMMdd_hhmmss") + ".log"
$LogName = "FolderCleanup_" + $(Get-Date -Format "yyyyMMdd_hhmmss") + ".log"

 

 if(Test-Path -Path $path) {
    # If the path exists, switch there so the log sticks with the folder being cleaned
    cd $path

	Write-Output "Cleaning $path of files older than $age days" | Tee-Object -Append -FilePath $LogName
	Write-Output "Deleting old files....." | Tee-Object -Append -FilePath $LogName

    $files = Get-ChildItem -recurse -File -Path $path | 
		Where {!$_.PSIsContainer -and $_.LastWriteTime.AddDays($age) -lt (get-date)}
    foreach ($file in $files)
    {
        Write-Output "-- Deleting $file" | Tee-Object -Append -FilePath $LogName
        $file | Remove-Item -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable err
        if($err)
        {
            Write-Output "---- Failed to delete! "  | Tee-Object -Append -FilePath $LogName
        }
    }
		

    Write-Output "Deleting Empty Folders...." | Tee-Object -Append -FilePath $LogName

    $folders = Get-ChildItem -recurse -Directory -Path $path | 
		Where {$_.PSIsContainer -and @(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} 
    foreach ($folder in $folders)
    {
        Write-Output "-- Deleting $folder" | Tee-Object -Append -FilePath $LogName
        Remove-Item $folder -Recurse
    }
 }
 else {
    
    throw "The folder does not exist: $path"
 }