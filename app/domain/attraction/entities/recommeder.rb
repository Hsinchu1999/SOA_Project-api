# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'


module TravellingSuggestions
  module Entity
    # An Entity object to calculate MBTI score
    class Recommender
      attr_accessor :mbti_type, attraction_mbti_ratings_list

      def initialize(mbti_type, attraction_mbti_ratings_list)
        @mbti_type = mbti_type
        @attraction_mbti_ratings_list = attraction_mbti_ratings_list
      end
      def mbti_top_k(k)
        @attraction_mbti_ratings_list.sort_by {|transaction| transaction.attribute}
      end
 
    end
  end
end
