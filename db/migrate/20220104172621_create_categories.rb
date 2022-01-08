class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, unique: true
      t.string :description
      t.uuid :category_uid,  null: false, default: 'gen_random_uuid()'

      t.timestamps
    end
  end
end
