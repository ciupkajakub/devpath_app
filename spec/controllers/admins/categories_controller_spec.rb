require 'rails_helper'
RSpec.describe Admins::CategoriesController do
  context 'POST categories#create' do
    describe 'When admin is authenticated' do
      it 'creates new category' do
        admin = create(:admin)
        sign_in admin
        expect {
          post :create, params: { category: { 'name' => 'apple',
                                              'description' => 'tasty apple' } }
        }.
          to change(Category, :count).by(1)
        expect(Category.last).to have_attributes(name: 'apple', description: 'tasty apple')
      end
    end
  end
end
