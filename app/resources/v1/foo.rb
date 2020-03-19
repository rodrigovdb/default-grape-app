# frozen_string_literal: true

module Vdb
  class Foo < Grape::API
    namespace :foo do
      desc 'Foo route'

      params do
        optional :arg1, String, desc: 'String optional argument'
      end

      get do
        { foo: :bar }.merge(decoded_params)
      end
    end
  end
end
