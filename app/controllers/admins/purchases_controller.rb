class Admins::PurchasesController < ApplicationController
  before_action :authenticate_admin!

  def index
    all_purchases = Purchase.where(aasm_state: 'bought')
    @q = all_purchases.ransack(params[:q])
    @q.sorts = 'name asc'
    @purchases = @q.result(distinct: true).includes(:purchase_products, :user).
      page(params[:page]).per(4)
  end
end