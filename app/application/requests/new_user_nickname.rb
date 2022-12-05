# frozen_string_literal: true
require 'dry/monads'
require 'json'

module TravellingSuggestions
  module Request
    # A Request object for a new user nickname
    class EncodedNewUserNickname
      include Dry::Monads::Result::Mixin
      NICKNAME_REGEX = %r{/^\w+$/}

      def initialize(params)
        @params = params
      end

      def call
        Success(
          self.rule
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :forbidden,
            message: 'Invalid nickname'
          )
        )
      end

      def rule
        raise StandardError.new unless @params[:nickname].count("^a-zA-Z0-9_").zero?
        @params
      end
    end
  end
end
