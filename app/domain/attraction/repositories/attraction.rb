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

        region_entity = Repository::Regions.find_id(db_record.in_region_id)

        Entity::Attraction.new(
          name: db_record.name,
          id: db_record.id,
          added_time: db_record.created_at.to_s,
          in_region: region_entity,
          indoor_or_outdoor: nil,
          main_activity: nil,
          staying_time: nil,
          type: db_record.type,
          attendants: nil,
          notes: db_record.notes,
          contact: db_record.contact,
          best_time_to_visit: nil
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          Attractions.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        db_attraction = Database::AttractionOrm.find_or_create(entity.to_attr_hash)
        db_region = Database::RegionOrm.find_or_create(entity.in_region.to_attr_hash)
        db_attraction.update(in_region_id: db_region.id)
      end
    end
  end
end
