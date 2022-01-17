FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category#{n}" }
    description { 'description' }
  end
end
