# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'region'

module TravellingSuggestions
  module Entity
    # An Entity object for attraction sites
    class AttractionMbtiRating < Dry::Struct
      include Dry.Types

      attribute :id,                    Integer.optional
      attribute :attraction_id,         Integer.optional
      attribute :ESTJ_like,             Strict::Integer
      attribute :ESTJ_seen,             Strict::Integer
      attribute :ENTJ_like,             Strict::Integer
      attribute :ENTJ_seen,             Strict::Integer
      attribute :ESFJ_like,             Strict::Integer
      attribute :ESFJ_seen,             Strict::Integer
      attribute :ENFJ_like,             Strict::Integer
      attribute :ENFJ_seen,             Strict::Integer
      attribute :ISTJ_like,             Strict::Integer
      attribute :ISTJ_seen,             Strict::Integer
      attribute :ISFJ_like,             Strict::Integer
      attribute :ISFJ_seen,             Strict::Integer
      attribute :INTJ_like,             Strict::Integer
      attribute :INTJ_seen,             Strict::Integer
      attribute :INFJ_like,             Strict::Integer
      attribute :INFJ_seen,             Strict::Integer
      attribute :ESTP_like,             Strict::Integer
      attribute :ESTP_seen,             Strict::Integer
      attribute :ESFP_like,             Strict::Integer
      attribute :ESFP_seen,             Strict::Integer
      attribute :ENTP_like,             Strict::Integer
      attribute :ENTP_seen,             Strict::Integer
      attribute :ENFP_like,             Strict::Integer
      attribute :ENFP_seen,             Strict::Integer
      attribute :ISTP_like,             Strict::Integer
      attribute :ISTP_seen,             Strict::Integer
      attribute :ISFP_like,             Strict::Integer
      attribute :ISFP_seen,             Strict::Integer
      attribute :INTP_like,             Strict::Integer
      attribute :INTP_seen,             Strict::Integer
      attribute :INFP_like,             Strict::Integer
      attribute :INFP_seen,             Strict::Integer

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end