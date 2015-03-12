require 'spec_helper'
require 'copperegg/alerts'

describe Copperegg::Alerts::Client do

  before :each do
    @client = Copperegg::Alerts::Client.instance.auth_setup(Copperegg::Alerts::Test::API_KEY)
  end

  describe 'Client' do

    it 'is an instance of Copperegg::Alerts::Client' do
      expect(@client) === Copperegg::Alerts::Client
    end

    it 'has set the base_uri' do
      expect(@api_base_uri) == 'https://api.copperegg.com/v2'
    end

    it 'has set the auth hash' do
      expect(@auth) == {:basic_auth => {:username => Copperegg::Alerts::Test::API_KEY, :password => 'U'}}
    end

    %w(get delete).each do |verb|
      it "fails on wrong #{verb}" do
        VCR.use_cassette('4xx', :record => :once, :match_requests_on => [:path], :allow_playback_repeats => true) do
          expect { @client.send(verb + '?', 'veryWrong') }.to raise_error(RuntimeError, /HTTP.*failed/)
        end
      end
    end

    %w(post put).each do |verb|
      it "fails on wrong #{verb}" do
        VCR.use_cassette('4xx', :record => :once, :match_requests_on => [:path], :allow_playback_repeats => true) do
          expect { @client.send(verb + '?', 'veryWrong', {}) }.to raise_error(RuntimeError, /HTTP.*failed/)
        end
      end
    end
  end
end
