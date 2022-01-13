class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!

  def index
    #keszuj
    @users = User.count
    @purchases = Purchase.count
    @products  = Product.count
    @categories = Category.count
    @bestseller = bestseller
    @sold_products_amount = sold_products_amount
  end

  private
  def bestseller
    BestsellerQuery.new.resolve
  end

  def sold_products_amount
    BestsellerQuery.new.sold_products_count
  end
end
