# frozen_string_literal: true

module TravellingSuggestions
  module Mapper
    # Mapper for 12 hr forecast
    class ForecastPer12hrMapper
      attr_reader :pop,
                  :min_temp,
                  :max_temp

      def initialize(pop, min_temp, max_temp)
        @pop = pop
        @min_temp = min_temp
        @max_temp = max_temp
      end

      def build_entity
        Entity::ForecastPer12Hr.new(
          pop: @pop,
          min_temp: @min_temp,
          max_temp: @max_temp
        )
      end
    end
  end
end
