module Admin
  class CustomersController < ApplicationController
    before_action  :validate_required_params?, only: [:create]
    load_and_authorize_resource :user, except: [:create], parent: false
    skip_load_resource only: [:create]

    def index
      @customers = if params[:query].present?
                     filter_customers(params[:query])
                   else
                     User.customer.active
                   end

      @customers = @customers.paginate(page: params[:page], per_page: params[:per_page] || 10)
      render json: {
        customers: @customers,
        meta: {
          current_page: @customers.current_page,
          total_pages: @customers.total_pages,
          total_entries: @customers.total_entries
        }
      }
    end

    def create
      customer, account, errors = User.create_customer_with_account(customers_params)
      if customer
        render json: { customer: customer, account: account }, status: :created
      else
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end

    def destroy
      if @user.destroy
        render json: { message: I18n.t('success.customer_deleted')}, status: :ok
      else
        render json: { errors: @user.errors.full_messages}, status: :unprocessable_entity
      end
    end
    
    def update_status
      if @user.update(is_active: !@user.is_active)
        render json: { message: I18n.t('success.customer_status_updated', status: @user.is_active ? 'active' : 'inactive') }, status: :ok
      else 
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def validate_required_params?
      render json: { error: I18n.t('error.email_password_not_present') }, status: :bad_request if params[:user].nil? || params[:user][:email].nil? || params[:user][:password].nil?
    end

    def customers_params
      params.require(:user).permit(:email, :password)
    end

    def authorize_admin!
      render json: { error: I18n.t('error.access_denied') }, status: :forbidden unless current_user.admin?
    end

    def generate_account_number
      SecureRandom.random_number(10**10).to_s.rjust(10, '0')
    end

    def filter_customers(query)
      User.customer.active.where('email LIKE :query OR first_name LIKE :query OR last_name LIKE :query', query: "%#{query}%")
    end
  end
end