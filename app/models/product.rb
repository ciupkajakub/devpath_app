class Product < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :categories
  validates :categories, presence: true

end
