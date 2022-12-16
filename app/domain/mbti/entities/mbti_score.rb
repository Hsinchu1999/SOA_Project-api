# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'mbti_question'

module TravellingSuggestions
  module Entity
    # An Entity object to calculate MBTI score
    class MBTIScore

      def initialize(questions, answers)
        @questions = questions
        @answers = answers
      end

      def mbti_type
        puts @questions.class
        scores = {E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0}
        personalities = ''
        @questions.each_with_index do |question, index|
          answer = @answers[index]
          section = question.section
          # section_sym = question.section.to_sym
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

        if scores[:E] > scores[:I]
          personalities += 'E'
        else
          personalities += 'I'
        end

        if scores[:S] > scores[:N]
          personalities += 'S'
        else
          personalities += 'N'
        end

        if scores[:T] > scores[:F]
          personalities += 'T'
        else
          personalities += 'F'
        end

        if scores[:J] > scores[:P]
          personalities += 'J'
        else
          personalities += 'P'
        end

        personalities
      end
    end
  end
end
