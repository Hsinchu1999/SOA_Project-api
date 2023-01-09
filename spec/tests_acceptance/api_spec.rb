# frozen_string_literal: true

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

  describe 'Root route' do
    it 'HAPPY: should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      message = JSON.parse(last_response.body)

      _(message['message']).must_equal 'TravellingSuggestions API v1 at /api/v1/ in test mode'
    end
  end

  describe 'mbti_test/question' do
    it 'HAPPY: should give correct question' do
      MBTI_QUESTION_ID.each do |id|
        correct_answer = TravellingSuggestions::Representer::MBTIQuestion.new(
          TravellingSuggestions::Repository::MBTIQuestions.find_id(id)
        ).to_json
        correct_answer = JSON.parse(correct_answer)

        get "/api/v1/mbti_test/question?question_id=#{id}"
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

  describe 'mbti_test/question_set' do
    it 'HAPPY: should give a set of mbti question ids' do
      VALID_MBTI_QUESTION_SET_SIZE.each do |set_size|
        get "/api/v1/mbti_test/question_set?set_size=#{set_size}"

        _(last_response.status).must_equal 200
      end
    end

    it 'SAD: should block invalid mbti question set size' do
      INVALID_MBTI_QUESTION_SET_SIZE.each do |set_size|
        get "/api/v1/mbti_test/question_set?set_size=#{set_size}"

        _(last_response.status).must_equal 400
      end
    end
  end


  describe 'mbti_test/result' do
    it 'HAPPY: should calculate correct result' do
      VALID_MBTI_QUESTION_PAIR.each_with_index do |question_pair, index|
        get "/api/v1/mbti_test/result?#{question_pair}"
        _(last_response.status).must_equal 200

        mbti_result = JSON.parse(last_response.body)

        _(mbti_result['personalities']).must_equal CORRECT_MBTI_QUESTION_RESULT[index]
      end
    end

    it 'SAD: should block invalid mbti id' do
      INVALID_MBTI_QUESTION_PAIR.each do |question_pair|
        get "/api/v1/mbti_test/result?#{question_pair}"

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

    it 'HAPPY: should allow correct user login' do
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
    it 'HAPPY: should fetch valid user favorites' do
      VALID_NICKNAMES.each do |nickname|
        get "/api/v1/user/favorites?nickname=#{nickname}"

        _(last_response.status).must_equal 200
      end
    end

    it 'SAD: should fail fetching invalid user favorites' do
      INVALID_NICKNAMES.each do |nickname|
        get "/api/v1/user/favorites?nickname=#{nickname}"

        _(last_response.status).must_equal 404
      end
    end
  end

  describe 'recommendation/attraction_set' do
    it 'HAPPY: should give attraction set' do
      VALID_MBTI_TYPES_CAP.each do |mbti|
        VALID_ATTRACTION_SET_SIZE.each do |set_size|
          get "/api/v1/recommendation/attraction_set?set_size=#{set_size.to_s}&mbti=#{mbti.to_s}"
          _(last_response.status).must_equal 200

          attraction_set = JSON.parse(last_response.body)
          # puts "attraction_set=#{attraction_set}"

          _(attraction_set['attraction_set'].length).must_equal set_size
        end
      end
    end

    it 'SAD: should reject incorrect attraction set size' do
      VALID_MBTI_TYPES_CAP.each do |mbti|
        INVALID_ATTRACTION_SET_SIZE_POS.each do |set_size|
          get "/api/v1/recommendation/attraction_set?set_size=#{set_size.to_s}&mbti=#{mbti.to_s}"

          _(last_response.status).must_equal 400
        end
      end

      VALID_MBTI_TYPES_CAP.each do |mbti|
        INVALID_ATTRACTION_SET_SIZE_NEG.each do |set_size|
          get "/api/v1/recommendation/attraction_set?set_size=#{set_size.to_s}&mbti=#{mbti.to_s}"

          _(last_response.status).must_equal 400
        end
      end
    end

    it 'SAD: should reject incorrect mbti' do
      INVALID_MBTI_TYPES_CAP.each do |mbti|
        VALID_ATTRACTION_SET_SIZE.each do |set_size|
          get "/api/v1/recommendation/attraction_set?set_size=#{set_size.to_s}&mbti=#{mbti.to_s}"

          _(last_response.status).must_equal 500
        end
      end
    end
  end

  describe 'recommendation/attraction' do
    it 'HAPPY: should able to return attraction' do
      VALID_ATTRACTION_ID.each do |attraction_id|
        get "/api/v1/recommendation/attraction?attraction_id=#{attraction_id.to_s}"
        _(last_response.status).must_equal 200
      end
    end

    it 'SAD: should able to reject invalid attraction id' do
      INVALID_MBTI_QUESTION_PAIR.each do |attraction_id|
        get "/api/v1/recommendation/attraction?attraction_id=#{attraction_id.to_s}"
        _(last_response.status).must_equal 400
      end
    end
  end

  describe 'recommendation/result' do
    before do
      # Constructs a valid user profile
      VALID_NICKNAMES.each do |nickname|
        post "/api/v1/user/construct_profile?nickname=#{nickname}&mbti=ENFJ"
      end
    end

    it 'HAPPY: should successfully update' do
      VALID_ATTRACTION_SET.each do |attraction_set|
        VALID_NICKNAMES.each do |nickname|
          get "/api/v1/recommendation/result?nickname=peter_chen&#{attraction_set[0]}=like&#{attraction_set[1]}=dislike&#{attraction_set[2]}=like"
        end
      end
    end

    it 'SAD: should reject incorrect nickname' do
      VALID_ATTRACTION_SET.each do |attraction_set|
        INVALID_NICKNAMES.each do |nickname|
          get "/api/v1/recommendation/result?nickname=#{nickname}&#{attraction_set[0]}=like&#{attraction_set[1]}=dislike&#{attraction_set[2]}=like"
          _(last_response.status).must_equal 404
        end
      end
    end

  end

  describe 'model/update' do
    it 'HAPPY: should calculate correct result' do
      VALID_MBTI_QUESTION_PAIR.each_with_index do |question_pair, index|
        get "/api/v1/model/update?attraction_id=1&estj_like=1&estj_dislike=1&entj_like=2&entj_dislike=2&esfj_like=3&esfj_dislike=3&enfj_like=4&enfj_dislike=4&istj_like=5&istj_dislike=5&isfj_like=6&isfj_dislike=6&intj_like=7&intj_dislike=7&infj_like=8&infj_dislike=8&estp_like=9&estp_dislike=9&esfp_like=1&esfp_dislike=1&entp_like=2&entp_dislike=2&enfp_like=3&enfp_dislike=3&istp_like=4&istp_dislike=4&isfp_like=5&isfp_dislike=5&intp_like=6&intp_dislike=6&infp_like=7&infp_dislike=7"
        _(last_response.status).must_equal 200
      end
    end
  end

  describe 'model/attraction' do
    it 'HAPPY: should give correct result' do
      VALID_ATTRACTION_ID.each do |attraction_id|
        get "/api/v1/model/attraction?attraction_id=#{attraction_id}"
        _(last_response.status).must_equal 200
      end
    end
  end

