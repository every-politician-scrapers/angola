#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

REMAP = {
  'janeiro'   => '01',
  'fevereiro' => '02',
  'março'     => '03',
  'abril'     => '04',
  'maio'      => '05',
  'junho'     => '06',
  'julho'     => '07',
  'agosto'    => '08',
  'setembro'  => '09',
  'outubro'   => '10',
  'novembro'  => '11',
  'dezembro'  => '12',
  'dezembr'   => '12',
}.freeze

class MemberList
  class Member
    def name
      noko.css('h2').text.tidy
    end

    field :position do
    end

    field :positionLabel do
      noko.css('h4').text.tidy
    end

    field :dob do
      birthdate_en.split(' ').reverse.join('-')
    end

    private

    def birthdate
      noko.css('.texto').text.tidy[/Nasceu no (dia|mês) (.*?\d{4})/, 2].gsub('de', ' ').tidy
    end

    def birthdate_en
      REMAP.reduce(birthdate.downcase) { |str, (local, eng)| str.to_s.sub(local, eng) }
    end
  end

  class Members
    def member_container
      noko.css('.row .info')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
