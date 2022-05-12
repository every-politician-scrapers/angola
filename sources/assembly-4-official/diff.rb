#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

CSV::Converters[:uppercase] = ->(val) { val.to_s.upcase }

class Comparison < EveryPoliticianScraper::NulllessComparison
  def columns
    super - %i(arealabel partylabel)
  end

  def wikidata_csv_options
    { converters: %i[uppercase] }
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r[0].to_s.gsub(/\-.*/, '+++').gsub('@@','!!'), r[2].to_s.downcase] }.map(&:to_csv)
