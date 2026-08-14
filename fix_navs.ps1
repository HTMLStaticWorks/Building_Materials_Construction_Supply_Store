$indexContent = Get-Content -Path 'index.html' -Raw -Encoding UTF8
$navRegex = '(?s)<nav class="navbar [^>]*>.*?</nav>'
$offcanvasRegex = '(?s)<!-- Mobile Offcanvas Menu -->\s*<div class="offcanvas.*?</div>\s*</div>'

$navMatch = [regex]::Match($indexContent, $navRegex)
$offcanvasMatch = [regex]::Match($indexContent, $offcanvasRegex)

if (-not $navMatch.Success -or -not $offcanvasMatch.Success) {
    Write-Output "Could not find standard navbar or offcanvas in index.html"
    exit 1
}

$standardNav = $navMatch.Value
$standardOffcanvas = $offcanvasMatch.Value

$htmlFiles = Get-ChildItem -Path '.' -Filter '*.html' | Where-Object { $_.Name -ne 'index.html' }

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Remove existing offcanvas strings and variants
    $content = $content -replace '(?s)<!-- Offcanvas Mobile Menu omitted for brevity but required in production -->', ''
    $content = $content -replace '(?s)<!-- Mobile Menu.*?</div>\s*</div>', ''
    $content = $content -replace '(?s)<!-- Mobile Offcanvas Menu -->\s*<div class="offcanvas.*?</div>\s*</div>', ''
    $content = $content -replace '(?s)<div class="offcanvas[^>]*id="mobileMenu".*?</div>\s*</div>', ''
    
    $fileMatch = [regex]::Match($content, $navRegex)
    
    if ($fileMatch.Success) {
        $newNav = $standardNav
        
        # Remove active class globally
        $newNav = $newNav -replace 'class="nav-link active"', 'class="nav-link"'
        
        # Set active class for current file
        $fileName = $file.Name
        $newNav = $newNav -replace "class=`"nav-link`" href=`"$fileName`"", "class=`"nav-link active`" href=`"$fileName`""
        
        $replacement = $newNav + "`r`n`r`n  " + $standardOffcanvas
        
        $newContent = $content.Substring(0, $fileMatch.Index) + $replacement + $content.Substring($fileMatch.Index + $fileMatch.Length)
        
        # Remove excessive blank lines if any
        $newContent = $newContent -replace "(?s)\r?\n\s*\r?\n\s*\r?\n", "`r`n`r`n"

        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Output "Updated $($file.Name)"
    } else {
        Write-Output "Could not find navbar in $($file.Name)"
    }
}
