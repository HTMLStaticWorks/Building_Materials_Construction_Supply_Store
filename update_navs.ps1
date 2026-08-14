$indexContent = Get-Content -Path 'index.html' -Raw -Encoding UTF8
$regex = '(?s)<nav class="navbar [^>]*>.*?</nav>'
$match = [regex]::Match($indexContent, $regex)

if (-not $match.Success) {
    Write-Output "Could not find standard navbar in index.html"
    exit 1
}

$standardNav = $match.Value

$htmlFiles = Get-ChildItem -Path '.' -Filter '*.html' | Where-Object { $_.Name -ne 'index.html' }

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $fileMatch = [regex]::Match($content, $regex)
    
    if ($fileMatch.Success) {
        $newNav = $standardNav
        
        # Remove active class globally
        $newNav = $newNav -replace 'class="nav-link active"', 'class="nav-link"'
        
        # Set active class for current file
        $fileName = $file.Name
        $newNav = $newNav -replace "class=`"nav-link`" href=`"$fileName`"", "class=`"nav-link active`" href=`"$fileName`""
        
        # Build new content
        $newContent = $content.Substring(0, $fileMatch.Index) + $newNav + $content.Substring($fileMatch.Index + $fileMatch.Length)
        
        # Write back as UTF8 without BOM (in modern PS, but let's just use utf8)
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Output "Updated $($file.Name)"
    } else {
        Write-Output "Could not find navbar in $($file.Name)"
    }
}
