# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_bot_status

  def set_bot_status
    @bot_status = last_status.status_code
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username
                                                         email
                                                         password
                                                         password_confirmation
                                                         remember_me
                                                         sign_up_code])
  end

  def last_status
    use_last_status? ? Status.last : Status.default_record
  end

  def use_last_status?
    Status.count.positive? &&
      time_difference_in_minutes < 20.minutes # Use a small buffer of 5 minutes in case upload is pending
  end

  def time_difference_in_minutes
    (DateTime.current.to_i - Status.last.post_time.to_i) / 1.minute
  end
end
