require 'rails_helper'
RSpec.describe Users::RegistrationsController do
  context 'PUT registrations#update' do
    describe 'When user is signed in' do
      it 'updates user data' do
        user = create(:user)
        sign_in user
        @request.env['devise.mapping'] = Devise.mappings[:user]

        put :update, params: { user: { 'email' => 'user@user.com',
                                       'password' => '',
                                       ' password_confirmation' => '',
                                       'current_password' => '123456',
                                       'first_name' => 'Bob',
                                       'last_name' => 'Marley' } }

        expect(user.reload).to have_attributes(first_name: 'Bob', last_name: 'Marley')
      end
    end
    describe 'When user is not signed in' do
      it 'does not update user data' do
        user = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[:user]

        put :update, params: { user: { 'email' => 'user@user.com',
                                       'password' => '',
                                       'password_confirmation' => '',
                                       'current_password' => '123456',
                                       'first_name' => 'Bob',
                                       'last_name' => 'Marley' } }

        expect(user.reload).to have_attributes(first_name: user.first_name.to_s,
                                               last_name: user.last_name.to_s)
      end
    end
  end
end
