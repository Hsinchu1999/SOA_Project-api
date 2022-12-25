# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to get attraction from db
    class ListAttraction
      include Dry::Monads::Result::Mixin

      def call(attraction_id)
        attraction = Repository::ForAttraction.klass(Entity::Attraction).find_id(attraction_id)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: attraction
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :not_found,
            message: 'Could not fetch attraction from database'
          )
        )
      end
    end
  end
end
