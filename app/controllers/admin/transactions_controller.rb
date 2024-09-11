module Admin
  class TransactionsController < ApplicationController
    before_action :authorize_admin!

    def index
      if params[:account_number].present?
        transactions = Transaction.joins(:account)
                                  .where(accounts: { account_number: params[:account_number] })
                                  .order(created_at: :desc)
                                  .paginate(page: params[:page], per_page: params[:per_page] || 10)
      else
        transactions = Transaction.includes(account: :user)
                                  .order(created_at: :desc)
                                  .paginate(page: params[:page], per_page: params[:per_page] || 10)
      end
      render json:{
        transactions: transactions.as_json(include: { account: { include: { user: { only: [:email, :role] } } } }),
        meta: {
          current_page: transactions.current_page,
          total_pages: transactions.total_pages,
          total_entries: transactions.total_entries
        }
      } 
    end

    private

    def authorize_admin!
      unless current_user.admin?
        render json: { error: I18n.t('error.access_denied') }, status: :forbidden
      end
    end
  end
end