FactoryBot.define do
  factory :transaction do
    account
    transaction_type {'deposit' }
    amount { 100.0 }
    status { 'completed' }
  end
end