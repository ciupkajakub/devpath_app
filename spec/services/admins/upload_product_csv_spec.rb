require 'rails_helper'

RSpec.describe Admins::UploadProductCsv do
  context '.call' do
    describe 'when categories are given' do
      it 'creates products with single category' do
        require 'csv'
        category1 = create(:category, name: 'Fruits')
        category2 = create(:category, name: 'meat')

        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
          csv << ['apple', 'tasty', 30, 'meat']
          csv << ['kiwi', 'tasty fruit', 10, 'fruits']
        end
        allow(File).to receive(:open).and_return(file)

        expect { Admins::UploadProductCsv.call(file) }.to change { Product.count }.from(0).to(2)
        expect(Product.last.categories).to eq([category1])
      end
      it 'creates products with multiple categories' do
        category1 = create(:category, name: 'Fruits')
        category2 = create(:category, name: 'Meat')
        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount', 'category'] #hash keys
          csv << ['apple', 'tasty', 30, 'Meat, fruits']
          csv << ['kiwi', 'tasty fruit ', 10, 'fruits, meat']
        end
        allow(File).to receive(:open).and_return(file)

        expect { Admins::UploadProductCsv.call(file) }.to change { Product.count }.from(0).to(2)
        expect(Product.last.categories).to eq([category1, category2])
      end
      it 'creates products with multiple categories with whitespaces' do
        category1 = create(:category, name: 'Fruits')
        category2 = create(:category, name: 'Meat')
        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount', ' category'] #hash keys
          csv << ['apple', 'tasty', 30, 'Meat, fruits ']
          csv << ['kiwi', 'tasty fruit ', 10, 'fruits, meat  ']
        end
        allow(File).to receive(:open).and_return(file)

        expect { Admins::UploadProductCsv.call(file) }.to change { Product.count }.from(0).to(2)
        expect(Product.last.categories).to eq([category1, category2])
      end
    end
    describe 'when categories are not given' do
      it 'raises an error' do
        file = CSV.generate do |csv|
          csv << ['name', 'description', 'stock_amount'] #hash keys
          csv << ['apple', 'tasty', 30]
          csv << ['kiwi', 'tasty fruit ', 10]
        end
        allow(File).to receive(:open).and_return(file)
        expect { Admins::UploadProductCsv.call(file) }.to raise_error(CsvNoCategoryError)
      end
    end
  end
end
