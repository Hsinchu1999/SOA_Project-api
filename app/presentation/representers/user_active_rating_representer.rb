# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'user_representer'
require_relative 'attraction_representer'

module TravellingSuggestions
  module Representer
    # Represent about User Active Rating
    class UserActiveRating < Roar::decorator
      include Roar::JSON
      
      collection :favorites_list, extend: Representer::Attraction, class: OpenStruct

    end
  end
end
