# frozen_string_literal: true

require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for calculating mbti score
    class EncodedMBTIQuestionSet
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
            message: 'Incorrect mbti question size input'
          )
        )
      end

      def rule
        set_size = @params[:set_size]
        raise StandardError unless set_size !~ /\D/
        raise StandardError unless set_size.to_i <= 11
        raise StandardError unless set_size.to_i.positive?

        set_size
      end
    end
  end
end
