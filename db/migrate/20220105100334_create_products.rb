class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null:false, unique: true
      t.string :description
      t.integer :stock_amount, null: false
      t.uuid :product_uid,  null: false, default: 'gen_random_uuid()', unique: true

      t.timestamps
    end
  end
end
