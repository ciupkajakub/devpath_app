require 'rails_helper'
RSpec.describe PurchaseProductsController do
  context 'POST purchase_products#create' do
    context 'when user is signed in' do
      describe 'when there is no purchase saved in session' do
        it 'creates new session purchase' do
          user = create(:user)
          sign_in user
          category = create(:category)
          product = create(:product, category_ids: [category.id])
          session[:purchase_id] = nil

          expect {
            post :create, params: { 'product_id' => "#{product.id}" }
          }.to change(Purchase, :count).from(0).to(1)
          expect(session[:purchase_id]).to eq(Purchase.last.id)
        end

        it 'creates purchase_product' do
          user = create(:user)
          sign_in user
          category = create(:category)
          product = create(:product, category_ids: [category.id])
          session[:purchase_id] = nil
          post :create, params: { 'product_id' => "#{product.id}" }

          expect(Purchase.last.purchase_products.last).to have_attributes(product_id: product.id, product_amount: 1)
          expect(Purchase.last.purchase_products.count).to eq(1)

        end
      end

      describe 'when there is purchase saved in session' do
        it 'finds the purchase saved in session' do
          user = create(:user)
          sign_in user
          category = create(:category)
          product = create(:product, category_ids: [category.id])
          purchase = create(:purchase, user_id: user.id)
          session[:purchase_id] = purchase.id

          post :create, params: { 'product_id' => "#{product.id}" }
          post :create, params: { 'product_id' => "#{product.id}" }

          expect(Purchase.count).to eq(1)
          expect(session[:purchase_id]).to eq(purchase.id)
        end

        it 'creates purchase_products' do
          user = create(:user)
          sign_in user
          category = create(:category)
          product = create(:product, category_ids: [category.id])
          purchase = create(:purchase, user_id: user.id)
          session[:purchase_id] = purchase.id

          post :create, params: { 'product_id' => "#{product.id}" }
          post :create, params: { 'product_id' => "#{product.id}" }

          expect(Purchase.last.purchase_products.count).to eq(2)
          expect(Purchase.last.purchase_products.last.product_amount).to eq(1)
          expect(session[:purchase_id]).to eq(purchase.id)
        end
      end
    end
  end
end
