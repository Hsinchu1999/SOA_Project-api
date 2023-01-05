# frozen_string_literal: true

require 'dry/transaction'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class SendMbtiSqsMessage
      include Dry::Transaction

      step :create_user_entity
      step :send_message

      private

      def create_user_entity(post_params)
        if (user = Repository::ForUser.klass(Entity::User).find_name(post_params['nickname']))
          post_params.delete('nickname')
          Success(
              Response::ApiResult.new(
                status: :ok,
                message: [user, post_params]
              )
            )
        else
          Failure(
            Response::ApiResult.new(
              status: :not_found,
              message: 'User not found'
            )
          )
        end
      end

      def send_message(input)
        puts 'in send_message'
        user = input.message[0]
        post_params = input.message[1]

        post_params.each do |key, value|
          message = "{mbti:\"enfj\", attraction_id:1, preference:\"like\"}"
          puts 'in send_message'
          puts App.config.TSP_QUEUE_URL
          puts App.config
          queue = TravellingSuggestions::Messaging::Queue.new(App.config.TSP_QUEUE_URL, App.config)
          res = queue.send(message)
          puts res
          puts res.class
        end

        Success(
          Response::ApiResult.new(
            status: :ok,
            message: 'Success'
          )
        )
      rescue StandardError
        Failure(Response::ApiResult.new(
                  status: :not_found,
                  message: 'cannot send message to sqs'
                ))
      end
    end
  end
end
