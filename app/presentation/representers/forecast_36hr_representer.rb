# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'forecast_per_12hr_representer'

module TravellingSuggestions
  module Representer
    # Represent about forecast of 36 Hr
    class Forecast36Hr < Roar::Decorator
      include Roar::JSON

      property :forecast_report_time
      property :first_12hr, extend: Representer::ForecastPer12Hr, class: OpenStruct
      property :second_12hr, extend: Representer::ForecastPer12Hr, class: OpenStruct
      property :third_12hr, extend: Representer::ForecastPer12Hr, class: OpenStruct
    end
  end
end
