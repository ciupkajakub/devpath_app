class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = UsersTotal.new.result
    @categories = CategoriesTotal.new.result
    @products = ProductsTotal.new.result
    @purchases = ProductsTotal.new.result
    @bestseller = bestseller.result
    @sold_products_amount = sold_products_amount.result
  end

  private

  def bestseller
    FindBestseller.call
  end

  def sold_products_amount
    FindSoldProductsAmount.call
  end
end
