module Users
  class UserPurchasesController < ApplicationController
    before_action :authenticate_user!

    def index
      @user_purchases = current_user.purchases.where(aasm_state: 'bought')
    end
  end
end
