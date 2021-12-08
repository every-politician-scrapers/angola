#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

class Comparison < EveryPoliticianScraper::Comparison
  def columns
    super - [:dob]
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
