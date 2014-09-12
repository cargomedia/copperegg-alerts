require 'spec_helper'
require 'copperegg'

describe Copperegg::Client do

  before :each do
    @client = Copperegg::Client.instance.auth_setup(Copperegg::Test::API_KEY)
  end

  describe 'Client' do

    it 'should be an instance of Copperegg::Client' do
      expect(@client) === Copperegg::Client
    end

    it 'should have set the base_uri' do
      expect(@api_base_uri) == 'https://api.copperegg.com/v2'
    end

    it 'should have set the auth hash' do
      expect(@auth) == {:basic_auth => {:username => Copperegg::Test::API_KEY, :password => 'U'}}
    end

  end

end
