require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:account) { Account.new(user: user, account_number: '1234567890', balance: 1000.0) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(account).to be_valid
    end

    it 'is not valid without an account_number' do
      account.account_number = nil
      expect(account).not_to be_valid
      expect(account.errors[:account_number]).to include(I18n.t('model_test_error.cannot_blank'))
    end

    it 'is not valid without a unique account_number' do
      Account.create(user: user, account_number: '1234567890', balance: 500.0)
      expect(account).not_to be_valid
      expect(account.errors[:account_number]).to include(I18n.t('model_test_error.value_taken'))
    end

    it 'is not valid with a negative balance' do
      account.balance = -100.0
      expect(account).not_to be_valid
      expect(account.errors[:balance]).to include(I18n.t('model_test_error.balance_check'))
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:destroy) }
  end
end
