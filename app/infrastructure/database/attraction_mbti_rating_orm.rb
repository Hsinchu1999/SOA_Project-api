# frozen_string_literal: true

require 'sequel'

module TravellingSuggestions
  module Database
    class AttractionMbtiRatingOrm < Sequel::Model(:attraction_mbti_ratings)
      many_to_one :attraction,
                class: :'TravellingSuggestions::Database::AttractionOrm'
      plugin :timestamps, update_on_create: true

      def self.find_or_create(attraction_id)
        first(attraction_id:) || create(attraction_id:)
      end
    end
  end
end
