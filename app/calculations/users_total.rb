class UsersTotal
  def initialize
  end

  def result
    Rails.cache.fetch(cache_key, cache_key: 4.days) do
      users
    end
  end

  private

  def users
    User.count
  end

  def cache_key
    User.last.created_at
  end
end
