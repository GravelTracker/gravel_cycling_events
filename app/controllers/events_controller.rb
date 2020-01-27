# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = sorted_events
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(build_record)

    if @event.valid?
      render 'static_pages/upload'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:updated,
                                  :summary,
                                  :start_time,
                                  :time_zone,
                                  :location,
                                  :url,
                                  :thumbnail_url,
                                  :insertion_type,
                                  :active)
  end

  def build_record
    {
      updated: DateTime.current.to_s,
      summary: [params['event'][:title], params['event'][:location]].join(' – '),
      start_time: build_start_time,
      time_zone: params['event'][:time_zone],
      location: params['event'][:location],
      url: params['event'][:url],
      thumbnail_url: params['event'][:image_url],
      insertion_type: 'user',
      active: false
    }
  end

  def build_start_time
    date = params['event'][:date] + 'T' + params['event'][:start_time]
    DateTime.strptime(date, '%Y-%m-%dT%H:%M')
  end

  def sorted_events
    current_month = 0
    events_array = []
    events = Event.where(:start_time.gte => DateTime.current.to_date.to_datetime,
                         active: true)
                  .order(:start_time => 'asc')
    events.each do |event|
      events_array << [] if event.parsed_start_month != current_month
      events_array.last << event
      current_month = event.parsed_start_month
    end
    events_array
  end
end
