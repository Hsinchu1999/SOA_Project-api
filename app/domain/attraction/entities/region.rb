# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'weather'

module TravellingSuggestions
  module Entity
    # An Entity object for region
    class Region < Dry::Struct
      include Dry.Types

      attribute :country,         Strict::String
      attribute :city,            Strict::String
      attribute :weather,         Weather

      def to_attr_hash
        to_hash.except(:weather)
      end
    end
  end
end
