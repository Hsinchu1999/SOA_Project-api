# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # A Repository for Entity::UsersFavorite object
    class UsersFavorites
      def self.find_user_id(id)
        rebuild_entity Database::UserOrm.first(id:)
      end

      def self.find_user_name(nickname)
        rebuild_entity Database::UserOrm.first(nickname:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        user_favorite_attractions = Repository::Attractions.rebuild_many_entities(db_record.favorite_attractions)

        Entity::UserFavorite.new(
          favorites_list: user_favorite_attractions
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          UsersFavorites.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        entity.favorites_list.map do |attraction|
          Database::AttractionOrm.find_or_create(attraction.to_attr_hash)
        end
      end
    end
  end
end
