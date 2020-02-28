# frozen_string_literal: true

class Status
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  class << self
    def build_status(stats_list)
      result = Array.new(192, default_record)
      return result if stats_list.count.zero?

      result << stats_list.first
      stats_list.each do |status|
        next if status == stats_list.first

        result << if interval(result.last, status) > 1
                    result.last
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

    def flush_db
      Status.destroy_all
    end

    def default_record
      {
        'status_code' => 'offline',
        'post_time' => DateTime.current,
        'default' => true
      }
    end

    def fetch_status
      return parsed_cache if cached_status.present? && cached_status_not_expired?

      status_list = Status.limit(192).map do |status|
        {
          'status_code' => status.status_code,
          'post_time' => status.post_time
        }
      end
      redis.set('status', status_list.to_json)
      status_list
    end

    private

    def cached_status
      redis.get('status')
    end

    def parsed_cache
      JSON.parse(cached_status).map! do |status|
        status['post_time'] = status['post_time'].to_datetime
        status
      end
    end

    def cached_status_not_expired?
      parsed_cache.first['post_time'].to_datetime + 15.minutes < DateTime.current
    end

    def redis
      Redis.new
    end

    def default?(record)
      record['default'].presence == true
    end

    def interval(start_entry, end_entry)
      time_delta = start_entry['post_time'].to_i - end_entry['post_time'].to_i
      time_delta / 15.minutes
    end

    def pad_offline(result)
      while interval({ 'post_time' => DateTime.current }, result.last) > 1
        dummy_record = result.last
        dummy_record['post_time'] += 15.minutes
        result << dummy_record
      end
      result
    end
  end
end
