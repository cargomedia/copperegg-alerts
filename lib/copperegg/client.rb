require 'singleton'
require 'httparty'
require 'deep_merge'

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

    JSON = {'content-type' => 'application/json'}

    def method_missing(method, resource, *args)
      if method.to_s =~ /\?$/
        method = method.to_s.sub!(/\?$/, '')
        result = self.send(method.to_sym, resource, *args)
        return result if result.code == 200
      end
    end

    ['get', 'post', 'put', 'delete'].each do |method|
      define_method(method) do |resource, *args|
        unless args.nil?
          body = {}
          args.each { |arg| body.deep_merge!(arg) }
          @auth.merge!({:headers => JSON}.merge!({:body => body.to_json}))
        end
        response = HTTParty.send(method.to_sym, @api_base_uri + resource, @auth.to_hash)
        if response.code != 200
          raise("HTTP/#{method} Request failed. Response code `#{response.code}`, message `#{response.message}`, body `#{response.body}`")
        end
        response
      end
    end

  end
end

