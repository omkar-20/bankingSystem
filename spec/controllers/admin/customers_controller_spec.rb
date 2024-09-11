require 'rails_helper'

RSpec.describe Admin::CustomersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let!(:customer) { create(:user, :customer) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns a list of customers' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to be >= 1
    end

    it 'searches customers by email' do
      get :index, params: { query: customer.email, page: 1, per_page: 10  }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes)  { { user: { email: 'newcustomer@example.com', password: 'password123', password_confirmation: 'password123' } } }

    it 'creates a new customer' do
      expect { post :create, params: valid_attributes }. to change(User.customer, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns error if email is missing' do
      post :create, params: { user: { password: 'password123', password_confirmation: 'password123' } }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq(I18n.t('error.email_password_not_present'))
    end

  end

  describe 'DELETE #destroy' do
    it 'deletes a customer' do
      customer = create(:user, :customer)
      expect { delete :destroy, params: { id: customer.id } }. to change(User.customer, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end