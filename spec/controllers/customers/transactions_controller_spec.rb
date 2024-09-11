require 'rails_helper'

RSpec.describe Customers::TransactionsController, type: :controller do
  let(:customer) { create(:user, :customer) }
  let!(:account) { create(:account, user: customer) }

  before do
    sign_in customer
  end

  describe 'GET #index' do
    let!(:transaction) { create(:transaction, account: account) }
    it 'returns a list of transaction' do 
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to be >= 1
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { transaction: { transaction_type: 'deposit', amount: 100.0 } } }

    it 'creates a new transaction' do 
      expect { post :create, params: valid_attributes }.to change(Transaction, :count).by(1)
      expect(response).to have_http_status(:ok)

      transaction = Transaction.last
      expect(transaction.transaction_type).to eq('deposit')
      expect(transaction.amount).to eq(100.0)
      expect(transaction.account).to eq(account)
    end
    
    it 'returns error if transaction type is missing' do
      post :create, params: { transaction: { amount: 100.0} }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq(I18n.t('error.transaction_params_not_present'))
    end

    it 'returns error if amount type is missing' do
      post :create, params: { transaction: { transaction_type: 'deposit'} }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq(I18n.t('error.transaction_params_not_present'))
    end
  end
end