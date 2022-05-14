#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'every_politician_scraper/scraper_data'
require 'pry'

class Comparison < EveryPoliticianScraper::NulllessComparison
  def wikidata_csv_options
    { converters: [->(v) { v.to_s.sub(/ Province$/, '') }] }
  end

  def external_csv_options
    { converters: [->(v) { v.to_s.sub(/ Provincia$/, '') }] }
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r.first.to_s, r[1].to_s] }.reverse.map(&:to_csv)
