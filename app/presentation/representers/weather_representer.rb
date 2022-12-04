# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'forecast_one_week_representer'
require_relative 'forecast_36hr_representer'

module TravellingSuggestions
  module Representer
    # Represent about weather
    class Weather < Roar::decorator
      include Roar::JSON

      property :forecast_36hr, extend: Representer::Forecast36Hr, class: OpenStruct
      property :forecast_one_week, extend: Representer::ForecastOneWeek, class: OpenStruct
    end
  end
end
