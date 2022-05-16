#!/bin/bash

cd $(dirname $0)

# list from https://club-k.net/index.php?option=com_content&view=article&id=1132&lang=pt +
# http://www.embaixadadeangola.pt/wp-content/uploads/2013/11/Mwangole-09.pdf +
# https://www.kas.de/c/document_library/get_file?uuid=e32c946f-e19b-bbc2-c307-c20d65c05c3e&groupId=252038

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s name,startDate > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s name | tee diff.csv

cd ~-
