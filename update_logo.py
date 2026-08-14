import os
import re

target_dir = r"d:\August Websites\Building Materials & Construction Supply Store"

# Regex for adding favicon just before </head>
favicon_tag = '  <link rel="icon" type="image/jpeg" href="assets/images/logo.jpg">\n</head>'

# Regex for replacing navbar-brand content
# The original usually looks like:
# <a class="navbar-brand" href="index.html">
#   <i data-lucide="hard-hat" class="text-primary-custom"></i>
#   <span>Industrial<span class="text-primary-custom">Supply</span></span>
# </a>

# Note: In some files, the class might have other classes. 
# We can find `<a class="navbar-brand"[^>]*>...</a>` but regex over multiple lines is tricky.
# Let's replace the specific pattern.

logo_html = '''<a class="navbar-brand d-flex align-items-center gap-2" href="index.html">
        <img src="assets/images/logo.jpg" alt="Logo" height="40" width="40" class="rounded">
        <span>Industrial<span class="text-primary-custom">Supply</span></span>
      </a>'''

brand_pattern = re.compile(r'<a\s+class="navbar-brand"[^>]*>.*?</a>', re.DOTALL)

for file in os.listdir(target_dir):
    if file.endswith('.html'):
        filepath = os.path.join(target_dir, file)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Add favicon
        if '<link rel="icon"' not in content:
            content = content.replace('</head>', favicon_tag)

        # Replace navbar-brand
        content = brand_pattern.sub(logo_html, content)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {file}")
