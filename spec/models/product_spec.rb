# require 'rails_helper'
#
# RSpec.describe Product, type: :model do
#   describe 'product#import'
#   describe 'creating products based on imported csv' do
#     it 'creates products with single categories' do
#       category1 = create(:category, name: 'Fruits')
#       category2 = create(:category, name: 'Meat')
#       file = CSV.generate do |csv|
#         csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
#         csv << ['apple', 'tasty', 30, 'Meat']
#         csv << ['kiwi', 'tasty fruit ', 10, 'fruits']
#       end
#       allow(File).to receive(:open).and_return(file)
#
#       expect { Product.upload('filename') }.to change(Product, :count).by(2)
#       expect(Product.last.categories.count).to eq(1)
#     end
#     it 'creates products with multiple categories' do
#       category1 = create(:category, name: 'Fruits')
#       category2 = create(:category, name: 'Meat')
#       file = CSV.generate do |csv|
#         csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
#         csv << ['apple', 'tasty', 30, 'Meat, fruits']
#         csv << ['kiwi', 'tasty fruit ', 10, 'fruits, meat']
#       end
#       allow(File).to receive(:open).and_return(file)
#
#       expect { Product.upload('filename') }.to change(Product, :count).by(2)
#       expect(Product.last.categories.count).to eq(2)
#     end
#   end
# end
