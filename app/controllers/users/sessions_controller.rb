# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts={})
    render json: {
      status: { code: 200, message: 'Logged in Successfully' },
      data: resource
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 401,
        message: 'not find an active session' 
      }, status: :unauthorized
    else
      render json: {
        status: 200,
        message: 'Logged out successfully' 
      }, status: :ok
    end
  end
end
