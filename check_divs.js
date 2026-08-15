const fs = require('fs');
['register.html', 'home-2.html'].forEach(file => {
    const html = fs.readFileSync(file, 'utf8');
    const openDivs = (html.match(/<div\b/g) || []).length;
    const closeDivs = (html.match(/<\/div>/g) || []).length;
    console.log(`${file} divs: +${openDivs} -${closeDivs} (diff: ${openDivs - closeDivs})`);
});
