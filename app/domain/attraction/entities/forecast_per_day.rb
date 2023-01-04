# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module TravellingSuggestions
  module Entity
    # An Entity object for future day
    class ForecastPerDay < Dry::Struct
      include Dry.Types

      attribute :pop,                 Strict::Integer
      attribute :min_temp,            Strict::Integer
      attribute :max_temp,            Strict::Integer
      def to_attr_hash
        to_hash
      end
    end
  end
end
