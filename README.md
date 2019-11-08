# Folder Cleaner
Powershell script that will clean a folder of files that have not been modified over a certain number of days, and remove empty folders

## Prerequisites
What things you need to install the software and how to install them
```
Powershell
```
Your system will need to be configured to allow PowerShell scripts to be run

    Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted
Alternatively, you can code sign the script and tighten up your security from unrestricted

## Implementation

### Running Manually
The script has built in help text that describes the usage of the script. It can be viewed by using the following command

	Get-Help .\FolderCleanup.ps1

### Example
Clean out any files in C:\Temp that haven't been written to in over 30 days

	.\FolderCleanup.ps1 -path "c:\temp" -age 30

### Running as a Scheduled Task

 1. Copy the script to a folder on the server (e.g. C:\Scripts)
 2. Open up Task Scheduler, and create a new **Basic Task**
 3. Give it a name like "**Folder Cleanup**"
 4. Set the trigger to "**Daily**" and run at **4:00 am** (or whatever meets your requirements)
 5. Set the Action to "**Start a program**"
 6. Set the program as "**C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe**"
 7. Set the arguments to the below using a similar format as running it manually. Be sure to pay attention to the double and single quotes

    -command "C:\Scripts\FolderCleanup.ps1 'C:\inetpub\ftproot' -age '7'"
