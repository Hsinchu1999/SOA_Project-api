# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'region_representer'

module TravellingSuggestions
  module Representer
    # Represent about attraction
    class Attraction < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :name
      property :id
      # property :added_time
      property :in_region, extend: Representer::Region, class: OpenStruct
      # property :indoor_or_outdoor
      # property :main_activity
      # property :staying_time
      property :type
      # property :attendants
      property :notes
      property :contact
      # property :best_time_to_visit

      link :self do
        "#{App.config.API_HOST}/recommendation/attraction&attraction_id=#{id}"
      end

      private

      def id
        represented.id
      end

      def city_name
        represented.in_region.city
      end

      def attraction_name
        represented.name
      end
    end
  end
end
