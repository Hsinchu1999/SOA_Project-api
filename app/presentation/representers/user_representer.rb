# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'user_favorite_representer'

module TravellingSuggestions
  module Representer
    # Represent about User
    class User < Roar::Decorator
      include Roar::JSON
      
      property :id
      property :nickname
      property :mbti
      property :favorite_attractions, extend: Representer::UserFavorite, class: OpenStruct
    end
  end
end
