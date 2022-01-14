class PurchasesTotal
  def initialize
  end

  def result
    Rails.cache.fetch(cache_key, cache_key: 4.days) do
      purchases.count
    end
  end

  private

  def purchases
    Purchase.select { aasm_state == 'bought' }
  end

  def cache_key
    Purchase.last.created_at
  end
end
