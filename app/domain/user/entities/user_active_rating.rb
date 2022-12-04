# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'user'
require_relative '../../attraction/entities/attraction'

module TravellingSuggestions
  module Entity
    # An Entity object for user's active rating
    class UserActiveRating < Dry::Struct
      include Dry.Types

      attribute :user,                  User
      attribute :attraction,            Attraction
      attribute :score,                 Strict::Integer

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
