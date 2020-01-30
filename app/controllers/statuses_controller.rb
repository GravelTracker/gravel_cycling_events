# frozen_string_literal: true

class StatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :validate_jwt, only: :create

  def index
    @status_list = build_status
    @uptime = calculate_uptime
    @last_status_code = @status_list.first['status_code']
    @status_message = status_message
    @status_color = status_color
  end

  def create
    @status = Status.create!(build_status_record)
    notify_admin if @status['status_code'] != 'success'

    render json: { success: 'Status posted.' },
           status: :ok
  rescue Mongoid::Errors::Validations
    render json: { error: 'Status not posted.' },
           status: :unprocessable_entity
  end

  private

  def build_status
    Status.build_status(Status.all)
  end

  def calculate_uptime
    up_status_count = @status_list.select { |x| x['status_code'] == 'success' }.count.to_f
    uptime = up_status_count / @status_list.size * 100.0
    format('%.2f', uptime)
  end

  def status_message
    return 'All Systems Operational' if @last_status_code == 'success'
    return 'Offline' if @last_status_code == 'offline'

    'Down -- Administrator has been notified'
  end

  def status_color
    return @last_status_code if @last_status_code == 'success'
    return 'danger' if @last_status_code == 'error'

    'secondary'
  end

  def validate_jwt
    token = JSON.parse(request.body.read)['token']
    password = Rails.application.credentials.secret_key_base
    bot_auth = Rails.application.credentials.bot_auth
    return if JWT.decode(token, password).first == bot_auth

    render(json: { error: 'Not authorized.' }, status: :forbidden) && return
  rescue JWT::DecodeError
    render(json: { error: 'Invalid auth token.' }, status: :bad_request) && return
  end

  def build_status_record
    {
      post_time: params[:post_time].to_datetime,
      status_code: params[:status_code]
    }
  end

  def notify_admin
    # TODO: Implement!
  end
end