end

describe 'Integration Tests of CWB API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_cwb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_weather
    end

    it 'HAPPY: should be able to save forecast from CWB to database' do
      region = TravellingSuggestions::Mapper::RegionMapper.new('Taiwan', LOCATION).find_weather(CWB_TOKEN)
      weather = region.weather
      rebuilt_region = TravellingSuggestions::Repository::Regions.db_find_or_create(region)
      rebuilt_forecast36hr = TravellingSuggestions::Repository::Forecasts36Hr.db_find_or_create(region)
      rebuilt_forecast1w = TravellingSuggestions::Repository::ForecastsOneWeek.db_find_or_create(region)
      _(rebuilt_region.city).must_equal region.city
      _(rebuilt_forecast36hr.region.city).must_equal region.city
      _(rebuilt_forecast36hr.forecast_first_12hr.pop).must_equal weather.forecast_36hr.first_12hr.pop
      _(rebuilt_forecast36hr.forecast_second_12hr.pop).must_equal weather.forecast_36hr.second_12hr.pop
      _(rebuilt_forecast36hr.forecast_last_12hr.pop).must_equal weather.forecast_36hr.third_12hr.pop
      _(rebuilt_forecast1w.region.city).must_equal region.city
      _(rebuilt_forecast1w.first_day.pop).must_equal weather.forecast_one_week.day1.pop
      _(rebuilt_forecast1w.second_day.pop).must_equal weather.forecast_one_week.day2.pop
      _(rebuilt_forecast1w.third_day.pop).must_equal weather.forecast_one_week.day3.pop
      _(rebuilt_forecast1w.fourth_day.pop).must_equal weather.forecast_one_week.day4.pop
      _(rebuilt_forecast1w.fifth_day.pop).must_equal weather.forecast_one_week.day5.pop
      _(rebuilt_forecast1w.sixth_day.pop).must_equal weather.forecast_one_week.day6.pop
      _(rebuilt_forecast1w.seventh_day.pop).must_equal weather.forecast_one_week.day7.pop
    end

    it 'HAPPY: should be able to save attraction from NTPC to database' do
      region = TravellingSuggestions::Mapper::RegionMapper.new('Taiwan', CITY).find_weather(CWB_TOKEN)
      rebuilt_region = TravellingSuggestions::Repository::Regions.db_find_or_create(region)
      attractions = TravellingSuggestions::Mapper::AttractionNTPCMapper.new(NTPCAPI, region).find(0, 5)
      rebuilt_attraction0 = TravellingSuggestions::Repository::Attractions.db_find_or_create(attractions[0])
      rebuilt_attraction1 = TravellingSuggestions::Repository::Attractions.db_find_or_create(attractions[1])
      _(rebuilt_attraction0.name).must_equal attractions[0].name
      _(rebuilt_attraction0.in_region.city).must_equal attractions[0].in_region.city
      _(rebuilt_attraction0.notes).must_equal attractions[0].notes
      _(rebuilt_attraction1.contact).must_equal attractions[1].contact
    end
  end
end