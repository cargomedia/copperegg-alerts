require 'webmock'
require 'vcr'

module Copperegg
  module Alerts
    module Test
      API_KEY = 'foo'
    end
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

WebMock.enable!
