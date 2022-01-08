class ProductsController < ApplicationController
  def index
    @products = Product.all
    @purchase = Purchase.new# here current purchase
  end
end