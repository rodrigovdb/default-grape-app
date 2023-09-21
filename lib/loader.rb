# frozen_string_literal: true

%w[. app lib].each do |dir|
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end

require 'dotenv/load'

RACK_ENV = 'development'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, RACK_ENV.to_sym)

APPLICATION_PATH = File.expand_path("#{File.dirname(__FILE__)}/../")

OTR::ActiveRecord.configure_from_file! 'config/database.yml'
ActiveRecord::Base.logger = Logger.new('log/database.log')

require './app'
