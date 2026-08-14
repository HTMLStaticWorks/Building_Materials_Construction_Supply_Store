import re

html_file = 'brands.html'
with open(html_file, 'r', encoding='utf-8') as f:
    content = f.read()

new_buttons = '''
      <style>
        .filter-btn {
          border: 1px solid #dee2e6;
          transition: all 0.2s ease-in-out;
        }
        .filter-btn:hover {
          background-color: #e2e8f0 !important;
          color: #0f172a !important;
          border-color: #cbd5e1 !important;
        }
      </style>
      <div class="d-flex flex-wrap justify-content-center gap-3" id="brand-filters">
        <button class="btn btn-dark px-4 rounded-pill filter-btn text-white" data-filter="All">All Brands</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Cement">Cement</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Steel">Steel</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Tiles">Tiles</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Plumbing">Plumbing</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Glass">Glass</button>
        <button class="btn bg-white text-dark px-4 rounded-pill filter-btn" data-filter="Finishing">Finishing</button>
      </div>
'''

content = re.sub(r'<div class="d-flex flex-wrap justify-content-center gap-3">.*?</div>', new_buttons.strip(), content, flags=re.DOTALL)


brands = [
    ('Cement', 'Cement & Concrete', ['UltraTech Cement', 'Ambuja Cements', 'ACC Limited']),
    ('Steel', 'Steel & Rebar', ['Tata Tiscon', 'JSW Steel', 'Jindal Panther']),
    ('Tiles', 'Tiles & Flooring', ['Kajaria Ceramics', 'Somany Ceramics', 'Nitco Tiles']),
    ('Plumbing', 'Plumbing', ['Finolex Pipes', 'Ashirvad Pipes', 'Supreme Plastics']),
    ('Glass', 'Glass', ['Saint-Gobain', 'Asahi India Glass (AIS)', 'Modiguard']),
    ('Finishing', 'Finishing', ['Asian Paints', 'Berger Paints', 'Nerolac'])
]

cards_html = '<div class="row g-4" id="brands-grid">\n'
for cat, sub, b_list in brands:
    for b_name in b_list:
        short_name = b_name.split()[0]
        cards_html += f'''        <div class="col-md-6 col-lg-4 brand-card" data-category="{cat}">
          <div class="premium-card p-4 text-center h-100">
            <div class="bg-light p-3 rounded mb-4 mx-auto" style="width: 120px; height: 120px; display:flex; align-items:center; justify-content:center;">
              <span class="fw-bold fs-5 text-muted">{short_name}</span>
            </div>
            <span class="badge bg-primary-custom text-white mb-2">{sub}</span>
            <h5 class="fw-bold">{b_name}</h5>
            <div class="d-flex align-items-center justify-content-center gap-2 mb-4 text-success small fw-bold">
              <i data-lucide="shield-check" style="width: 16px;"></i> Verified Partner
            </div>
            <a href="categories.html" class="btn-outline-custom w-100 mt-auto">View Products</a>
          </div>
        </div>\n'''
cards_html += '      </div>'

content = re.sub(r'<div class="row g-4">.*?</div>\s*</div>\s*</section>', cards_html + '\n    </div>\n  </section>', content, flags=re.DOTALL)

js_script = '''
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const filterBtns = document.querySelectorAll('.filter-btn');
      const brandCards = document.querySelectorAll('.brand-card');

      filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
          // Update button styles
          filterBtns.forEach(b => {
            b.classList.remove('btn-dark', 'text-white');
            b.classList.add('bg-white', 'text-dark');
          });
          btn.classList.remove('bg-white', 'text-dark');
          btn.classList.add('btn-dark', 'text-white');

          const filter = btn.getAttribute('data-filter');

          brandCards.forEach(card => {
            if (filter === 'All' || card.getAttribute('data-category') === filter) {
              card.style.display = 'block';
            } else {
              card.style.display = 'none';
            }
          });
        });
      });
    });
  </script>
'''

if 'const filterBtns = document.querySelectorAll(' not in content:
    content = content.replace('</body>', js_script + '\n</body>')

with open(html_file, 'w', encoding='utf-8') as f:
    f.write(content)
