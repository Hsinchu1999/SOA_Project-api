# frozen_string_literal: true

require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for validating updates for user favorites
    class EncodedCalculateAttraction
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
            message: 'Incorrect attraction update request url'
          )
        )
      end

      def rule
        @params.each do |key, value|
          next if key == 'nickname'
          raise StandardError unless key !~ /\D/
          raise StandardError unless %w[like dislike].include? value
        end

        @params
      end
    end
  end
end
