# frozen_string_literal: true

require './app.rb'

describe Vdb::API do
  include Rack::Test::Methods

  def app
    described_class
  end

  context '/foo' do
    describe '/' do
      describe 'GET' do
        it 'Get foo' do
          token = { bar: :baz }

          get '/api/v1/foo', token: encode_jwt(token.to_json)

          expect(last_response.status).to eq 200
          expect(last_response.body).to eq({ foo: :bar }.merge(token).to_json)
        end
      end
    end
  end
end
