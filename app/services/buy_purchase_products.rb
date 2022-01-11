class BuyPurchaseProducts < Patterns::Service

  def initialize(current_purchase)
    @current_purchase = current_purchase
  end

  def call
    buy
  end

  private

  def buy
    @current_purchase.buy!
    @current_purchase.update_attribute(:purchase_date, DateTime.now)

    purchase_products = @current_purchase.purchase_products
    purchase_products.each do |purchase_product|

      product = Product.find_by(id: purchase_product.product_id)
      updated_amount = product.stock_amount - purchase_product.product_amount
      product.update_attribute(:stock_amount, updated_amount)
    end
  end
end
