#!/bin/env ruby
# frozen_string_literal: true

require 'date'

require 'every_politician_scraper/scraper_data'
require 'pry'

class DatePT
  MONTHS = %w[
    null Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro
  ].freeze

  def initialize(str)
    @str = str
  end

  def to_s
    str.sub(/(\d+) de (.*?) de (\d+).*/) do
      day, mon, year = Regexp.last_match.captures
      format('%d-%02d-%02d', year, MONTHS.index(mon), day)
    end
  end

  private

  attr_reader :str
end

class MemberList
  class Member
    def name
      noko.css('h2').text.tidy
    end

    def position
      noko.css('h4').text.tidy
    end

    field :dob do
      DatePT.new(raw_dob).to_s
    end

    field :birth_place do
      noko.xpath('.//span[contains(text(),"Naturalidade")]/following-sibling::text()[1]').text.tidy
    end

    def raw_dob
      noko.xpath('.//div[span]/following-sibling::div[1]').text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.info')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
