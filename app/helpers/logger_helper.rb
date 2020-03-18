# frozen_string_literal: true

require 'services/logger'

module LoggerHelper
  def logger
    Vdb::Logger::Logger.instance.logger
  end

  def serialize_request
    { method: request.request_method, path_info: request.path_info,
      headers: request.headers, params: serializable_params }
  end

  private

  def serializable_params
    params.key?(:token) ? decoded_params : params
  end
end
