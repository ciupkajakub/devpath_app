class PurchaseProductsController < ApplicationController

  def create
    # binding.pry
    purchase = helpers.current_purchase
    purchase.purchase_products.create(product_id: purchase_product,
                                      product_amount: product_amount)
    session[:purchase_id] = purchase.id
  end

  private

  def purchase_product
    params[:product_id].to_i
  end

  def product_amount
    params[:purchase][:product_amount].to_i
  end
end
