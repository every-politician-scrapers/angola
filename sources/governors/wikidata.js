const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
  return `SELECT DISTINCT ?province ?provinceLabel ?position ?positionLabel ?person ?name ?dob
         ?source ?sourceDate (STRAFTER(STR(?held), '/statement/') AS ?psid)
  WHERE {
    ?province wdt:P31 wd:Q329028 ; wdt:P1313 ?position .
    MINUS { ?province wdt:P576 [] }
    OPTIONAL {
      ?person wdt:P31 wd:Q5 ; p:P39 ?held .
      OPTIONAL { ?person wdt:P569 ?dob }

      ?held ps:P39 ?position ; pq:P580 ?start .
      FILTER NOT EXISTS { ?held pq:P582 ?end }

      OPTIONAL {
        ?held prov:wasDerivedFrom ?ref .
        ?ref pr:P854 ?source FILTER CONTAINS(STR(?source), '${meta.source.url}') .
        OPTIONAL { ?ref pr:P1810 ?sourceName }
        OPTIONAL { ?ref pr:P1932 ?statedName }
        OPTIONAL { ?ref pr:P813  ?sourceDate }
      }
      OPTIONAL { ?person rdfs:label ?wdLabel FILTER(LANG(?wdLabel) = "en") }
      BIND(COALESCE(?sourceName, ?wdLabel) AS ?name)

      OPTIONAL { ?position rdfs:label ?posLabel FILTER(LANG(?posLabel) = "en") }
      BIND(COALESCE(?statedName, ?posLabel) AS ?positionLabel)
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  } # ${new Date().toISOString()}
  ORDER BY ?provinceLabel ?sourceDate`
}
