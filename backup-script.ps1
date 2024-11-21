# Default directories
$defaultSource = Join-Path $env:USERPROFILE "Documents"
$defaultBackup = Join-Path $env:USERPROFILE "Backups"

# Display current settings and prompt for inputs
Write-Host "=============================="
Write-Host "       Backup Script"
Write-Host "=============================="
Write-Host "`nDefault Directories:"
Write-Host "  Source: $defaultSource"
Write-Host "  Backup: $defaultBackup"
Write-Host "--------------------------------"
Write-Host "`nPress Enter to use defaults or input new paths."

$sourceInput = Read-Host "Enter source directory path (or press Enter for default)"
$backupInput = Read-Host "Enter backup directory path (or press Enter for default)"

# Use provided paths or fall back to defaults
$sourceDirectory = if ($sourceInput) { $sourceInput } else { $defaultSource }
$backupRoot = if ($backupInput) { $backupInput } else { $defaultBackup }
$logFile = Join-Path $backupRoot "backup_log.txt"
$maxBackups = 5

# Create timestamped backup folder
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$backupDirectory = Join-Path $backupRoot "Backup_$timestamp"

# Function to write to log file
function Write-Log {
    param (
        [string]$Message
    )
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    $logDir = Split-Path $logFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    Add-Content -Path $logFile -Value $logMessage
    Write-Host $logMessage
}

# Function to show a progress bar
function Show-Progress {
    param (
        [int]$PercentComplete,
        [string]$Message
    )
    Write-Host -NoNewline "`r[$('{0,-3}' -f $PercentComplete)%] $Message"
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
        Show-Progress -PercentComplete $percent -Message "Copying: $($item.Name)"

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
            Write-Log "Permission denied or error: $($_.Exception.Message) - Skipped $($item.FullName)"
        }
    }
}

# Function to remove old backups beyond limit
function Remove-OldBackups {
    if (Test-Path $backupRoot) {
        $backups = Get-ChildItem -Path $backupRoot -Directory | Sort-Object CreationTime -Descending
        if ($backups.Count -gt $maxBackups) {
            Write-Log "Removing old backups to maintain limit of $maxBackups"
            $backups | Select-Object -Skip $maxBackups | ForEach-Object {
                Write-Host "[Removing]: $($_.FullName)"
                Remove-Item -Path $_.FullName -Recurse -Force
                Write-Log "Removed old backup: $($_.Name)"
            }
        }
    }
}

# Function to compress the backup folder into a zip file
function Compress-Backup {
    param (
        [string]$Source,
        [string]$Destination
    )

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($Source, $Destination)
        Write-Log "Backup successfully compressed to $Destination"
        Write-Host "`n[Success]: Backup compressed to $Destination"
    } catch {
        Write-Log "ERROR during compression: $($_.Exception.Message)"
        Write-Host "`n[Error]: Compression failed. Check the logfile for details."
    }
}

# Main backup process
try {
    Write-Host "`nVerifying directories..."

    if (-not (Test-Path $backupRoot)) {
        Write-Host "[Creating]: Backup directory $backupRoot"
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    }

    if (-not (Test-Path $sourceDirectory)) {
        throw "Source directory does not exist: $sourceDirectory"
    }

    Write-Log "Starting backup from $sourceDirectory to $backupDirectory"

    Write-Host "`n[Backup In Progress] Copying files..."
    Copy-WithVisualFeedback -Source $sourceDirectory -Destination $backupDirectory

    $backupSize = (Get-ChildItem -Path $backupDirectory -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Log "Backup completed successfully. Size: $([math]::Round($backupSize, 2)) MB"

    Write-Host "`n[Cleanup] Removing old backups (if any)..."
    Remove-OldBackups

    # Compression submenu
    Write-Host "`n[Compression] Would you like to compress the backup into a zip file?"
    Write-Host "1. Yes"
    Write-Host "2. No"
    $compressChoice = Read-Host "Enter your choice (1 or 2)"

    if ($compressChoice -eq "1") {
        $zipFile = Join-Path $backupRoot "Backup_$timestamp.zip"
        Write-Host "`n[Compressing] Creating zip file: $zipFile"
        Compress-Backup -Source $backupDirectory -Destination $zipFile
    } else {
        Write-Host "`n[Skipped] Compression skipped by user."
    }

    Write-Host "`n[Success]: Backup process completed successfully."
    Write-Host "Logfile: $logFile"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    Write-Host "`n[Error]: An error occurred. Check the logfile: $logFile"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}
