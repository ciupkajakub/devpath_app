class CategoriesTotal
  def initialize
  end

  def result
    Rails.cache.fetch(cache_key, cache_key: 4.days) do
      categories
    end
  end

  private

  def categories
    Category.count
  end

  def cache_key
    Category.last.created_at
  end
end
