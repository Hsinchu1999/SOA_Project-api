# frozen_string_literal: true

require 'roda'

module TravellingSuggestions
  # Web App
  class App < Roda
    plugin :common_logger, $Stderr
    plugin :halt
    plugin :caching

    route do |routing|
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
              end
            end
          end

          routing.on 'mbti_test' do
            routing.is 'question' do
              # GET a single question by its question id
              routing.get do
                response.cache_control public: true, max_age: 30
                question_id = routing.params['question_id']
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

            routing.is 'question_set' do
              # GET a set (array) of mbti question id for a complete mbti test
              routing.get do
                response.cache_control public: true, max_age: 30
                set_size = routing.params['set_size']

                result = Request::EncodedMBTIQuestionSet.new(
                  set_size:
                ).call

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                set_size = set_size.to_i
                result = Service::ListMBTIQuestionSet.new.call(
                  set_size:
                )
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::MBTIQuestionSet.new(result.value!.message).to_json
              end
            end

            routing.is 'result' do
              routing.get do
                # GET mbti result by providing answer
                params = routing.params
                result = Request::EncodedMBTIScore.new(params).call

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
          end

          routing.on 'user' do
            # POST consturct_profile(name+mbti+attractions) / submit_login
            # GET  user / favorites(use list_user service object)

            routing.is do
              response.cache_control public: true, max_age: 30
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
              Representer::User.new(result.value!.message).to_json
            end

            routing.is 'construct_profile' do
              nickname = routing.params['nickname']
              mbti = routing.params['mbti']
              result = Request::EncodedNewUserNickname.new({ nickname: }).call
              if result.failure?
                failed = Representer::HTTPResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              result = Service::AddUser.new.call(
                nickname:,
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
                  nickname:
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
              response.cache_control public: true, max_age: 30
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
              Representer::UserFavorite.new(result.value!.message).to_json
            end
          end

          routing.on 'recommendation' do
            routing.is 'attraction_set' do
              routing.get do
                response.cache_control public: true, max_age: 30
                set_size = routing.params['set_size']
                mbti = routing.params['mbti']
                result = Request::EncodedAttractionSet.new(
                  k: set_size
                ).call
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                set_size = set_size.to_i
                result = Service::ListAttractionSet.new.call(
                  mbti:, set_size:
                )
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end
                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::AttractionSet.new(result.value!.message).to_json
              end
            end

            routing.is 'attraction' do
              routing.get do
                response.cache_control public: true, max_age: 30
                attraction_id = routing.params['attraction_id']
                result = Request::EncodedAttraction.new(
                  attraction_id:
                ).call
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                result = Service::ListAttraction.new.call(attraction_id.to_i)
                if result.failure?
                  puts 'in failure'
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end
                puts "result.value!=#{result.value!}"
                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::Attraction.new(result.value!.message).to_json
              end
            end

            routing.is 'result' do
              routing.get do
                # GET attraction result from user like/dislike
                params = routing.params
                result = Request::EncodedCalculateAttraction.new(params).call

                # Check result submit validity
                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                result = Service::UpdateUserFavorites.new.call(routing.params)

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                input = {}
                input['post_params'] = routing.params
                input['keep_ids'] = result.value!.message
                result = Service::SendMbtiSqsMessage.new.call(input)

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                result.value!.message.to_json
              end
            end
          end

          routing.on 'model' do
            routing.is 'update' do
              routing.get do
                routing_params = routing.params
                # puts "routing_params=#{routing_params}"
                result = Service::UpdateModel.new.call(routing_params)

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                '{"Success":"Success"}'
              end
            end
            routing.is 'attraction' do
              routing.get do
                attraction_id = routing.params['attraction_id']
                result = Service::ListAttractionMbtiRating.new.call(
                  attraction_id:
                )

                if result.failure?
                  failed = Representer::HTTPResponse.new(result.failure)
                  routing.halt failed.http_status_code, failed.to_json
                end

                http_response = Representer::HTTPResponse.new(result.value!)
                response.status = http_response.http_status_code
                Representer::AttractionMbtiRating.new(result.value!.message).to_json
              end
            end
          end
        end
      end
    end
  end
end
