
module Customers
  class TransactionsController < ApplicationController
    before_action :load_account
    before_action :validate_transaction, only: [:create]
    load_and_authorize_resource :account
    load_and_authorize_resource :transaction, through: :account

    def create
      if @transaction.save
        render json: { message: I18n.t('success.transaction_created') }, status: :ok
      else 
        render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def index
      transactions = @transactions.order(created_at: :desc)

      if params[:transaction_type].present?
        transactions = transactions.where(transaction_type: params[:transaction_type])
      end

     transactions = transactions.paginate(page: params[:page], per_page: params[:per_page] || 10)
      render json: {
        transactions: transactions.as_json(
                                           only: [:transaction_type, :amount, :status, :created_at], 
                                           include: { 
                                             account:{ 
                                               only: [],
                                               include: {
                                                 user: {
                                                   only: [:id] 
                                                } 
                                              }
                                            } 
                                          }
                                        ),
        meta: {
          current_page: transactions.current_page,
          total_pages: transactions.total_pages,
          total_entries: transactions.total_entries
        }
      }
    end

    private

    def transaction_params
      params.require(:transaction).permit(:transaction_type, :amount)
    end

    def validate_transaction
      render json: { error:  I18n.t('error.transaction_params_not_present') } , status: :bad_request  if params[:transaction].nil? || params[:transaction][:transaction_type].nil? || params[:transaction][:amount].nil?
    end

    def load_account
      @account = current_user.account

      if @account.nil?
        render json: { error: I18n.t('error.account_not_found') }, status: :not_found
      end
    end
  end
end
