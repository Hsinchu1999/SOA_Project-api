# frozen_string_literal: true

module TravellingSuggestions
  module Representer
    # Representer for API's HTTP response
    class HTTPResponse < Roar::Decorator
      include Roar::JSON

      property :status
      property :message

      HTTP_CODE = {
        ok: 200,
        created: 201,
        processing: 202,
        no_content: 204,

        forbidden: 403,
        not_found: 404,
        bad_request: 400,
        conflict: 409,
        cannot_process: 422,

        internal_error: 500
      }.freeze

      def http_status_code
        HTTP_CODE[represented.status]
      end
    end
  end
end
