# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

Slim::Engine.set_options encoding: 'utf-8'

module TravellingSuggestions
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views/views_html'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $Stderr
    plugin :public, root: 'app/views/public'
    plugin :flash
    plugin :halt

    route do |routing|
      routing.public
      routing.assets
      response['Content-Type'] = 'application/json'

      routing.root do
        session[:testing] = 'home'
        view 'home'
      end

      routing.on 'weather' do
        # GET  weather/#{location}
        routing.is do
          # POST /weather/
          routing.post do
            location = routing.params['location']
            routing.redirect "weather/#{location}"
          end
        end
        routing.on String do |region_id|
          routing.get do
            result = Service::ListWeather.new.call(
              region_id.to_i
            )
            if result.failure?
              failed = Representer::HTTPResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json
            end
            http_response = Representer::HTTPResponse.new(result.value!)
            response.status = http_response.http_status_code
            Representer::Weather.new(result.value!.message).to_json
            # case location
            # when 'hsinchu'
            #   location = '新竹縣'
            # when 'taipei'
            #   location = '臺北市'
            # end
            # cwb_weather = TravellingSuggestions::CWB::LocationMapper
            #               .new(CWB_TOKEN, TravellingSuggestions::CWB::CWBApi)
            #               .find(location)
            # view 'weather', locals: { weather: cwb_weather }
          end
        end
      end

      routing.on 'mbti_test' do
        # POST submit_answer / show_result
        # GET  question (by id???)

        routing.on 'question' do
          # GET a single question by its question id
          routing.on String do |question_id|
            routing.get do
              result = Service::ListMBTIQuestion.new.call(
                question_id.to_i
              )
              if result.failure?
                failed = Representer::HTTPResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HTTPResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::MBTIQuestion.new(result.value!.message).to_json
            end
          end
        end

        routing.is 'submit_answer' do
          # accepts submitted mbti answers
          routing.post do
            answer = routing.params['score']
            session[:mbti_answers].push(answer)
            # puts answer
            session[:answered_cnt] = session[:answered_cnt] + 1
            puts session[:answered_cnt]

            if session[:answered_cnt] >= 4
              routing.redirect '/mbti_test/last'
            else
              routing.redirect '/mbti_test/continue'
            end
          end
        end
        routing.is 'show_result' do
          routing.post do
            # answer = routing.params['score']
            routing.redirect '/mbti_test/result'
          end
        end
        routing.is 'previous_page' do
          routing.post do
            session[:answered_cnt] = session[:answered_cnt] - 1
            session[:mbti_answers].pop
            if session[:answered_cnt].zero?
              routing.redirect '/mbti_test/start'
            else
              routing.redirect '/mbti_test/continue'
            end
          end
        end
        routing.is 'start' do
          if session[:current_user]
            routing.redirect '/user'
          else
            session[:answered_cnt] = 0
            session[:mbti_answers] = []
            view 'mbti_test_first'
          end
        end
        routing.is 'continue' do
          puts 'in mbti_test/continue'
          puts session[:answered_cnt]
          if session[:answered_cnt].nil?
            routing.redirect '/mbti_test/start'
          else
            view 'mbti_test_general', locals: { current_question: session[:answered_cnt] + 1 }
          end
        end

        routing.is 'last' do
          puts 'in mbti_test/last'
          puts session[:answered_cnt]
          if session[:answered_cnt] != 4
            routing.redirect '/mbti_test/start'
          else
            view 'mbti_test_last'
          end
        end

        routing.is 'result' do
          if session[:retry_username] == true
            # incomplete
            puts 'give some warning here by flash'
          end
          view 'mbti_test_result'
        end
        routing.is 'recommendation' do
          view 'recommendation'
        end
      end

      routing.on 'user' do
        # POST consturct_profile(name+mbti+attractions) / submit_login
        # GET  user / favorites(use list_user service object)

        routing.is do
          nickname = routing.params['user_name']
          result = Service::ListUser.new.call(
            nickname:
          )

          if result.failure?
            failed = Representer::HTTPResponse.new(result.failure)
            routing.halt failed.http_status_code, failed.to_json
          end

          http_response = Representer::HTTPResponse.new(result.value!)
          response.status = http_response.http_status_code
          Representer::User.new(result.value!.message).to_json
        end

        routing.is 'construct_profile' do
          user_name = routing.params['user_name']
          mbti = routing.params['mbti']
          result = Request::EncodedNewUserNickname.new({ nickname: user_name }).call
          if result.failure?
            failed = Representer::HTTPResponse.new(result.failure)
            routing.halt failed.http_status_code, failed.to_json
          end

          result = Service::AddUser.new.call(
            nickname: user_name,
            mbti:
          )
          if result.failure?
            failed = Representer::HTTPResponse.new(result.failure)
            routing.halt failed.http_status_code, failed.to_json
          end

          http_response = Representer::HTTPResponse.new(result.value!)
          response.status = http_response.http_status_code
          Representer::User.new(result.value!.message).to_json
        end

        routing.is 'login' do
          user_name = session[:current_user]
          user = Repository::Users.find_name(user_name)
          puts 'currently at user/login'
          puts 'user_name = '
          puts user_name
          if user
            routing.redirect '/user'
          else
            view 'login'
          end
        end
        routing.is 'submit_login' do
          routing.post do
            nick_name = routing.params['nick_name']
            result = Service::ListUser.new.call(
              nickname: nick_name
            )
            if result.failure?
              failed = Representer::HTTPResponse.new(result.failure)
              routing.halt failed.http_status_code, failed.to_json

              session[:retry_login] = true
              flash[:error] = 'Invalid Nickname'
              flash[:notice] = 'Type correct nickname or start journey to get recommendation'
              routing.redirect '/user/login'
            end

            http_response = Representer::HTTPResponse.new(result.value!)
            response.status = http_response.http_status_code
            Representer::User.new(result.value!.message).to_json
          end
        end
        routing.is 'favorites' do
          nickname = routing.params['user_name']
          result = Service::ListUserFavorites.new.call(
            nickname:
          )
          if result.failure?
            failed = Representer::HTTPResponse.new(result.failure)
            routing.halt failed.http_status_code, failed.to_json
          end

          http_response = Representer::HTTPResponse.new(result.value!)
          response.status = http_response.http_status_code
          Representer::User.new(result.value!.message).to_json
        end
        routing.is 'viewed-attraction' do
          view 'viewed_attraction'
        end
      end
    end
  end
end
