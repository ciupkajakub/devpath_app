class PurchaseProductsController < ApplicationController

  def create
    purchase = helpers.current_purchase
    purchase.purchase_products.create(product_id: purchase_product,
                                      product_amount: 1)
    session[:purchase_id] = purchase.id
  end

  private

  def purchase_product
    params[:product_id]
  end
end
