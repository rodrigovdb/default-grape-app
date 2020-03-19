# frozen_string_literal: true

require 'helpers'

require 'resources/v1/auth'
require 'resources/v1/users'

module Vdb
  class V1 < Grape::API
    prefix    :api
    version   'v1', using: :path, vendor: 'rodrigovdb'
    format    :json

    helpers HandleHelper
    helpers ParamsHelper

    mount Auth
    mount User
  end
end
