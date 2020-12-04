# frozen_string_literal: true

class Status
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  class << self
    def default_record
      OpenStruct.new(status_code: 'offline',
                     post_time: DateTime.current,
                     default: true)
    end
  end
end
