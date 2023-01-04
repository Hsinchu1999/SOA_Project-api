# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

LOCATION = '新竹縣'
CITY = '新北市'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
CWB_TOKEN = CONFIG['test']['CWB_TOKEN']
YML_FILE = YAML.safe_load(File.read('spec/fixtures/cwb_results.yml'))
CORRECTLOCATION = YML_FILE.select { |data| data['locationName'] == LOCATION }
CORRECTPOP = CORRECTLOCATION[0]['weatherElement'].select do |data|
  data['elementName'] == 'PoP'
end[0]['time'][0]['parameter']['parameterName'].to_i
CORRECTMINT = CORRECTLOCATION[0]['weatherElement'].select do |data|
  data['elementName'] == 'MinT'
end[0]['time'][0]['parameter']['parameterName'].to_i
CORRECTMAXT = CORRECTLOCATION[0]['weatherElement'].select do |data|
  data['elementName'] == 'MaxT'
end[0]['time'][0]['parameter']['parameterName'].to_i
UNAUTHORIZED = TravellingSuggestions::CWB::CWBApi::Response::Errors::Unauthorized
NTPCAPI = TravellingSuggestions::NewTaiPeiCityGovernment::NTPCApi
CASSETTE_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'cwb_api'
