module Customers
  class ProfilesController < ApplicationController
    before_action :set_user
    before_action :authorize_user!

    def update
      if @user.update(profile_params)
        render json: { message: I18n.t('success.profile_update_message'), user: @user }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = current_user
    end
    
    def authorize_user!
      authorize! :update, @user
    end

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :address, :mobile_number)
    end
  end
end