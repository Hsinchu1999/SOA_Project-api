# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'region'

module TravellingSuggestions
  module Entity
    # An Entity object for attraction sites
    class Attraction < Dry::Struct
      include Dry.Types

      attribute :name,                  Strict::String
      attribute :id,                    Integer.optional
      attribute :in_region,             Region
      attribute :indoor_or_outdoor,     Strict::Symbol.optional
      attribute :main_activity,         Strict::String.optional
      attribute :staying_time,          Strict::String.optional
      attribute :type,                  Strict::String
      attribute :attendants,            Integer.optional
      attribute :notes,                 Strict::String
      attribute :contact,               Strict::String
      attribute :best_time_to_visit,    Strict::String.optional

      def to_attr_hash
        to_hash.except(:id, :in_region)
      end
    end
  end
end
