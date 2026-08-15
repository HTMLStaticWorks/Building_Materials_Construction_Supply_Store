$files = Get-ChildItem -Filter *.html

$snippet = @"
  <!-- Back to Top Button -->
  <a href="#" class="back-to-top bg-primary-custom text-white shadow-lg d-flex align-items-center justify-content-center transition" aria-label="Back to Top">
    <i data-lucide="arrow-up"></i>
  </a>
"@

$regex = '(?s)[ \t]*<!-- Back to Top Button -->\s*<a href="#" class="back-to-top[^>]+>\s*<i data-lucide="arrow-up"></i>\s*</a>'

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Remove all existing back-to-top snippets
    $newContent = $content -replace $regex, ''
    
    # Insert exactly one before </body>
    if ($newContent -match '</body>') {
        $newContent = $newContent -replace '</body>', ($snippet + "`n</body>")
    } else {
        $newContent = $newContent + "`n" + $snippet
    }
    
    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
    Write-Output "Fixed back-to-top in $($file.Name)"
}
