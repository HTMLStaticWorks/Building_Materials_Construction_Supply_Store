$htmlFiles = Get-ChildItem -Path '.' -Filter '*.html'

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Reset all active states in navs
    $content = $content -replace 'class="nav-link active"', 'class="nav-link"'
    $content = $content -replace 'class="nav-link active text-center"', 'class="nav-link text-center"'
    $content = $content -replace 'class="nav-link text-center active"', 'class="nav-link text-center"'
    $content = $content -replace 'class="dropdown-item active"', 'class="dropdown-item"'
    $content = $content -replace 'class="nav-link dropdown-toggle active"', 'class="nav-link dropdown-toggle"'
    $content = $content -replace 'class="nav-link justify-content-center py-1 active"', 'class="nav-link justify-content-center py-1"'
    $content = $content -replace 'class="nav-link active justify-content-center py-1"', 'class="nav-link justify-content-center py-1"'
    $content = $content -replace 'class="nav-link active d-flex justify-content-center align-items-center" data-bs-toggle="collapse"', 'class="nav-link d-flex justify-content-center align-items-center" data-bs-toggle="collapse"'
    $content = $content -replace 'class="nav-link d-flex justify-content-center align-items-center active" data-bs-toggle="collapse"', 'class="nav-link d-flex justify-content-center align-items-center" data-bs-toggle="collapse"'

    # Add active state for current page
    $fileName = $file.Name
    
    # Desktop nav
    $content = $content -replace "class=`"nav-link`" href=`"$fileName`"", "class=`"nav-link active`" href=`"$fileName`""
    $content = $content -replace "class=`"dropdown-item`" href=`"$fileName`"", "class=`"dropdown-item active`" href=`"$fileName`""
    
    # Mobile nav
    $content = $content -replace "class=`"nav-link text-center`" href=`"$fileName`"", "class=`"nav-link active text-center`" href=`"$fileName`""
    $content = $content -replace "class=`"nav-link justify-content-center py-1`" href=`"$fileName`"", "class=`"nav-link active justify-content-center py-1`" href=`"$fileName`""
    
    # Dropdown toggle for specific pages
    if ($fileName -in @('categories.html', 'brands.html')) {
        $content = $content -replace 'class="nav-link dropdown-toggle"', 'class="nav-link dropdown-toggle active"'
        $content = $content -replace 'class="nav-link d-flex justify-content-center align-items-center" data-bs-toggle="collapse"', 'class="nav-link active d-flex justify-content-center align-items-center" data-bs-toggle="collapse"'
    }

    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
Write-Output "Fixed active states for all pages!"
