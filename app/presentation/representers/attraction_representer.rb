# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'region_representer'

module TravellingSuggestions
  module Representer
    # Represent about attraction
    class Attraction < Roar::Decorator
      include Roar::JSON
      include Roar::hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :name
      property :id
      property :added_time
      property :region, extend: Representer::Region, class: OpenStruct
      property :indoor_or_outdoor
      property :main_activity
      property :staying_time
      property :type
      property :attendants
      property :notes
      property :contact
      property :best_time_to_visit

      link :self do
        '#{Api.config.API_HOST}/attractions/#{attraction_name}/#{city_name}'
      end

      private
      
      def city_name
        represented.region.city
      end
      def attraction_name
        represented.name
      end
    end
  end
end
