# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'


module TravellingSuggestions
  module Entity
    # An Entity object to calculate MBTI score
    class Recommender
      attr_accessor :mbti_type

      def initialize(mbti_type)
        @mbti_type = mbti_type
      end
      def mbti_top_k(k)
      end
      def data_loader(attraction_id, perference)
      end
    end
  end
end
