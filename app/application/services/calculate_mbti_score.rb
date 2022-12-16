# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to calculate MBTI score using Entity::MBTIScore
    class CalculateMBTIScore
      include Dry::Monads::Result::Mixin

      def call(params)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: calculate_score(params)
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :not_found,
            message: 'Could not fetch mbti question from database'
          )
        )
      end

      def calculate_score(params)
        questions = params.map do |key, value|
          Repository::MBTIQuestions.find_id(key.to_i)
        end

        answers = params.map do |key, value|
          value
        end

        Entity::MBTIScore.new(questions, answers).mbti_type
      end
    end
  end
end
