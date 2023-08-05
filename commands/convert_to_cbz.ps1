$sourceDirectory = Get-Location
$targetDirectory = Join-Path -Path $sourceDirectory -ChildPath "PROCESSED_COMICS"

# Prompt the user to enter the file extension
$extension = Read-Host -Prompt "Enter the file extension (e.g., cbr):"

# Create the target directory if it doesn't exist
if (-not (Test-Path $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory | Out-Null
}

try {
    $files = Get-ChildItem -Filter "*.$extension"

    if ($files.Count -eq 0) {
        Write-Host "No files with the extension '.$extension' found in the directory." -ForegroundColor Yellow
        Read-Host -Prompt "Press Enter to exit"
        exit
    }

    $totalFiles = $files.Count
    $processedFiles = 0

    foreach ($file in $files) {
        if ($file.Exists) {
            $processedFiles++
            Write-Host "Processing file $processedFiles of $totalFiles --> $($file.Name)" -ForegroundColor Cyan

            $dir = [System.IO.Path]::GetInvalidFileNameChars() -replace '\\', '\\\\' -join ''
            $dir = $file.BaseName -replace "[{0}]" -f $dir
            $dir = Join-Path -Path $targetDirectory -ChildPath $dir

            $newName = "$($file.BaseName).cbz"
            $newPath = Join-Path -Path $targetDirectory -ChildPath $newName
            Write-Host "$newPath"
            if (Test-Path -LiteralPath $newPath) {
                Write-Host "Skipping $($file.Name) as it already exists in the CBZ folder." -ForegroundColor Yellow
                Write-Host ""
                continue
            }

            New-Item -ItemType Directory -Path $dir | Out-Null

            & "C:\Program Files\7-Zip\7z.exe" e "$($file.FullName)" -o"$dir" | Out-Null
            & "C:\Program Files\7-Zip\7z.exe" a "$dir.zip" "$dir" -mx0 | Out-Null

            Write-Host "Compression of $($file.Name) successful!" -ForegroundColor Green

            Rename-Item -LiteralPath "$dir.zip" -NewName $newName -ErrorAction Stop

            Write-Host "Extension renamed to $newName successful!" -ForegroundColor Green

            Remove-Item -LiteralPath $dir -Recurse -Force -Confirm:$false | Out-Null
            # Remove or comment out this line if you want to keep cbr files
            Remove-Item -LiteralPath $file.FullName -Force -Confirm:$false | Out-Null

            Write-Host "Conversion of $($file.Name) successful!" -ForegroundColor Green
            Write-Host ""
        }
    }

    Write-Host "Conversion process completed." -ForegroundColor Green
}
catch {
    Write-Host "An error occurred during the conversion process: $_" -ForegroundColor Red
}

Read-Host -Prompt "Press Enter to exit"
