import re

def main():
    with open('index.html', 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the Project Solutions section
    section_start = content.find('<!-- Project Solutions -->')
    section_end = content.find('<!-- How It Works -->')
    
    if section_start == -1 or section_end == -1:
        print("Could not find section")
        return
        
    section_content = content[section_start:section_end]
    
    # Replace align-items-center with align-items-stretch h-100 for the premium-cards
    section_content = re.sub(r'class="premium-card p-4 d-flex align-items-center gap-4"', 'class="premium-card p-4 d-flex align-items-stretch gap-4 h-100"', section_content)
    
    # Add align-self-center flex-shrink-0 to images
    section_content = re.sub(r'class="rounded-3"', 'class="rounded-3 align-self-center flex-shrink-0"', section_content)
    
    # Update the text divs
    # Find <div> \n <h5 class="fw-bold">...</h5> \n <p class="text-muted small">...</p> \n <a ...>...</a> \n </div>
    # We will use regex to find the div that follows the image
    
    def replacer(match):
        h5 = match.group(1)
        p = match.group(2)
        a = match.group(3)
        return f'<div class="d-flex flex-column w-100 py-1">\n              <h5 class="fw-bold mb-2">{h5}</h5>\n              <p class="text-muted small mb-2">{p}</p>\n              <div class="mt-auto">\n                {a}\n              </div>\n            </div>'

    # Match the inner div
    pattern = r'<div>\s*<h5 class="fw-bold">([^<]+)</h5>\s*<p class="text-muted small">([^<]+)</p>\s*(<a href="services\.html"[^>]*>.*?</a>)\s*</div>'
    
    section_content = re.sub(pattern, replacer, section_content, flags=re.DOTALL)
    
    new_content = content[:section_start] + section_content + content[section_end:]
    
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("Updated Project Solutions cards")

if __name__ == "__main__":
    main()
