require 'rails_helper'

RSpec.describe Admins::Statistics do
  context '#result' do
    it 'returns a hash with total counts' do
      user1 = create(:user)
      user2 = create(:user)
      category1 = create(:category)
      category2 = create(:category)
      product1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category1.id])
      product2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category1.id])
      product3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category2.id])
      purchase1 = create(:purchase, aasm_state: 'bought', user_id: user1.id)
      purchase2 = create(:purchase, aasm_state: 'bought', user_id: user2.id)

      purchase_product1 = create(:purchase_product, purchase_id: purchase1.id,
                                 product_id: product1.id, product_amount: 1)
      purchase_product2 = create(:purchase_product, purchase_id: purchase1.id,
                                 product_id: product2.id, product_amount: 1)
      purchase_product3 = create(:purchase_product, purchase_id: purchase2.id,
                                 product_id: product2.id, product_amount: 2)
      purchase_product4 = create(:purchase_product, purchase_id: purchase2.id,
                                 product_id: product3.id, product_amount: 2)
      purchase_product5 = create(:purchase_product, purchase_id: purchase2.id,
                                 product_id: product1.id, product_amount: 3)

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
