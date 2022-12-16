# frozen_string_literal: true

require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for calculating mbti score
    class EncodedMBTIScore
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      def call
        Success(
          rule
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Incorrect mbti question id'
          )
        )
      end

      def rule
        @params.each do |key, value|
          puts 'in Request.rule'
          puts TravellingSuggestions::App.config.MBTI_QUESTION_MAX_ID.to_i.class
          puts TravellingSuggestions::App.config.MBTI_QUESTION_MAX_ID.to_i
          raise StandardError unless key !~ /\D/
          raise StandardError unless key.to_i >= TravellingSuggestions::App.config.MBTI_QUESTION_MIN_ID.to_i
          raise StandardError unless key.to_i <= TravellingSuggestions::App.config.MBTI_QUESTION_MAX_ID.to_i
        end

        @params
      end
    end
  end
end
