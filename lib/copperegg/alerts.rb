module Copperegg
  class Alerts
    attr_reader :schedules

    def initialize
      @client = Copperegg::Client.instance
      @schedules = @client.get('alerts/schedules.json')
    end

    def set_schedule(name, tags = {})
      reset_schedules(name)
      result = create_schedule(name, tags)
      if result.code == 200
        @schedules << result.parsed_response
      else
        warn("No alert schedule set (HTTP response code: #{result.code})")
      end
    end

    def modify_schedule(name, *args)
      body = {:body => {}}
      args.each { |arg| body[:body].merge!(arg) }
      @schedules.select { |h| h['name'] == name }.each do |schedule|
        @client.put('alerts/schedules/' + schedule['id'] + '.json', body)
      end
    end

    def create_schedule(name, *args)
      body = {
        'state' => 'enabled',
        'duration' => 10,
        'start_time' => Time.now.gmtime.strftime('%Y-%m-%dt%H:%M:%Sz'),
      }
      args.each { |arg| body.merge!(arg) }
      @client.post('alerts/schedules.json', body)
    end

    def reset_schedules(name)
      selected_schedules = @schedules.select! { |h| h['name'] == name }
      selected_schedules.each { |s| @client.delete("alerts/schedules/#{s['id']}.json") } if selected_schedules
    end
  end
end
