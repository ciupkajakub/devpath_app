class UserMailer < ApplicationMailer
  def send_user_data
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Login Data')
  end
end
