# frozen_string_literal: true

require 'http'

module TravellingSuggestions
  # Library for Github Web API
  module NewTaiPeiCityGovernment
    # Object for accessing HCCG api
    class NTPCApi

      def attractions(page, size)
        call_ntpc_url(page, size).parse
      end

      private

      def call_ntpc_url(page, size)
        result =
          HTTP.get("https://data.ntpc.gov.tw/api/datasets/b3a30a19-4b89-4da2-8d99-18200dc5dfde/json?page=#{page}&size=#{size}")
        
        Response.new(result).tap do |response|
          raise(response.error) unless response.successful?
        end
      end

      # API response message
      class Response < SimpleDelegator
        module Errors
          # 404 error
          class NotFound < StandardError; end
          # 401 error
          class Unauthorized < StandardError; end
        end

        HTTP_ERROR = {
          401 => Errors::Unauthorized,
          404 => Errors::NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
