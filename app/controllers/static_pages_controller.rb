# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def index
    @events = Event.where(:start_time.gte => DateTime.current.to_date.to_datetime)
  end
end
