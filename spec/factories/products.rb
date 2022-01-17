FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product#{n}" }
    description { 'description' }
    stock_amount { 12 }
  end
end
