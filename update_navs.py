import os
import re

# Read index.html to get the gold standard navbar
with open('index.html', 'r', encoding='utf-8') as f:
    index_content = f.read()

# Extract the exact <nav> tag
nav_pattern = re.compile(r'(<nav class="navbar [^>]*>.*?</nav>)', re.DOTALL)
match = nav_pattern.search(index_content)
if not match:
    print("Could not find standard navbar in index.html")
    exit(1)

standard_nav = match.group(1)

html_files = [f for f in os.listdir('.') if f.endswith('.html') and f != 'index.html']

for filename in html_files:
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    target_match = nav_pattern.search(content)
    if not target_match:
        print(f"Could not find navbar in {filename}")
        continue
    
    new_nav = standard_nav
    
    # Remove active class from all nav-links
    new_nav = re.sub(r'class="nav-link active"', 'class="nav-link"', new_nav)
    # Add active class to the correct nav-link for this page
    new_nav = re.sub(f'class="nav-link" href="{filename}"', f'class="nav-link active" href="{filename}"', new_nav)
    
    new_content = content[:target_match.start()] + new_nav + content[target_match.end():]
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Updated {filename}")
