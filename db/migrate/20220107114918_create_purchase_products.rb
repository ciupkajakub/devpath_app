class CreatePurchaseProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_products do |t|
      t.integer :product_amount
      t.belongs_to :purchase
      t.belongs_to :product

      t.timestamps
    end
  end
end
