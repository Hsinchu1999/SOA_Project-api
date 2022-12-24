# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # An Repository object for Entity::Attraction
    class Attractions
      def self.find_id(id)
        rebuild_entity Database::AttractionOrm.first(id:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        region_entity = Repository::Region.find_id(db_record.in_region_id)

        Entity::Attraction.new(
          id: db_record.id,
          added_time: db_record.created_at.to_s,
          in_region: region_entity,
          indoor_or_outdoor: db_record.indoor_or_outdoor.to_sym,
          main_activity: db_record.main_activity,
          staying_time: db_record.staying_time,
          type: db_record.type,
          attendants: db_record.attendants,
          notes: db_record.notes,
          contact: db_record.contact,
          best_time_to_visit: db_record.best_time_to_visit
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          Attractions.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::AttractionOrm.find_or_create(entity.to_attr_hash)
      end
      # to be completed
    end
  end
end
