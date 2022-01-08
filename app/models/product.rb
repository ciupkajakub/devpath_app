class Product < ApplicationRecord
  require 'csv'
  has_one_attached :image
  has_and_belongs_to_many :categories

  def self.upload(file)
    CSV.foreach(file, headers: true) do |row|
      lower_key_row = row.to_hash.transform_keys(&:downcase)
      hashed_row = lower_key_row.except('category').transform_values(&:capitalize)
      p = Product.new(hashed_row)
      if lower_key_row['category']
        categories = lower_key_row['category'].try(:split, ', ').
          try(:map) { |c| Category.select{ |s| s.name.downcase == c.downcase} }.flatten
        p.categories = categories
      end
      p.save!
    end
  end
end
