# encoding utf-8

require 'rubygems'
require 'json'
require 'grape'
require 'rubygems'
require 'bundler/setup'

# Require app/models
Dir["#{APPLICATION_PATH}/app/models/*.rb"].each { |file| require file }

# Require app/helpers
Dir["#{APPLICATION_PATH}/app/helpers/*.rb"].each { |file| require file }

# Require app/controllers
Dir["#{APPLICATION_PATH}/app/controllers/*.rb"].each { |file| require file }
