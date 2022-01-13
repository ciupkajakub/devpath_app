class FindBestseller < Patterns::Service

  def call
    bestseller
  end

  private

  def bestseller
    Rails.cache.fetch(expires_in: 5.days) do
      BestsellerQuery.new.resolve
    end
  end
end
