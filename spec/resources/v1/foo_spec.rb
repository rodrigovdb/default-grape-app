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
          token = 'eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InJvZHJpZ292ZGJAZ21haWwuY29tIiwicGFzc3dvcmQiOiJyYXBhZHVyYSJ9.dYBWbBSxRyBwlw83KnUB1S03ZyeeRmwkehCYb6mDtQE'

          get '/api/v1/foo', token: token

          expect(last_response.status).to eq 200
          expect(last_response.body).to eq({ foo: :bar, token: token }.to_json)
        end
      end
    end
  end
end
