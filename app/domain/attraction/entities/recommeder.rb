# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module TravellingSuggestions
  module Entity
    # An Entity object to calculate MBTI score
    class Recommender
      attr_accessor :mbti_type
      attr_accessor :attraction_mbti_ratings_list

      def initialize(mbti_type, attraction_mbti_ratings_list)
        @mbti_type = mbti_type
        @attraction_mbti_ratings_list = attraction_mbti_ratings_list
      end

      def mbti_top_k(topk)
        @attraction_mbti_ratings_list.sort_by do |attraction_rating|
          -1 * (attraction_rating.send("#{mbti_type}_like").to_f / attraction_rating.send("#{mbti_type}_seen"))
        end [0..(topk - 1)]
      end
    end
  end
end
