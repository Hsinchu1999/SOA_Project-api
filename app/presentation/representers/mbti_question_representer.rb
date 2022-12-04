# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TravellingSuggestions
  module Representer
    # Represent about mbti question
    class MBTIQuestion < Roar::Decorator
      include Roar::JSON
      
      property :id
      property :question
      property :answerA
      property :answerB
      property :section
      property :directionA
      property :scoreA
      property :scoreB
    end
  end
end
