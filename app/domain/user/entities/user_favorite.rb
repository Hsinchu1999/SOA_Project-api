# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module TravellingSuggestions
  module Entity
    # An Entity object for user's favorite attractions
    class UserFavorite < Dry::Struct
      include Dry.Types

      attribute :favorites_list, Strict::Array.of(Attraction)

      def retrieve_all
        sort
      end

      def add_new(new_attraction)
        favorites_list.append(new_attraction)
      end

      private

      def sort
        # could extend sorting methods here
        favorites_list
      end
    end
  end
end
