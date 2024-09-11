require 'rails_helper'

RSpec.describe Admin::TransactionsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let!(:account) { create(:account) }
  let!(:transaction) { create(:transaction, account: account) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns a list of transactions' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to be >= 1
    end
  end
end