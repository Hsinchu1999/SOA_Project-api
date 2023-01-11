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

      def create_user_entity(input)
        post_params = input['post_params']
        keep_ids = input['keep_ids']
        if (user = Repository::ForUser.klass(Entity::User).find_name(post_params['nickname']))
          post_params.delete('nickname')
          Success(
            Response::ApiResult.new(
              status: :ok,
              message: [user, post_params, keep_ids]
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
        # puts 'in send_message'
        user = input.message[0]
        post_params = input.message[1]
        keep_ids = input.message[2]

        post_params.each do |key, value|
          next unless keep_ids.include? key.to_i

          message = "{\"mbti\":\"#{user.mbti}\", \"attraction_id\":#{key}, \"preference\":\"#{value}\"}"
          queue = TravellingSuggestions::Messaging::Queue.new(App.config.TSP_QUEUE_URL, App.config)
          res = queue.send(message)
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
