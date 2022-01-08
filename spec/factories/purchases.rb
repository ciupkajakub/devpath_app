FactoryBot.define do
  factory :purchase do
    aasm_state { 'pending' }
  end
end
