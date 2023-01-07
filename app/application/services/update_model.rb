# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class UpdateModel
      include Dry::Monads::Result::Mixin

      def call(input)
        # puts "In Service::UpdateMode.create_attraction_mbti_rating"
        # puts "input=#{input}"
        

        attraction_id = input['attraction_id'].to_i
        # puts "attraction_id=#{attraction_id}"
        estj_like = input['estj_like'].to_i
        estj_seen = input['estj_like'].to_i + input['estj_dislike'].to_i
        entj_like = input['entj_like'].to_i
        entj_seen = input['entj_like'].to_i + input['entj_dislike'].to_i
        esfj_like = input['esfj_like'].to_i
        esfj_seen = input['esfj_like'].to_i + input['esfj_dislike'].to_i
        enfj_like = input['enfj_like'].to_i
        enfj_seen = input['enfj_like'].to_i + input['enfj_dislike'].to_i
        istj_like = input['istj_like'].to_i
        istj_seen = input['istj_like'].to_i + input['istj_dislike'].to_i
        isfj_like = input['isfj_like'].to_i
        isfj_seen = input['isfj_like'].to_i + input['isfj_dislike'].to_i
        intj_like = input['intj_like'].to_i
        intj_seen = input['intj_like'].to_i + input['intj_dislike'].to_i
        infj_like = input['infj_like'].to_i
        infj_seen = input['infj_like'].to_i + input['infj_dislike'].to_i
        estp_like = input['estp_like'].to_i
        estp_seen = input['estp_like'].to_i + input['estp_dislike'].to_i
        esfp_like = input['esfp_like'].to_i
        esfp_seen = input['esfp_like'].to_i + input['esfp_dislike'].to_i
        entp_like = input['entp_like'].to_i
        entp_seen = input['entp_like'].to_i + input['entp_dislike'].to_i
        enfp_like = input['enfp_like'].to_i
        enfp_seen = input['enfp_like'].to_i + input['enfp_dislike'].to_i
        istp_like = input['istp_like'].to_i
        istp_seen = input['istp_like'].to_i + input['istp_dislike'].to_i
        isfp_like = input['isfp_like'].to_i
        isfp_seen = input['isfp_like'].to_i + input['isfp_dislike'].to_i
        intp_like = input['intp_like'].to_i
        intp_seen = input['intp_like'].to_i + input['intp_dislike'].to_i
        infp_like = input['infp_like'].to_i
        infp_seen = input['infp_like'].to_i + input['infp_dislike'].to_i

        puts "infp_seen=#{infp_seen}"
        attraction_mbti_rating = Repository::ForAttraction
            .klass(Entity::AttractionMbtiRating)
            .find_attraction_id(attraction_id)
        
        puts "attraction_mbti_rating=#{attraction_mbti_rating}"

        attraction_mbti_rating_orm = Repository::ForAttraction
            .klass(Entity::AttractionMbtiRating)
            .db_find_or_create(attraction_mbti_rating)

        puts "attraction_mbti_rating_orm=#{attraction_mbti_rating_orm}"

        attraction_mbti_rating_orm.update(ESTJ_like: estj_like)
        attraction_mbti_rating_orm.update(ESTJ_seen: estj_seen)
        attraction_mbti_rating_orm.update(ENTJ_like: entj_like)
        attraction_mbti_rating_orm.update(ENTJ_seen: entj_seen)
        attraction_mbti_rating_orm.update(ESFJ_like: esfj_like)
        attraction_mbti_rating_orm.update(ESFJ_seen: esfj_seen)
        attraction_mbti_rating_orm.update(ENFJ_like: enfj_like)
        attraction_mbti_rating_orm.update(ENFJ_seen: enfj_seen)
        attraction_mbti_rating_orm.update(ISTJ_like: istj_like)
        attraction_mbti_rating_orm.update(ISTJ_seen: istj_seen)
        attraction_mbti_rating_orm.update(ISFJ_like: isfj_like)
        attraction_mbti_rating_orm.update(ISFJ_seen: isfj_seen)
        attraction_mbti_rating_orm.update(INTJ_like: intj_like)
        attraction_mbti_rating_orm.update(INTJ_seen: intj_seen)
        attraction_mbti_rating_orm.update(INFJ_like: infj_like)
        attraction_mbti_rating_orm.update(INFJ_seen: infj_seen)
        attraction_mbti_rating_orm.update(ESTP_like: estp_like)
        attraction_mbti_rating_orm.update(ESTP_seen: estp_seen)
        attraction_mbti_rating_orm.update(ESFP_like: esfp_like)
        attraction_mbti_rating_orm.update(ESFP_seen: esfp_seen)
        attraction_mbti_rating_orm.update(ENTP_like: entp_like)
        attraction_mbti_rating_orm.update(ENTP_seen: entp_seen)
        attraction_mbti_rating_orm.update(ENFP_like: enfp_like)
        attraction_mbti_rating_orm.update(ENFP_seen: enfp_seen)
        attraction_mbti_rating_orm.update(ISTP_like: istp_like)
        attraction_mbti_rating_orm.update(ISTP_seen: istp_seen)
        attraction_mbti_rating_orm.update(ISFP_like: isfp_like)
        attraction_mbti_rating_orm.update(ISFP_seen: isfp_seen)
        attraction_mbti_rating_orm.update(INTP_like: intp_like)
        attraction_mbti_rating_orm.update(INTP_seen: intp_seen)
        attraction_mbti_rating_orm.update(INFP_like: infp_like)
        attraction_mbti_rating_orm.update(INFP_seen: infp_seen)
        
        Success(
            Response::ApiResult.new(
              status: :ok,
              message: 'Success'
            )
          )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Cannot update attraction mbti rating'
          )
        )
      end
    end
  end
end
