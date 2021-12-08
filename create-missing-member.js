const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label, dob) => {
  return {
    type: 'item',
    labels: {
      en: label,
      pt: label,
    },
    descriptions: {
      en: 'Angolan politician',
      pt: 'político angolano',
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q82955' }, // politician
      P569: {
        value: dob,
        references: {
          P854: meta.source.url,
          P1476: {
            text: meta.source.title,
            language: meta.source.lang.code,
          },
          P813: new Date().toISOString().split('T')[0],
        }
      }
    }
  }
}
