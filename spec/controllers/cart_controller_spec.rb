require 'rails_helper'
RSpec.describe CartController do
  context 'PUT cart#update' do
    it 'updates product amount in the shopping cart' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)

      expect {
        patch :update, params: { 'product_id' => "#{purchase_product.id}",
                                 'purchase_product' => { 'product_amount' => '3' } } }.
        to change { purchase.purchase_products.last.product_amount }.
          from(purchase.purchase_products.last.product_amount).to(3)
    end
  end
  context 'DESTROY cart#delete' do
    it 'deletes product from the shopping cart' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)

      expect {
        delete :destroy, params: { 'product_id' => purchase_product.id } }.
        to change { purchase.purchase_products.count }.
          from(1).to(0)
    end
  end
  context 'PUT cart#buy' do
    it 'updates purchase`s aasm_state from pending to bought' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      session[:purchase_id] = purchase.id

      expect {
        patch :buy, params: { 'some' => 'params' } }.
        to change { purchase.reload.aasm_state }.
          from('pending').to('bought')
      expect(purchase).to transition_from(:pending).to(:bought).on_event(:buy)
    end

    it 'decreases the stock amount of product by amount of bought products' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      session[:purchase_id] = purchase.id

      expect {
        patch :buy, params: { 'some' => 'params' } }.
        to change { product.reload.stock_amount }.by(-purchase_product.product_amount)
    end

    it 'updates purchase_date' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      session[:purchase_id] = purchase.id

      expect { patch :buy, params: { 'some' => 'params' } }.to change { purchase.reload.purchase_date }
    end

    it 'sets session purchase to nil after buuying products' do
      user = create(:user)
      sign_in user
      category = create(:category)
      product = create(:product, category_ids: [category.id])
      product.categories = [category]
      purchase = create(:purchase, user_id: user.id)
      purchase_product = create(:purchase_product, purchase_id: purchase.id, product_id: product.id)
      session[:purchase_id] = purchase.id
      patch :buy, params: { 'some' => 'params' }

      expect(session[:purchase_id]).to eq(nil)
    end
  end
end