# frozen_string_literal: true

require 'http'

module TravellingSuggestions
  # Library for Github Web API
  module HsinChuCityGovernment
    # Object for accessing HCCG api
    class HCCGApi
      def attractions(page, size)
        call_hccg_url(page, size).parse
      end

      private

      def call_hccg_url(skip, take)
        result =
          HTTP.get("https://opendata.hccg.gov.tw/API/v3/Rest/OpenData/5A07674C217C3EC7?take=#{take}&skip=#{skip}")

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
