# frozen_string_literal: true

require './lib/loader'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             methods: %i[get post put delete options],
             headers: :any
  end
end

run Vdb::API
