# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # An Repository object for Entity::ForecastPer12Hr
    class ForecastsPer12Hr
      def self.find_id(id)
        rebuild_entity Database::Forecastper12hrOrm.first(id:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::ForecastPer12Hr.new(
          pop: db_record.pop,
          minT: db_record.minT,
          maxT: db_record.maxT
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          ForecastsPer12Hr.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(_entity)
        nil
      end
      # to be completed
    end
  end
end
