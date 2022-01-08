class CreateCategoriesProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_products do |t|
      t.belongs_to :category
      t.belongs_to :product

      t.timestamps
    end
  end
end
