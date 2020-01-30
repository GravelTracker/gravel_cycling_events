# frozen_string_literal: true

class Status
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  class << self
    def build_status(stats_list)
      result = Array.new(192, default_record)
      return result if stats_list.count.zero?

      stats_list.each_with_index do |status, _i|
        if currently_offline?(status)
          result << result.last
          next
        end

        result << if interval(result.last, status) > 1
                    default_record
                  else
                    status
                  end
      end
      result = pad_offline(result)
      result.reverse[0..191]
    end

    def seed_db
      192.times do |i|
        Status.create(
          post_time: DateTime.current + (i * 15).minutes,
          status_code: %w[offline error success].sample
        )
      end
    end

    def flush_status_db
      Status.destroy_all
    end

    def default_record(post_time = DateTime.current)
      {
        'status_code' => 'offline',
        'post_time' => post_time
      }
    end

    private

    def interval(start_entry, end_entry)
      time_delta = end_entry['post_time'].to_i - start_entry['post_time'].to_i
      time_delta / 15.minutes
    end

    def offline?(item)
      return if item.nil?

      item['status_code'] == 'error' || item['status_code'] == 'offline'
    end

    def currently_offline?(item)
      time_delta = DateTime.current.to_i - item['post_time'].to_i
      time_delta > 15.minutes
    end

    def pad_offline(result)
      while interval(result.last, 'post_time' => DateTime.current) > 1
        result << default_record(result['post_time'] + 15.minutes)
      end
      result
    end
  end
end
