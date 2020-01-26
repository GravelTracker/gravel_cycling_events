class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @events = sorted_events
  end

  private

  def sorted_events
    current_month = 0
    events_array = []
    events = Event.where(active: false)
    events.each do |event|
      events_array << [] if event.parsed_start_month != current_month
      events_array.last << event
      current_month = event.parsed_start_month
    end
    events_array
  end
end