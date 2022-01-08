FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@user.com" }
    first_name { 'John' }
    last_name { 'Doe' }
    password { 123456 }
    password_confirmation { 123456 }
  end
end
