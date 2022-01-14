class Admins::Statistics < Patterns::Calculation
  set_cache_expiry_every 7.days

  def result
    {
      total_users: users_count,
      total_categories: categories_count,
      total_products: products_count,
      total_purchases: purchases_count,
      bestseller: bestseller.name,
      sold_products_amount: sold_products_amount
    }
  end

  private

  def users_count
    User.count
  end

  def categories_count
    Category.count
  end

  def products_count
    Product.count
  end

  def purchases_count
    Purchase.where(aasm_state: 'bought').count

  end

  def bestseller
    BestsellerQuery.new.resolve
  end

  def sold_products_amount
    BestsellerQuery.new.sold_products_count
  end
end
