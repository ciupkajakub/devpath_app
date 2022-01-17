require 'rails_helper'

RSpec.describe Admins::Statistics do
  context '#result' do
    it 'returns a hash with total counts' do
      user_1 = create(:user)
      user_2 = create(:user)
      category_1 = create(:category)
      category_2 = create(:category)
      product_1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category_1.id])
      product_2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category_1.id])
      product_3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category_2.id])
      purchase_1 = create(:purchase, aasm_state: 'bought', user_id: user_1.id)
      purchase_2 = create(:purchase, aasm_state: 'bought', user_id: user_2.id)

      create(:purchase_product, purchase_id: purchase_1.id,
                                product_id: product_1.id, product_amount: 1)
      create(:purchase_product, purchase_id: purchase_1.id,
                                product_id: product_2.id, product_amount: 1)
      create(:purchase_product, purchase_id: purchase_2.id,
                                product_id: product_2.id, product_amount: 2)
      create(:purchase_product, purchase_id: purchase_2.id,
                                product_id: product_3.id, product_amount: 2)
      create(:purchase_product, purchase_id: purchase_2.id,
                                product_id: product_1.id, product_amount: 3)

      expect(Admins::Statistics.result).to match(
        {
          total_users: 2,
          total_categories: 2,
          total_products: 3,
          total_purchases: 2,
          bestseller: 'banana',
          sold_products_amount: 9
        }
      )
    end
  end
end
