# frozen_string_literal: true

class StatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :validate_jwt, only: :create

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
