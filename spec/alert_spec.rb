require 'spec_helper'
require 'copperegg'
require 'webmock/rspec'
require 'pp'

BASE_URI = 'https://foo:U@api.copperegg.com/v2'

describe Copperegg::Alerts do


  before :each do

    @client = Copperegg::Client.instance.auth_setup(Copperegg::Test::API_KEY)

    @create = stub_request(:post, BASE_URI + '/alerts/schedules.json').
        to_return(:status => 200, :body => "", :headers => {})

    uri_template = Addressable::Template.new BASE_URI + "/alerts/schedules/{id}.json"
    @destroy = stub_request(:delete, uri_template).
        to_return(:status => 200, :body => "", :headers => {})
    #
    # @modify = stub_request(:put, BASE_URI + "/alerts/schedules.json").
    #     to_return(:status => 200, :body => "", :headers => {})

    VCR.use_cassette('schedules', :record => :once, :match_requests_on => [:method, :path]) do
      @alerts = Copperegg::Alerts.new
    end

  end

  describe '#new' do
    it 'requests a list of all schedules' do
      expect(@alerts.schedules.size > 0).to be(true)
    end
  end

  describe 'create schedule' do
    it 'creates three new schedules with name "spec_test"' do
      alerts_schedules_list_size_before = @alerts.schedules.size
      VCR.use_cassette('schedule_create', :record => :once, :match_requests_on => [:body_as_json], :allow_playback_repeats => true) do
        3.times { @alerts.create_schedule('spec_test', 'match' => {'tag' => ['foo']}, 'state' => 'disabled', 'duration' => 7, 'start_time' => '2014-09-14T10:21:40Z') }
      end
      expect(@alerts.schedules.size - alerts_schedules_list_size_before).to eq(3)
    end
  end

  describe 'reset_schedules("spec_test")' do
    it 'removes all schedules with name "spec_test" from the list if any' do
      alerts_schedules_list_size_before = @alerts.schedules.size
      VCR.use_cassette('schedule_reset', :record => :once, :match_requests_on => [:method, :path]) do
        @alerts.reset_schedules('spec_test')
      end
      expect(alerts_schedules_list_size_before - @alerts.schedules.size).to eq(3)
    end
  end

  describe 'modify schedule' do
    it 'modifies a schedule with name "spec_test"' do

    end
  end

end
