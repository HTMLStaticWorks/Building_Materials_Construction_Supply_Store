import os
import glob

html_files = glob.glob('*.html')

snippet = """
  <!-- Back to Top Button -->
  <a href="#" class="back-to-top bg-primary-custom text-white shadow-lg d-flex align-items-center justify-content-center transition" aria-label="Back to Top">
    <i data-lucide="arrow-up"></i>
  </a>
"""

for file_path in html_files:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'class="back-to-top"' not in content:
        # Find </body> and insert before it
        if '</body>' in content:
            new_content = content.replace('</body>', snippet + '\n</body>')
        else:
            new_content = content + snippet
            
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Added back-to-top to {file_path}")
    else:
        print(f"Already exists in {file_path}")
