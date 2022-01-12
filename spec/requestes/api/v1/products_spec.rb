require 'rails_helper'

RSpec.describe 'api/v1/products', type: :request do

  describe 'admin is signed in' do
    before(:each) do
      sign_in create(:admin)
    end

    describe 'GET api/v1/products' do
      it 'returns all products' do
        category1 = create(:category, name: 'fruits')
        category2 = create(:category, name: 'meat')
        product1 = create(:product, name: 'banana', category_ids: ["#{category1.id}"])
        product2 = create(:product, name: 'apple', category_ids: ["#{category1.id}"])
        product3 = create(:product, name: 'beef', category_ids: ["#{category2.id}"])

        get '/api/v1/products'

        expect(response).to have_http_status(200)
        expect(JSON(response.body).size).to eq(3)

      end
    end

    describe 'GET api/v1/products/:id' do

      it 'returns the product' do
        category1 = create(:category, name: 'fruits')
        product1 = create(:product, name: 'banana', category_ids: ["#{category1.id}"])

        get "/api/v1/products/#{product1.id}"

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['name']).to eq('banana')
      end
    end

    describe 'POST api/v1/products/:id' do
      describe 'when data is valid' do
        it 'creates the product' do
          category1 = create(:category, name: 'fruits')

          post '/api/v1/products', params: {
            name: 'banana',
            description: 'tasty',
            stock_amount: 30,
            category_ids: [category1.id]
          }
          expect(response).to have_http_status(201)
        end
      end

      describe 'when data is invalid' do
        it 'does not create the product' do
          category1 = create(:category, name: 'fruits')

          post '/api/v1/products', params: {
            name: 'banana',
            description: 'tasty',
            stock_amount: 30
          }

          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'PUT api/v1/products/:id' do
      describe 'when data is valid' do
        it 'updates the product' do
          category1 = create(:category, name: 'food')
          category2 = create(:category, name: 'fruits')

          product1 = create(:product,
                            name: 'banana',
                            description: 'best on the market',
                            stock_amount: 20,
                            category_ids: ["#{category1.id}"])

          put "/api/v1/products/#{product1.id}", params: {
            name: 'apple',
            description: 'tasty',
            stock_amount: 30,
            category_ids: [category1.id, category2.id]
          }
          expect(response).to have_http_status(202)
          expect(product1.reload).to have_attributes(
                                       name: 'apple',
                                       description: 'tasty',
                                       stock_amount: 30,
                                       category_ids: [category1.id, category2.id]
                                     )
        end
      end
      describe 'when data is not valid' do
        it 'does not the product' do
          category1 = create(:category, name: 'food')

          product1 = create(:product,
                            name: 'banana',
                            description: 'best on the market',
                            stock_amount: 20,
                            category_ids: ["#{category1.id}"])

          put "/api/v1/products/#{product1.id}", params: {
            name: 'apple',
            description: 'tasty',
            stock_amount: 30
          }
          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'DELETE api/v1/products/:id' do
      it 'archives the product' do
        category1 = create(:category, name: 'meat')
        product1 = create(:product, name: 'banana', category_ids: ["#{category1.id}"])
        expect { delete "/api/v1/products/#{product1.id}" }.to change { product1.reload.archived_at }
        expect(response).to have_http_status(202)
      end
    end
  end
end
