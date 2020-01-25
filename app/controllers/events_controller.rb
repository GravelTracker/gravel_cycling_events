# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = Event.where(:start_time.gte => DateTime.current)
  end
end
