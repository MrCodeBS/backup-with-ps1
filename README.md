###how to run:###
 powershell.exe -File backup-script.ps1
**important**
The command powershell.exe -ep bypass is used to run PowerShell with the execution policy set to Bypass. This allows PowerShell scripts to run without prompting for user confirmation or modification of the system’s default execution policy
Examples and code snippets
Run PowerShell with the -ep bypass option:
powershell.exe -ep bypass -File C:\Path\To\Script.ps1

Set the execution policy to Bypass for a specific script:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force

Use the -ep bypass option in a batch file or script to run PowerShell:
powershell.exe -ep bypass -Command "Get-ChildItem C:\Path\To\Folder"
