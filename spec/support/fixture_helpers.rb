# frozen_string_literal: true

module FixtureHelpers
  def load_fixture_to(name)
    path = File.join(SPEC_PATH, 'fixtures', "#{name}.json")

    File.read(path)
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end
