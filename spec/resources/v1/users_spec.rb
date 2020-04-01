# frozen_string_literal: true

require './app.rb'

describe Vdb::API do
  include Rack::Test::Methods

  def app
    described_class
  end

  context '/user' do
    describe 'POST' do
      it 'fails if email is invalid' do
        params = { email: 'fooo', password: 'rapadura', password_confirmation: 'rapadura' }

        post '/api/v1/users', token: encode_jwt(params.to_json)

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq({ email: ['Invalid email format'] }.to_json)
      end

      it 'fails if password does not match' do
        params = { email: 'foo@bar.com', password: 'rapadura', password_confirmation: 'rapaduras' }

        post '/api/v1/users', token: encode_jwt(params.to_json)

        expect(last_response.status).to eq 400
        expect(last_response.body).to eq({ password_confirmation: ["doesn't match Password"] }.to_json)
      end

      it 'creates an user with right params' do
        params = { email: 'foo@bar.com', password: 'rapadura', password_confirmation: 'rapadura' }

        post '/api/v1/users', token: encode_jwt(params.to_json)

        user = User.find_by_email(params[:email])
        expect(last_response.status).to eq 201
        expect(last_response.body).to eq UserSerializer.new(user).to_json
      end
    end

    describe 'GET' do
      it 'get all users' do
        users = create_list(:user, 10)
        get '/api/v1/users'

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq users.map { |item| UserSerializer.new(item) }.to_json
      end
    end
  end
end
