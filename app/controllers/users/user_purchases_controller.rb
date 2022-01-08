class Users::UserPurchasesController < ApplicationController
  def index
    @user_purchases = current_user.purchases.where(aasm_state: 'bought')
  end
end