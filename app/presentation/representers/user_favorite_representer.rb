# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'user_representer'
require_relative 'attraction_representer'

module TravellingSuggestions
  module Representer
    # Represent about User favorite
    class UserFavorite < Roar::decorator
      include Roar::JSON
      
      property :user, extend: Representer::User, class: OpenStruct
      property :attraction, extend: Representer::Attraction, class: OpenStruct
      property :score
    end
  end
end
