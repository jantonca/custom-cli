$replaceString = Read-Host -Prompt "Write the string to remove from the file name and press Enter to continue"
$replacement = Read-Host -Prompt "Write the string to replace the removed text in the file name (press Enter for empty string)"
$extension = Read-Host -Prompt "Write the file extension (e.g., cbr) to rename or press Enter for all files in the directory"

# Get the files with the specified extension
if ([string]::IsNullOrWhiteSpace($extension)) {
    $fileList = Get-ChildItem
} else {
    $fileList = Get-ChildItem -Filter "*.$extension"
}

# Check if there are no files with the specified extensions
if ($fileList.Count -eq 0) {
    Write-Host -ForegroundColor Red "No files with the specified extension found in the directory."
    exit
}

$fileList | ForEach-Object {
    $originalName = $_.Name

    Write-Host "The name is: $originalName" -ForegroundColor Yellow
    $newName = $originalName -replace [regex]::Escape($replaceString), $replacement

    # Skip the file if the name doesn't change
    if ($newName -eq $originalName) {
        Write-Host "Skipping file -----> $originalName" -ForegroundColor Cyan
        return
    }

    Write-Host "The new name will be: $newName" -ForegroundColor Green

    do {
        $continue = Read-Host -Prompt "Press Enter to rename, 's' to skip, 'a' to skip all remaining, or 'x' to quit"
        if ($continue -eq 'x') {
            exit
        }
    } while ($continue -ne '' -and $continue -ne 's' -and $continue -ne 'a')

    if ($continue -eq 's') {
        Write-Host "Skipping file -----> $originalName" -ForegroundColor Cyan
        continue
    }
    if ($continue -eq 'a') {
        Write-Host "Skipping all remaining files..." -ForegroundColor Cyan
        break
    }

    $newPath = Join-Path -Path $_.Directory.FullName -ChildPath ($newName -replace '\[', '`[' -replace '\]', '`]')

    if (Test-Path $newPath) {
        Write-Host "A file with the new name already exists. Skipping..." -ForegroundColor Yellow
    } else {
        try {
            Rename-Item -LiteralPath $_.FullName -NewName $newName -ErrorAction Stop
            Write-Host "File renamed!" -ForegroundColor Green
        } catch {
            Write-Host "Failed to rename the file: $_" -ForegroundColor Red
        }
    }
}
