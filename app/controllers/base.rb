# encoding utf-8

require "#{APPLICATION_PATH}/app/loader.rb"

module Vdb
  class API < Grape::API
    format :json
    prefix :api

    desc 'Return a simple string to check system health'
    get '/health' do
      'I\'m OK'
    end

    helpers AuthHelper

    mount Vdb::Auth
    mount Vdb::V1
  end
end
