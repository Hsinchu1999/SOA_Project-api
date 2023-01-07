# frozen_string_literal: true

module TravellingSuggestions
  module Mapper
    # Mapper for 1 day forecast
    class ForecastPerDayMapper
      attr_reader :pop,
                  :min_temp,
                  :max_temp

      def initialize(pop, min_temp, max_temp)
        @pop = pop
        @min_temp = min_temp
        @max_temp = max_temp
      end

      def build_entity
        Entity::ForecastPerDay.new(
          pop: @pop,
          minT: @min_temp,
          maxT: @max_temp
        )
      end
    end
  end
end
