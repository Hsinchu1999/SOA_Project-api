# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'weather_representer'

module TravellingSuggestions
  module Representer
    # Represent about region
    class Region < Roar::Decorator
      include Roar::JSON

      property :country
      property :city
      property :weather, extend: Representer::Weather, class: OpenStruct
    end
  end
end
