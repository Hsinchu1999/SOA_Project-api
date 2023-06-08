# frozen_string_literal: true

# Helper to wipe database
module DatabaseHelper
  def self.wipe_database
    TravellingSuggestions::App.DB.run('PRAGMA foreign_keys = OFF')
    TravellingSuggestions::Database::RegionOrm.map(&:destroy)
    TravellingSuggestions::Database::AttractionOrm.map(&:destroy)
    TravellingSuggestions::Database::ForecastOneWeekOrm.map(&:destroy)
    TravellingSuggestions::Database::Forecastper12hrOrm.map(&:destroy)
    TravellingSuggestions::Database::Forecast36hrOrm.map(&:destroy)
    TravellingSuggestions::Database::ForecastperDayOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTIInOutdoorRatingOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTIMainActivityRatingOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTIOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTIQuestionOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTIStayingtimeRatingOrm.map(&:destroy)
    TravellingSuggestions::Database::MBTITypeRatingOrm.map(&:destroy)
    TravellingSuggestions::Database::UserOrm.map(&:destroy)
    TravellingSuggestions::Database::UserActiveRatingOrm.map(&:destroy)
    TravellingSuggestions::App.DB.run('PRAGMA foreign_keys = ON')
  end

  def self.wipe_weather
    TravellingSuggestions::App.DB.run('PRAGMA foreign_keys = OFF')
    TravellingSuggestions::Database::ForecastOneWeekOrm.map(&:destroy)
    TravellingSuggestions::Database::Forecastper12hrOrm.map(&:destroy)
    TravellingSuggestions::Database::Forecast36hrOrm.map(&:destroy)
    TravellingSuggestions::Database::ForecastperDayOrm.map(&:destroy)
    TravellingSuggestions::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
