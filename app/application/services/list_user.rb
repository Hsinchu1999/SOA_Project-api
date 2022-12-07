# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object for validating Entity::User object from db
    class ListUser
      include Dry::Monads::Result::Mixin

      def call(input)
        if (user = Repository::ForUser.klass(Entity::User).find_name(input[:nickname]))
          Success(
            Response::ApiResult.new(
              status: :ok,
              message: user
            )
          )
        else
          Failure(
            Response::ApiResult.new(
              status: :not_found,
              message: 'User nickname does not exist'
            )
          )
        end
      end
    end
  end
end
