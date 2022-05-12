#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'capybara/dsl'
require 'capybara/poltergeist'
require 'pry'
require 'csv'

include Capybara::DSL
Capybara.default_driver = :poltergeist

@BASE = 'http://www.parlamento.ao'
@PAGE = @BASE + '/web/guest/deputados-e-grupos-parlamentares/deputados/lista'

@COLS = %i[id name party constituency homepage]

def extract_people
  within('div#main-content') do
    all('div.members-table').each do |mp|
      parts = mp.all('div')
      data = {
        name:         parts[1].find('a').text.strip,
        homepage:     URI.join(@PAGE, parts[1].find('a')[:href]).to_s,
        party:        parts[2].text.strip || 'unknown',
        constituency: parts[3].text.strip,
      }
      data[:id] = data[:homepage].split('/').last
      sleep 1
      puts data.values_at(*@COLS).to_csv
    end
  end
end

puts @COLS.to_csv
visit @PAGE
extract_people

next_link = '//a[text()[contains(.,"Próximo")]]'
while page.has_xpath? next_link
  warn 'Next page...'
  find(:xpath, next_link).click
  extract_people
end
