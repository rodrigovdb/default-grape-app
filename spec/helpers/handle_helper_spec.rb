# frozen_string_literal: true

require './app.rb'

class Foo < Grape::API
  format :json

  helpers HandleHelper
  helpers LoggerHelper

  get '/handler' do
    handle! Object.stubbed
  end

  get '/exist' do
    exist? Object.stubbed
  end
end

describe HandleHelper do
  include Rack::Test::Methods

  def app
    Foo
  end

  describe '#handle!' do
    it 'return an object if it is valid' do
      retailer = create(:retailer)
      allow(Object).to receive(:stubbed).and_return(retailer)

      get '/handler'

      expect(last_response.status).to be 200
      expect(last_response.body).to eq(RetailerSerializer.new(retailer).to_json)
    end

    it 'return a collection of serialized items when it is a collection' do
      retailers = create_list(:retailer, 4)
      allow(Object).to receive(:stubbed).and_return(retailers)

      get '/handler'

      expect(last_response.status).to be 200
      expect(last_response.body).to eq(retailers.map { |i| RetailerSerializer.new(i) }.to_json)
    end

    it 'return error when object is not valid' do
      retailer = Retailer.new(attributes_for(:retailer).except(:full_name))
      allow(Object).to receive(:stubbed).and_return(retailer)

      get '/handler'

      expect(last_response.status).to be 400
      expect(last_response.body).to eq('{"full_name":["Invalid full name"]}')
    end
  end

  describe '#exist?' do
    it 'does nothing when object exist' do
      retailer = create(:retailer)
      allow(Object).to receive(:stubbed).and_return(retailer)

      get '/exist'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'null'
    end

    it 'returns 404 if object does not exist and log it' do
      allow(Object).to receive(:stubbed)
      logger = stub_logger

      get '/exist'

      expect(last_response.status).to eq 404
      expect(last_response.body).to eq({ error: 'Object not found' }.to_json)
      expect(logger).to have_received(:warn)
    end
  end
end
