require 'rails_helper'
RSpec.describe Admins::ProductsController do
  context 'POST products#create' do
    describe 'When admin is authenticated' do
      it 'creates new product' do
        admin = create(:admin)
        sign_in admin
        category = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
        expect { post :create, params: { product: { 'name' => 'apple',
                                                    'description' => 'tasty apple',
                                                    'stock_amount' => '10' },
                                         'category_ids' => ["#{category.id}"] } }.
          to change(Product, :count).by(1)
        expect(Product.last).to have_attributes(:name => 'apple', :description => 'tasty apple',
                                                :stock_amount => 10)
        expect(Product.last.categories.last.id).to eq(category.id)
      end
    end
  end
  context 'PUT products#update' do
    describe 'When admin is authenticated' do
      it 'updates product' do
        admin = create(:admin)
        sign_in admin
        category1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
        category2 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619d')
        product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c', category_ids: ["#{category1.id}"])
        # binding.pry
        patch :update, params: { product: { 'name' => 'apple',
                                            'description' => 'tasty apple',
                                            'stock_amount' => '10' }, 'id' => "#{product.id}",
                                 category_ids: ["#{category2.id}"] }
        expect(product.reload).to have_attributes(:name => 'apple', :description => 'tasty apple',
                                                  :stock_amount => 10)
        expect(product.reload.categories.last.id).to eq(category2.id)
      end
    end
  end
  context 'POST products#import_product_csv' do
    describe 'When admin is authenticated' do
      it 'creates products with single category' do
        require 'csv'
        admin = create(:admin)
        sign_in admin
        category1 = create(:category, name: 'Fruits')
        category2 = create(:category, name: 'Meat')
        # binding.pry
        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
          csv << ['apple', 'tasty', 30, 'Fruits']
          csv << ['kiwi', 'tasty fruit', 10, 'Meat']
        end
        allow(File).to receive(:open).and_return(file)

        expect { post :upload_product_csv, params: { file: 'filename' } }.to change(Product, :count).by(2)

        expect(Product.last.categories.count).to eq(1)
      end
      it 'creates products with multiple categories' do
        require 'csv'
        admin = create(:admin)
        sign_in admin
        category1 = create(:category, name: 'Fruits')
        category2 = create(:category, name: 'Meat')
        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
          csv << ['apple', 'tasty', 30, 'Fruits, meat']
          csv << ['kiwi', 'tasty fruit', 10, 'Meat, fruits']
        end
        allow(File).to receive(:open).and_return(file)

        expect { post :upload_product_csv, params: { file: 'filename' } }.to change(Product, :count).by(2)

        expect(Product.last.categories.count).to eq(2)
      end
    end
  end
  context 'PATCH products#archive' do
    describe 'When admin is authenticated' do
      describe 'When product is available' do
        it 'archives the product' do
          admin = create(:admin)
          sign_in admin
          category1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
          product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c', category_ids: ["#{category1.id}"])
          expect { patch :archive, params: { 'id' => "#{product.id}" } }.to change { product.reload.archived_at }
        end
      end
      describe 'When product is archived' do
        it 'restores the product' do
          admin = create(:admin)
          sign_in admin
          category1 = create(:category, category_uid: 'b26a58a0-ec49-4009-b616-f4111e40619c')
          product = create(:product, product_uid: 'b26a44a0-ec49-4009-b616-f4111e40619c', category_ids: ["#{category1.id}"], archived_at: DateTime.now)
          # binding.pry
          patch :archive, params: { 'id' => "#{product.id}" }
          expect(product.reload.archived_at).to eq(nil)
        end
      end
    end
  end
end
#add specs