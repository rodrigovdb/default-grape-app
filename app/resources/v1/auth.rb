# frozen_string_literal: true

require 'models/user'
require 'serializers/user'

module Vdb
  class Auth < Grape::API
    resource :authenticate do
      desc 'Authenticate user'
      params do
        requires :token, type: String, desc: 'JWT Token with {"email":"your-email","password": "your-password"}'
      end

      post do
        response = ::User.authenticate(email: decoded_params[:email], password: decoded_params[:password])

        error! 'Invalid Credentials', 403 and return unless response

        status 200
        handle! response
      end
    end
  end
end
