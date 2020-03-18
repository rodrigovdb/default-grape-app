# frozen_string_literal: true

module LoggerHelpers
  def stub_logger
    logger = logger_spy
    instance = double
    allow(instance).to receive(:logger).and_return(logger)
    allow(Vdb::Logger::Logger).to receive(:instance).and_return(instance)

    logger
  end

  private

  def logger_spy
    logger = spy(Vdb::Logger::Logger)

    %i[debug info warn error fatal].each do |message|
      allow(logger).to receive(message)
    end

    logger
  end
end

RSpec.configure do |config|
  config.include LoggerHelpers
end
