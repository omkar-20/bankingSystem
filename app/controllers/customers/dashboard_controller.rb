module Customers
  class DashboardController < ApplicationController
    before_action :authorize_dashboard_access!

    def show
      account = current_user.account

      if account
        transactions = account.transactions
                              .order(created_at: :desc)
                              .paginate(page: params[:page], per_page: params[:per_page] || 10)
        render json: {
          account_number: account.account_number,
          balance: account.balance,
          status: account.status,
          transactions: transactions.as_json(only: [:transaction_type, :amount, :status, :created_at]),
          meta: {
            current_page: transactions.current_page,
            total_pages: transactions.total_pages,
            total_entries: transactions.total_entries
          }
        }
      else
        render json: { error: I18n.t('error.account_not_found')}, status: :not_found
      end
    end

    private

    def authorize_dashboard_access!
      authorize! :read, Account, user_id: current_user.id
    end
  end
end