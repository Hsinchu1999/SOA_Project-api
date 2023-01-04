# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:attraction_mbti_ratings) do
      primary_key :id
      foreign_key :attraction_id, :attractions

      Integer :ESTJ_like
      Integer :ESTJ_seen
      Integer :ENTJ_like
      Integer :ENTJ_seen
      Integer :ESFJ_like
      Integer :ESFJ_seen
      Integer :ENFJ_like
      Integer :ENFJ_seen
      Integer :ISTJ_like
      Integer :ISTJ_seen
      Integer :ISFJ_like
      Integer :ISFJ_seen
      Integer :INTJ_like
      Integer :INTJ_seen
      Integer :INFJ_like
      Integer :INFJ_seen
      Integer :ESTP_like
      Integer :ESTP_seen
      Integer :ESFP_like
      Integer :ESFP_seen
      Integer :ENTP_like
      Integer :ENTP_seen
      Integer :ENFP_like
      Integer :ENFP_seen
      Integer :ISTP_like
      Integer :ISTP_seen
      Integer :ISFP_like
      Integer :ISFP_seen
      Integer :INTP_like
      Integer :INTP_seen
      Integer :INFP_like
      Integer :INFP_seen

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
