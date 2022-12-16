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
            message: 'Incorrect mbti test result'
          )
        )
      end

      def rule
        @params.each do |key, value|
          raise StandardError unless key !~ /\D/
          raise StandardError unless key != '0'
        end

        @params
      end
    end
  end
end
