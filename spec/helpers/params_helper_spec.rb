# frozen_string_literal: true

require './app.rb'

class Foo < Grape::API
  format :json

  helpers ParamsHelper

  get do
    decoded_params
  end
end

describe ParamsHelper do
  include Rack::Test::Methods

  def app
    Foo
  end

  describe '#decoded_params' do
    it 'returns parsed token when it is valid' do
      params = { foo: :bar }.to_json

      get '/', token: encode_jwt(params)

      expect(last_response.body).to eq(params)
    end

    it 'return error when token is not valid' do
      get '/', token: 'fooobar'

      expect(last_response.status).to eq 400
      expect(last_response.body).to eq({ error: 'Invalid token' }.to_json)
    end
  end
end
