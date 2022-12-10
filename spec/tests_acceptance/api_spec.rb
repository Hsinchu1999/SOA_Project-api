require_relative '../helpers/spec_helper'
require_relative '../helpers/vcr_helper'
require_relative '../helpers/database_helper'
require 'rack/test'
require 'json'

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
      MBTI_QUESTION_ID.each do |id|
        correct_answer = TravellingSuggestions::Representer::MBTIQuestion.new(
          TravellingSuggestions::Repository::MBTIQuestions.find_id(id)
        ).to_json
        correct_answer = JSON.parse(correct_answer)

        get "/mbti_test/question/#{id.to_s}"
        _(last_response.status).must_equal 200

        mbti_question = JSON.parse(last_response.body)
        _(mbti_question['id']).must_equal id
        _(mbti_question['question']).must_equal correct_answer['question']
        _(mbti_question['answerA']).must_equal correct_answer['answerA']
        _(mbti_question['answerB']).must_equal correct_answer['answerB']
        _(mbti_question['section']).must_equal correct_answer['section']
        _(mbti_question['directionA']).must_equal correct_answer['directionA']
        _(mbti_question['scoreA']).must_equal correct_answer['scoreA']
        _(mbti_question['scoreB']).must_equal correct_answer['scoreB']
      end
    end
  end
end

