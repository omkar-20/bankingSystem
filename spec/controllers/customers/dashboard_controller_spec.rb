require 'rails_helper'

RSpec.describe Customers::DashboardController, type: :controller do
  let(:customer) { create(:user, :customer) }
  let!(:account) { create(:account, user: customer) }

  before do
    sign_in customer
  end

  describe 'GET #show' do
    it 'returns account details and transactions' do
      get :show
      expect(response).to have_http_status(:success)
      json_response =  JSON.parse(response.body)
      expect(json_response['account_number']).to eq(account.account_number)
    end
  end
end