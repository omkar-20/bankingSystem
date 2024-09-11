require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:account) { Account.create(user: user, account_number: '1234567890', balance: 1000.0) }
  let(:transaction) { Transaction.new(account: account, transaction_type: 'deposit', amount: 100.0, status: 'completed') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(transaction).to be_valid
    end

    it 'is not valid without an amount' do
      transaction.amount = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include(I18n.t('model_test_error.cannot_blank'))
    end

    it 'is not valid with a non-numeric amount' do
      transaction.amount = 'abc'
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include(I18n.t('model_test_error.not_number'))
    end

    it 'is not valid with a negative amount' do
      transaction.amount = -100
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include(I18n.t('model_test_error.greater_than_0'))
    end

    it 'is not valid without a transaction_type' do
      transaction.transaction_type = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include(I18n.t('model_test_error.cannot_blank'))
    end

    it 'is not valid with an invalid transaction_type' do
      transaction.transaction_type = 'invalid_type'
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include(I18n.t('model_test_error.not_in_list'))
    end

    it 'validates sufficient balance for withdrawal' do
      transaction.transaction_type = 'withdrawal'
      transaction.amount = 2000
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include(I18n.t('model_test_error.not_available_balance'))
    end
  end

  describe 'associations' do
    it { should belong_to(:account) }
  end
end
