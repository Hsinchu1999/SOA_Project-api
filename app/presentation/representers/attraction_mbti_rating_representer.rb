# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module TravellingSuggestions
  module Representer
    # Represent about attraction
    class AttractionMbtiRating < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :ESTJ_like
      property :ESTJ_seen
      property :ENTJ_like
      property :ENTJ_seen
      property :ESFJ_like
      property :ESFJ_seen
      property :ENFJ_like
      property :ENFJ_seen
      property :ISTJ_like
      property :ISTJ_seen
      property :ISFJ_like
      property :ISFJ_seen
      property :INTJ_like
      property :INTJ_seen
      property :INFJ_like
      property :INFJ_seen
      property :ESTP_like
      property :ESTP_seen
      property :ESFP_like
      property :ESFP_seen
      property :ENTP_like
      property :ENTP_seen
      property :ENFP_like
      property :ENFP_seen
      property :ISTP_like
      property :ISTP_seen
      property :ISFP_like
      property :ISFP_seen
      property :INTP_like
      property :INTP_seen
      property :INFP_like
      property :INFP_seen

      # link :self do
      #  "#{App.config.API_HOST}/recommendation/attraction&attraction_id=#{id}"
      # end

      # private

      # def id
      #   represented.id
      # end

      # def city_name
      #   represented.in_region.city
      # end

      # def attraction_name
      #   represented.name
      # end
    end
  end
end
