# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_bot_status

  def set_bot_status
    last_status = Status.last
    time_delta = DateTime.current.to_i - last_status['post_time'].to_i
    @bot_status_color = if time_delta > 15.minutes
                          'offline'
                        else
                          last_status['status_code'] == 'success' ? 'success' : 'danger'
                        end
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
end
