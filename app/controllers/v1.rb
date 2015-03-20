module Vdb
  class V1 < Grape::API
    version 'v1', using: :accept_version_header

    before do
      check_session
    end

    namespace :foo do
      get '/' do
        { namespace: :foo }
      end

      namespace :bar do
        get '/' do
          { namespace: :foo_bar }
        end
      end
    end
  end
end
