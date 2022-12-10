# frozen_string_literal: true

module TravellingSuggestions
  module Repository
    # A Repository for Entity::MBTIQuestion object
    class MBTIQuestions
      def self.find_id(id)
        rebuild_entity Database::MBTIQuestionOrm.first(id:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::MBTIQuestion.new(
          id: db_record.id,
          question: db_record.question,
          answerA: db_record.answerA,
          answerB: db_record.answerB,
          section: db_record.section,
          directionA: db_record.directionA,
          scoreA: db_record.scoreA,
          scoreB: db_record.scoreB
        )
      end

      def self.rebuild_many_entities(db_records)
        db_records.map do |db_member|
          MBTIQuestions.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(_entity)
        nil
      end
      # to be completed
    end
  end
end
