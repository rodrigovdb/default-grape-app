# frozen_string_literal: true

require 'helpers'
require 'resources/v1/foo'

module Vdb
  class V1 < Grape::API
    prefix    :api
    version   'v1', using: :path, vendor: 'rodrigovdb'
    format    :json

    before do
      logger.info serialize_request
    end

    helpers HandleHelper
    helpers LoggerHelper
    helpers ParamsHelper

    mount Foo
  end
end

