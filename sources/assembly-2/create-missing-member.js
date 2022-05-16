const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

// https://stackoverflow.com/questions/196972/convert-string-to-title-case-with-javascript

module.exports = (label) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P2937: meta.term.id,
    },
    references: {
      P854: meta.source,
      P813: new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label, pt: label },
    descriptions: { en: 'politician in Angola' },
    claims: claims,
  }
}
