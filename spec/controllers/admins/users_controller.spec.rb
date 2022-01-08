require 'rails_helper'
RSpec.describe Admins::UsersController do
  context 'POST users#create' do
    describe 'When admin is authenticated' do
      it 'creates new user' do
        admin = create(:admin)
        sign_in admin

        expect { post :create, :params => { :user => { 'email' => 'john@doe.com',
                                                       'password' => '',
                                                       ' password_confirmation' => '',
                                                       'current_password' => '123456',
                                                       'first_name' => 'John',
                                                       'last_name' => 'Doe' } } }.
          to change(User, :count).by(1)
      end
    end
  end
end
#add specs