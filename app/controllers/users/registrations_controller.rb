# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up Successfully' },
        data: resource
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "User couldn't be created successfully, #{resource.errors.full_messages.to_sentence}"},
        data: resource.errors
      }, status: :unprocessable_entity
    end
  end
end
