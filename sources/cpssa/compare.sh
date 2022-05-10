#!/bin/bash

cd $(dirname $0)

qsv join --left position cpssa.csv raw reconciled-positions.csv | qsv select minister,position\[1\],transformed,startdate,enddate | qsv join --left minister - name reconciled-people.csv | qsv select id,minister,position,transformed,startdate,enddate | qsv rename item,itemLabel,position,positionLabel,start,end > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv search -s start . > wikidata.csv

bundle exec ruby diff.rb | qsv sort -s itemlabel,positionlabel | tee diff.csv

cd ~-
