# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TravellingSuggestions
  module Representer
    # Represent about forecast of 1 day
    class ForecastPerDay < Roar::decorator
      include Roar::JSON
      
      property :pop
      property :min_temp
      property :max_temp
    end
  end
end
