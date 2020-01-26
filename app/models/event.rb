# frozen_string_literal: true

class Event
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :title
  field :description
  field :location
  field :url
  field :image_url
  field :date
  field :time_zone
  field :start_time
  
  def parsed_name
    self['summary'].split(' – ').first
  end

  def parsed_location
    self['summary'].split(' – ').second
  end

  def parsed_start_date
    parsed_start_time.strftime('%B %d, %Y')
  end

  def parsed_start_month
    parsed_start_time.month
  end

  def parsed_start_month_string
    parsed_start_time.strftime('%B')
  end

  def parsed_start_year
    parsed_start_time.year
  end

  def parsed_start_hour
    parsed_start_time.strftime('%l:%M%p')
  end

  def parsed_time_zone
    self['time_zone'].gsub('_', ' ')
  end

  def parsed_description
    self['description']
  end

  def parsed_contact
    self['contact']
  end

  def parsed_image_url
    self['thumbnail_url']
  end

  def parsed_url
    self['url']
  end

  private

  def parsed_start_time
    self['start_time'].to_datetime
  end
end
