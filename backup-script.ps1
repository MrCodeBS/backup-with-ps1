# Simple Backup Script
$ErrorActionPreference = "Stop"  # Makes all errors terminating

# Configuration - EDIT THESE PATHS
$sourceDirectory = "$env:USERPROFILE\Documents"  # Default to user's Documents folder
$backupDirectory = "$env:USERPROFILE\Desktop\Backup"  # Default to a Backup folder on Desktop

# Create timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$backupPath = Join-Path $backupDirectory "Backup_$timestamp"

Write-Host "Starting backup process..."
Write-Host "From: $sourceDirectory"
Write-Host "To: $backupPath"

try {
    # Check if source exists
    if (-not (Test-Path $sourceDirectory)) {
        throw "Source directory not found: $sourceDirectory"
    }

    # Create backup directory if it doesn't exist
    if (-not (Test-Path $backupDirectory)) {
        Write-Host "Creating backup directory..."
        New-Item -ItemType Directory -Path $backupDirectory -Force
    }

    # Perform the backup
    Write-Host "Copying files..."
    Copy-Item -Path $sourceDirectory -Destination $backupPath -Recurse -Force

    Write-Host "Backup completed successfully!" -ForegroundColor Green
    Write-Host "Files backed up to: $backupPath"

} catch {
    Write-Host "Error occurred during backup:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
