require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(email: 'test@example.com', password: 'password123', first_name: 'John', last_name: 'Doe') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('model_test_error.cannot_blank'))
    end

    it 'is not valid with an invalid email format' do
      user.email = 'invalid_email'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('model_test_error.valid_email_address'))
    end

    it 'is not valid without a unique email' do
      User.create(email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('model_test_error.value_taken'))
    end

    it 'validates mobile number only when updating' do
      user.save
      user.mobile_number = '1234567890'
      expect(user).not_to be_valid
      expect(user.errors[:mobile_number]).to include(I18n.t('model_test_error.valid_mobile_number'))

      user.mobile_number = '9876543210'
      expect(user).to be_valid
    end

  end

  describe 'associations' do
    it { should have_one(:account).dependent(:destroy) }
  end
end
