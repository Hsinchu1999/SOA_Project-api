require_relative '../require_app.rb'
require_app

require 'figaro'
require 'shoryuken'

class TSPWorker
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand('config/secrets.yml')
  )
  Figaro.load
  def self.config = Figaro.env

  include Shoryuken::Worker
  shoryuken_options queue: config.TSP_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    puts 'to be completed'
  rescue
    puts 'something went wrong'
  end

end
