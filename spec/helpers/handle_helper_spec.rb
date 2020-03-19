# frozen_string_literal: true

require './app.rb'

class Foo < Grape::API
  format :json

  helpers HandleHelper

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
      user = create(:user)
      allow(Object).to receive(:stubbed).and_return(user)

      get '/handler'

      expect(last_response.status).to be 200
      expect(last_response.body).to eq(UserSerializer.new(user).to_json)
    end

    it 'return a collection of serialized items when it is a collection' do
      users = create_list(:user, 4)
      allow(Object).to receive(:stubbed).and_return(users)

      get '/handler'

      expect(last_response.status).to be 200
      expect(last_response.body).to eq(users.map { |i| UserSerializer.new(i) }.to_json)
    end

    it 'return error when object is not valid' do
      user = User.new(attributes_for(:user).except(:email))
      allow(Object).to receive(:stubbed).and_return(user)

      get '/handler'

      expect(last_response.status).to be 400
      expect(last_response.body).to eq('{"email":["Invalid email format"]}')
    end
  end

  describe '#exist?' do
    it 'does nothing when object exist' do
      user = create(:user)
      allow(Object).to receive(:stubbed).and_return(user)

      get '/exist'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'null'
    end

    it 'returns 404 if object does not exist and log it' do
      allow(Object).to receive(:stubbed)

      get '/exist'

      expect(last_response.status).to eq 404
      expect(last_response.body).to eq({ error: 'Object not found' }.to_json)
    end
  end
end
