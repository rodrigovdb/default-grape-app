# frozen_string_literal: true

require './app'

describe Vdb::API do
  include Rack::Test::Methods

  def app
    described_class
  end

  context '/authenticate' do
    describe 'POST' do
      it 'receives 400 when authentication fails' do
        user = create(:user, password: 'rapadura')
        params = { email: user.email, password: 'foo' }.to_json

        post '/api/v1/authenticate', token: encode_jwt(params)

        expect(last_response.status).to eq 403
        expect(last_response.body).to eq({ error: 'Invalid Credentials' }.to_json)
      end

      it 'receives email and token when authentication does not fail' do
        user = create(:user, password: 'rapadura')
        params = { email: user.email, password: 'rapadura' }.to_json

        post '/api/v1/authenticate', token: encode_jwt(params)

        response = JSON.parse(last_response.body)
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq UserSerializer.new(user).to_json
        expect(response['token']).not_to be_empty
      end
    end
  end
end
