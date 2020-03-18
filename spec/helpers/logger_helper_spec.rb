# frozen_string_literal: true

require './app.rb'

class Foo < Grape::API
  format :json

  helpers LoggerHelper
  helpers ParamsHelper

  get '/full/url/path' do
    serialize_request
  end
end

describe LoggerHelper do
  include Rack::Test::Methods

  def app
    Foo
  end

  describe '#serializable_request' do
    it 'get params information when it has params data' do
      get '/full/url/path', foo: :bar

      expect(last_response.body).to eq '{"method":"GET","path_info":"/full/url/path","headers":{"Host":"example.org","Cookie":""},"params":{"foo":"bar"}}'
    end

    it 'get jwt params decripted when params is a token' do
      params = { foo: :bar }

      get '/full/url/path', token: encode_jwt(params)

      expect(last_response.body).to eq '{"method":"GET","path_info":"/full/url/path","headers":{"Host":"example.org","Cookie":""},"params":{"foo":"bar"}}'
    end
  end
end
