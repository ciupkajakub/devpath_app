class BestsellerQuery

  def initialize(purchase_products = PurchaseProduct.select { |p| p.purchase.aasm_state == 'bought' })
    @purchase_products = purchase_products
  end

  def resolve
    bestseller
  end

  def sold_products_count
    sold_products_amount
  end

  private

  def bestseller
    bestseller_id = products_amount_hash.max_by { |k, v| v }[0]
    Product.find_by(id: bestseller_id)
  end

  def sold_products_amount
    products_amount_hash.values.sum
  end

  def products_amount_hash
    q = @purchase_products.map { |c| { c[:product_id] => c[:product_amount] } }
    q.inject { |acc, next_obj| acc.merge(next_obj) { |key, arg1, arg2| arg1 + arg2 } }
  end
end
