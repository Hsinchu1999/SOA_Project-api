# frozen_string_literal: true

require 'roda'
# require 'slim'
# require 'slim/include'

# Slim::Engine.set_options encoding: 'utf-8'

module TravellingSuggestions
  # Web App
  class App < Roda
    # plugin :render, engine: 'slim', views: 'app/views/views_html'
    # plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $Stderr
    # plugin :public, root: 'app/views/public'
    # plugin :flash
    plugin :halt

    route do |routing|
      # routing.public
      # routing.assets
      response['Content-Type'] = 'application/json'

      routing.root do
        message = "TravellingSuggestions API v1 at /api/v1/ in #{App.environment} mode"

        result = Representer::HTTPResponse.new(
          Response::ApiResult.new(status: :ok, message:)
        )
        response.status = result.http_status_code
        result.to_json
      end
      
      routing.on 'api' do
        routing.on 'v1' do
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

            routing.is 'question' do
              # GET a single question by its question id
              routing.get do
                question_id = routing.params['question_id']
                puts question_id
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

            routing.is 'result' do
              routing.get do
                params = routing.params
                result = Request::EncodedMBTIScore.new(params).call()

                # Check mbti submit validity
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end
                
                result = Service::CalculateMBTIScore.new.call(routing.params)

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::MBTIScore.new(result.value!.message).to_json

              end
            end
            routing.is 'recommendation' do
              # view 'recommendation'
            end
          end

          routing.on 'user' do
            # POST consturct_profile(name+mbti+attractions) / submit_login
            # GET  user / favorites(use list_user service object)

            routing.is do
              nickname = routing.params['nickname']
              result = Service::ListUser.new.call(
                nickname:
              )

              if result.failure?
                failed = Representer::HTTPResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HTTPResponse.new(result.value!)
              response.status = http_response.http_status_code
              puts result.value!.message
              Representer::User.new(result.value!.message).to_json
            end

            routing.is 'construct_profile' do
              nickname = routing.params['nickname']
              mbti = routing.params['mbti']
              result = Request::EncodedNewUserNickname.new({ nickname: nickname }).call
              if result.failure?
                failed = Representer::HTTPResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              result = Service::AddUser.new.call(
                nickname: nickname,
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

            routing.is 'submit_login' do
              routing.post do
                nickname = routing.params['nickname']
                result = Service::ListUser.new.call(
                  nickname: nickname
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
              nickname = routing.params['nickname']
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
          end
        end
      end
    end
  end
end
