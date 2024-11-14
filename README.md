### How to Run the Backup Script

To execute the backup script, use the following command:

```powershell
powershell.exe -File backup-script.ps1
```

---

**Important Note:**  
To bypass PowerShell's default execution policy and run scripts without user confirmation, use the `-ep bypass` option. This sets the execution policy to **Bypass** temporarily, allowing scripts to execute even if restrictions are in place.

### Examples

#### 1. Run a PowerShell Script with Execution Policy Bypass
To execute a script directly with the bypass option, use:
```powershell
powershell.exe -ep bypass -File C:\Path\To\Script.ps1
```

#### 2. Set Execution Policy to Bypass for a Specific User
To permanently set the execution policy to Bypass for the current user:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
```

#### 3. Using `-ep bypass` in a Batch File or Another Script
You can integrate `-ep bypass` in batch files or other scripts to avoid permission issues:
```powershell
powershell.exe -ep bypass -Command "Get-ChildItem C:\Path\To\Folder"
```
