FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@user.com" }
    first_name { 'John' }
    last_name { 'Doe' }
    password { 123_456 }
    password_confirmation { 123_456 }
  end
end
