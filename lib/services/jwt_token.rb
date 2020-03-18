# frozen_string_literal: true

module JwtToken
  def encode_jwt(payload)
    JWT.encode(payload, jwt_token, 'HS256')
  end

  def decode_jwt(token)
    JWT.decode(token, jwt_token, true, algorithm: 'HS256').first.symbolize_keys
  end

  private

  def jwt_token
    @jwt_token ||= ENV.fetch('JWT_PASSWORD')
  end
end
