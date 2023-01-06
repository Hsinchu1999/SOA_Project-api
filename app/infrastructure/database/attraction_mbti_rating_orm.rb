# frozen_string_literal: true

require 'sequel'

module TravellingSuggestions
  module Database
    # Attraction Mbti Ratings
    class AttractionMbtiRatingOrm < Sequel::Model(:attraction_mbti_ratings)
      many_to_one :attraction,
                  class: :'TravellingSuggestions::Database::AttractionOrm'
      plugin :timestamps, update_on_create: true

      def self.find_or_create(rating_info)
        first(attraction_id: rating_info[:attraction_id],
              ESTJ_like: rating_info[:ESTJ_like],
              ESTJ_seen: rating_info[:ESTJ_seen],
              ENTJ_like: rating_info[:ENTJ_like],
              ENTJ_seen: rating_info[:ENTJ_seen],
              ESFJ_like: rating_info[:ESFJ_like],
              ESFJ_seen: rating_info[:ESFJ_seen],
              ENFJ_like: rating_info[:ENFJ_like],
              ENFJ_seen: rating_info[:ENFJ_seen],
              ISTJ_like: rating_info[:ISTJ_like],
              ISTJ_seen: rating_info[:ISTJ_seen],
              ISFJ_like: rating_info[:ISFJ_like],
              ISFJ_seen: rating_info[:ISFJ_seen],
              INTJ_like: rating_info[:INTJ_like],
              INTJ_seen: rating_info[:INTJ_seen],
              INFJ_like: rating_info[:INFJ_like],
              INFJ_seen: rating_info[:INFJ_seen],
              ESTP_like: rating_info[:ESTP_like],
              ESTP_seen: rating_info[:ESTP_seen],
              ESFP_like: rating_info[:ESFP_like],
              ESFP_seen: rating_info[:ESFP_seen],
              ENTP_like: rating_info[:ENTP_like],
              ENTP_seen: rating_info[:ENTP_seen],
              ENFP_like: rating_info[:ENFP_like],
              ENFP_seen: rating_info[:ENFP_seen],
              ISTP_like: rating_info[:ISTP_like],
              ISTP_seen: rating_info[:ISTP_seen],
              ISFP_like: rating_info[:ISFP_like],
              ISFP_seen: rating_info[:ISFP_seen],
              INTP_like: rating_info[:INTP_like],
              INTP_seen: rating_info[:INTP_seen],
              INFP_like: rating_info[:INFP_like],
              INFP_seen: rating_info[:INFP_seen]) || create(attraction_id: rating_info[:attraction_id],
                                                            ESTJ_like: rating_info[:ESTJ_like],
                                                            ESTJ_seen: rating_info[:ESTJ_seen],
                                                            ENTJ_like: rating_info[:ENTJ_like],
                                                            ENTJ_seen: rating_info[:ENTJ_seen],
                                                            ESFJ_like: rating_info[:ESFJ_like],
                                                            ESFJ_seen: rating_info[:ESFJ_seen],
                                                            ENFJ_like: rating_info[:ENFJ_like],
                                                            ENFJ_seen: rating_info[:ENFJ_seen],
                                                            ISTJ_like: rating_info[:ISTJ_like],
                                                            ISTJ_seen: rating_info[:ISTJ_seen],
                                                            ISFJ_like: rating_info[:ISFJ_like],
                                                            ISFJ_seen: rating_info[:ISFJ_seen],
                                                            INTJ_like: rating_info[:INTJ_like],
                                                            INTJ_seen: rating_info[:INTJ_seen],
                                                            INFJ_like: rating_info[:INFJ_like],
                                                            INFJ_seen: rating_info[:INFJ_seen],
                                                            ESTP_like: rating_info[:ESTP_like],
                                                            ESTP_seen: rating_info[:ESTP_seen],
                                                            ESFP_like: rating_info[:ESFP_like],
                                                            ESFP_seen: rating_info[:ESFP_seen],
                                                            ENTP_like: rating_info[:ENTP_like],
                                                            ENTP_seen: rating_info[:ENTP_seen],
                                                            ENFP_like: rating_info[:ENFP_like],
                                                            ENFP_seen: rating_info[:ENFP_seen],
                                                            ISTP_like: rating_info[:ISTP_like],
                                                            ISTP_seen: rating_info[:ISTP_seen],
                                                            ISFP_like: rating_info[:ISFP_like],
                                                            ISFP_seen: rating_info[:ISFP_seen],
                                                            INTP_like: rating_info[:INTP_like],
                                                            INTP_seen: rating_info[:INTP_seen],
                                                            INFP_like: rating_info[:INFP_like],
                                                            INFP_seen: rating_info[:INFP_seen])
      end
    end
  end
end
