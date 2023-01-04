# frozen_string_literal: true

require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for calculating mbti score
    class EncodedAttractionSet
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
        k = @params[:k]
        raise StandardError unless k !~ /\D/
        raise StandardError unless k.to_i <= 50
        raise StandardError unless k.to_i.positive?

        set_size
      end
    end
  end
end
