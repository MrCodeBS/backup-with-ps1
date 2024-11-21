# Backup Script 

# Default directories
$defaultSource = Join-Path $env:USERPROFILE "Documents"
$defaultBackup = Join-Path $env:USERPROFILE "Backups"
$settingsFile = Join-Path $env:USERPROFILE "backup_settings.json"

# Function to save settings to a JSON file
function Save-Settings {
    param (
        [hashtable]$Settings
    )
    $Settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsFile -Force
}

# Function to load settings from a JSON file
function Load-Settings {
    if (Test-Path $settingsFile) {
        return Get-Content -Path $settingsFile | ConvertFrom-Json
    } else {
        # Default settings
        return @{
            AutoBackupEnabled = $false
            BackupFrequencyMinutes = 60
            SourceDirectory = $defaultSource
            BackupDirectory = $defaultBackup
        }
    }
}

# Load settings
$settings = Load-Settings

# Settings Menu
function Settings-Page {
    while ($true) {
        Write-Host "=============================="
        Write-Host "       Settings Page"
        Write-Host "=============================="
        Write-Host "1. Toggle Auto Backup (Currently: $($settings.AutoBackupEnabled))"
        Write-Host "2. Set Backup Frequency (Currently: $($settings.BackupFrequencyMinutes) minutes)"
        Write-Host "3. Set Source Directory (Currently: $($settings.SourceDirectory))"
        Write-Host "4. Set Backup Directory (Currently: $($settings.BackupDirectory))"
        Write-Host "5. Save and Exit"
        $choice = Read-Host "Enter your choice (1-5)"

        switch ($choice) {
            1 {
                $settings.AutoBackupEnabled = -not $settings.AutoBackupEnabled
                Write-Host "Auto Backup is now: $($settings.AutoBackupEnabled)"
            }
            2 {
                $frequency = Read-Host "Enter backup frequency in minutes (10-1440)"
                if ($frequency -match "^\d+$" -and $frequency -ge 10 -and $frequency -le 1440) {
                    $settings.BackupFrequencyMinutes = [int]$frequency
                    Write-Host "Backup frequency set to $frequency minutes."
                } else {
                    Write-Host "Invalid input. Please enter a number between 10 and 1440."
                }
            }
            3 {
                $newSource = Read-Host "Enter new source directory path"
                if (Test-Path $newSource) {
                    $settings.SourceDirectory = $newSource
                    Write-Host "Source directory updated to: $newSource"
                } else {
                    Write-Host "Invalid path. Directory not updated."
                }
            }
            4 {
                $newBackup = Read-Host "Enter new backup directory path"
                $settings.BackupDirectory = $newBackup
                Write-Host "Backup directory updated to: $newBackup"
            }
            5 {
                Save-Settings -Settings $settings
                Write-Host "Settings saved. Returning to the main menu."
                break
            }
            default {
                Write-Host "Invalid choice. Please select a valid option."
            }
        }
    }
}

# Ensure the backup directory exists
function Ensure-Directory {
    param (
        [string]$Path
    )
    if (-not (Test-Path -Path $Path)) {
        Write-Host "[Creating Directory]: $Path"
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

# Function to copy directory with progress and error handling
function Copy-WithVisualFeedback {
    param (
        [string]$Source,
        [string]$Destination
    )

    $items = Get-ChildItem -Path $Source -Recurse -Force
    $totalItems = $items.Count
    $completed = 0

    foreach ($item in $items) {
        $completed++
        $percent = [math]::Floor(($completed / $totalItems) * 100)
        Write-Host -NoNewline "`r[$('{0,-3}' -f $percent)%] Copying: $($item.Name)"

        try {
            $targetPath = Join-Path -Path $Destination -ChildPath $item.FullName.Substring($Source.Length).TrimStart('\')
            if ($item.PSIsContainer) {
                if (-not (Test-Path -Path $targetPath)) {
                    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                }
            } else {
                Copy-Item -Path $item.FullName -Destination $targetPath -Force
            }
        } catch {
            Write-Host "Skipped: $($item.FullName) (Permission Denied or Error)"
        }
    }
}

# Function to perform the backup
function Perform-Backup {
    $useCustomPath = Read-Host "Would you like to specify custom paths for this backup? (yes/no)"
    if ($useCustomPath -eq "yes") {
        $customSource = Read-Host "Enter source directory path (leave blank for default: $($settings.SourceDirectory))"
        $customBackup = Read-Host "Enter backup directory path (leave blank for default: $($settings.BackupDirectory))"

        $sourceDirectory = if ($customSource) { $customSource } else { $settings.SourceDirectory }
        $backupDirectoryRoot = if ($customBackup) { $customBackup } else { $settings.BackupDirectory }
    } else {
        $sourceDirectory = $settings.SourceDirectory
        $backupDirectoryRoot = $settings.BackupDirectory
    }

    Ensure-Directory -Path $backupDirectoryRoot
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $backupDirectory = Join-Path $backupDirectoryRoot "Backup_$timestamp"

    Ensure-Directory -Path $backupDirectory

    Write-Host "[Starting Backup] From: $sourceDirectory To: $backupDirectory"
    Copy-WithVisualFeedback -Source $sourceDirectory -Destination $backupDirectory
    Write-Host "`n[Success]: Backup completed successfully."
}

# Function to run auto-backup
function Run-AutoBackup {
    while ($settings.AutoBackupEnabled) {
        Perform-Backup
        Write-Host "`nAuto Backup: Next backup will run in $($settings.BackupFrequencyMinutes) minutes."
        Start-Sleep -Seconds ($settings.BackupFrequencyMinutes * 60)
    }
}

# Main Menu
function Main-Menu {
    while ($true) {
        Write-Host "=============================="
        Write-Host "       Backup Script"
        Write-Host "=============================="
        Write-Host "1. Perform Backup Now"
        Write-Host "2. Configure Settings"
        Write-Host "3. Start Auto Backup (Ctrl+C to stop)"
        Write-Host "4. Exit"
        $choice = Read-Host "Enter your choice (1-4)"

        switch ($choice) {
            1 { Perform-Backup }
            2 { Settings-Page }
            3 { Run-AutoBackup }
            4 { break }
            default { Write-Host "Invalid choice. Please try again." }
        }
    }
}

# Run the main menu
Main-Menu
