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
    it 'HAPPY: should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200
      
      message = JSON.parse(last_response.body)

      _(message['message']).must_equal "TravellingSuggestions API v1 at /api/v1/ in test mode"
    end
  end

  describe 'mbti tests' do
    it 'HAPPY: should give correct question' do
      MBTI_QUESTION_ID.each do |id|
        correct_answer = TravellingSuggestions::Representer::MBTIQuestion.new(
          TravellingSuggestions::Repository::MBTIQuestions.find_id(id)
        ).to_json
        correct_answer = JSON.parse(correct_answer)

        get "/api/v1/mbti_test/question?question_id=#{id.to_s}"
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

  describe 'calculate mbti result' do
    it 'HAPPY: should calculate correct result' do
      VALID_MBTI_QUESTION_PAIR.each_with_index do |question_pair, index|
        get "/api/v1/mbti_test/result?" + question_pair
        _(last_response.status).must_equal 200

        mbti_result = JSON.parse(last_response.body)

        _(mbti_result['personalities']).must_equal CORRECT_MBTI_QUESTION_RESULT[index]
      end
    end

    it 'SAD: should block invalid mbti id' do
      INVALID_MBTI_QUESTION_PAIR.each do |question_pair|
        get "/api/v1/mbti_test/result?" + question_pair

        _(last_response.status).must_equal 400
      end
    end
  end

  describe 'user page' do
    before do
      # Constructs a valid user profile
      VALID_NICKNAMES.each do |nickname|
        post "/api/v1/user/construct_profile?nickname=#{nickname}&mbti=ENFJ"
      end
    end

    it 'HAPPY: should fetch user info on /user' do
      VALID_NICKNAMES.each do |nickname|
        correct_answer = TravellingSuggestions::Representer::User.new(
          TravellingSuggestions::Repository::Users.find_name(nickname)
        ).to_json
        correct_answer = JSON.parse(correct_answer)

        get "/api/v1/user?nickname=#{nickname}"

        _(last_response.status).must_equal 200

        user_profile = JSON.parse(last_response.body)
        _(user_profile['id']).must_equal correct_answer['id']
        _(user_profile['mbti']).must_equal correct_answer['mbti']
      end
    end

    it 'SAD: should not allow invalid user names' do
      INVALID_NICKNAMES.each do |nickname|
        post "/api/v1/user/construct_profile?nickname=#{nickname}&mbti=ENFJ"

        _(last_response.status).must_equal 403
      end
    end

    it 'SAD: should allow correct user login' do
      VALID_NICKNAMES.each do |nickname|
        post "/api/v1/user/submit_login?nickname=#{nickname}"

        _(last_response.status).must_equal 200
      end
    end

    it 'SAD: should not allow incorrect user login' do
      INVALID_NICKNAMES.each do |nickname|
        post "/api/v1/user/submit_login?nickname=#{nickname}"

        _(last_response.status).must_equal 404
      end
    end
  end

end

