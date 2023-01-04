# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # An Repository object for Entity::Attraction
    class AttractionMbtiRatings
      def self.find_id(id)
        rebuild_entity Database::AttractionMbtiRatingOrm.first(id:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::AttractionMbtiRating.new(
          id: db_record.id,
          attraction_id: db_record.attraction_id,
          ESTJ_like: db_record.ESTJ_like,
          ESTJ_seen: db_record.ESTJ_seen,
          ENTJ_like: db_record.ENTJ_like,
          ENTJ_seen: db_record.ENTJ_seen,
          ESFJ_like: db_record.ESFJ_like,
          ESFJ_seen: db_record.ESFJ_seen,
          ENFJ_like: db_record.ENFJ_like,
          ENFJ_seen: db_record.ENFJ_seen,
          ISTJ_like: db_record.ISTJ_like,
          ISTJ_seen: db_record.ISTJ_seen,
          ISFJ_like: db_record.ISFJ_like,
          ISFJ_seen: db_record.ISFJ_seen,
          INTJ_like: db_record.INTJ_like,
          INTJ_seen: db_record.INTJ_seen,
          INFJ_like: db_record.INFJ_like,
          INFJ_seen: db_record.INFJ_seen,
          ESTP_like: db_record.ESTP_like,
          ESTP_seen: db_record.ESTP_seen,
          ESFP_like: db_record.ESFP_like,
          ESFP_seen: db_record.ESFP_seen,
          ENTP_like: db_record.ENTP_like,
          ENTP_seen: db_record.ENTP_seen,
          ENFP_like: db_record.ENFP_like,
          ENFP_seen: db_record.ENFP_seen,
          ISTP_like: db_record.ISTP_like,
          ISTP_seen: db_record.ISTP_seen,
          ISFP_like: db_record.ISFP_like,
          ISFP_seen: db_record.ISFP_seen,
          INTP_like: db_record.INTP_like,
          INTP_seen: db_record.INTP_seen,
          INFP_like: db_record.INFP_like,
          INFP_seen: db_record.INFP_seen
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_rating|
          AttractionMbtiRatings.rebuild_entity(db_rating)
        end
      end

      def self.db_find_or_create(entity)
        Database::AttractionMbtiRatingOrm.find_or_create(entity.to_attr_hash)
      end
      # to be completed
    end
  end
end
