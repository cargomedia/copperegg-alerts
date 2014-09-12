require 'copperegg'
require 'webmock/rspec'
require 'webmock'

module Copperegg
  module Test
    API_KEY = 'foo'
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
WebMock.enable!
