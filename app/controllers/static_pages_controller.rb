# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def index
    @events = Event.where(:start_time.gte => DateTime.current).count
  end
end
