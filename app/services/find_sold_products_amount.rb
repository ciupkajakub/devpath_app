class FindSoldProductsAmount < Patterns::Service

  def call
    sold_products_amount
  end

  private

  def sold_products_amount
    Rails.cache.fetch(cache_key, cache_key: 4.days) do
      BestsellerQuery.new.sold_products_count
    end
  end

  def cache_key
    PurchaseProduct.last.updated_at
  end
end
