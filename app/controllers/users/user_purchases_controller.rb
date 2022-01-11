class Users::UserPurchasesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_purchases = current_user.purchases.where(aasm_state: 'bought')
  end
end
