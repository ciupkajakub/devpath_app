class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.datetime :purchase_date
      t.string :aasm_state
      t.belongs_to :user

      t.timestamps
    end
  end
end
