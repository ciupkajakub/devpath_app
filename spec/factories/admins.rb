FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@admin.com" }
    password { 123_456 }
    password_confirmation { 123_456 }
  end
end
