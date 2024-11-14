# Backup Script
# Creates a dated backup of specified source directory to destination directory

# Prompt user for directories or use defaults
$defaultSource = Join-Path $env:USERPROFILE "Documents"
$defaultBackup = Join-Path $env:USERPROFILE "Backups"

Write-Host "Current Settings:"
Write-Host "Default source directory: $defaultSource"
Write-Host "Default backup directory: $defaultBackup"
Write-Host "`nPress Enter to use defaults or input new paths:"

$sourceInput = Read-Host "Enter source directory path (or press Enter for default)"
$backupInput = Read-Host "Enter backup directory path (or press Enter for default)"

# Use input or default values
$sourceDirectory = if ($sourceInput) { $sourceInput } else { $defaultSource }
$backupRoot = if ($backupInput) { $backupInput } else { $defaultBackup }
$logFile = Join-Path $backupRoot "backup_log.txt"
$maxBackups = 5

# Create timestamp for backup folder
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$backupDirectory = Join-Path $backupRoot "Backup_$timestamp"

# Function to write to log file
function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    
    # Create log directory if it doesn't exist
    $logDir = Split-Path $logFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    Add-Content -Path $logFile -Value $logMessage
    Write-Host $logMessage
}

# Function to remove old backups
function Remove-OldBackups {
    if (Test-Path $backupRoot) {
        $backups = Get-ChildItem -Path $backupRoot -Directory | Sort-Object CreationTime -Descending
        if ($backups.Count -gt $maxBackups) {
            Write-Log "Removing old backups to maintain limit of $maxBackups"
            $backups | Select-Object -Skip $maxBackups | ForEach-Object {
                Remove-Item $_.FullName -Recurse -Force
                Write-Log "Removed old backup: $($_.Name)"
            }
        }
    }
}

# Main backup process
try {
    Write-Host "`nVerifying directories..."
    
    # Create backup directory if it doesn't exist
    if (-not (Test-Path $backupRoot)) {
        Write-Host "Creating backup directory: $backupRoot"
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    }

    # Verify source directory exists
    if (-not (Test-Path $sourceDirectory)) {
        throw "Source directory does not exist: $sourceDirectory"
    }

    Write-Log "Starting backup from $sourceDirectory to $backupDirectory"

    # Create new backup
    Copy-Item -Path $sourceDirectory -Destination $backupDirectory -Recurse -Force

    # Calculate and log backup size
    $backupSize = (Get-ChildItem -Path $backupDirectory -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Log "Backup completed successfully. Size: $([math]::Round($backupSize, 2)) MB"

    # Clean up old backups
    Remove-OldBackups

    Write-Host "`nBackup completed successfully. Logfile: $logFile"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    Write-Host "`nAn error occurred. Check the logfile: $logFile"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}
