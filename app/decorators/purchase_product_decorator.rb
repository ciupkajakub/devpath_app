class PurchaseProductDecorator < ApplicationDecorator
  delegate_all

  def product
    Product.find_by(id: purchase_product.product_id).try(:name)
  end
end
