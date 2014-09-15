require 'deep_merge'

module Copperegg
  class Alerts
    attr_reader :schedules

    def initialize
      @client = Copperegg::Client.instance
      @schedules = @client.get('alerts/schedules.json')
    end

    def set_schedule(name, tags = {})
      reset_schedules(name)
      create_schedule(name, tags)
    end

    def modify_schedule(name, *args)
      @schedules.select { |h| h['name'] == name }.each do |schedule|
        @client.put('alerts/schedules/' + schedule['id'] + '.json', body)
      end
    end

    def create_schedule(name, *args)
      defaults = {
          'name' => name,
          'state' => 'enabled',
          'duration' => 10,
          'start_time' => Time.now.gmtime.strftime('%Y-%m-%dt%H:%M:%Sz'),
      }
      args.each { |arg| defaults.deep_merge!(arg) }
      if result = @client.post?('alerts/schedules.json', defaults)
        @schedules << result.parsed_response
      else
        warn("No alert schedule created (HTTP response code: #{result.code})")
      end
    end

    def reset_schedules(name)
      selected_schedules = @schedules.reject! { |h| h['name'] == name }
      selected_schedules.each { |s|
        if not @client.delete?("alerts/schedules/#{s['id']}.json")
          @schedules << s
        end
      } if selected_schedules
    end
  end
end
