# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = sorted_events
  end

  private

  def sorted_events
    current_month = 0
    events_array = []
    Event.where(:start_time.gte => DateTime.current.to_date.to_datetime).each do |event|
      events_array << [] if event.start_month != current_month
      events_array.last << event
      current_month = event.start_month
    end
    events_array
  end
end
