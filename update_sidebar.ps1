$files = Get-ChildItem -Path "d:\August Websites\Building Materials & Construction Supply Store" -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # We need to match from the beginning of the cart <li> to the end of the Mobile Toggles <li>
    # Since HTML can vary slightly with whitespace, we'll use a regex that matches the start of the Cart li,
    # and matches up to the <!-- Mobile CTA --> or similar block following it.
    
    $pattern = '(?s)<li class="nav-item[^>]*>\s*<a[^>]*href="cart\.html"[^>]*>.*?</li>\s*<!-- Mobile CTA -->'
    
    $replacement = @"
        <!-- Mobile Actions & Toggles -->
        <li class="nav-item px-3 py-2 border-top mt-2">
          <div class="d-flex align-items-center justify-content-center gap-4">
            <button class="action-icon" id="theme-toggle-mobile" aria-label="Toggle theme">
              <span id="theme-icon-mobile" style="pointer-events: none;"><i data-lucide="moon"></i></span>
            </button>
            <button class="action-icon" id="dir-toggle-mobile" aria-label="Toggle layout direction">
              <i data-lucide="arrow-left-right" style="pointer-events: none;"></i>
            </button>
            <a href="cart.html" class="action-icon text-decoration-none">
              <i data-lucide="shopping-cart"></i>
              <span class="cart-badge">0</span>
            </a>
            <a href="login.html" class="action-icon text-decoration-none" aria-label="Login">
              <i data-lucide="user"></i>
            </a>
          </div>
        </li>
        
        <!-- Mobile CTA -->
"@
    
    if ($content -match $pattern) {
        $content = $content -replace $pattern, $replacement
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated: $($file.Name)"
    } else {
        Write-Host "Pattern not found in: $($file.Name)"
    }
}
