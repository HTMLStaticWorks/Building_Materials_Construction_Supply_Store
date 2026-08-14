$targetDir = "d:\August Websites\Building Materials & Construction Supply Store"
$faviconTag = '  <link rel="icon" type="image/jpeg" href="assets/images/logo.jpg">`n</head>'

$logoHtml = '<a class="navbar-brand d-flex align-items-center gap-2" href="index.html">
        <img src="assets/images/logo.jpg" alt="Logo" height="40" width="40" class="rounded">
        <span>Industrial<span class="text-primary-custom">Supply</span></span>
      </a>'

$files = Get-ChildItem -Path $targetDir -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw

    # Add favicon
    if (-not $content.Contains('<link rel="icon"')) {
        $content = $content -replace '</head>', $faviconTag
    }

    # Replace navbar-brand
    $content = $content -replace '(?s)<a\s+class="navbar-brand"[^>]*>.*?</a>', $logoHtml

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($file.Name)"
}
