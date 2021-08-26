#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    # TODO: handle precisions
    { converters: [->(val, field) { field.header == :dob ? val.to_s.split('T').first : val }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
