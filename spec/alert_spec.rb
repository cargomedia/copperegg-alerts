require 'spec_helper'
require 'copperegg'
require 'webmock/rspec'
require 'pp'
require 'hashdiff'

describe Copperegg::Alerts do


  before :each do

    Copperegg::Client.instance.auth_setup(Copperegg::Test::API_KEY)
    VCR.use_cassette('schedules', :record => :once, :match_requests_on => [:method, :path]) do
      @alerts = Copperegg::Alerts.new
    end

  end

  describe '#new' do
    it 'requests a list of all schedules' do
      expect(@alerts.schedules.size > 0).to be(true)
      expect(WebMock).to have_requested(:get, /\/alerts\/schedules\.json$/).once
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
    before :each do
      VCR.use_cassette('schedule_create', :record => :once, :match_requests_on => [:body_as_json], :allow_playback_repeats => true) do
        3.times { @alerts.create_schedule('spec_test', 'match' => {'tag' => ['foo']}, 'state' => 'disabled', 'duration' => 7, 'start_time' => '2014-09-14T10:21:40Z') }
      end
      expect(WebMock).to have_requested(:post, /\/alerts\/schedules\.json$/).times(3)
    end

    it 'removes all schedules with name "spec_test" from the list if any' do
      alerts_schedules_list_size_before = @alerts.schedules.size
      VCR.use_cassette('schedule_reset', :record => :once, :match_requests_on => [:method, :path]) do
        @alerts.delete_schedules('spec_test')
      end
      expect(alerts_schedules_list_size_before - @alerts.schedules.size).to eq(3)
      expect(WebMock).to have_requested(:delete, /.*alerts\/schedules\/\d+\.json$/).times(3)
    end

    it 'deletes schedules from the instance list variable only if api call was successful' do
      alerts_schedules_list_size_before = @alerts.schedules.size
      VCR.use_cassette('schedule_reset_with_error', :record => :once, :match_requests_on => [:method, :path]) do
        @alerts.delete_schedules('spec_test')
      end
      expect(alerts_schedules_list_size_before - @alerts.schedules.size).to eq(2)
      expect(WebMock).to have_requested(:delete, /.*alerts\/schedules\/\d+\.json$/).times(3)
    end
  end


  describe 'modify schedule' do
    before :each do
      VCR.use_cassette('schedule_create', :record => :once, :match_requests_on => [:body_as_json], :allow_playback_repeats => true) do
        @alerts.create_schedule('spec_test', 'match' => {'tag' => ['foo']}, 'state' => 'disabled', 'duration' => 7, 'start_time' => '2014-09-14T10:21:40Z')
      end
      expect(WebMock).to have_requested(:post, /\/alerts\/schedules\.json$/).once
    end

    it 'modifies a schedule with name "spec_test"' do
      schedule_name='spec_test'
      alert_schedule_before = @alerts.schedules.select { |schedule| schedule['name'] == schedule_name }
      VCR.use_cassette('schedule_modify', :record => :once, :match_requests_on => [:body_as_json], :allow_playback_repeats => true) do
        @alerts.modify_schedule(schedule_name, {'duration' => 33, 'state' => 'enabled'})
      end
      alert_schedule_after = @alerts.schedules.select { |schedule| schedule['name'] == schedule_name }
      diff = HashDiff.diff(alert_schedule_before.first, alert_schedule_after.first)
      expect(diff).to eq([['~', 'duration', 7, 33], ['~', 'state', 'disabled', 'enabled' ]])
      expect(WebMock).to have_requested(:put, /.*alerts\/schedules\/\d+\.json$/).once
    end
  end

end
