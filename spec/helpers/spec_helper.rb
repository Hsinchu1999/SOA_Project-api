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
VALID_NICKNAMES = ['peter', 'Peter', 'Peter_', '_PETER', '_', 'PETERCHEN', 'peter_chen', 'peterchen999']
INVALID_NICKNAMES = [' ', '.', '', './']

VALID_MBTI_QUESTION_PAIR = ['1=A&2=B&3=A&4=B', '9=B&10=A&11=A&14=A']
CORRECT_MBTI_QUESTION_RESULT = ['ENTJ', 'ISFJ']
INVALID_MBTI_QUESTION_PAIR = ['0=A&1=A&2=A&3=A', '99=A&1=A&3=A&4=A']

VALID_MBTI_QUESTION_SET_SIZE = (1..11).to_a
INVALID_MBTI_QUESTION_SET_SIZE = ['a', '-1', '99', '12', '0']

CASSETTE_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'web_api'
