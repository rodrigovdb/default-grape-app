# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

%w[. app].each do |dir|
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end

require 'dotenv/load'

RACK_ENV ||= 'development'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, RACK_ENV.to_sym)

SimpleCov.start do
  add_group 'Resources',    ['app/resources', 'app.rb']
  add_group 'Models',       'app/models'
  add_group 'Serializers',  'app/serializers'
  add_group 'Helpers',      'app/helpers'
  add_group 'Services',     'lib/services'

  add_filter 'spec/'
end

require 'rack/test'
require 'rspec'

APPLICATION_PATH ||= File.expand_path(File.dirname(__FILE__) + '/../')

OTR::ActiveRecord.configure_from_file! 'config/database.yml'
ActiveRecord::Base.logger = Logger.new('log/database.log')

require 'webmock/rspec'
WebMock.disable_net_connect!(allow: %w[localhost 127.0.0.1 db])

require_relative 'support'

SPEC_PATH = __dir__

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
