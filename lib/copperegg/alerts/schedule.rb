require 'deep_merge'
require 'copperegg/alerts'

module Copperegg
  module Alerts
    class Schedule
      attr_reader :schedules

      def initialize
        @client = Copperegg::Alerts::Client.instance
        @schedules = @client.get('alerts/schedules.json')
      end

      def create(name, tags = {})
        delete(name)
        add(name, tags)
      end

      def update(name, *args)
        body = {}
        args.each { |arg| body.deep_merge!(arg) }
        selected_schedules = @schedules.select { |h| h['name'] == name }
        if selected_schedules
          @schedules -= selected_schedules
          selected_schedules.each do |s|
            result = @client.put?("alerts/schedules/#{s['id']}.json", body)
            @schedules << if result.nil?
                            s
                          else
                            result
                          end
          end
        end
      end

      def add(name, *args)
        defaults = {
          'name' => name,
          'state' => 'enabled',
          'duration' => 10,
          'start_time' => Time.now.gmtime.strftime('%Y-%m-%dt%H:%M:%Sz')
        }
        args.each { |arg| defaults.deep_merge!(arg) }
        result = @client.post?('alerts/schedules.json', defaults)
        @schedules << result.parsed_response if result
      end

      def delete(name)
        selected_schedules = @schedules.select { |h| h['name'] == name }
        if selected_schedules
          @schedules -= selected_schedules
          selected_schedules.each do |s|
            if @client.delete?("alerts/schedules/#{s['id']}.json").nil?
              @schedules << s
            end
          end
        end
      end
    end
  end
end
