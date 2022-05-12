#!/bin/bash

cd $(dirname $0)

# from https://github.com/everypolitician-scrapers/angola-national-assembly
# Requires phantomjs, and is unlikely to change much between now and the election,
# so run locally occasionally rather than rewriting and setting up an Action

# bundle exec ruby scraper.rb > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s name,startDate > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s name | tee diff.csv

cd ~-
