# frozen_string_literal: true

require 'grape'
require 'grape-swagger'

require 'resources/v1'

module Vdb
  class API < Grape::API
    mount V1

    add_swagger_documentation(
      mount_path: '/docs',
      info: {
        title: 'Vdb API',
        description: 'API to fork.'
      }
    )
  end
end
