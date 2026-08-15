$files = @('register.html', 'home-2.html')
foreach ($file in $files) {
    $content = Get-Content $file -Raw
    $openDivs = ([regex]::Matches($content, '<div\b')).Count
    $closeDivs = ([regex]::Matches($content, '</div\b')).Count
    $diff = $openDivs - $closeDivs
    Write-Output "$file divs: +$openDivs -$closeDivs (diff: $diff)"
}
