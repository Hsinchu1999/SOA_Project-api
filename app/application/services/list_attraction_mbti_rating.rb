# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class ListAttractionMbtiRating
      include Dry::Monads::Result::Mixin

      def call(input)
        # puts "In Service::ListAttractionMbtiRating.list_attraction_mbti_rating"
        # puts "input=#{input}"

        attraction_id = input[:attraction_id].to_i
        # puts "attraction_id=#{attraction_id}"

        attraction_mbti_rating = Repository::ForAttraction
                                 .klass(Entity::AttractionMbtiRating)
                                 .find_attraction_id(attraction_id)

        Success(
          Response::ApiResult.new(
            status: :ok,
            message: attraction_mbti_rating
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :not_found,
            message: 'Attraction Mbti rating not found'
          )
        )
      end
    end
  end
end
