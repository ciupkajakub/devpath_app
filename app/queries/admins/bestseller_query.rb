module Admins
  class BestsellerQuery
    def initialize
      @purchase_products = PurchaseProduct.includes([:purchase]).select do |p|
        p.purchase&.aasm_state == 'bought'
      end
    end

    def resolve
      bestseller
    end

    def sold_products_count
      sold_products_amount
    end

    private

    def bestseller
      bestseller_id = products_amount_hash.max_by { |_k, v| v }[0]
      Product.find_by(id: bestseller_id)
    end

    def sold_products_amount
      products_amount_hash.values.sum
    end

    def products_amount_hash
      q = @purchase_products.map { |c| { c[:product_id] => c[:product_amount] } }
      q.inject { |acc, next_obj| acc.merge(next_obj) { |_key, arg_1, arg_2| arg_1 + arg_2 } }
    end

    def cache_key
      PurchaseProduct.last.created_at
    end
  end
end
