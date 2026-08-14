import re

def main():
    with open('index.html', 'r', encoding='utf-8') as f:
        content = f.read()

    section_start = content.find('<!-- Client Testimonials -->')
    if section_start == -1:
        print("Could not find section")
        return
        
    section_end = content.find('<!-- Newsletter -->', section_start)
    if section_end == -1:
        section_end = len(content)
        
    section_content = content[section_start:section_end]
    
    # 1. Add flex-column and responsive text alignment to cards
    section_content = section_content.replace(
        'class="premium-card p-4 bg-white text-dark h-100 shadow-sm border-0"',
        'class="premium-card p-4 bg-white text-dark h-100 shadow-sm border-0 d-flex flex-column text-start text-md-center text-xl-start"'
    )
    
    # 2. Update the profile wrapper to center on md/lg, but we also want it to look good. Let's stack the image and name vertically on md/lg, and horizontally on mobile/desktop.
    # original: class="d-flex align-items-center gap-3 mt-auto"
    # new: class="d-flex flex-column flex-xl-row align-items-center gap-3 mt-auto justify-content-start justify-content-md-center justify-content-xl-start"
    # Wait, if it's flex-column on md, the gap-3 will create vertical space. This is perfect for a centered name and image!
    # Wait, on mobile (xs) we want it horizontal maybe? "flex-row flex-md-column flex-xl-row"
    section_content = section_content.replace(
        'class="d-flex align-items-center gap-3 mt-auto"',
        'class="d-flex flex-row flex-md-column flex-xl-row align-items-center gap-3 mt-auto justify-content-start justify-content-md-center justify-content-xl-start"'
    )
    
    # Update text inside the profile wrapper to be centered when stacked, left aligned when row
    # original: <div>
    # new: <div class="text-start text-md-center text-xl-start">
    section_content = re.sub(
        r'(<img src="[^"]+" class="[^"]+" style="[^"]+" alt="[^"]+">\s*)<div>',
        r'\1<div class="text-start text-md-center text-xl-start">',
        section_content
    )
    
    new_content = content[:section_start] + section_content + content[section_end:]
    
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("Updated testimonials")

if __name__ == "__main__":
    main()
