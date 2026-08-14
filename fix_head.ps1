$targetDir = "d:\August Websites\Building Materials & Construction Supply Store"
$files = Get-ChildItem -Path $targetDir -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $content = $content -replace '`n</head>', "`n</head>"
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Fixed $($file.Name)"
}
