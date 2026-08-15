$files = Get-ChildItem -Filter *.html

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $original = $content
    
    # Replace em-dash mojibake with standard dash
    $content = $content -replace 'Ã¢â‚¬â€', '-'
    
    # Replace black circle mojibake with HTML entity bullet
    $content = $content -replace 'Ã¢â€”Â ', '&bull;'
    
    # Replace 8 bullets in placeholders with asterisks
    $content = $content -replace 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢', '********'
    
    # Replace single bullet in cart with hyphen
    $content = $content -replace 'â€¢', '-'
    
    if ($content -cne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Output "Fixed encoding issues in $($file.Name)"
    }
}
