module Admins
  class UsersController < ApplicationController
    before_action :authenticate_admin!

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.save!
      UserMailer.with(user: @user, password: password).send_user_data.deliver_later
      redirect_to(root_path)
    end

    private

    def password
      @password ||= Devise.friendly_token.first(8)
    end

    def user_params
      user_password = password
      params.require(:user).permit(:first_name, :last_name, :email).
        merge(password: user_password, password_confirmation: user_password)
    end
  end
end
