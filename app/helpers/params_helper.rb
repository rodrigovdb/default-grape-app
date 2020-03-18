# frozen_string_literal: true

require 'services/jwt_token'

module ParamsHelper
  def decoded_params
    JwtHandler.decode_jwt(params[:token])
  rescue StandardError => _e
    error! 'Invalid token', 400
  end

  class JwtHandler
    include JwtToken

    def self.decode_jwt(token)
      new(token).decode
    end

    def decode
      decode_jwt(token)
    end

    private

    attr_reader :token

    def initialize(token)
      @token = token
    end
  end
end
