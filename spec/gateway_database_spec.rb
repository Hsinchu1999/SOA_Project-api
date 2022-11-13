# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/database_helper'
require_relative 'helpers/vcr_helper'

describe 'Integration Tests of CWB API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_cwb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end
    it 'HAPPY: should be able to save project from CWB to database' do
      weather = TravellingSuggestions::CWB::WeatherMapper.new(CWB_TOKEN, TravellingSuggestions::CWB::CWBApi).find(LOCATION)
      rebuilt = TravellingSuggestions::Repository::For.entity(weather).create(weather)
      _(rebuilt.)
    end
  end
end