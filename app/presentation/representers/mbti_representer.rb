# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TravellingSuggestions
  module Representer
    # Represent about mbti type
    class MBTI < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      
      property :id
      property :type
      property :description

      link :self do
        '#{Api.config.API_HOST}/mbtis/#{mbti_type}'
      end

      private
      def mbti_type
        represented.type
      end
    end
  end
end
