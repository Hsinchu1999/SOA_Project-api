# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'mbti_question'

module TravellingSuggestions
  module Entity
    # An Entity object to calculate MBTI score
    class MBTIScore
      attr_accessor :personalities

      def initialize(questions, answers)
        @questions = questions
        @answers = answers
        @personalities = nil
      end

      def mbti_type
        scores = { E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0 }
        personalities = ''
        @questions.each_with_index do |question, index|
          answer = @answers[index]
          section = question.section
          directionA = question.directionA
          directionB = section.gsub(directionA, '')
          scoreA = question.scoreA
          scoreB = question.scoreB
          if answer == 'A'
            scores[directionA.to_sym] += scoreA
          else
            scores[directionB.to_sym] += scoreB
          end
        end

        personalities += if scores[:E] > scores[:I]
                           'E'
                         else
                           'I'
                         end

        personalities += if scores[:S] > scores[:N]
                           'S'
                         else
                           'N'
                         end

        personalities += if scores[:T] > scores[:F]
                           'T'
                         else
                           'F'
                         end

        personalities += if scores[:J] > scores[:P]
                           'J'
                         else
                           'P'
                         end

        @personalities = personalities
      end
    end
  end
end
