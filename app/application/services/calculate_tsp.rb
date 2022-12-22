# frozen_string_literal: true

require 'dry/monads'

module TravellingSuggestions
  module Service
    # A Service object to call worker to calculate TSP
    class CalculateTSP
      include Dry::Transaction

      step :setup_sets
      step :pick_set

      private

      
    end
  end
end
