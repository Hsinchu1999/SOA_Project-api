# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'region_representer'

module TravellingSuggestions
    module Representer
      # Represent about attraction
      class Attraction < Roar::decorator
        include Roar::JSON
  
        property :name
        property :id
        property :added_time
        property :region, extend: Representer::Region, clas OpenStruct
        property :indoor_or_outdoor
        property :main_activity
        property :staying_time
        property :type
        property :attendants
        property :notes
        property :contact
        property :best_time_to_visit
      end
    end
  end