RSpec.describe Admins::BestsellerQuery do
  context '#resolve' do
    it 'finds the bestseller' do
      user_1 = create(:user)
      user_2 = create(:user)
      category = create(:category)
      product_1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category.id])
      product_2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category.id])
      product_3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category.id])
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

      expect(Admins::BestsellerQuery.new.resolve).to eq(product_1)
    end
    it 'finds total amount of sold products' do
      user_1 = create(:user)
      user_2 = create(:user)
      category = create(:category)
      product_1 = create(:product, name: 'banana', stock_amount: 10, category_ids: [category.id])
      product_2 = create(:product, name: 'apple', stock_amount: 12, category_ids: [category.id])
      product_3 = create(:product, name: 'apple', stock_amount: 22, category_ids: [category.id])
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

      expect(Admins::BestsellerQuery.new.sold_products_count).to eq(9)
    end
  end
end
