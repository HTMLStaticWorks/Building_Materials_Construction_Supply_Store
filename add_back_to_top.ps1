$files = Get-ChildItem -Filter *.html

$snippet = @"
  <!-- Back to Top Button -->
  <a href="#" class="back-to-top bg-primary-custom text-white shadow-lg d-flex align-items-center justify-content-center transition" aria-label="Back to Top">
    <i data-lucide="arrow-up"></i>
  </a>
"@

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    if ($content -notmatch 'class="back-to-top"') {
        if ($content -match '</body>') {
            $newContent = $content -replace '</body>', ($snippet + "`n</body>")
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
            Write-Output "Added back-to-top to $($file.Name)"
        } else {
            $newContent = $content + "`n" + $snippet
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
            Write-Output "Added back-to-top to $($file.Name) (no body tag)"
        }
    } else {
        Write-Output "Already exists in $($file.Name)"
    }
}
