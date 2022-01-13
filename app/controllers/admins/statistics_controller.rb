class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!

  def index

    # @users = RegisteredUsers.result
    # # # @users = User.count
    # #
    # @purchases = Purchase.count
    # @products = Product.count
    # @categories = Category.count
    @bestseller = bestseller
    @sold_products_amount = sold_products_amount

  end

  private

  def bestseller
    FindBestseller.call
  end

  def sold_products_amount
    FindSoldProductsAmount.call
  end
end
