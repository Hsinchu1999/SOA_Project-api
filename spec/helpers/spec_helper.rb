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

# CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
# CWB_TOKEN = CONFIG['test']['CWB_TOKEN']
# YML_FILE = YAML.safe_load(File.read('spec/fixtures/cwb_results.yml'))

MBTI_QUESTION_ID = Array(1..10)
VALID_NICKNAMES = ['peter', 'Peter', 'Peter_', '_PETER', '_', 'PETERCHEN', 'peter_chen', 'peterchen999']
INVALID_NICKNAMES = [' ', '.', '', './']

CASSETTE_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'web_api'
