$targetDir = "d:\August Websites\Building Materials & Construction Supply Store"
$files = Get-ChildItem -Path $targetDir -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw

    # Update favicon
    $content = $content -replace '<link rel="icon" type="image/jpeg" href="assets/images/logo.jpg">', '<link rel="icon" type="image/svg+xml" href="assets/images/logo.svg">'

    # Update navbar img
    $content = $content -replace '<img src="assets/images/logo.jpg"', '<img src="assets/images/logo.svg"'

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated to SVG in $($file.Name)"
}
