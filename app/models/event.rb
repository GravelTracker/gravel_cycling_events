# frozen_string_literal: true

class Event
  include Mongoid::Document

  def name
    self['summary'].split(' – ').first
  end

  def location
    self['summary'].split(' – ').second
  end

  def start_date
    start_time.strftime('%B %d, %Y')
  end

  def start_month
    start_time.month
  end

  def start_month_string
    start_time.strftime('%B')
  end

  def start_year
    start_time.year
  end

  def start_hour
    start_time.strftime('%l:%M%p')
  end

  def time_zone
    self['time_zone'].gsub('_', ' ')
  end

  def description
    self['description']
  end

  def contact
    self['contact']
  end

  def image_url
    self['thumbnail_url']
  end

  def url
    self['url']
  end

  private

  def start_time
    self['start_time'].to_datetime
  end
end
