RSpec.describe Admins::BestsellerQuery do
  context '#resolve' do
    it 'finds the bestseller' do
      user1 = create(:user)
      user2 = create(:user)
      category = create(:category)
      product1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category.id])
      product2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category.id])
      product3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category.id])
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

      expect(Admins::BestsellerQuery.new.resolve).to eq(product1)
    end
    it 'finds total amount of sold products' do
      user1 = create(:user)
      user2 = create(:user)
      category = create(:category)
      product1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category.id])
      product2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category.id])
      product3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category.id])
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

      expect(Admins::BestsellerQuery.new.sold_products_count).to eq(9)
    end
  end
end

