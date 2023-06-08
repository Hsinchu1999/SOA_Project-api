# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def generate_url_path(functionality, config)
  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/#{functionality}?Authorization=#{config['test']['CWB_TOKEN']}"
end

def call_cwb_api(url)
  HTTP.get(url)
end

cwb_response = {}

url_36 = generate_url_path('F-C0032-001', config)
cwb_response[url_36] = call_cwb_api(url_36)

# puts cwb_response[url_36]

forecast_hash = cwb_response[url_36].parse

forecast_all = forecast_hash['records']['location']

bad_url_36 = generate_url_path('F-C0032-000', config)
cwb_response[bad_url_36] = call_cwb_api(url_36)

File.write('spec/fixtures/cwb_results.yml', forecast_all.to_yaml)
