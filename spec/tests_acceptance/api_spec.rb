require_relative '../helpers/spec_helper'
require_relative '../helpers/vcr_helper'
require_relative '../helpers/database_helper'
require 'rack/test'

def app
  TravellingSuggestions::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_cwb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200
    end
  end

  describe 'mbti tests' do
    it 'should give correct question' do
      puts MBTI_QUESTION_ID
      MBTI_QUESTION_ID.each do |id|
        puts "/mbti_test/question/#{id.to_s}"
        get "/mbti_test/question/#{id.to_s}"
        _(last_response.status).must_equal 200

        body = JSON.parse(last_response.body)
        puts body
      end
    end
  end
end

