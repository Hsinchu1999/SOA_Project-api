# frozen_string_literal: true

require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for calculating mbti score
    class EncodedAttraction
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
            message: 'Incorrect attraction id'
          )
        )
      end

      def rule
        attraction_id = @params[:attraction_id]
        raise StandardError unless attraction_id !~ /\D/
        raise StandardError unless attraction_id.to_i.positive?

        attraction_id
      end
    end
  end
end
