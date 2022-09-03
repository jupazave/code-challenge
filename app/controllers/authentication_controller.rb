# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request!

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session = Session.create(user_id: user.id, session_id: SecureRandom.uuid)
      render json: { session_id: session.session_id }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
