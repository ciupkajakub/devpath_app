class Purchase < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :purchase_products
#
  aasm do
    state :pending, initial: true
    state :bought

    event :buy do
      transitions from: :pending, to: :bought
    end
  end
end
