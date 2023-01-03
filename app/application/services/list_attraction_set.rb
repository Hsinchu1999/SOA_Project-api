# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to get a set attractions for an mbti type
    class ListAttractionSet
      include Dry::Transaction

      step :setup_recommender
      step :pick_set

      private

      def setup_recommender(mbti, k)
        recommender = TravellingSuggestions::Entity::Recommender.new(mbti)
        Success([recommender, k])
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not setup recommender for attraction recommendation'
          )
        )
      end

      def pick_set(input)
        recommender = input[0]
        k = input[1]
        attractions = recommender.mbti_top_k(k)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: attractions
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not generate attraction set'
          )
        )
      end
    end
  end
end
1