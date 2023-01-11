# frozen_string_literal: true

module TravellingSuggestions
  module Representer
    # Representer for a set of Attractions
    class AttractionSet
      def initialize(attraction_ids)
        @attraction_ids = attraction_ids
      end

      def to_json(*_args)
        { attraction_set: @attraction_ids }.to_json
      end
    end
  end
end
