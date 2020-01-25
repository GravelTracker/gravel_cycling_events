# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = sorted_events
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)

    if @event.valid?
      redirect_to 'static_pages#upload'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title,
                                  :description,
                                  :location,
                                  :url,
                                  :image_url,
                                  :time_zone,
                                  :start_time)
  end

  def sorted_events
    current_month = 0
    events_array = []
    Event.where(:start_time.gte => DateTime.current.to_date.to_datetime).each do |event|
      events_array << [] if event.parsed_start_month != current_month
      events_array.last << event
      current_month = event.parsed_start_month
    end
    events_array
  end
end
