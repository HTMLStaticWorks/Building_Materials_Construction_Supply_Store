$htmlFile = 'd:\August Websites\Building Materials & Construction Supply Store\brands.html'
$content = Get-Content -Path $htmlFile -Raw

$brands = @(
    @('Cement', 'Cement & Concrete', @('UltraTech Cement', 'Ambuja Cements', 'ACC Limited')),
    @('Steel', 'Steel & Rebar', @('Tata Tiscon', 'JSW Steel', 'Jindal Panther')),
    @('Tiles', 'Tiles & Flooring', @('Kajaria Ceramics', 'Somany Ceramics', 'Nitco Tiles')),
    @('Plumbing', 'Plumbing', @('Finolex Pipes', 'Ashirvad Pipes', 'Supreme Plastics')),
    @('Glass', 'Glass', @('Saint-Gobain', 'Asahi India Glass (AIS)', 'Modiguard')),
    @('Finishing', 'Finishing', @('Asian Paints', 'Berger Paints', 'Nerolac'))
)

$cardsHtml = '<div class="row g-4" id="brands-grid">' + "`n"

foreach ($categoryData in $brands) {
    $cat = $categoryData[0]
    $sub = $categoryData[1]
    $bList = $categoryData[2]
    
    foreach ($bName in $bList) {
        $cardsHtml += '        <div class="col-md-6 col-lg-4 brand-card" data-category="' + $cat + '">
          <div class="premium-card p-4 text-center h-100 d-flex flex-column">
            <div class="card-image mb-4 mx-auto w-100" style="height: 160px; display:flex; align-items:center; justify-content:center;">
              <img src="assets/images/' + $bName + '.png" alt="' + $bName + '" class="w-100 h-100" style="object-fit: contain;">
            </div>
            <span class="badge bg-primary-custom text-white mb-2 mx-auto" style="width: fit-content;">' + $sub + '</span>
            <h5 class="fw-bold">' + $bName + '</h5>
            <div class="d-flex align-items-center justify-content-center gap-2 mb-4 text-success small fw-bold">
              <i data-lucide="shield-check" style="width: 16px;"></i> Verified Partner
            </div>
            <a href="categories.html" class="btn-outline-custom w-100 mt-auto">View Products</a>
          </div>
        </div>' + "`n"
    }
}
$cardsHtml += '      </div>'

$content = $content -replace '(?s)<div class="row g-4" id="brands-grid">.*?</div>\s*</div>\s*</section>', ($cardsHtml + "`n    </div>`n  </section>")

Set-Content -Path $htmlFile -Value $content -Encoding UTF8
