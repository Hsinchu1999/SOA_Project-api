# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to get a set attractions for an mbti type
    class ListAttractionSet
      include Dry::Transaction

      step :setup_recommender
      step :pick_set

      private

      def setup_recommender(input)
        puts 'In Service::ListAttractionSet.setup_recommender'
        mbti = input[:mbti]
        k = input[:set_size]
        puts "k=#{k}"

        attraction_ids = Array(0..99)
        attraction_mbti_ratings_list = attraction_ids.map do |attraction_id|
          puts attraction_id
          rating_entity = TravellingSuggestions::Entity::AttractionMbtiRating.new(
            id: nil,
            attraction_id: attraction_id,
            ESTJ_like: 1,
            ESTJ_seen: 1,
            ENTJ_like: 1,
            ENTJ_seen: 1,
            ESFJ_like: 1,
            ESFJ_seen: 1,
            ENFJ_like: 1,
            ENFJ_seen: 1,
            ISTJ_like: 1,
            ISTJ_seen: 1,
            ISFJ_like: 1,
            ISFJ_seen: 1,
            INTJ_like: 1,
            INTJ_seen: 1,
            INFJ_like: 1,
            INFJ_seen: 1,
            ESTP_like: 1,
            ESTP_seen: 1,
            ESFP_like: 1,
            ESFP_seen: 1,
            ENTP_like: 1,
            ENTP_seen: 1,
            ENFP_like: 1,
            ENFP_seen: 1,
            ISTP_like: 1,
            ISTP_seen: 1,
            ISFP_like: 1,
            ISFP_seen: 1,
            INTP_like: 1,
            INTP_seen: 1,
            INFP_like: 1,
            INFP_seen: 1
          )
        end

        # attraction_mbti_ratings_list = TravellingSuggestions::Repository::AttractionMbtiRatings.find_all
        # puts "attraction_mbti_ratings_list=#{attraction_mbti_ratings_list}"
        puts "attraction_mbti_ratings_list.class=#{attraction_mbti_ratings_list.class}"
        recommender = TravellingSuggestions::Entity::Recommender.new(mbti, attraction_mbti_ratings_list)
        Success([recommender, k])
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not setup recommender for attraction recommendation'
          )
        )
      end

      def pick_set(input)
        recommender = input[0]
        k = input[1]
        puts "In pick_set"
        puts "k=#{k}"
        attractions = recommender.mbti_top_k(k)
        Success(
          Response::ApiResult.new(
            status: :ok,
            message: attractions.map { |attraction| attraction.attraction_id }
          )
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :internal_error,
            message: 'Could not generate attraction set'
          )
        )
      end
    end
  end
end
1