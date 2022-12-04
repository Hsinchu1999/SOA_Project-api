# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'forecast_per_day_representer'

module TravellingSuggestions
  module Representer
    # Represent about forecast of 1 week
    class ForecastOneWeek < Roar::Decorator
      include Roar::JSON
      
      property :day1, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day2, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day3, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day4, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day5, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day6, extend: Representer::ForecastPerDay, class: OpenStruct
      property :day7, extend: Representer::ForecastPerDay, class: OpenStruct
    end
  end
end