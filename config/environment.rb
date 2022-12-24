# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'sequel'
require 'figaro'
require 'rack/session'

module TravellingSuggestions
  # App for Roda routing
  class App < Roda
    plugin :environments

    configure do
      Figaro.application = Figaro::Application.new(
        environment:,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config = Figaro.env

      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      configure :development do
        use Rack::Cache,
            verbose: true,
            metastore: 'file:_cache/rack/meta',
            entitystore: 'file:_cache/rack/body'
      end

      use Rack::Session::Cookie, secret: config.SESSION_SECRET
      CWB_TOKEN = config.CWB_TOKEN
      DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.DB = DB
    end
  end
end
