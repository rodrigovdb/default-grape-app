module Vdb
  class Auth < Grape::API
    version 'v3', using: :header, vendor: 'rumblefish'

    resource :auth do
      desc 'Validates user and return the API Token if everything is OK'

      params do
        requires :public_key, type: String, desc: 'The public_key address associated with your portal'
        requires :password,   type: String, desc: 'The password associated with your portal'
      end

      post '/' do
        # See app/helpers/auth_helper.rb
        # and app/models/user.rb
        user  = authenticate

        unless user
          status 401
          return { error: { authentication: 'Specified public_key or password is incorrect' } }
        end

        { token: user.access_token }
      end
    end
  end
end
