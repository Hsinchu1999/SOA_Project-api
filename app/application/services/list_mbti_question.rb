# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to validate Entity::Weather object from db
    class ListMBTIQuestion
      include Dry::Monads::Result::Mixin

      def call(question_id)
        mbti_question = Repository::MBTIQuestions.find_id(question_id)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: mbti_question
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
    end
  end
end
