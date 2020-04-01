# frozen_string_literal: true

require 'models/user'
require 'serializers/user'

module Vdb
  class User < Grape::API
    namespace :users do
      before do
        auth!
      end

      desc 'Create an user'

      params do
        requires :token, type: String, desc: 'User payload encoded with JWT'
      end

      post do
        handle! ::User.create(decoded_params)
      end

      desc 'Get all users'

      get do
        handle! ::User.all
      end
    end
  end
end
