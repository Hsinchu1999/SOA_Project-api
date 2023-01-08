# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'sequel'
require 'figaro'
require 'rack/session'
require 'rack/cache'
require 'redis-rack-cache'

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
        ENV['MBTI_QUESTION_MIN_ID'] = config.MBTI_QUESTION_MIN_ID
        ENV['MBTI_QUESTION_MAX_ID'] = config.MBTI_QUESTION_MAX_ID
      end

      configure :development, :test do
        use Rack::Cache,
            verbose: true,
            metastore: 'file:_cache/rack/meta',
            entitystore: 'file:_cache/rack/body'
      end

      configure :production do
        use Rack::Cache,
            verbose: true,
            metastore: config.REDISCLOUD_URL + '/0/metastore',
            entitystore: config.REDISCLOUD_URL + '/0/entitystore'
      end

      use Rack::Session::Cookie, secret: config.SESSION_SECRET
      CWB_TOKEN = config.CWB_TOKEN
      DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
      def self.DB = DB
    end
  end
end
