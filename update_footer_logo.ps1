$targetDir = "d:\August Websites\Building Materials & Construction Supply Store"
$files = Get-ChildItem -Path $targetDir -Filter "*.html"

$oldLogo = '<i data-lucide="hard-hat" class="text-primary-custom"></i>'
$newLogo = '<img src="assets/images/logo.svg" alt="Logo" height="40" width="40" class="rounded">'

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content.Contains($oldLogo)) {
        $content = $content.Replace($oldLogo, $newLogo)
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated footer/auth logo in $($file.Name)"
    }
}
