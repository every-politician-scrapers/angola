#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Years in office'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name dates].freeze
    end

    def itemLabel
      super.gsub(' *', '').gsub(/ aka .*/, '')
    end

    def raw_combo_date
      years = super.gsub(/\(.*?\)/, '').tidy
      years =~ /^\d{4}$/ ? "#{years} - #{years}" : years
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
