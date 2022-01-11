class ProductsController < ApplicationController
  def index
    @products = Product.select { |p| p.stock_amount > 0 }.sort_by(&:name)
    @purchase = Purchase.new # here current purchase
  end
end
