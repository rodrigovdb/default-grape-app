# frozen_string_literal: true

require './app.rb'

describe Vdb::API::V1::Foo do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe '/' do
    describe 'GET' do
      it 'Get foo' do
        get '/api/v1/foo', token: 'foo'

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq({ foo: :bar, token: 'foo' }.to_json)
      end
    end
  end
end
