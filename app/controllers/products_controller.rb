class ProductsController < ApplicationController
  def index
    @products = Product.select { |p| p.stock_amount.positive? }.sort_by(&:name)
    @purchase = Purchase.new # here current purchase
  end
end
