class ProductsTotal
  def initialize
  end

  def result
    Rails.cache.fetch(cache_key, cache_key: 4.days) do
      products
    end
  end

  private

  def products
    Product.count
  end

  def cache_key
    Product.last.created_at
  end
end
