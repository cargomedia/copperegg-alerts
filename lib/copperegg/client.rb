require 'singleton'
require 'httparty'

module Copperegg
  class Client
    include Singleton

    attr_reader :api_base_uri

    def initialize
      @api_base_uri = 'https://api.copperegg.com/v2/'
    end

    def auth_setup(api_key)
      @auth = {:basic_auth => {:username => api_key, :password => 'U'}}
      return self
    end

    def get(resource)
      HTTParty.get(@api_base_uri + resource, @auth.to_hash)
    end

    JSON = {'content-type' => 'application/json'}

    def post(resource, body)
      HTTParty.post(@api_base_uri + resource, @auth.merge({:headers => JSON}.merge({:body => body.to_json})))
    end

    def put(resource, body)
      HTTParty.put(@api_base_uri + resource, @auth.merge({:headers => JSON}.merge({:body => body.to_json})))
    end

    def delete(resource)
      HTTParty.delete(@api_base_uri + resource, @auth.to_hash)
    end

  end
end

