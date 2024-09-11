require 'rails_helper'

RSpec.describe Customers::ProfilesController, type: :controller do
  let(:customer) { create(:user, :customer) }

  before do
    sign_in customer
  end

  describe 'PATCH #update' do
    let(:valid_attributes) { { user: { first_name: 'Test', last_name: 'Singh', address: '123 Pune', mobile_number: '9234586862' } } }

    it 'updates the user profile' do
      patch :update, params: valid_attributes
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq(I18n.t('success.profile_update_message'))

      customer.reload
      expect(customer.first_name).to eq('Test')
      expect(customer.last_name).to eq('Singh')
      expect(customer.address).to eq('123 Pune')
      expect(customer.mobile_number).to eq('9234586862')
    end
  end
end