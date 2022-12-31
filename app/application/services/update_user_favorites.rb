# frozen_string_literal: true

require 'dry/transaction'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class UpdateUserFavorites
      include Dry::Transaction

      step :create_user_entity
      step :update_user_favorites

      private

      def create_user_entity(post_params)
        if (user = Repository::ForUser.klass(Entity::User).find_name(post_params['nickname']))
          Success(
              Response::ApiResult.new(
                status: :ok,
                message: [user, post_params.delete('nickname')]
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

      def update_user_favorites(input)
        user = input.message[0]
        post_params = input.message[1]

        post_params.each do |key, value|
          next unless value == 'like'
          attraction = Repository::ForAttraction.klass(Entity::Attraction).find_id(key)
          user.favorite_attractions.add_new(attraction)
        end

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
