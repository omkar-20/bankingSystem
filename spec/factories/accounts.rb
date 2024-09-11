FactoryBot.define do
  factory :account do
    user
    account_number { SecureRandom.hex(10).upcase }
    balance { 0.0 }
    status { 'active' }
  end
end