require 'rails_helper'

RSpec.describe Admins::ProductsController do
  context 'POST products#create' do
    describe 'When admin is authenticated' do
      it 'creates new product' do
        admin = create(:admin)
        sign_in admin
        category = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
        expect {
          post :create, params: { product: { 'name' => 'apple',
                                             'description' => 'tasty apple',
                                             'stock_amount' => '10' },
                                  'category_ids' => [category.id.to_s] }
        }.
          to change(Product, :count).by(1)
        expect(Product.last).to have_attributes(name: 'apple', description: 'tasty apple',
                                                stock_amount: 10)
        expect(Product.last.categories.last.id).to eq(category.id)
      end
    end
  end
  context 'PUT products#update' do
    describe 'When admin is authenticated' do
      it 'updates product' do
        admin = create(:admin)
        sign_in admin
        category_1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
        category_2 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619d')
        product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c',
                                   category_ids: [category_1.id.to_s])
        patch :update, params: { product: { 'name' => 'apple',
                                            'description' => 'tasty apple',
                                            'stock_amount' => '10' }, 'id' => product.id.to_s,
                                 category_ids: [category_2.id.to_s] }
        expect(product.reload).to have_attributes(name: 'apple', description: 'tasty apple',
                                                  stock_amount: 10)
        expect(product.reload.categories.last.id).to eq(category_2.id)
      end
    end
  end
  context 'POST products#import_product_csv' do
    describe 'When admin is authenticated' do
      describe 'When categories are given' do
        it 'creates products with single category' do
          require 'csv'
          admin = create(:admin)
          sign_in admin
          create(:category, name: 'Fruits')
          create(:category, name: 'Meat')
          file = CSV.generate do |csv|
            csv << %w[name description stock_amount category] # hash keys
            csv << ['apple', 'tasty', 30, 'Fruits']
            csv << ['kiwi', 'tasty fruit', 10, 'Meat']
          end
          allow(File).to receive(:open).and_return(file)

          expect {
            post :upload_product_csv, params: { file: 'filename' }
          }.to change(Product, :count).by(2)

          expect(Product.last.categories.count).to eq(1)
        end
        it 'creates products with multiple categories' do
          require 'csv'
          admin = create(:admin)
          sign_in admin
          create(:category, name: 'Fruits')
          create(:category, name: 'Meat')
          file = CSV.generate do |csv|
            csv << %w[name description stock_amount category] # hash keys
            csv << ['apple', 'tasty', 30, 'Fruits, meat']
            csv << ['kiwi', 'tasty fruit', 10, 'Meat, fruits']
          end
          allow(File).to receive(:open).and_return(file)

          expect {
            post :upload_product_csv, params: { file: 'filename' }
          }.to change(Product, :count).by(2)

          expect(Product.last.categories.count).to eq(2)
        end
      end
      describe 'When categories are not given' do
        it 'redirects and renders flash message' do
          require 'csv'
          admin = create(:admin)
          sign_in admin
          file = CSV.generate do |csv|
            csv << %w[name description stock_amount] # hash keys
            csv << ['apple', 'tasty', 30]
            csv << ['kiwi', 'tasty fruit ', 10]
          end
          allow(File).to receive(:open).and_return(file)

          post :upload_product_csv, params: { file: 'filename' }

          expect(response).to redirect_to root_path
          expect(flash[:alert]).to eq('CSV with products is missing categories, please add them!')
        end
      end
    end
  end
  context 'PATCH products#archive' do
    describe 'When admin is authenticated' do
      describe 'When product is available' do
        it 'archives the product' do
          admin = create(:admin)
          sign_in admin
          category_1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
          product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c',
                                     category_ids: [category_1.id.to_s])
          expect { patch :archive, params: { 'id' => product.id.to_s } }.
            to change { product.reload.archived_at }
        end
      end
      describe 'When product is archived' do
        it 'restores the product' do
          admin = create(:admin)
          sign_in admin
          category_1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
          product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c',
                                     category_ids: [category_1.id.to_s], archived_at: DateTime.now)
          patch :archive, params: { 'id' => product.id.to_s }
          expect(product.reload.archived_at).to eq(nil)
        end
      end
    end
  end
end
