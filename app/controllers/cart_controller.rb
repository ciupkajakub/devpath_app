class CartController < ApplicationController
  before_action :set_purchase_product, only: %i[ update destroy ]
  before_action :authenticate_user!

  def index
    @current_purchase = helpers.current_purchase
    @purchase_products = helpers.current_purchase.purchase_products
  end

  def update
    @purchase_product.update_attribute(:product_amount, purchase_product_amount)
  end

  def destroy
    @purchase_product.destroy
  end

  def buy
    BuyPurchaseProducts.call(helpers.current_purchase)
    session[:purchase_id] = nil

    redirect_to products_path
  end

  private

  def set_purchase_product
    @purchase_product = PurchaseProduct.find_by(id: params[:product_id])
  end

  def purchase_product_amount
    params[:purchase_product][:product_amount]
  end
end
