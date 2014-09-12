require 'spec_helper'
require 'copperegg'
require 'pp'

describe Copperegg::Alerts do

  before :each do

    @client = Copperegg::Client.instance.auth_setup(Copperegg::Test::API_KEY)
    canned_response = File.new 'spec/fixtures/schedules.json.response'
    BASE_URI = 'https://foo:U@api.copperegg.com/v2'
    @get = stub_request(:get, BASE_URI + '/alerts/schedules.json').
        to_return(canned_response)

    @create = stub_request(:post, BASE_URI + '/alerts/schedules.json').
        with(:body => "{\"state\":\"disabled\",\"duration\":7,\"start_time\":\"2014-09-12t21:47:38z\",\"match\":{\"tag\":\"foo\"}}",
             :headers => {'Content-Type' => 'application/json'}).
        to_return(:status => 200, :body => "", :headers => {})

    @destroy = []
    [1275, 1276, 1277].each do |stub|
      @destroy << stub_request(:delete, BASE_URI + "/alerts/schedules/#{stub}.json").
          to_return(:status => 200, :body => "", :headers => {})
    end

    @modify = stub_request(:put, BASE_URI + "/alerts/schedules.json").
        to_return(:status => 200, :body => "", :headers => {})

    @alerts = Copperegg::Alerts.new


  end

  describe '#new' do
    it 'should request a list of all schedules' do
      expect(@alerts.schedules) === Hash
      @get.should have_been_requested
    end
  end

  describe 'reset_schedules("test")' do
    it 'should remove all schedules with name "test" from the list if any' do
      @alerts.reset_schedules('test')
      @destroy.each { |i| i.should have_been_requested }
    end
  end

  describe 'create schedule' do
    it 'should create a new schedule' do
      @alerts.create_schedule('spec_test', 'match' => {'tag' => 'foo'}, 'state' => 'disabled', 'duration' => 7)
      @create.should have_been_requested
    end
  end

  describe 'modify schedule' do
    it 'should activate a given schedule' do

    end
  end

end
