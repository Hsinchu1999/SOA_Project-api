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
            message: 'Could not calculate mbti score'
          )
        )
      end

      def calculate_score(params)
        questions = params.map do |key, _value|
          Repository::MBTIQuestions.find_id(key.to_i)
        end

        answers = params.map do |_key, value|
          value
        end

        result = Entity::MBTIScore.new(questions, answers)
        result.mbti_type
        result
      end
    end
  end
end
