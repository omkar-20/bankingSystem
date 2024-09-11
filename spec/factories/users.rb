FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "testabc#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :admin do
      role { :admin } 
    end

    trait :customer do
      role { :customer }
    end
  end
end