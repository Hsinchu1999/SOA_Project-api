# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TravellingSuggestions
  module Representer
    # Represent about mbti type
    class MBTIScore < Roar::Decorator
        include Roar::JSON

        property :personalities
    end
  end
end
