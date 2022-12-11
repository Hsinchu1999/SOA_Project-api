# frozen_string_literal: true

require 'dry/transaction'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class AddUser
      include Dry::Transaction

      step :check_no_use_username
      step :store_user

      private

      def check_no_use_username(input)
        if Repository::ForUser.klass(Entity::User).find_name(input[:nickname])
          Failure(
            Response::ApiResult.new(
              status: :conflict,
              message: 'Nickname already in use'
            )
          )
        else
          Success(
            Response::ApiResult.new(
              status: :ok,
              message: input
            )
          )
        end
      end

      def store_user(input)
        nickname = input.message[:nickname]
        mbti = input.message[:mbti]

        user = Repository::ForUser.klass(Entity::User).db_create(nickname, mbti)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: user
          )
        )
      rescue StandardError
        Failure(Response::ApiResult.new(
                  status: :not_found,
                  message: 'Having trouble accessing database'
                ))
      end
    end
  end
end
