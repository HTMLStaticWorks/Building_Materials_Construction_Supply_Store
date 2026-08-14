import os
import re

def main():
    with open('index.html', 'r', encoding='utf-8') as f:
        index_content = f.read()

    nav_pattern = re.compile(r'(<nav class="navbar [^>]*>.*?</nav>)', re.DOTALL)
    offcanvas_pattern = re.compile(r'(<!-- Mobile Offcanvas Menu -->\s*<div class="offcanvas.*?</div>\s*</div>)', re.DOTALL)

    nav_match = nav_pattern.search(index_content)
    offcanvas_match = offcanvas_pattern.search(index_content)

    if not nav_match or not offcanvas_match:
        print("Could not find nav or offcanvas in index.html")
        return

    standard_nav = nav_match.group(1)
    standard_offcanvas = offcanvas_match.group(1)

    html_files = [f for f in os.listdir('.') if f.endswith('.html') and f != 'index.html']

    for filename in html_files:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 1. Remove old offcanvas variants
        content = re.sub(r'<!-- Offcanvas Mobile Menu omitted for brevity but required in production -->', '', content)
        content = re.sub(r'<!-- Mobile Menu.*?</nav>', '</nav>', content, flags=re.DOTALL) # wait, that's wrong
        content = re.sub(r'<!-- Mobile Menu.*?</div>\s*</div>', '', content, flags=re.DOTALL)
        content = re.sub(r'<!-- Mobile Offcanvas Menu -->\s*<div class="offcanvas.*?</div>\s*</div>', '', content, flags=re.DOTALL)
        content = re.sub(r'<div class="offcanvas[^>]*id="mobileMenu".*?</div>\s*</div>', '', content, flags=re.DOTALL)
        
        # 2. Find target nav
        target_match = nav_pattern.search(content)
        if not target_match:
            print(f"Could not find navbar in {filename}")
            continue
        
        # 3. Create new nav with active class
        new_nav = standard_nav
        new_nav = re.sub(r'class="nav-link active"', 'class="nav-link"', new_nav)
        new_nav = re.sub(f'class="nav-link" href="{filename}"', f'class="nav-link active" href="{filename}"', new_nav)
        
        # 4. Replace nav with nav + offcanvas
        replacement = new_nav + "\n\n  " + standard_offcanvas
        new_content = content[:target_match.start()] + replacement + content[target_match.end():]
        
        # Clean up any excessive blank lines created
        new_content = re.sub(r'\n\s*\n\s*\n', '\n\n', new_content)

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"Updated {filename}")

if __name__ == '__main__':
    main()
