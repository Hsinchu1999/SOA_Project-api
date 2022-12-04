# frozen_string_literal: true

module TravellingSuggestions
  module Request
    class EncodedNewUserNickname
      include Dry::Monads::Result::Mixin
      NICKNAME_REGEX = %r{/^\w+$/}

      def initialize(params)
        @params = params
      end

      def call
        Success(
          JSON.parse(rule(@params['nickname']))
        )
      rescue StandardError
        Failure(
          Reponse::ApiResult.new(
            status: :forbidden,
            message: 'Invalid nickname'
          )
        )
      end

      self.rule(param) do
        NICKNAME_REGEX.match?(param) ? param : raise StandardError.new
      end
    end
  end
end
