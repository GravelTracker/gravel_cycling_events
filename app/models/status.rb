class Status
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  def self.build_status(stats_list)
    result = Array.new(192, default_record)
    return result if stats_list.empty?

    stats_list.each_with_index do |status, i|
      if currently_offline?(status)
        result << result.last
        next
      end

      if offline?(result.last) && interval(result.last, status) > 1
        result << result.last
      else
        result << status
      end
    end
    result.reverse[0..191]
  end

  def self.seed_db
    192.times do |i|
      Status.create({
        post_time: DateTime.current + (i * 15).minutes,
        status_code: %w[offline error success].sample,
      })
    end
  end

  def self.flush_status_db
    Status.destroy_all
  end

  private

  def self.interval(start_entry, end_entry)
    time_delta = end_entry['post_time'].to_i - start_entry['post_time'].to_i
    time_delta / 15.minutes
  end

  def self.offline?(item)
    return if item.nil?

    item['status_code'] == 'error' || item['status_code'] == 'offline'
  end

  def self.currently_offline?(item)
    time_delta = DateTime.current.to_i - item['post_time'].to_i
    time_delta > 15.minutes
  end

  def self.default_record
    { 
      'status_code' => 'offline',
      'post_time' => DateTime.current
    }
  end
end
