# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request!

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end

  private

  def authenticate_request!
    return if session.present?

    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  def session
    return @session if @session.present?

    session_id = request.headers['Authorization']&.split(' ')&.last
    @session = Session.find_by(session_id:)
  end

  def current_user
    @current_user ||= session&.user
  end
end
