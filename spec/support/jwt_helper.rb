# frozen_string_literal: true

require 'services/jwt_token'

RSpec.configure do |config|
  config.include JwtToken
end
