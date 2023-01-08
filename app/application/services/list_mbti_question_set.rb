# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to get a set of MBTI questions
    class ListMBTIQuestionSet
      include Dry::Transaction

      step :setup_sets
      step :pick_set

      private

      def setup_sets(input)
        set_size = input[:set_size]
        min_id = ENV['MBTI_QUESTION_MIN_ID'].to_i
        max_id = ENV['MBTI_QUESTION_MAX_ID'].to_i
        question_ids = (min_id..max_id).to_a

        ei_section = []
        jp_section = []
        sn_section = []
        tf_section = []

        question_ids.each do |question_id|
          mbti_question = Repository::ForMBTI.klass(Entity::MBTIQuestion).find_id(question_id)
          case mbti_question.section
          when 'JP'
            jp_section.append(mbti_question)
          when 'SN'
            sn_section.append(mbti_question)
          when 'EI'
            ei_section.append(mbti_question)
          else
            tf_section.append(mbti_question)
          end
        end
        Success([{ ei: ei_section, jp: jp_section, sn: sn_section, tf: tf_section }, set_size])
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not setup question sets'
          )
        )
      end

      def pick_set(input)
        sections = input[0]
        set_size = input[1]
        selected = []

        sections.each do |_section_name, section|
          num_to_pick = set_size
          while num_to_pick.positive?
            chosen_index = rand(section.length)
            selected.append(section[chosen_index].id)
            section.delete_at(chosen_index)
            num_to_pick -= 1
          end
        end
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: selected
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not generate question sets'
          )
        )
      end
    end
  end
end
