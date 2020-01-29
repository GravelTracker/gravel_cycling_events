class StatusesController < ApplicationController
  def index
    @status_list = build_status
    @uptime = calculate_uptime
    @last_status_code = @status_list.first['status_code']
    @status_message = status_message
    @status_color = status_color
  end

  private

  def build_status
    Status.build_status(Status.all)
  end

  def calculate_uptime
    uptime = @status_list.select {|x| x['status_code'] == 'success'}.count.to_f / @status_list.size * 100.0
    sprintf("%.2f", uptime)
  end

  def status_message
    return 'All Systems Operational' if @last_status_code == 'success'
    return 'Offline' if @last_status_code == 'offline'

    'Down -- Administrator has been notified'
  end

  def status_color
    return @last_status_code if @last_status_code == 'success'
    return 'danger' if @last_status_code == 'error'

    'secondary' 
  end
end
