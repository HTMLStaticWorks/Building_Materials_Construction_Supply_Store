const fs = require('fs');

let content = fs.readFileSync('index.html', 'utf-8');

const startStr = '<!-- Project Solutions -->';
const endStr = '<!-- How It Works -->';

const startIndex = content.indexOf(startStr);
const endIndex = content.indexOf(endStr);

if (startIndex === -1 || endIndex === -1) {
  console.log("Could not find section");
  process.exit(1);
}

let sectionContent = content.substring(startIndex, endIndex);

// Replace card classes
sectionContent = sectionContent.replace(/class="premium-card p-4 d-flex align-items-center gap-4"/g, 'class="premium-card p-4 d-flex align-items-stretch gap-4 h-100"');

// Replace image classes
sectionContent = sectionContent.replace(/class="rounded-3"/g, 'class="rounded-3 align-self-center flex-shrink-0"');

// Replace inner divs
const pattern = /<div>\s*<h5 class="fw-bold">([^<]+)<\/h5>\s*<p class="text-muted small">([^<]+)<\/p>\s*(<a href="services\.html"[^>]*>[\s\S]*?<\/a>)\s*<\/div>/g;

sectionContent = sectionContent.replace(pattern, (match, h5, p, a) => {
  return `<div class="d-flex flex-column w-100 py-1">
              <h5 class="fw-bold mb-2">${h5}</h5>
              <p class="text-muted small mb-2">${p}</p>
              <div class="mt-auto">
                ${a}
              </div>
            </div>`;
});

const newContent = content.substring(0, startIndex) + sectionContent + content.substring(endIndex);

fs.writeFileSync('index.html', newContent, 'utf-8');
console.log("Updated Project Solutions cards");
