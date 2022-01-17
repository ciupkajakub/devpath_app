require 'rails_helper'

RSpec.describe BuyPurchaseProducts do
  context '.call' do
    it 'updates purchase`s aasm_state from pending to bought' do
      user = create(:user)
      # sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      current_purchase = purchase

      expect { BuyPurchaseProducts.call(current_purchase) }.
        to change { purchase.reload.aasm_state }.
          from('pending').to('bought')
      expect(purchase).to transition_from(:pending).to(:bought).on_event(:buy)
    end

    it 'decreases the stock amount of product by amount of bought products' do
      user = create(:user)
      # sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      current_purchase = purchase

      expect { BuyPurchaseProducts.call(current_purchase) }.
        to change { product.reload.stock_amount }.by(-purchase_product.product_amount)
    end

    it 'updates purchase_date' do
      user = create(:user)
      # sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      current_purchase = purchase

      expect { BuyPurchaseProducts.call(current_purchase) }.to change { purchase.reload.purchase_date }
    end
  end
end
