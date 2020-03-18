# frozen_string_literal: true

module Vdb
  module Logger
    def logger
      Logger.instance.logger
    end

    class Logger
      include Singleton

      def logger
        @logger ||= initialize_logger
      end

      private

      def initialize_logger
        path = File.join(APPLICATION_PATH, 'log', "application_#{current_env}.log")

        logger = ::Logger.new(path)
        logger.level = ::Logger::INFO

        logger
      end

      def current_env
        ENV.fetch('RACK_ENV', 'development')
      end
    end
  end
end
