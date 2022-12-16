# frozen_string_literal: true

module TravellingSuggestions
  module Representer
    # Representer for a set of MBTI question
    class MBTIQuestionSet
      def initialize(question_ids)
        @question_ids = question_ids
      end

      def to_json
        {question_set: @question_ids}.to_json
      end
    end
  end
end
