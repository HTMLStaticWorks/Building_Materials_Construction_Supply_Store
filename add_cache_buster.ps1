$files = Get-ChildItem -Filter *.html

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $newContent = $content -replace 'href="assets/css/style.css"', 'href="assets/css/style.css?v=1.1"'
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    Write-Output "Updated CSS link in $($file.Name)"
}
