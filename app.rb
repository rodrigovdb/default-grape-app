# frozen_string_literal: true

require 'grape'
require 'grape-swagger'

require 'resources/v1'

module Vdb
  class Api < Grape::API
    mount V1

    add_swagger_documentation(
      mount_path: '/docs',
      info: {
        title: 'CashBack API',
        description: 'API to handle retailers, sales and cashback.'
      }
    )
  end
end
