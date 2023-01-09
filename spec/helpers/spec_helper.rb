# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app

MBTI_QUESTION_ID = Array(1..10)
VALID_NICKNAMES = %w[peter Peter Peter_ _PETER _ PETERCHEN peter_chen peterchen999].freeze
INVALID_NICKNAMES = [' ', '.', '', './'].freeze

VALID_MBTI_QUESTION_PAIR = ['1=A&2=B&3=A&4=B', '9=B&10=A&11=A&14=A'].freeze
CORRECT_MBTI_QUESTION_RESULT = %w[ENTJ ISFJ].freeze
INVALID_MBTI_QUESTION_PAIR = ['0=A&1=A&2=A&3=A', '99=A&1=A&3=A&4=A'].freeze

VALID_MBTI_QUESTION_SET_SIZE = (1..11).to_a
INVALID_MBTI_QUESTION_SET_SIZE = ['a', '-1', '99', '12', '0'].freeze

VALID_MBTI_TYPES = ["estj",
  "entj", "esfj", "enfj", "istj",
  "isfj", "intj", "infj", "estp",
  "esfp", "entp", "enfp", "istp",
  "isfp", "intp", "infp"].freeze

INVALID_MBTI_TYPES = [
  "abcd",
  "efgh"
]

VALID_MBTI_TYPES_CAP = VALID_MBTI_TYPES.map do |mbti|
  mbti.upcase
end

INVALID_MBTI_TYPES_CAP = INVALID_MBTI_TYPES.map do |mbti|
  mbti.upcase
end

VALID_ATTRACTION_SET_SIZE = Array(1..10)

INVALID_ATTRACTION_SET_SIZE_POS = Array(70..100)
INVALID_ATTRACTION_SET_SIZE_NEG = Array(-10..-1)

VALID_ATTRACTION_ID = Array(1..99)
INVALID_ATTRACTION_ID = Array(-10..-1)

VALID_ATTRACTION_SET = VALID_ATTRACTION_ID.each_slice(3).to_a
puts "VALID_ATTRACTION_SET=#{VALID_ATTRACTION_SET}"

CASSETTE_FOLDER_CWB = 'spec/fixtures/cassettes'
CASSETTE_FILE_CWB = 'cwb_api'

LOCATION = '新竹縣'
CITY = '新北市'
CWB_TOKEN = ENV['CWB_TOKEN']
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
