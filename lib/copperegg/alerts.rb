require 'deep_merge'

module Copperegg
  class Alerts
    attr_reader :schedules

    def initialize
      @client = Copperegg::Client.instance
      @schedules = @client.get('alerts/schedules.json')
    end

    def set_schedule(name, tags = {})
      delete_schedules(name)
      create_schedule(name, tags)
    end

    def modify_schedule(name, *args)
      body = {}
      args.each { |arg| body.deep_merge!(arg) }
      selected_schedules = @schedules.select { |h| h['name'] == name }
      if selected_schedules
        @schedules -= selected_schedules
        selected_schedules.each do |s|
          result = @client.put?("alerts/schedules/#{s['id']}.json", body)
          if result == nil
            @schedules << s
          else
            @schedules << result
          end
        end
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
      end
    end

    def delete_schedules(name)
      selected_schedules = @schedules.select { |h| h['name'] == name }
      if selected_schedules
        @schedules -= selected_schedules
        selected_schedules.each do |s|
          if @client.delete?("alerts/schedules/#{s['id']}.json") == nil
            @schedules << s
          end
        end
      end
    end
  end
end
