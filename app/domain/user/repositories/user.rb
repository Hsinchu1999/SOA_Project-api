# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # A Repository object for Entity::User objects
    class Users
      def self.find_id(id)
        rebuild_entity Database::UserOrm.first(id:)
      end

      def self.find_name(nickname)
        rebuild_entity Database::UserOrm.first(nickname:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        user_favorite_attractions = Repository::UsersFavorites.rebuild_entity(db_record)

        Entity::User.new(
          id: db_record.id,
          nickname: db_record.nickname,
          mbti: db_record.mbti,
          favorite_attractions: user_favorite_attractions
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          Users.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(_entity)
        nil
      end

      def self.db_create(nickname, mbti)
        Database::UserOrm.create(nickname:, mbti:)
      end
      # to be completed
    end
  end
end
